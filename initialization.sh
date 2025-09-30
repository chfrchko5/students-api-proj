#!/bin/bash

# install minikube
echo "------ installing minikube ------"

curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# start minikube with 2 CPU, 2 GB RAM, 20 GB disk space 
echo "------ starting minikube ------"
minikube start --nodes=2 --memory="2GB" --cpus="2" --disk-size="20G"

# minikube addons to support volumes on multiple node cluster
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

# append a shortcut for 'kubectl' into aliases
echo "alias kubectl='minikube kubectl'" -- >> /home/.bashrc

# create namespaces required for the project
kubectl create namespace observ
kubectl create namespace students-api

# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml