FROM octopuslabs/tentacle:latest

ARG Powershell_Version=7.0.3\*
ARG Octopus_Cli_Version=7.4.1
ARG Octopus_Client_Version=8.8.3
ARG Azure_Cli_Version=2.10.1\*
ARG Azure_Powershell_Version=4.5.0
ARG Helm_Version=v3.3.0
ARG Node_Version=12.18.4\*
ARG Kubectl_Version=1.18.8-00
ARG Terraform_Version=0.13.0
ARG Eks_Cli_Version=0.25.0
ARG Ecs_Cli_Version=1.20.0
ARG Aws_Iam_Authenticator_Version=0.5.1
ARG Umoci_Version=0.4.6

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

# Get AZ Powershell core modules
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-3.6.1
RUN pwsh -c 'Install-Module -Force -Name Az -AllowClobber -Scope AllUsers -MaximumVersion "'${Azure_Powershell_Version}'"'

# Get JDK
# https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04
RUN apt-get install -y default-jdk

# Install common Java tools
RUN apt-get install -y maven gradle

# Get Azure CLI
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN wget --quiet -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli=${Azure_Cli_Version}

# Get NodeJS
# https://websiteforstudents.com/how-to-install-node-js-10-11-12-on-ubuntu-16-04-18-04-via-apt-and-snap/\
RUN wget --quiet -O - https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs=${Node_Version}

# Get Terraform
# https://computingforgeeks.com/how-to-install-terraform-on-ubuntu-centos-7/
RUN wget https://releases.hashicorp.com/terraform/${Terraform_Version}/terraform_${Terraform_Version}_linux_amd64.zip && \
    unzip terraform_${Terraform_Version}_linux_amd64.zip && \
    mv terraform /usr/local/bin

# Install Google Cloud CLI
# https://cloud.google.com/sdk/docs/downloads-apt-get
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get install -y ca-certificates gnupg && \
    wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-sdk

# Get python & groff
RUN apt-get install -y python3-pip groff

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

# Get common utilities for scripting
# https://mikefarah.gitbook.io/yq/
# https://augeas.net/
RUN add-apt-repository -y ppa:rmescandon/yq && \
    apt-get update && apt-get install -y jq yq openssh-client rsync git augeas-tools