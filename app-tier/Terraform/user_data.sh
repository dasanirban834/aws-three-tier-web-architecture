#!/bin/bash
sudo yum update -y
USER='ansible'
sudo useradd -m $USER
sudo mkdir /home/$USER/.ssh
sudo echo $ANSIBLE_PUBLIC_SSH_KEY > /home/$USER/.ssh/authorized_keys
sudo chown -R $USER:$USER /home/$USER/.ssh/
sudo chown -R $USER:$USER /home/$USER/.ssh/authorized_keys
sudo echo ''$USER'  ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/11-$USER
sudo yum install git -y