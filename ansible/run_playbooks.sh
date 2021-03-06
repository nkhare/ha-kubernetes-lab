#!/bin/bash

# $1 is playbook to run string
# $2 is inventory string
# $3 is filename string

function run_playbook () {
  echo "Running: ansible-playbook $1 -i $2 at $(date)"
  ansible-playbook $1 -i $2 >> $3 2>&1
  if [ $? -eq 0 ]; then
    echo "Success."
  else
    echo "Unsuccessful playbook. Error Code $?"
    exit 1
  fi
}

echo "Beginning Installation at $(date)."

run_playbook provision_core_servers.yaml inventory.py install.out
run_playbook update_resolv.yaml inventory.py install.out
run_playbook provision_lb_servers.yaml inventory.py install.out
run_playbook create_and_expose_ssl_certs.yaml inventory.py install.out
run_playbook download_certs.yaml inventory.py install.out
run_playbook provision_etcd_servers.yaml inventory.py install.out
run_playbook provision_k8s_controllers.yaml inventory.py install.out
run_playbook provision_k8s_workers.yaml inventory.py install.out
run_playbook provision_k8s_l3_routes.yaml inventory.py install.out
run_playbook provision_k8s_addons.yaml inventory.py install.out

echo "Ending Installation at $(date)."
