-- the code is pretty self explanatory. Start the reverse engineering with the view and functions at the end of the file
CREATE TABLE ciq.salesforce_instances (sf_instance varchar
    , organization_id varchar NOT NULL
    , pwd varchar NOT NULL
    , username varchar NOT NULL
    , session_id varchar NOT NULL DEFAULT ''
    , security_token varchar NOT NULL DEFAULT ''
    )

DROP TABLE IF EXISTS ciq.api_column;
DROP TABLE IF EXISTS ciq.api_table;
CREATE TABLE ciq.api_table(
    source_table varchar PRIMARY KEY
    , target_table varchar
    , last_modified_column varchar
    , pk_column varchar
    , readers _varchar -- array of pgsql ROLES which should be allowed to select from target tables.
    , source_filter varchar
    , enabled boolean DEFAULT TRUE
    , rebuild boolean DEFAULT FALSE
    , update_frequency INTERVAL DEFAULT '5 minutes'
);

CREATE TABLE ciq.api_column (
    source_table varchar REFERENCES ciq.api_table(source_table)
    , source_column varchar
    , target_column varchar
    , column_order int DEFAULT -1
    , enabled boolean DEFAULT TRUE
    , PRIMARY KEY (source_table, source_column)
);

-- DROP VIEW ciq.api_query;
CREATE OR REPLACE VIEW ciq.api_query AS
SELECT source_table
--, update_frequency
, concat('SELECT '||string_agg(source_column, ', ')||chr(10)
    ||'FROM '||source_table||chr(10)
    ||'WHERE '||last_modified_column||'>'||to_char(
            COALESCE(ciq.last_update(api_table.source_table), '1900-01-01')
                -update_frequency::interval
                -INTERVAL '5 minutes'
                , 'YYYY-MM-DD"T"HH24:MI:SS"Z"'
        )||chr(10)
--    , 'OR ISNULL('||last_modified_column||') '||chr(10)
    , 'AND '||source_filter|| chr(10)
    , 'ORDER BY '||last_modified_column||' DESC    ALL ROWS'
    ) source_query
FROM ciq.api_table
NATURAL JOIN ciq.api_column
WHERE enabled
GROUP BY source_table

