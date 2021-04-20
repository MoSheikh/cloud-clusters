#!/usr/bin/env bash

##
#
#   When reusing this script, check the following properties:
#       
#       - GCE_SERVICE_ACCOUNT: update to match regional service account
#       - DNS_ZONE: update to match region
#       - MASTER_PUBLIC_NAME: update to match environment and service
#       - CLUSTER_NAME: update to match environment and service
#       - CLUSTER_ZONE: update to match region
#
##

export KOPS_STATE_STORE=gs://devops.dojolaunch.app/kops/
export KOPS_FEATURE_FLAGS=AlphaAllowGCE

CLOUD_PROVIDER=gce
GCE_SERVICE_ACCOUNT=master-ue1@dojolaunch-302702.iam.gserviceaccount.com
PROJCECT=dojolaunch-302702
DNS_ZONE=dev.dojolaunch.app

CLUSTER_NAME=api.dev.k8s.local
CLUSTER_ZONES=us-east1-b

MASTER_PUBLIC_NAME=master.api.dev
MASTER_TYPE=e2-micro
MASTER_COUNT=1
MASTER_IMAGE=debian-cloud/debian-10-buster-v20210122
MASTER_VOLUME_TYPE=pd-standard
MASTER_VOLUME_SIZE=20

NODE_TYPE=e2-micro
NODE_COUNT=1
NODE_IMAGE=debian-cloud/debian-10-buster-v20210122
NODE_VOLUME_TYPE=pd-standard
NODE_VOLUME_SIZE=20

ADDITIONAL_POLICIES_FILE=/app/kops/cluster_additional_policies.yml
TIMESTAMP=$(date +%s)
INITIAL_OUTPUT="/app/tmp/initial_configs/${CLUSTER_NAME}_${TIMESTAMP}.yml"

kops create cluster \
    $CLUSTER_NAME \
    --cloud=$CLOUD_PROVIDER \
    --project=$PROJECT \
    --zones=$CLUSTER_ZONES \
    --dns-zone=$DNS_ZONE \
    --state=$KOPS_STATE_STORE \
    --image=$IMAGE_NAME \
    --gce-service-account=$GCE_SERVICE_ACCOUNT \
    --node-image=$NODE_IMAGE \
    --node-size=$NODE_TYPE \
    --node-count=$NODE_COUNT \
    --node-volume-size=$NODE_VOLUME_SIZE \
    --master-public-name=$MASTER_PUBLIC_NAME \
    --master-image=$MASTER_IMAGE \
    --master-size=$MASTER_TYPE \
    --master-count=$MASTER_COUNT \
    --etcd-storage-type=$MASTER_VOLUME_TYPE \
    --master-volume-size=$MASTER_VOLUME_SIZE &&

kops get cluster $CLUSTER_NAME -o yaml > $INITIAL_OUTPUT &&
cat $ADDITIONAL_POLICIES_FILE >> $INITIAL_OUTPUT &&
kops replace -f $INITIAL_OUTPUT &&
kops update cluster $CLUSTER_NAME
# kops update cluster $CLUSTER_NAME --yes
