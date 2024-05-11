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
# clipboard copy. (windows)
> clip < %USERPROFILE%\.ssh\ssh_key.pub
# create user-data file.
> make user-data
...
...
# create network-config
> make network-conf
...
...
# Copy the config file to the Ubuntu boot unit.
> xcopy .\config\* <target path>
```


## How to use...

#### Update cidr in "custom-resources.yaml":

> original data: https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml

```yaml
apiVersion: operator.tigera.io/v1
...
spec:
  calicoNetwork:
    ipPools:
    - blockSize: 26
      cidr: 192.168.0.20/24 # Address of "kubeadm init pod-network-cidr"
...
```

#### Deploy setup script to cluster:

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

> kubeadm config images pull
[config/images] Pulled registry.k8s.io/kube-apiserver:v1.30.0
[config/images] Pulled registry.k8s.io/kube-controller-manager:v1.30.0
[config/images] Pulled registry.k8s.io/kube-scheduler:v1.30.0
[config/images] Pulled registry.k8s.io/kube-proxy:v1.30.0
[config/images] Pulled registry.k8s.io/coredns/coredns:v1.11.1
[config/images] Pulled registry.k8s.io/pause:3.9
[config/images] Pulled registry.k8s.io/etcd:3.5.12-0



# <Calico> Master node only installation
> kubeadm init --apiserver-advertise-address=192.168.xx.yy --pod-network-cidr=10.240.0.0/16
...
Your Kubernetes control-plane has initialized successfully!

...

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.xx.yy:6443 --token zz.eeee \
        --discovery-token-ca-cert-hash sha256:...

> /tmp/src/master/config.sh

> kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml

# setup cni
> /tmp/src/master/setup_cni_calico.sh

> kubectl get nodes
NAME      STATUS   ROLES           AGE   VERSION
k8s0001   Ready    control-plane   45m   v1.30.0

# install calicoctl
> /tmp/src/master/install_kubectl_calico.sh

# Verify the plugin works. 
> kubectl calico -h
Usage:
  kubectl-calico [options] <command> [<args>...]
...
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

# Set NAMESPACE

```bash
# create config.
# make setconfig name=<new config name> space=<namespace>
> make setconfig name=example space=example-namespace

# show config
> make showconfig
kubectl config get-contexts
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
          example                       kubernetes   kubernetes-admin   example-namespace
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin

# switch config.
# make useconfig name=<config name>
>make useconfig name=example                    
kubectl config use-context example
Switched to context "example".
```

# Create workspace 

Procedure for creating a new Terraform Workspace.

A directory called terraform.tfstate.d will be created, and a workspace directory will be created under it.

```bash
# new workspace..
# make workspace-<new workspace name>"
> make workspace-qa1
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' に入ります
Creating raspberry-k8s-pilot_tf_run ... done
Created and switched to workspace "qa1"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' から出ます
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' に入ります
Creating raspberry-k8s-pilot_sh_run ... done
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' から出ます
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' に入ります
Creating raspberry-k8s-pilot_sh_run ... done
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' から出ます
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' に入ります
Creating raspberry-k8s-pilot_tf_run ... done

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
make[1]: ディレクトリ `C:/work/raspberry-k8s-pilot' から出ます
```


kubeadm join 192.168.11.101:6443 --token 4jpsfx.au0ugkt52dykzbp5 \
        --discovery-token-ca-cert-hash sha256:cd8b67cd47e14cd6e667229e78a224424d77be9a858908f9f4193156568826bc
