#!/usr/bin/env python3
import psycopg2, psycopg2.extras

# The reccomendation is to use unix socket with trusted connection. Uncomment if you really need!
# use .pgpass to store your password!
# check official documentation if needed
con = psycopg2.connect(
    database="postgres"     # according to your needs
    , user="salesforce2pg_service"   # don't forget to grant salesforce_2pg to this role!
    # , host="localhost"      # enable for remote or if unix socket connection impossible
    # , port="5432"           
    ).cursor()

cur=con.cursor(cursor_factory = psycopg2.extras.DictCursor)


def rebuild():
    cur.execute("CALL salesforce2pg.rebuild_target()")
    con.commit()

    
def list_sf_instances():
    cur.execute('SELECT * FROM salesforce2pg.sf_instance')
    return cur.fetchall()


def list_src_tables(instance):
    cur.execute(f"SELECT source_table, source_query FROM salesforce2pg.api_query WHERE sf_instance='{instance}'")
    return cur.fetchall()


def upsert(src_table,json_records):
    cur.execute(f"CALL salesforce2pg.upsert('{src_table}','{json_records}')")
    con.commit()

    
def update_table_api_status(instance, table, status):
    cur.execute(f"UPDATE salesforce2pg.api_table SET status='{status}' WHERE sf_instance='{instance}' AND source_table='{table}'")
    con.commit()


