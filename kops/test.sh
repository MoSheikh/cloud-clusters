#!/usr/bin/env bash

SERVICE_TAG=api
ENV_TAG=dev
CLUSTER_ZONE=us-east1-b

ig_prefix=${CLUSTER_ZONE: -1}
node_ig_name=$ig_prefix-nodes-$CLUSTER_ZONE-$ENV_TAG-$SERVICE_TAG-dojolaunch-app


echo $node_ig_name