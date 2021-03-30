#!/usr/bin/env python3
# chmod +x on me
from simple_salesforce import Salesforce
#from pg_conn_config import pg  # imports and prepares schema
import json, datetime, pg

pg.rebuild()

def process_instance(i):
    sf = Salesforce(instance=i['sf_instance']
                , organizationId=i['organization_id']
                , username=i['username']
                , password=i['pwd']
                , session_id=i['session_id']
                , security_token=i['security_token']
                )

    src_tables = pg.list_src_tables(i['sf_instance'])

    for src_table in src_tables:
        sf_res = sf.query_all(src_table[1], include_deleted=True)
        while sf_res:
            list_pos = 0
            list_step = 100
            ciq_records = len(sf_res["records"])
            while list_pos < ciq_records:
                dict_records = sf_res["records"][list_pos:list_pos+list_step-1]
                json_records = json.dumps(dict_records).replace("'","''")
                list_pos += list_step
                pg.upsert(src_table[0], json_records)
            if "nextRecordsUrl" in sf_res:
                sf_res = sf.query_more(sf_res["nextRecordsUrl"], True)
            else:
                sf_res = None

for instance in pg.list_sf_instances():
    process_instance(instance)

print ('sync completed at:', datetime.datetime.now())
