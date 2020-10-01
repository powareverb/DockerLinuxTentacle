# Docker Linux Tentacle
This is sample Linux-based Docker image that houses a tentacle for [Octopus Deploy](https://octopus.com).

# This docker iamge is provided as is
This docker image was created by the Octopus Advisory Team as an example for our users so they could build their own docker images.  It is used internally and it should work for 99% of your use cases, it is not officially supported.  Please do not contact support if you run into issues with this image.  

# What's in the box
The docker image includes tooling to make it easy to get going right from the start.

- PowerShell Core
- Octopus Deploy CLI
- .NET Core 3.1.x
- python
- groff
- openssh-client 
- git 
- Docker

# Docker Image information
The docker container has a few self-imposed limitations.

1) Only one tentacle instance allowed.  
2) Can either be a target OR a worker.  It cannot be both.

## Environment variables

- **SERVER_API_KEY**: The [API Key](https://octopus.com/docs/octopus-rest-api/how-to-create-an-api-key) of the Octopus Server the Tentacle should register with.
- **SERVER_USERNAME**: If not using an api key, the user to use when registering the Tentacle with the Octopus Servr.
- **SERVER_PASSWORD**: If not using an api key, the password to use when registering the Tentacle
- **SERVER_URL**: The Url of the Octopus Server the Tentacle should register with.
- **TARGET_ENVIRONMENT**: Comma delimited list of [environments](https://octopus.com/docs/infrastructure/environments) to add this target to.
- **TARGET_ROLE**: Comma delimited list of [roles](https://octopus.com/docs/infrastructure/deployment-targets#target-roles) to add to this target.
- **TARGET_WORKER_POOL**: Comma delimited list of [worker pools](https://octopus.com/docs/infrastructure/workers/worker-pools) to add to this target to.  Not needed if this container will be a target.  If set then the container will be registered as a worker.  
- **REGISTRATION_NAME**: Optional Target name, defaults to host.
- **SERVER_PORT**: The port on the Octopus Server that the Tentacle will poll for work. Defaults to 10943.
- **LISTENING_PORT**: The port that the Octopus Server will connect back to the Tentacle with. Defaults to 10933. 
- **SPACE**: The name of the [space](https://octopus.com/docs/administration/spaces) to register the tentacle with.  Default is Default.
- **COMMUNICATION_TYPE**: Whether you are using [polling tentacles or listening tentacles](https://octopus.com/docs/infrastructure/deployment-targets/windows-targets/tentacle-communication).  Default is Polling.
- **MACHINE_POLICY_NAME**: The name of the [machine policy](https://octopus.com/docs/infrastructure/deployment-targets/machine-policies) to associate the container with.  Defaults to `Default Machine Policy.`
- **DISABLE_DIND**: Indicates if docker in docker should be disabled.  Defaults to N.
- **ACCEPT_EULA**: You must accept the [Octopus Deploy EULA](https://octopus.com/legal/customer-agreement).

## Ports

- **10933**: Port tentacle will be listening on (if in listening mode).

# Examples

Here are some examples to help get your started using the tentacle

## Docker Compose - Polling Deployment Target

.ENV File
```
OCTOPUS_LINUX_TENTACLE=octopuslabs/tentacle:latest
ACCEPT_OCTOPUS_EULA=Y
OCTOPUS_SERVER_URL=https://yoururltooctopus.com
OCTOPUS_SERVER_API_KEY=YOUR API KEY
OCTOPUS_ENVIORNMENT="Test,Production"
OCTOPUS_ROLE="TestRole01,TestRole-02"
OCTOPUS_TARGET_NAME=DockerTarget-01
```

docker-compose.yml file
```
version: '3'
services:  
  octopusworker:
    image: ${OCTOPUS_LINUX_TENTACLE}
    privileged: true
    environment:
      ACCEPT_EULA: ${ACCEPT_OCTOPUS_EULA}
      SERVER_URL: ${OCTOPUS_SERVER_URL}
      SERVER_API_KEY: ${OCTOPUS_SERVER_API_KEY}            
      TARGET_ENVIRONMENT: ${OCTOPUS_ENVIORNMENT}      
      TARGET_ROLE: ${OCTOPUS_ROLE}
      REGISTRATION_NAME: ${OCTOPUS_TARGET_NAME}
```

## Docker Compose - Polling Worker

.ENV File
```
OCTOPUS_LINUX_TENTACLE=octopuslabs/tentacle:latest
ACCEPT_OCTOPUS_EULA=Y
OCTOPUS_SERVER_URL=https://yoururltooctopus.com
OCTOPUS_SERVER_API_KEY=YOUR API KEY
OCTOPUS_WORKER_POOL="DEMO WORKER POOL"
OCTOPUS_TARGET_NAME=DockerWORKER-01
```

docker-compose.yml file
```
version: '3'
services:  
  octopusworker:
    image: ${OCTOPUS_LINUX_TENTACLE}
    privileged: true
    environment:
      ACCEPT_EULA: ${ACCEPT_OCTOPUS_EULA}
      SERVER_URL: ${OCTOPUS_SERVER_URL}
      SERVER_API_KEY: ${OCTOPUS_SERVER_API_KEY}            
      TARGET_WORKER_POOL: ${OCTOPUS_WORKER_POOL}            
      REGISTRATION_NAME: ${OCTOPUS_TARGET_NAME}
```