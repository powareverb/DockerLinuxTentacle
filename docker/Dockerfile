FROM mcr.microsoft.com/dotnet/core/runtime:3.1-bionic

ARG Powershell_Version=7.0.3\*
ARG Octopus_Cli_Version=7.4.1

RUN apt-get update && \
    apt-get install -y wget unzip apt-utils curl software-properties-common  

# get powershell for 18.04
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    add-apt-repository universe && \
    apt-get install -y powershell=${Powershell_Version}

# Get Octo CLI
# https://octopus.com/downloads/octopuscli#linux
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
    curl -sSfL https://apt.octopus.com/public.key | apt-key add - && \
    sh -c "echo deb https://apt.octopus.com/ stable main > /etc/apt/sources.list.d/octopus.com.list" && \
    apt-get update && \
    apt-get install -y octopuscli=${Octopus_Cli_Version}

# Get python & groff
RUN apt-get install -y python3-pip groff

# Get common utilities for scripting
# https://mikefarah.gitbook.io/yq/
# https://augeas.net/
RUN add-apt-repository -y ppa:rmescandon/yq && \
    apt-get update && apt-get install -y jq yq openssh-client rsync git augeas-tools

RUN apt-get update && \
    apt-get install -y curl sudo dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 10933

WORKDIR /tmp

COPY ./install-scripts/* /install-scripts/
RUN chmod +x /install-scripts/*.sh

COPY ./scripts/* /scripts/
RUN chmod +x /scripts/*.sh

# Install Docker daemon and CLI
COPY ./scripts/dockerd-entrypoint.sh /usr/local/bin/
RUN /install-scripts/install-docker.sh

# Install Tentacle
RUN apt-key adv --fetch-keys https://apt.octopus.com/public.key && \
    add-apt-repository "deb https://apt.octopus.com/ stretch main" && \
    apt-get update && \
    apt-get install tentacle

WORKDIR /

ENV SERVER_URL="https://octopus.example.com/"
ENV SERVER_PORT=10943
ENV SERVER_API_KEY="API-SOURCE-THIS-FROM-YOUR-OCTOPUS-SERVER"
ENV ServerThumbprint=""
ENV SERVER_USERNAME=""
ENV SERVER_PASSWORD=""
ENV TARGET_ENVIRONMENT=""
ENV TARGET_ROLE=""
ENV REGISTRATION_NAME=""
ENV SPACE="Default"
ENV TARGET_WORKER_POOL=""
ENV MACHINE_POLICY_NAME="Default Machine Policy"
ENV COMMUNICATION_TYPE="Polling"
ENV DISABLE_DIND=N
ENV ACCEPT_EULA=N

VOLUME /var/lib/docker

CMD /scripts/configure-tentacle.sh && /scripts/run-tentacle.sh