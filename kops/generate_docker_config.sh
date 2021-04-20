#!/usr/bin/env bash

# Set $CLUSTER_NAME before using

gsutil cat gs://auth.dojolaunch.app/docker/config.json | \
    kops create secret dockerconfig -f - \
    --name=$CLUSTER_NAME
