#############################################################################################################

                #Description: Create Terraform Cloud Workspace
                # Author: Anirban Das

#############################################################################################################
print('******************************************************Start Creation of Terraform Cloud Workspace******************************************************', '\n')

import os
import requests
import json
import sys
import time

time.sleep(5)
# Fetch variables:

HEADERS = {"Content-Type": "application/vnd.api+json",}
ENV = os.environ["ENV"]
GITLAB_PROJECT_NAME = os.environ['GITLAB_PROJECT_NAME']
WORKSPACE_NAME = f"tfc-{GITLAB_PROJECT_NAME}-{ENV}"
ORGANIZATION = ['PROD_TFC', 'TEST_TFC']
TFC_URL = 'app.terraform.io'
print('\n')
# Load credentials :

def load_api_credentials():
    path = '/home/gitlab-runner/creds/cred.json'
    with open(path, 'r') as f:
        read_data = f.read()
        load_data = json.loads(read_data)
        if ENV == 'prod':
            TFC_API_TOKEN = load_data["TFC_API_TOKEN_PROD"]
            print(f'*************Authentication Update : Production token has been added*************', '\n')
        elif ENV == 'test':
            TFC_API_TOKEN = load_data["TFC_API_TOKEN_TEST"]
            print(f'*************Authentication Update : Testing token has been added*************', '\n')
        else:
            print("Not Found")

        if not TFC_API_TOKEN:
            raise RuntimeError(f"Unable to load credentials at {path}")
        else:
            HEADERS["Authorization"] = f"Bearer {TFC_API_TOKEN}"

load_api_credentials()

ORGANIZATION = ORGANIZATION[0] if ENV == 'prod' else ORGANIZATION[1]
os.environ['ORGANIZATION'] =  ORGANIZATION

def createtfcworkspce():
    get_req = requests.request("GET", f"https://{TFC_URL}/api/v2/organizations/{ORGANIZATION}/workspaces/{WORKSPACE_NAME}", headers=HEADERS)
    if get_req.status_code == 200 and "id" in json.loads(get_req.text)['data']:
        WORKSPACE_ID = json.loads(get_req.text)['data']['id']
        print(f"Workspace : \'{WORKSPACE_NAME}\' does already exist. Workspace ID : ", json.loads(get_req.text)['data']['id'], '\n')
        time.sleep(5)
        os.environ['WORKSPACE_ID'] = json.loads(get_req.text)['data']['id']
    else:
        print('************* Creating of TFC workspaces*************')
        PAYLOAD = json.dumps(
                {
                      "data": {
                            "attributes": {
                                "name": WORKSPACE_NAME,
                            },
                            "type": "workspaces"
                        }
                })

        post_req = requests.request("POST", f"https://{TFC_URL}/api/v2/organizations/{ORGANIZATION}/workspaces", headers=HEADERS, data=PAYLOAD)
        print('\n')
        print(post_req.text, '\n')
        if post_req.status_code == 201 and "id" in json.loads(post_req.text)['data']:
            WORKSPACE_ID = json.loads(post_req.text)['data']['id']
            print(f'Success !! Workspace has been created with {post_req.status_code} code. Workspace ID : {WORKSPACE_ID}', '\n')
            os.environ['WORKSPACE_ID'] = json.loads(post_req.text)['data']['id']
            def setVar():
                print('***********Add the variables to the workspace***********', '\n')
                PAYLOAD1 = json.dumps(
                        {
                            "data": {
                                "type": "vars",
                                "attributes": {
                                    "key": "AWS_DEFAULT_REGION",
                                    "value": os.environ['AWS_DEFAULT_REGION'],
                                    "category": "env",
                                    "hcl": False,
                                    "sensitive": True
                                },
                                "relationships": {
                                    "workspace": {
                                        "data": {
                                            "id": WORKSPACE_ID,
                                            "type": "workspaces"
                                        }
                                    }
                                }
                            }
                        })

                PAYLOAD2 = json.dumps(
                        {
                            "data": {
                                "type": "vars",
                                "attributes": {
                                    "key": "AWS_SECRET_ACCESS_KEY",
                                    "value": os.environ['AWS_SECRET_ACCESS_KEY'],
                                    "category": "env",
                                    "hcl": False,
                                    "sensitive": True
                                },
                                "relationships": {
                                    "workspace": {
                                        "data": {
                                            "id": WORKSPACE_ID,
                                            "type": "workspaces"
                                        }
                                    }
                                }
                            }
                        })

                PAYLOAD3 = json.dumps(
                        {
                            "data": {
                                "type": "vars",
                                "attributes": {
                                    "key": "AWS_ACCESS_KEY_ID",
                                    "value": os.environ['AWS_ACCESS_KEY_ID'],
                                    "category": "env",
                                    "hcl": False,
                                    "sensitive": True
                                },
                                "relationships": {
                                    "workspace": {
                                        "data": {
                                            "id": WORKSPACE_ID,
                                            "type": "workspaces"
                                        }
                                    }
                                }
                            }
                        })

                post_req1 = requests.request("POST", f"https://{TFC_URL}/api/v2/vars", headers=HEADERS, data=PAYLOAD1)
                print(post_req1.text, post_req1.status_code, '\n')
                time.sleep(1)
                post_req2 = requests.request("POST", f"https://{TFC_URL}/api/v2/vars", headers=HEADERS, data=PAYLOAD2)
                print(post_req2.text, '\n')
                time.sleep(1)
                post_req3 = requests.request("POST", f"https://{TFC_URL}/api/v2/vars", headers=HEADERS, data=PAYLOAD3)
                print(post_req3.text, '\n')
                print('Success !! All the variables have been added to the workspace', '\n')

            setVar()
            os.system('bash')

        else:
            raise RuntimeError(f"Failed !! Try again.")

