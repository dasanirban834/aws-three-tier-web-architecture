#/bin/bash

export AWS_ACCESS_KEY_ID=$(cat /home/gitlab-runner/creds/cred.json | jq .AWS_ACCESS_KEY_ID | xargs)
export AWS_SECRET_ACCESS_KEY=$(cat /home/gitlab-runner/creds/cred.json | jq .AWS_SECRET_ACCESS_KEY | xargs)
export AWS_DEFAULT_REGION=$(cat /home/gitlab-runner/creds/cred.json | jq .AWS_DEFAULT_REGION | xargs)
export TFC_API_TOKEN_TEST=$(cat /home/gitlab-runner/creds/cred.json | jq .TFC_API_TOKEN_TEST | xargs)
export TFC_API_TOKEN_PROD==$(cat /home/gitlab-runner/creds/cred.json | jq .TFC_API_TOKEN_PROD | xargs)
export ENV="prod"
export GITLAB_PROJECT_ID="44038888"
export GITLAB_PROJECT_NAME="3_db-tier"
export GITLAB_PROJECT_PATH="anirban-grp/aws-project/aws-three-tier-web-architecture/db-tier"
export GITLAB_PROJECT_URL="https://gitlab.com/anirban-grp/aws-project/aws-three-tier-web-architecture/db-tier"

declare -a arr=("ENV" "GITLAB_PROJECT_ID" "GITLAB_PROJECT_NAME" "GITLAB_PROJECT_PATH" "GITLAB_PROJECT_URL")
for i in "${arr[@]}"
do
        echo "$i = ${!i}"
done

export CONTENT_DIRECTORY=Terraform
export UPLOAD_FILE_NAME="./content.tar.gz"
tar -zcvf "$UPLOAD_FILE_NAME" -C "$CONTENT_DIRECTORY" .
