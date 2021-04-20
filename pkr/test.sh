#!/usr/bin/bash

. /app/cred/git.cnf
git_url=https://$user:$token@github.com/$org

tf_url=$git_url/terraform.git
git clone $tf_url /app/tf