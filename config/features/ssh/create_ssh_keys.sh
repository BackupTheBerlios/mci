#!/bin/sh

host=$(hostname -s)
site=$(cat /etc/myname | sed -e "s|$(hostname -s).||")

dir=/$(site)/$(host)/secrets/sshkeys &&
mkdir -p $dir &&
ssh-keygen -f $dir/ssh_host_rsa_key -t rsa -N '' &&
ssh-keygen -f $dir/ssh_host_dsa_key -t dsa -N '' &&
chmod -R o-rwx,go-rwx $dir