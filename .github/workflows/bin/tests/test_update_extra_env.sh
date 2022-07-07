#!/bin/bash

export SERVICE_FILE_NAME="$(dirname $0)/.tmp-gateway.yaml"
rm $SERVICE_FILE_NAME || true

function testExtraEnv {
  echo "$3" > $SERVICE_FILE_NAME
  EXTRA_ENV_KEY=$1 EXTRA_ENV_VALUE=$2 ../update_extra_env.sh
  fileContent=$(cat $SERVICE_FILE_NAME)
  [ "$fileContent" == "$4" ] && echo 'Test succeeded' || (echo -e "Test failed!\n\n--> Received:\n$fileContent\n\n--> Expected:\n$4")
}

###############################
## Without extranEnv
###############################
before="service: graphql-gateway"
after=$(cat << EOF
service: graphql-gateway
extraEnv:
  - name: SCHEMA_ID
    value: 123
EOF
)
testExtraEnv "SCHEMA_ID" "123" "$before" "$after"

###############################
## With extraEnv and key doesn't exist
###############################
before=$(cat << EOF
service: graphql-gateway
extraEnv:
  - name: ENV
    value: development
EOF
)
after=$(cat << EOF
service: graphql-gateway
extraEnv:
  - name: ENV
    value: development
  - name: SCHEMA_ID
    value: 123
EOF
)
testExtraEnv "SCHEMA_ID" "123" "$before" "$after"

###############################
## With extraEnv and key exists
###############################
before=$(cat << EOF
service: graphql-gateway
extraEnv:
  - name: SCHEMA_ID
    value: 12345
EOF
)
after=$(cat << EOF
service: graphql-gateway
extraEnv:
  - name: SCHEMA_ID
    value: 123
EOF
)
testExtraEnv "SCHEMA_ID" "123" "$before" "$after"

