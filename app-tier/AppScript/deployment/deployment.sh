#!/bin/bash
cd /home/ansible
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16
npm install -g pm2
npm audit fix --force   
cd app-tier
npm install
npm audit fix --force
pm2 start index.js
pm2 list
sudo env PATH=$PATH:/home/ansible/.nvm/versions/node/v16.0.0/bin /home/ansible/.nvm/versions/node/v16.0.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ansible —hp /home/ansible
pm2 save