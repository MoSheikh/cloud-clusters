#!/usr/bin/bash

sleep 30

sudo mkdir /app
sudo mkdir /app/cred
sudo mkdir /app/init
sudo mkdir /app/k8s
sudo mkdir /app/tf

sudo chmod 777 -R --preserve-root /app
sudo chown -R --preserve-root $(whoami):$(whoami) /app

gsutil cp -r gs://devops.dojolaunch.app/cred/ /app
gsutil cp -r gs://devops.dojolaunch.app/init/ /app
gsutil cp -r gs://devops.dojolaunch.app/k8s/ /app
gsutil cp -r gs://devops.dojolaunch.app/k8s/ /app

printf "" | sudo tee /etc/environment > /dev/null
echo "export KOPS_FEATURE_FLAGS=AlphaAllowGCE,SpecOverrideFlag" | sudo tee -a /etc/environment > /dev/null
echo "export KOPS_STATE_STORE=gs://devops.dojolaunch.app/kops/" | sudo tee -a /etc/environment > /dev/null

sudo bash /app/init/deps.sh

. /app/cred/git.cnf
git_url=https://$user:$token@github.com/$org

tf_url=$git_url/terraform.git
git clone $tf_url /app/tf