FROM octopuslabs/tentacle:latest

RUN apt-get update && \
    apt-get install -y curl sudo dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

COPY ./install-scripts/* /install-scripts/
RUN chmod +x /install-scripts/*.sh

# Install Docker daemon and CLI
COPY ./scripts/dockerd-entrypoint.sh /usr/local/bin/
RUN /install-scripts/install-docker.sh

VOLUME /var/lib/docker