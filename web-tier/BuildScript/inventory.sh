#!/bin/bash
TAG_NAME="Layer"
TAG_VAL="Web"
echo "`aws ec2 describe-instances --filters "Name=tag:$TAG_NAME, Values=$TAG_VAL" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text | awk '{print $1" ""ansible_user=ansible"}'`\n" > ./Ansible/inventory/host
sed '$ s/..$//' ./Ansible/inventory/host > ./Ansible/inventory/hosts
rm -f ./Ansible/inventory/host
cp -r ./Ansible/inventory/hosts WebScript/deployment/
