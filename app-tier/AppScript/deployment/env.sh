#!/bin/bash

RDS_WRITE_INS=instance-0
echo RDS_WRITE_LINK: $(aws rds describe-db-instances --db-instance-identifier ${RDS_WRITE_INS} | jq '.DBInstances[0].Endpoint.Address' | xargs) > ./AppScript/deployment/vars.yml

RDS_READ_INS=instance-1
echo RDS_READ_LINK: $(aws rds describe-db-instances --db-instance-identifier ${RDS_READ_INS} | jq '.DBInstances[0].Endpoint.Address' | xargs) >> ./AppScript/deployment/vars.yml

echo DB_USER: $(cat /home/gitlab-runner/creds/cred.json | jq .DB_USER | xargs) >> ./AppScript/deployment/vars.yml
echo DB_PASSWORD: $(cat /home/gitlab-runner/creds/cred.json | jq .DB_PASSWORD | xargs) >> ./AppScript/deployment/vars.yml