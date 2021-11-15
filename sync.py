#!/usr/bin/env python3
# chmod +x on me
import json, datetime, pg, sf

def tables_to_pg(t):
    print(' table:', t['source_table'])
    sf_res = sfi.query(t['source_query'], include_deleted=True)
    while sf_res:
        list_pos = 0
        list_step = 1000
        sf_records = len(sf_res["records"])
        while list_pos < sf_records:
            list_end = list_pos + list_step
            dict_records = sf_res["records"][list_pos:list_end]
            json_records = json.dumps(dict_records).replace("'", "''")
            list_pos += list_step
            pg.upsert(t['sf_instance'], t['source_table'], json_records)
        if "nextRecordsUrl" in sf_res:
            sf_res = sfi.query_more(sf_res["nextRecordsUrl"], True)
        else:
            sf_res = None


def main():
    pg.rebuild()
    for instance in pg.list_sf_instances():
        print('instance:', instance['sf_instance'])
        sfi = sf.init_instance(instance)

        for src_table in pg.list_src_tables(instance['sf_instance']):
            tables_to_pg(src_table)

    print('sync completed at:', datetime.now())
    
if __name__="__main__":
    main()
