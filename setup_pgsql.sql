-- the code is pretty self explanatory. Start the reverse engineering with the view and functions at the end of the file
CREATE ROLE salesforce_sync;
CREATE SCHEMA AUTHORIZATION salesforce_sync;
SET ROLE salesforce_sync;
-- grant all required rights on all required schemas!!!
--DROP TABLE IF EXISTS salesforce_sync.sf_instance;
--DROP TABLE IF EXISTS salesforce_sync.api_column;
--DROP TABLE IF EXISTS salesforce_sync.api_table;

CREATE TABLE salesforce_sync.sf_instance (sf_instance varchar PRIMARY KEY
    , organization_id varchar NOT NULL
    , username varchar NOT NULL
    , pwd varchar NOT NULL
    , session_id varchar NOT NULL DEFAULT ''
    , security_token varchar NOT NULL DEFAULT ''
    )

CREATE TABLE salesforce_sync.api_table(sf_instance varchar REFERENCES salesforce_sync.sf_instance(sf_instance)
    , source_table varchar PRIMARY KEY
    , target_table varchar
    , last_modified_column varchar
    , pk_column varchar
    , readers _varchar 
    , source_filter varchar
    , enabled boolean DEFAULT TRUE
    , rebuild boolean DEFAULT FALSE
    , update_frequency INTERVAL DEFAULT '5 minutes'
);

CREATE TABLE salesforce_sync.api_column (
    source_table varchar REFERENCES ciq.api_table(source_table)
    , source_column varchar
    , target_column varchar
    , column_order int DEFAULT -1
    , enabled boolean DEFAULT TRUE
    , PRIMARY KEY (source_table, source_column)
);

CREATE OR REPLACE FUNCTION salesforce_sync.last_update(src_table character varying, OUT last_update timestamp without time zone)
 RETURNS timestamp without time zone
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare 
 runner_sql TEXT;
BEGIN
runner_sql := (SELECT 'SELECT max('||target_column||') FROM '||target_table||';'
        FROM salesforce_sync.api_table apit
        NATURAL JOIN salesforce_sync.api_column
        WHERE source_column=apit.last_modified_column
        AND source_table=src_table
    );
--INSERT INTO ciq.api_debug VALUES (runner_sql);
EXECUTE runner_sql INTO last_update;
END;
$function$
;

CREATE OR REPLACE PROCEDURE salesforce_sync.rebuild_target()
-- rebuilds all tables at once;
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $procedure$
declare 
 code_snippet RECORD;
BEGIN
FOR code_snippet IN
SELECT 'DROP TABLE IF EXISTS '||target_table||';'||chr(10)
        ||'CREATE TABLE '||target_table||'('
        || string_agg(target_column
            ||CASE WHEN source_column=apit.last_modified_column
                THEN ' timestamp'
                ELSE ' varchar'
                END, ','||chr(10))
        ||');'||chr(10)
        ||'ALTER TABLE '||target_table||' ADD PRIMARY KEY('||pk_column||');'||chr(10)
        || string_agg('CREATE INDEX on '||target_table||'('||target_column||');',chr(10))
            FILTER (WHERE source_column=apit.last_modified_column)
        ||'GRANT SELECT ON '||target_table||' TO '||array_to_string(readers,', ')||';'
        ||chr(10) sql_runner
        FROM salesforce_sync.api_table apit
        NATURAL JOIN salesforce_sync.api_column
        WHERE rebuild
        GROUP BY apit.source_table
LOOP
    EXECUTE code_snippet.sql_runner;
END LOOP;
UPDATE salesforce_sync.api_table SET rebuild=FALSE WHERE rebuild;
END;
$procedure$
;

CALL salesforce_sync.rebuild_target();

CREATE OR REPLACE PROCEDURE salesforce_sync.rebuild_target(src_table character varying)
-- rebuilds specific table
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $procedure$
declare 
 runner_sql TEXT;
BEGIN
runner_sql := (SELECT 'DROP TABLE IF EXISTS '||target_table||';'||chr(10)
        ||'CREATE TABLE '||target_table||'('
        || string_agg(target_column
            ||CASE WHEN source_column=apit.last_modified_column
                THEN ' timestamp'
                ELSE ' varchar'
                END, ','||chr(10))
        ||');'||chr(10)
        ||'ALTER TABLE '||target_table||' ADD PRIMARY KEY('||pk_column||');'||chr(10)
        || string_agg('CREATE INDEX on '||target_table||'('||target_column||');',chr(10))
            FILTER (WHERE source_column=apit.last_modified_column)
        ||'GRANT SELECT ON '||target_table||' TO '||array_to_string(readers,', ')||';'
        FROM salesforce_sync.api_table apit
        NATURAL JOIN salesforce_sync.api_column
        WHERE rebuild
        AND source_table=src_table
        GROUP BY apit.source_table
    );
EXECUTE runner_sql;
UPDATE salesforce_sync.api_table SET rebuild=FALSE WHERE source_table=src_table;
END;
$procedure$
;

CREATE OR REPLACE PROCEDURE salesforce_sync.upsert(src_table character varying, jsontext text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $procedure$
declare 
 runner_sql TEXT;
BEGIN
runner_sql := (SELECT 
    format('WITH sf_data AS (SELECT (%L)::jsonb sf_records)'||chr(10)
    ||'INSERT INTO '||target_table||chr(10)
    ||'('||string_agg(target_column, ',' ORDER BY column_order)||')'||chr(10)
    ||'SELECT '
    ||string_agg(CASE WHEN source_column=last_modified_column
        THEN '(jsonb_array_elements(sf_records)->>'''||source_column||''')::timestamp '
        ELSE 'jsonb_array_elements(sf_records)->>'''||source_column||''' '
        END
        ||target_column, ','||chr(10) ORDER BY column_order)
    ||chr(10)||'FROM sf_data
    ON CONFLICT ('||pk_column||') DO UPDATE SET'||chr(10)
    ||string_agg(' '||target_column||' = EXCLUDED.'||target_column, ','||chr(10) ORDER BY column_order) FILTER (WHERE target_column<>pk_column)
    , jsontext::jsonb)
    FROM salesforce_sync.api_table apit
    NATURAL JOIN salesforce_sync.api_column
    WHERE enabled
    AND source_table=src_table
    GROUP BY apit.source_table);
EXECUTE runner_sql;
END;
$procedure$
;


DROP VIEW salesforce_sync.api_query;
CREATE OR REPLACE VIEW salesforce_sync.api_query AS
SELECT sf_instance, source_table
--, update_frequency
, concat('SELECT '||string_agg(source_column, ', ')||chr(10)
    ||'FROM '||source_table||chr(10)
    ||'WHERE '||last_modified_column||'>'||to_char(
            COALESCE(salesforce_sync.last_update(api_table.source_table), '1900-01-01')
                -update_frequency::interval
                -INTERVAL '5 minutes'
                , 'YYYY-MM-DD"T"HH24:MI:SS"Z"'
        )||chr(10)
--    , 'OR ISNULL('||last_modified_column||') '||chr(10)
    , 'AND '||source_filter|| chr(10)
    , 'ORDER BY '||last_modified_column||' DESC'
    ) source_query
FROM salesforce_sync.api_table
NATURAL JOIN salesforce_sync.api_column
NATURAL JOIN salesforce_sync.sf_instance
WHERE enabled
GROUP BY source_table;

RESET ROLE;
