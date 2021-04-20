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
export KOPS_FEATURE_FLAGS=AlphaAllowGCE,SpecOverrideFlag

CLOUD_PROVIDER=gce
GCE_SERVICE_ACCOUNT=master-ue1@dojolaunch-302702.iam.gserviceaccount.com
PROJCECT=dojolaunch-302702
DNS_ZONE=k8s.dojolaunch.app

SERVICE_TAG=api
ENV_TAG=dev

CLUSTER_REGION=us-east1
CLUSTER_ZONE=us-east1-b
CLUSTER_NAME="${CLUSTER_REGION}.${ENV_TAG}.${SERVICE_TAG}.${DNS_ZONE}"

MASTER_PUBLIC_NAME="master.${CLUSTER_NAME}"
MASTER_TYPE=e2-medium
MASTER_COUNT=1
MASTER_IMAGE=debian-cloud/debian-10-buster-v20210122
MASTER_VOLUME_TYPE=pd-standard
MASTER_VOLUME_SIZE=20

NODE_TYPE=e2-medium
NODE_COUNT=1
NODE_IMAGE=debian-cloud/debian-10-buster-v20210122
NODE_VOLUME_TYPE=pd-standard
NODE_VOLUME_SIZE=20

kops create cluster \
  $CLUSTER_NAME \
  --cloud=$CLOUD_PROVIDER \
  --project=$PROJECT \
  --gce-service-account=$GCE_SERVICE_ACCOUNT \
  --dns-zone=$DNS_ZONE \
\
  --zones=$CLUSTER_ZONE \
  --state=$KOPS_STATE_STORE \
  --image=$IMAGE_NAME \
  --etcd-storage-type=$MASTER_VOLUME_TYPE \
\
  --master-image=$MASTER_IMAGE \
  --master-size=$MASTER_TYPE \
  --master-count=$MASTER_COUNT \
  --master-volume-size=$MASTER_VOLUME_SIZE \
\
  --node-image=$NODE_IMAGE \
  --node-size=$NODE_TYPE \
  --node-count=$NODE_COUNT \
  --node-volume-size=$NODE_VOLUME_SIZE &&

kops set cluster --name $CLUSTER_NAME spec.certManager.enabled=true &&
kops set cluster --name $CLUSTER_NAME spec.metricsServer.enabled=true &&

ig_prefix=${CLUSTER_ZONE: -1}
node_ig_name="${ig_prefix}-nodes-${CLUSTER_ZONE}-${ENV_TAG}-${SERVICE_TAG}-dojolaunch-app"

TF_DIR="/app/tf/${ENV_TAG}/${SERVICE_TAG}" &&

# kops update cluster \
#   $CLUSTER_NAME \
#   --admin=87600h \
#   --out=/app/tf/$TF_DIR \
#   --target=terraform &&

# cd $TF_DIR &&

# terraform init &&
# terraform create /

# kops update cluster \
#   $CLUSTER_NAME \
#   --admin=87600h \
#   --out=. \
#   --target=terraform &&
#   -y &&

####

kops update cluster \
  $CLUSTER_NAME \
  --admin=87600h \
  -y &&

####

kops validate cluster --wait 20m &&

kubectl apply -f /app/k8s/secrets.yml &&
kubectl apply -f /app/k8s/deploy-cas.yml &&
kubectl apply -f /app/k8s/svc-api.yml &&
kubectl apply -f /app/k8s/deploy-api.yml &&
kubectl apply -f /app/k8s/hpa-api.yml
