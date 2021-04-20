#!/usr/bin/bash

kops toolbox template \
    --values values_cluster.yaml \
    --template template_cluster.yaml

