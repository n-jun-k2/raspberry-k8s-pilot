#!/bin/sh

export ARCH=arm64
export CALICO_VERSION=3.27.3

curl -L https://github.com/projectcalico/calico/releases/download/v${CALICO_VERSION}/calicoctl-linux-${ARCH} -o kubectl-calico
chmod +x kubectl-calico

mv kubectl-calico /usr/bin
