#!/usr/bin/bash

ROOT=./deps

files=(
  packer
  terraform 
  docker
  kubectl
  kops
  etc
)

for t in ${files[@]}; do
  bash "$ROOT/$t.sh"
done