createtfcworkspce()
os.system('bash')

# Fetching Workspace ID:

WORKSPACE_ID = os.environ['WORKSPACE_ID']


#############################################################################################################

                #Description: Create Configuration Versions
                # Author: Anirban Das

#############################################################################################################
print('******************************************************Start Creation of Configuration Versions******************************************************', '\n')
time.sleep(5)
''' Start Creating Configuration Versions '''

PAYLOAD = json.dumps(
        {
              "data": {
                    "type": "configuration-versions",
                    "attributes": {
                        "auto-queue-runs": False
                    }
                }
        })

post_req = requests.request("POST", f"https://{TFC_URL}/api/v2/workspaces/{WORKSPACE_ID}/configuration-versions", headers=HEADERS, data=PAYLOAD)
time.sleep(2)
print(post_req.text, '\n')
time.sleep(1)
if post_req.status_code == 201 and 'id' in json.loads(post_req.text)['data']:
    print(f"Status Code : {post_req.status_code}. Configuration version is created succesfully.", '\n')
    time.sleep(1)
    CV_ID = json.loads(post_req.text)['data']['id']
    os.environ['CV_ID'] = CV_ID
    print(f"Configuration Versions ID : {CV_ID}", '\n')
    time.sleep(1)
    UPLOAD_URL = json.loads(post_req.text)['data']['attributes']['upload-url']
    time.sleep(2)
    print(f"UPLOAD URL : {UPLOAD_URL}", '\n')
    os.environ['UPLOAD_URL'] = UPLOAD_URL
else:
    raise RuntimeError("Creation Failed. Please try again.")


#############################################################################################################

                #Description: Uploading COnfiguration Files
                # Author: Anirban Das

#############################################################################################################
print('******************************************************Uploading Configuration Versions******************************************************', '\n')
time.sleep(5)

'''Upload Configuration Files'''

UPLOAD_URL = os.environ['UPLOAD_URL']
UPLOAD_FILE_NAME = os.environ['UPLOAD_FILE_NAME']
HEADER_1 = {'Content-Type': 'multipart/form-data'}
files = {'files': open(UPLOAD_FILE_NAME, 'rb')}

