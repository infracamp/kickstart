#!/bin/bash


secretsEnv = $(env | grep ^KICKSECRET | sed 's/KICKSECRET_\([a-zA-Z0-9_]\+\).*/\1/');
for secret in $(env | grep ^KICKSECRET | sed 's/KICKSECRET_\([a-zA-Z0-9_]\+\).*/\1/'); do
    secretName="KICKSECRET_$secret"
    echo ${!secretName} > "/tmp/.kicksecret.$secretName"

    echo "adding secret $secret: ${!secretName}";
done;
