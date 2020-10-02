FROM octopuslabs/tentacle:latest

ARG Azure_Cli_Version=2.10.1\*
ARG Azure_Powershell_Version=4.5.0
ARG Helm_Version=v3.3.0
ARG Kubectl_Version=1.18.8-00
ARG Eks_Cli_Version=0.25.0
ARG Ecs_Cli_Version=1.20.0
ARG Aws_Iam_Authenticator_Version=0.5.1
ARG Umoci_Version=0.4.6

# Get AZ Powershell core modules
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.6.1
RUN pwsh -c 'Install-Module -Force -Name Az -AllowClobber -Scope AllUsers -MaximumVersion "'${Azure_Powershell_Version}'"'

# Get Helm3
RUN wget --quiet -O - https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash -s -- -v ${Helm_Version}

# Get Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN wget --quiet -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli=${Azure_Cli_Version}

# Get Kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-using-native-package-management
RUN wget --quiet -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -  && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install -y kubectl=${Kubectl_Version}

# Install Google Cloud CLI
# https://cloud.google.com/sdk/docs/downloads-apt-get
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get install -y ca-certificates gnupg && \
    wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-sdk

# Get AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html#install-linux-awscli
RUN pip3 install "awscli>=1.18.0,<=1.19.0"  --upgrade

# Get EKS CLI
# https://github.com/weaveworks/eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/${Eks_Cli_Version}/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin

# Get ECS CLI
# https://github.com/aws/amazon-ecs-cli
RUN curl --silent --location "https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-v${Ecs_Cli_Version}" -o /usr/local/bin/ecs-cli && \
    chmod +x /usr/local/bin/ecs-cli

# Get AWS IAM Authenticator
# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
RUN curl --silent --location https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${Aws_Iam_Authenticator_Version}/aws-iam-authenticator_${Aws_Iam_Authenticator_Version}_linux_amd64 -o /usr/local/bin/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator

# Get the Istio CLI
# https://istio.io/docs/ops/diagnostic-tools/istioctl/
RUN curl -sL https://istio.io/downloadIstioctl | sh - && \
    mv /root/.istioctl/bin/istioctl /usr/local/bin/istioctl && \
    rm -rf /root/.istioctl

# Get the Linkerd CLI
# https://linkerd.io/2/getting-started/
RUN curl -sL https://run.linkerd.io/install | sh && \
    cp /root/.linkerd2/bin/linkerd /usr/local/bin && \
    rm -rf /root/.linkerd2

# Get common utilities for scripting
# https://mikefarah.gitbook.io/yq/
# https://augeas.net/
RUN add-apt-repository -y ppa:rmescandon/yq && \
    apt-get update && apt-get install -y jq yq openssh-client rsync git augeas-tools

# Skopeo
# https://github.com/containers/skopeo/blob/master/install.md
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list" && \
    wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_18.04/Release.key -O- | apt-key add - && \
    apt-get update && apt-get install -y skopeo