put_req = requests.request("PUT", UPLOAD_URL, files=files)
time.sleep(1)
print(f'Status : {put_req.status_code}', '\n')
#print(put_req.text)
if put_req.status_code == 200:
    time.sleep(1)
    print("Success !! Files have been uploaded", '\n')
else:
    print("Failed. Try again", '\n')

# Fetching Oragnization and CV_ID:

ORGANIZATION = os.environ['ORGANIZATION']
CV_ID = os.environ['CV_ID']

#############################################################################################################

                #Description: Create Terraform Run and Plan
                # Author: Anirban Das

#############################################################################################################
print('******************************************************Start Create Run Job******************************************************', '\n')
time.sleep(5)

'''Create a run:'''

PAYLOAD = json.dumps(
        {
            "data": {
                "attributes": {
                    "message": "Triggered via API"
                },
            "type": "runs",
            "relationships": {
                "workspace": {
                    "data": {
                        "type": "workspaces",
                        "id": WORKSPACE_ID
                    }
                },
                "configuration-version": {
                    "data": {
                        "type": "configuration-versions",
                        "id": CV_ID
                    }
                }
            }
            }
        })

post_req = requests.request("POST", f"https://{TFC_URL}/api/v2/runs", headers=HEADERS, data=PAYLOAD)
print(post_req.text, '\n')
status = json.loads(post_req.text)['data']['attributes']['status']
if post_req.status_code == 201 and json.loads(post_req.text)['data']['attributes']['status'] == 'pending':
    run_id = json.loads(post_req.text)['data']['id']
    if run_id == "":
        print("Running workspace failed")
    else:
        print(f"Succeeded. The run id is : {run_id}", '\n')
        os.environ['RUN_ID'] = run_id
        run_details = requests.request("GET", f"https://{TFC_URL}/api/v2/runs/{run_id}", headers=HEADERS)
        print(run_details.text, '\n')
        status = json.loads(run_details.text)['data']['attributes']['status']
        print(f"Run Status : {status}", '\n')
        plan_id = json.loads(run_details.text)['data']['relationships']['plan']['data']['id']
        apply_id = json.loads(run_details.text)['data']['relationships']['apply']['data']['id']
        os.environ['PLAN_ID'] =  plan_id
        os.environ['APPLY_ID'] = apply_id
        print(f"Plan execution status : \'{status}\' and Plan ID is : {plan_id}", '\n')
        time.sleep(5)
        def call_api(number):
            for i in range(number):
                time.sleep(1.5)
                show_status = requests.request("GET", f"https://{TFC_URL}/api/v2/plans/{plan_id}", headers=HEADERS)
                plan_status = json.loads(show_status.text)['data']['attributes']['status']
                if plan_status ==  "pending":
                        print(f"Plan Status : {plan_status}")
                elif plan_status == "agent_queued":
                        print(f"Plan Status : {plan_status}")
                elif plan_status == "running":
                        print(f"Plan Status : {plan_status}")
                elif plan_status == "errored":
                        print(f"Plan Status : {plan_status}", '\n')
                        raise RuntimeError("Error !! Please try again")
                elif plan_status == "canceled":
                        print(f"Plan Status : {plan_status}", '\n')
                        raise RuntimeError("Cancelation has been triggered, hence closing this process")
                        sys.exit(0)
                elif plan_status == "finished":
                        print(f"Plan Status : {plan_status}", '\n')
                        print("Planning has been completed successfully", '\n')
                        RUN_ID = os.environ['RUN_ID']
                        PLAN_ID = os.environ['PLAN_ID']
                        APPLY_ID = os.environ['APPLY_ID']
                        print(f" Run ID : {RUN_ID} \n Plan ID : {PLAN_ID} \n Apply ID : {APPLY_ID} \n ")
                        sys.exit(0)

        call_api(30)
