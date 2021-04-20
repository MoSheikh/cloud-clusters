#!/usr/bin/env bash

ROOT_NAME=api

API_PATH="/app/git/dojolaunch/packages/api/"
REPOSITORY_NAME="modojolaunch/dojolaunch-${ROOT_NAME}:latest"
COMMON_NAME=api:latest

sudo docker build \
    $API_PATH \
    --no-cache \
    -t $REPOSITORY_NAME \
    -t $COMMON_NAME && 
    
sudo docker push $REPOSITORY_NAME
