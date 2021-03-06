FROM vmware/powerclicore:ubuntu18.04

RUN apt-get update && apt-get install -y wget jq git python python-pip
RUN python -m pip install pyyaml

RUN pwsh -c "Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP \$false -Confirm:\$false | Out-Null" && \
    pwsh -c "Import-Module VMware.VimAutomation.Core | Out-Null" && \
    pwsh -c "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:\$false | Out-Null"

ARG OPENSHIFT_VERSION="4.5.2"

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

ARG TERRAFORM_VERSION="0.12.28"

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/ && \
    rm -rf ./*

RUN mv /usr/bin/jq /usr/local/bin/

ARG HELM_VERSION="3.2.4"

RUN cd /tmp && \
    wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf ./*

RUN mkdir -p /terraform
RUN mkdir -p ~/.config/openstack/

WORKDIR /terraform

CMD ["/bin/bash"]
