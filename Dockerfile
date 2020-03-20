FROM vmware/powerclicore:ubuntu18.04

RUN apt-get update

RUN apt-get install -y wget jq git \
    && apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 install --upgrade pip

# Update Modules
#RUN pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Update-Module -Force -AcceptLicense -Confirm:\$false"

RUN pwsh -c "Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP \$false -Confirm:\$false | Out-Null" && \
    pwsh -c "Import-Module VMware.VimAutomation.Core | Out-Null" && \
    pwsh -c "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:\$false | Out-Null"

ARG OPENSHIFT_VERSION="4.3.5"

RUN cd /tmp && \
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_VERSION}/openshift-install-linux-${OPENSHIFT_VERSION}.tar.gz && \
    tar -xvf openshift-install-linux-${OPENSHIFT_VERSION}.tar.gz && \
    chmod +x openshift-install && \
    mv openshift-install /usr/local/bin/ && \
    rm -rf ./*

RUN cd /tmp && \
    wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_VERSION}/openshift-client-linux-${OPENSHIFT_VERSION}.tar.gz && \
    tar -xvf openshift-client-linux-${OPENSHIFT_VERSION}.tar.gz && \
    chmod +x oc kubectl && \
    mv oc kubectl /usr/local/bin/ && \
    rm -rf ./*

ARG TERRAFORM_VERSION="0.12.20"

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/ && \
    rm -rf ./*

RUN mv /usr/bin/jq /usr/local/bin/

ARG HELM_VERSION="3.0.3"

RUN cd /tmp && \
    wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf ./*

RUN mkdir -p /terraform

#ADD . /terraform/

CMD ["/bin/bash"]
