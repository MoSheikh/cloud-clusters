#!/usr/bin/env bash

CONTAINER_NAME=api
IMAGE_NAME=modojolaunch/dojolaunch-api:latest
HTTP_PORT_BINDING=80:80
HTTPS_PORT_BINDING=443:443

sudo docker run \
    --name $CONTAINER_NAME \
    -p $HTTP_PORT_BINDING \
    -p $HTTPS_PORT_BINDING \
    $IMAGE_NAME
    

