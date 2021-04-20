#!/usr/bin/bash

##
#
#   CONSTANTS
#
##

export KOPS_STATE_STORE='gs://devops.dojolaunch.app/kops/'
export KOPS_FEATURE_FLAGS='AlphaAllowGCE,SpecOverrideFlag'

CLOUD_PROVIDER=gce
PROJECT=dojolaunch-302702
IMAGE=debian-cloud/debian-10-buster-v20210122


##
#
#   SETTINGS
#
#   env:            must be either 'prod' or 'dev'
#   service_key:    shortened name of service (e.g. api, web)
#   zones:          comma delimited list of GCE zones
#   volume_type:    'pd-standard' or 'pd-ssd'   
#
##

env='dev'
service_key='api'
gce_service_account='master-ue1@dojolaunch-302702.iam.gserviceaccount.com'
zones='us-east1-b'
volume_type='pd-standard'

master_type='e2-medium'
master_count='1'
master_disk='pd-standard'
master_volume_size='20'
master_image=$IMAGE 

node_type='e2-medium'
node_count='1'
node_disk='pd-standard'
node_volume_size='20' 
node_image=$IMAGE

####

if [ $env = 'prod' ]; then dns_zone='dojolaunch.app' 
elif [ $env = 'dev' ]; then dns_zone='dev.dojolaunch.app'
else echo 'ERROR: "env" should have a value of "dev" or "prod"'; exit; fi

if [ ${service_key-''} = '' ]; then echo 'ERROR: "service_key" must be set'; exit; fi
cluster_name="$service_key.$env.k8s.local"

echo $gce_service_account

kops create cluster $cluster_name \
\
    --state=$KOPS_STATE_STORE \
    --cloud=$CLOUD_PROVIDER \
    --project=$PROJECT \
\
    --gce-service-account=$gce_service_account \
    --zones=$zones \
    --etcd-storage-type=$volume_type \
\
    --master-image=$master_image \
    --master-size=$master_type \
    --master-count=$master_count \
    --master-volume-size=$master_volume_size \
\
    --node-image=$node_image \
    --node-size=$node_type \
    --node-count=$node_count \
    --node-volume-size=$node_volume_size \
&& \
kops set cluster $cluster_name spec.clusterAutoscaler.enabled=true

# kops update cluster $cluster_name --admin=87600h --yes

