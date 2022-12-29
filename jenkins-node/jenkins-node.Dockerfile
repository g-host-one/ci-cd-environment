FROM ubuntu:22.04

## Pass the public SSH key using environment variable SSH_PUB_KEY

RUN set -e && \
    apt update && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt install -y --no-install-recommends \
        openssh-server \
        git \
        apt-utils \
        curl \
        gnupg \
        xz-utils \
        openjdk-11-jre-headless && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' \
        -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' \
        -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' && \
    mkdir -pm 0700 /root/.ssh && \
    mkdir -pm 0755 /var/run/sshd

COPY jenkins-node.sh /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["jenkins-node.sh"]