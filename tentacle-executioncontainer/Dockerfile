FROM mcr.microsoft.com/dotnet/core/runtime-deps:3.1-bionic

RUN apt-get update && \
    apt-get install -y wget unzip apt-utils curl software-properties-common  

RUN apt-get update && \
    apt-get install -y curl sudo dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 10933

WORKDIR /tmp

COPY ./scripts/* /scripts/
RUN chmod +x /scripts/*.sh

COPY ./install-scripts/* /install-scripts/
RUN chmod +x /install-scripts/*.sh

# Install Docker daemon and CLI
COPY ./scripts/dockerd-entrypoint.sh /usr/local/bin/
RUN /install-scripts/install-docker.sh

# Install Tentacle
RUN apt-key adv --fetch-keys https://apt.octopus.com/public.key && \
    add-apt-repository "deb https://apt.octopus.com/ stretch main" && \
    apt-get update && \
    apt-get install tentacle

WORKDIR /

# We know this won't reduce the image size at all. It's just to make the filesystem a little tidier.
RUN rm -rf /tmp/*

ENV DISABLE_DIND=N
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
ENV ACCEPT_EULA=N

VOLUME /var/lib/docker

CMD /scripts/configure-tentacle.sh && /scripts/run-tentacle.sh