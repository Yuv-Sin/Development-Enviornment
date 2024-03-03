#!/bin/bash

cd ./Ansible/

ansible-playbook infrasetup.yml 2>&1 | tee /tmp/ansiblelogs/infrasetup.log


if [ $? -eq 0 ]; then
    sleep 10
    ansible-playbook storage-1.yml 2>&1 | tee /tmp/ansiblelogs/storage-1.log &
    ansible-playbook developer-1.yml 2>&1 | tee /tmp/ansiblelogs/developer-1.log &
    ansible-playbook compile-1.yml 2>&1 | tee /tmp/ansiblelogs/compile-1.log &
    ansible-playbook docker.yml 2>&1 | tee /tmp/ansiblelogs/docker.log &
else
    
    echo "Playbook 1 failed. Please check the logs in /tmp/ansiblelogs"
fi

wait
