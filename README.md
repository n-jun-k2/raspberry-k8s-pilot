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
> scp -r -P <Port> .\scripts <host name>@<IP address>:/tmp/src/

# Connect to device
> ssh USERNAME@192.168.XXX.YYY -p 
```

## Setup node...

```bash
> sudo -i

# Install in common (If the script fails, try running the script again)
> sh scripts/install.sh

# Master node only installation
> kubeadm init --apiserver-advertise-address=192.168.11.15 --pod-network-cidr=10.244.0.0/16
...
kubeadm join 192.168.11.15:6443 --token 3ofe67.7aeswyreaxx6ejg6 \
    --discovery-token-ca-cert-hash sha256:78e148131354e...904e13760a2800
# setup config
> sh scripts/master/config.sh
# deploy flannel (https://github.com/flannel-io/flannel)
> kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.14.0/Documentation/kube-flannel.yml



# Worker node only installation
> kubeadm join 192.168.11.15:6443 --token 3ofe67.7aeswyreaxx6ejg6 \
    --discovery-token-ca-cert-hash sha256:78e148131354e...904e13760a2800

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

## kubectl setup...

```powershell
> cd ~
> mkdir .kube
> cd .kube
> New-Item config -type file
> ssh <user name>@<IP address> sudo kubectl config view --raw > ~/.kube/config
```

## terraform run...

```powershell
> make terraform init
make terraform CMD=init
docker-compose run --rm tf init
Creating raspberry-k8s-pilot_tf_run ... done

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/kubernetes versions matching "2.1.0"...
- Installing hashicorp/kubernetes v2.1.0...
- Installed hashicorp/kubernetes v2.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
