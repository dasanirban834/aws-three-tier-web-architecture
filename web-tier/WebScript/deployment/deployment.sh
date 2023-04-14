#!/bin/bash
cd /home/ansible
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16
cd web-tier
npm install
npm audit fix --force 
npm run build