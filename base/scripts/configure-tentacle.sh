#!/bin/bash
set -eux

function splitAndGetArgs {
    finalstring=""
    IFS=','
    #Convert string to array
    read -ra strarr <<< "$2"
    for i in "${strarr[@]}"; do
        finalstring+="--$1 \"$(echo $i | xargs)\" "
    done
    echo $finalstring
}

if [[ "$ACCEPT_EULA" != "Y" ]]; then
    echo "ERROR: You must accept the EULA at https://octopus.com/company/legal by passing an environment variable 'ACCEPT_EULA=Y'"
    exit 1
fi

if [ -f "/usr/bin/tentacle" ]; then
    echo "Octopus Tentacle is already configured."
    return
fi

ln -s /opt/octopus/tentacle/Tentacle /usr/bin/tentacle

# Tentacle Docker images only support once instance per container. Running multiple instances can be achieved by running multiple containers.
instanceName=Tentacle
configurationDirectory=/etc/octopus
applicationsDirectory=/home/Octopus/Applications

mkdir -p $configurationDirectory
mkdir -p $applicationsDirectory

tentacle create-instance --instance "$instanceName" --config "$configurationDirectory/tentacle.config"
tentacle new-certificate --instance "$instanceName" --if-blank

registerName=$HOSTNAME
if [[ "$REGISTRATION_NAME" != "" ]]; then
    registerName=$REGISTRATION_NAME
fi

if [[ "$TARGET_WORKER_POOL" != "" ]]; then
    workerPoolString=$(splitAndGetArgs "workerpool" "$TARGET_WORKER_POOL")
fi

if [[ "$TARGET_ENVIRONMENT" != "" ]]; then
    environmentString=$(splitAndGetArgs "environment" "$TARGET_ENVIRONMENT")
fi

if [[ "$TARGET_ROLE" != "" ]]; then
    roleString=$(splitAndGetArgs "role" "$TARGET_ROLE")
fi

if [[ "$COMMUNICATION_TYPE" != "Polling" ]]; then
    
    tentacle configure --instance "$instanceName" --app "$applicationsDirectory" --noListen "False" --reset-trust --port "$LISTENING_PORT"
    tentacle configure --trust "$ServerThumbprint"    

    if [[ "$TARGET_WORKER_POOL" != "" ]]; then
        eval tentacle register-worker --instance \"$instanceName\" --server \"$SERVER_URL\" --name \"$registerName\" --comms-style \"TentaclePassive\" --tentacle-comms-port $LISTENING_PORT --username \"$SERVER_USERNAME\" --password \"$SERVER_PASSWORD\" --apiKey \"$SERVER_API_KEY\" --space \"$SPACE\" --policy=\"$MACHINE_POLICY_NAME\" $workerPoolString --force
    else
        eval tentacle register-with --instance \"$instanceName\" --server \"$SERVER_URL\" --name \"$registerName\" --comms-style \"TentaclePassive\" --tentacle-comms-port $LISTENING_PORT --username \"$SERVER_USERNAME\" --password \"$SERVER_PASSWORD\" --apiKey \"$SERVER_API_KEY\" --space \"$SPACE\" --policy=\"$MACHINE_POLICY_NAME\" $environmentString $roleString --force
    fi
else
    tentacle configure --instance "$instanceName" --app "$applicationsDirectory" --noListen "True" --reset-trust     

    if [[ "$TARGET_WORKER_POOL" != "" ]]; then
        eval tentacle register-worker --instance \"$instanceName\" --server \"$SERVER_URL\" --name \"$registerName\" --comms-style \"TentacleActive\" --server-comms-port $SERVER_PORT --username \"$SERVER_USERNAME\" --password \"$SERVER_PASSWORD\" --apiKey \"$SERVER_API_KEY\" --space \"$SPACE\" --policy=\"$MACHINE_POLICY_NAME\" $workerPoolString --force
    else
        eval tentacle register-with --instance \"$instanceName\" --server \"$SERVER_URL\" --name \"$registerName\" --comms-style \"TentacleActive\" --server-comms-port $SERVER_PORT --username \"$SERVER_USERNAME\" --password \"$SERVER_PASSWORD\" --apiKey \"$SERVER_API_KEY\" --space \"$SPACE\" --policy=\"$MACHINE_POLICY_NAME\" $environmentString $roleString --force
    fi
fi