#!/bin/bash 
sudo swapoff -a
sudo modprobe br_netfilter
sudo modprobe overlay

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
sudo kubeadm reset --cri-socket=unix:///var/run/containerd/containerd.sock --force
sudo kubeadm reset --cri-socket=unix:///var/run/cri-dockerd.sock --force
#[ERROR FileAvailable--etc-kubernetes-kubelet.conf]: /etc/kubernetes/kubelet.conf already exists
#[ERROR FileAvailable--etc-kubernetes-pki-ca.crt]: /etc/kubernetes/pki/ca.crt already exists
sudo rm /etc/kubernetes/kubelet.conf
sudo rm /etc/kubernetes/pki/ca.crt
sudo rm /etc/kubernetes/bootstrap-kubelet.conf

sudo rm -rf /etc/cni/
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm $HOME/.kube/config

sudo ifconfig cni0 down
sudo ifconfig flannel.1 down
sudo ip link delete cni0
sudo ip link delete flannel.1

sudo systemctl restart containerd
sudo systemctl restart kubelet

sudo sysctl fs.inotify.max_user_instances=2280
sudo sysctl fs.inotify.max_user_watches=1255360
