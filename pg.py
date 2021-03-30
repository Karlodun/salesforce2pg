#!/usr/bin/env python3
import psycopg2, psycopg2.extras
con = psycopg2.connect(
    database="postgres",
    user="postgres",
    password="123456",
    host="localhost",
    port="5432"
    ).cursor()

cur=con.cursor(cursor_factory = psycopg2.extras.DictCursor)

def rebuild():
    cur.execute("CALL salesforce_sync.rebuild_target()")
    con.commit()

def list_sf_instances():
    cur.execute('SELECT * FROM salesforce_sync.sf_instance')
    return cur.fetchall()

def list_src_tables(instance):
    cur.execute("SELECT source_table, source_query FROM salesforce_sync.api_query WHERE sf_instance='"+instance+"'")
    return cur.fetchall()

def upsert(src_table,json_records):
    cur.execute("CALL salesforce_sync.upsert('"+src_table+"','"+json_records+"')")
    con.commit()
