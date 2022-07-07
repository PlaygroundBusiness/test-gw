#!/bin/bash
yqs='(.extraEnv | .[(to_entries | .[] | select(.value.name == env(EXTRA_ENV_KEY)).key) // length]) += {"name": env(EXTRA_ENV_KEY), "value": env(EXTRA_ENV_VALUE)}'

yq -i "$yqs" $SERVICE_FILE_NAME

