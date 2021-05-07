# raspberry-k8s-pilot

Practice building an environment using kubernets

## Reference pages...

- [cloud-init](https://cloudinit.readthedocs.io/en/latest/topics/instancedata.html)

## Runtime Unix domain sockets path...

| runtime | path |
|---|---|
|Docker|/var/run/docker.sock|
|containerd |/run/containerd/containerd.sock|
|CRI-O |/var/run/crio/crio.sock|


## Initial setting of raspberry pi
1. [install ubuntu server 20.04 LTS](https://www.raspberrypi.org/software/)
2. [setup cmdline](doc/CMDLINE.md)
3. [setup ``network-config``](doc/NETWORK.md)
4. [setup ssh](doc/SSH.md)


## Setup cloud-init...

```bash
> make build-tools
# create user-data file.
> make user-data
# Copy the config file to the Ubuntu boot unit.
> xcopy .\config\* <target path>
```


## How to use...

```bash
# Transfer project directory
> scp -r -P <Port> ../raspberry-k8s-train <host name>@<IP address>:/tmp/src/

# Connect to device
> ssh USERNAME@192.168.XXX.YYY -p 
```

## Setup node...

```bash
> sudo -i

# Install in common (If the script fails, try running the script again)
> sh scripts/install.sh

# Master node only installation
> kubeadm init
...
kubeadm join 192.168.11.15:6443 --token 3ofe67.7aeswyreaxx6ejg6 \
    --discovery-token-ca-cert-hash sha256:78e148131354ed0e8ceeb0bb8afa1330e05c2003d88c24a02d904e13760a2800
> sh scripts/master/config.sh

# Worker node only installation
> kubeadm join 192.168.11.15:6443 --token 3ofe67.7aeswyreaxx6ejg6 \
    --discovery-token-ca-cert-hash sha256:78e148131354ed0e8ceeb0bb8afa1330e05c2003d88c24a02d904e13760a2800

# Setup complete...
root@k8s-master-0001:~# kubectl get nodes
NAME              STATUS   ROLES    AGE   VERSION
k8s-master-0001   Ready    master   19m   v1.18.2
k8s-worker-0001   Ready    <none>   18m   v1.18.2
```

> if the status of all nodes is Not Ready, restart each Raspberry pi.

## Kubernetes packages checks...

```bash
dpkg -l | grep kube
hi  kubeadm                        1.18.2-00                          arm64        Kubernetes Cluster Bootstrapping Tool
hi  kubectl                        1.18.2-00                          arm64        Kubernetes Command Line Tool
hi  kubelet                        1.18.2-00                          arm64        Kubernetes Node Agent
ii  kubernetes-cni                 0.8.7-00                           arm64        Kubernetes CNI
```

