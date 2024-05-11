#!/bin/sh

export KUBE_VERSION=1.30
export CONTAINERD_VERSION=1.7.16
export RUNC_VERSION=1.1.9
export CNI_PLUGINS_VERSION=1.4.1
export ARCH=arm64

# IPv4を転送し、iptablesにブリッジされたトラフィックを認識させる
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# install Containerd
apt-get update && apt-get install -y apt-transport-https ca-certificates curl
curl -LO https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-${ARCH}.tar.gz
tar Cxzvf /usr/local containerd-${CONTAINERD_VERSION}-linux-${ARCH}.tar.gz

curl -LO https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.${ARCH}
install -m 755 runc.${ARCH} /usr/local/sbin/runc

curl -LO https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-${ARCH}-v${CNI_PLUGINS_VERSION}.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-${ARCH}-v${CNI_PLUGINS_VERSION}.tgz

mkdir -p /usr/local/lib/systemd/system
curl -o /usr/local/lib/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
systemctl daemon-reload
systemctl enable --now containerd


mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

systemctl restart containerd

# install kubeadm
apt-get update
apt-get install -y apt-transport-https

mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${KUBE_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBE_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update

# clear apt apt-get lock...
killall apt apt-get
rm /var/lib/apt/lists/lock
rm /var/lib/dpkg/lock
rm /var/lib/dpkg/lock-frontend
dpkg --configure -a

apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
