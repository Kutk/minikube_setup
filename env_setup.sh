#!/bin/sh

#Prepare Tools

yum update -y
yum -y install epel-release
yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils tmux vim git wget

#Setup libvirt 
systemctl start libvirtd
usermod -a -G libvirt $(whoami)
sed -i 's/^#unix_sock_group/unix_sock_group/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_rw_perms/unix_sock_rw_perms/' /etc/libvirt/libvirtd.conf
systemctl enable libvirtd
systemctl restart libvirtd

#Install minikube
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube


#Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl  /usr/local/bin/

#Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#Install Docker
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker $(whoami) && newgrp docker

