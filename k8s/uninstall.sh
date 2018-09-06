#!/bin/bash

set -e

echo -e "\033[33mWARNING: Delete hyperkube!\033[0m"
rm -f /usr/bin/{hyperkube,kube-apiserver,kube-controller-manager,kube-scheduler,kubelet,kube-proxy,cloud-controller-manager,kubectl}

echo -e "\033[33mWARNING: Delete kubernetes config!\033[0m"
rm -rf /etc/kubernetes /var/log/kube-audit /var/lib/kubelet

echo -e "\033[33mWARNING: Delete kubernetes systemd config!\033[0m"
allServices=(kube-apiserver kube-controller-manager kube-proxy kube-scheduler kubelet)
for serviceName in ${allServices[@]};do
    if [ -f "/lib/systemd/system/${serviceName}.service" ]; then
        systemctl disable ${serviceName}
        systemctl stop ${serviceName}
        rm -f /lib/systemd/system/${serviceName}.service
        echo -e "\033[33mDelete: /lib/systemd/system/${serviceName}.service\033[0m"
    fi
done
systemctl daemon-reload
