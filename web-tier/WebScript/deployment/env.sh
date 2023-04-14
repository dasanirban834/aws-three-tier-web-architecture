#!/bin/bash
echo ALB_URL: $(aws elbv2 describe-load-balancers | jq '.LoadBalancers[0].DNSName' | xargs) > ./WebScript/deployment/vars.yml
echo USER: ansible >> ./WebScript/deployment/vars.yml
