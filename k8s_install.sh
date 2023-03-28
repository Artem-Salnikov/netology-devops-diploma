#!/bin/bash

set -e

cd terraform
terraform init 
terraform apply -auto-approve

cd ../
rm -rf kubespray/inventory/mycluster
cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster

cd terraform
bash ./generate_inventory.sh > ../kubespray/inventory/mycluster/hosts.ini
terraform output -json external_ip_address_vm_instance_master | jq -r '.[]' > ../inv
export IP_MASTER=$(terraform output -json external_ip_address_vm_instance_master | jq -r '.[]')

sleep 60

cd ../kubespray
ansible-playbook -i ../kubespray/inventory/mycluster/hosts.ini ../kubespray/cluster.yml --become --ssh-common-args='-o StrictHostKeyChecking=no'

cd ..
ansible-playbook -i inv k8s_conf.yml --user ubuntu
rm -rf inv

# kubectl delete -f grafana-networkPolicy.yaml




