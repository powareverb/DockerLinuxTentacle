FROM mcr.microsoft.com/dotnet/core/runtime-deps:3.1-bionic

RUN apt-get update && \
    apt-get install -y wget unzip apt-utils curl software-properties-common  

EXPOSE 10933

COPY ./scripts/* /scripts/
RUN chmod +x /scripts/*.sh

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
ENV ACCEPT_EULA=N

CMD /scripts/configure-tentacle.sh && /scripts/run-tentacle.sh