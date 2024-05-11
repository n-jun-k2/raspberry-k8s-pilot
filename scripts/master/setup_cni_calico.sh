#!/bin/sh

export CALICO_VERSION=3.27.3
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

curl https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/calico-policy-only.yaml -o calico.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/tigera-operator.yaml

kubectl create -f /tmp/src/custom-resources.yaml

watch kubectl get pods -A
