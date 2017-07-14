#!/bin/bash

# Error if non-true result
set -e

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo "Usage: deploy-turnserver.sh <postgres_connection_string> <default_realm> <auth_method>"
    exit 1
fi

# Error on unset variables
set -u

echo Discovering internal and external ip address...
internalIp="$(ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
externalIp="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo External ip address: $externalIp
echo Internal ip address: $internalIp

if [ $3 == 'shared_secret' ]
then
    useAuthSecret="--use-auth-secret"
else
    useAuthSecret=""
fi

echo Starting turnserver with auth methos $auth_method 

exec turnserver -v \
    -n \
    -L "$internalIp" \
    -E "$internalIp" \
    -X "$externalIp" \
    --lt-cred-mech \
    $auth_method \
    --cert "etc/ssl/turn_server_cert.pem" \
    --pkey "etc/ssl/turn_server_pkey.pem" \
    --psql-userdb "$1" \
    --realm $2
