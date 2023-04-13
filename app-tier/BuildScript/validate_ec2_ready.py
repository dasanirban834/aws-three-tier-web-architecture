import boto3
import json
import os
import sys
import time

client = boto3.client('ec2')
response = client.describe_instances(
    Filters=[
        {
            'Name': 'tag:Layer',
            'Values': [
                'App'
            ]
        }
    ]
)

status_code = []
instance_id = []
for r in response['Reservations']:
    for i in r['Instances']:
        id = i['InstanceId']
        instance_id.append(id)

def validate_ec2_ready():
        for ins in range(0, len(instance_id)):
            instance_status_resp = client.describe_instance_status(
                InstanceIds=[
                    instance_id[ins],
                ],
            )
            for insstat in instance_status_resp['InstanceStatuses']:
                Instance_Status = insstat['InstanceStatus']['Status']
                System_Status = insstat['SystemStatus']['Status']
                print(f"Index: {ins} => InstanceId: {instance_id[ins]} => Instance_Status: {Instance_Status} => System_Status: {System_Status}")
                if Instance_Status and System_Status == "initializing":
                    status_dict = {
                        "Status_Code": "1",
                        "Comments": "Instances are not ready. Please wait few minutes"
                    }
                    status_code.append(status_dict['Status_Code'])
                elif Instance_Status and System_Status == "impaired":
                    status_dict = {
                        "Status_Code": "0",
                        "Comments": "Instances are not instantiated due to some reasons. Please try to stop and start the instances again."
                    }
                    status_code.append(status_dict['Status_Code'])

                elif Instance_Status and System_Status == "ok":
                    status_dict = {
                        "Status_Code": "2",
                        "Comments": "Success!! Instances are ready."
                    }
                    status_code.append(status_dict['Status_Code'])


for i in range(100):
    print("Iteration:", i)
    if len(status_code) != len(instance_id) and status_code.count("2") != len(instance_id):
        time.sleep(5)
        validate_ec2_ready()
        print(f"Status code in iteration {i}: {status_code}", '\n')
        if status_code.count("2") == len(instance_id):
            print(f"All EC2 instances are ready to work. Standing time starts..")
            time.sleep(30)
            sys.exit()
        status_code.clear()
