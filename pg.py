#!/usr/bin/env python3
import psycopg2, psycopg2.extras

# The reccomendation is to use unix socket with trusted connection, ommiting settings like here. Uncomment if you really need!
# check official documentation if needed
con = psycopg2.connect(
    database="postgres"     # according to your needs
    , user="not_postgres"   # don't forget to grant salesforce_sync to this role!
    # , host="localhost"      # enable for remote or if unix socket connection impossible 
    # , password="123456"     # enable if you cannot setup a trusted connection
    # , port="5432"           
    ).cursor()

cur=con.cursor(cursor_factory = psycopg2.extras.DictCursor)


def rebuild():
    cur.execute("CALL salesforce_sync.rebuild_target()")
    con.commit()

    
def list_sf_instances():
    cur.execute('SELECT * FROM salesforce_sync.sf_instance')
    return cur.fetchall()


def list_src_tables(instance):
    cur.execute(f"SELECT source_table, source_query FROM salesforce_sync.api_query WHERE sf_instance='{instance}'")
    return cur.fetchall()


def upsert(src_table,json_records):
    cur.execute(f"CALL salesforce_sync.upsert('{src_table}','{json_records}')")
    con.commit()

    
def update_table_api_status(instance, table, status):
    cur.execute(f"UPDATE salesforce2pg.api_table SET status='{status}' WHERE sf_instance='{instance}' AND source_table='{table}'")
    con.commit()


