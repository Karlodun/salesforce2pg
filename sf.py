#!/usr/bin/env python3
from simple_salesforce import Salesforce


def init_instance(i):
    return Salesforce(
      instance=i['sf_instance'],
      organizationId=i['organization_id'],
      username=i['username'],
      password=i['pwd'],
      session_id=i['session_id'],
      security_token=i['security_token']
      )
