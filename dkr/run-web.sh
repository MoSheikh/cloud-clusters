#!/usr/bin/env bash

CONTAINER_NAME=web
IMAGE_NAME=mojodolaunch/dojolaunch-web:latest
PORT_BINDING=0.0.0.0:80:80/tcp

sudo docker run \
    --name $CONTAINER_NAME \
    -p $PORT_BINDING \
    $IMAGE_NAME