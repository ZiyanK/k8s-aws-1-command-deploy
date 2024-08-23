# Change to root user
sudo su

# Update packages
sudo apt update
sudo apt-get update && sudo apt-get upgrade -y

sudo apt -y install curl apt-transport-https

# Install containerd
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

echo "Applying sysctl params"
sudo sysctl --system

echo "Verify that the br_netfilter, overlay modules are loaded by running the following commands:"
lsmod | grep br_netfilter
lsmod | grep overlay

echo "Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running the following command:"
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

echo "Update packages list"
sudo apt-get update

echo "Install containerd"
sudo apt-get -y install containerd

echo "Create a default config file at default location"
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

echo "Restarting containerd"
sudo systemctl restart containerd

# Install kubeadm, kubelet and kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# Check if kubectl and kubeadm install correctly
kubectl version --client && kubeadm version

# Fix ContainerD
sed -i -e 's/SystemdCgroup = false/SystemdCgroup = true/g' "/etc/containerd/config.toml"