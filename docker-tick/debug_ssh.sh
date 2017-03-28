#!/bin/bash

echo "[i] Installation of openssh"

apt-get install -y openssh-server
echo -e "root\nroot" | passwd root
rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
  ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi
#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi
timeout 2 /usr/sbin/sshd -D
sed -i 's#\#PermitRootLogin prohibit-password#PermitRootLogin yes#' /etc/ssh/sshd_config
/usr/sbin/sshd -D &
