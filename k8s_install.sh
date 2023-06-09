#!/bin/bash

set -e

cd terraform
terraform init 
terraform apply -auto-approve

cd ../
rm -rf kubespray/inventory/mycluster
cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster

cd terraform
export WORKSPACE=$(terraform workspace show)
bash ./generate_inventory.sh > ../kubespray/inventory/mycluster/hosts.ini
terraform output -json external_ip_address_vm_instance_master | jq -r '.[]' > ../inv
terraform output -json external_ip_address_vm_instance_jenkins | jq -r '.[]' > ../inv2
export IP_MASTER=$(terraform output -json external_ip_address_vm_instance_master | jq -r '.[]')

sleep 120

cd ../kubespray
ansible-playbook -i ../kubespray/inventory/mycluster/hosts.ini ../kubespray/cluster.yml --become --ssh-common-args='-o StrictHostKeyChecking=no'

cd ..
ansible-playbook -i inv k8s_conf.yml --user ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
rm -rf inv

ansible-playbook -i inv2 jenkins.yml --user ubuntu --ssh-common-args='-o StrictHostKeyChecking=no'
rm -rf inv2

export KUBECONFIG=~/.kube/$WORKSPACE/config
kubectl create namespace monitoring
kubectl create namespace myapp
helm install prometheus --namespace monitoring prometheus-community/kube-prometheus-stack
kubectl apply -f ./manifests/grafana-service-nodeport.yaml
helm install netology ./helm/myapp -n myapp