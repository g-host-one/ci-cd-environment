#!/bin/bash

set -e

if ! [[ -f /root/.ssh/authorized_keys ]]; then
    if [[ "$SSH_PUB_KEY" != "" ]]; then
        echo "$SSH_PUB_KEY" > /root/.ssh/authorized_keys
    else
        ssh-keygen -t rsa -m PEM -f /root/.ssh/id_rsa -q -N ""
        mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
        cat /root/.ssh/id_rsa >> /proc/1/fd/1
    fi

    chmod 0644 /root/.ssh/authorized_keys
fi

exec /usr/sbin/sshd -D -e