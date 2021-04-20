#!/usr/bin/env bash

WEB_PATH="/srv/git/dojolaunch/packages/web/"
IMAGE_PATH='/src/images'

sudo docker build \
    $WEB_PATH \
    -t modojolaunch/dojolaunch-web:latest \
    -t web:latest && 

sudo docker push modojolaunch/dojolaunch-web:latest