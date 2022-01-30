#!/bin/bash
source gc-config.sh

#gcloud compute instances create ${_GCPMACHINE_NAME} --machine-type=${_GCPMACHINE_TYPR}  --provisioning-model=SPOT --zone ${_GCPZONE} --metadata-from-file=startup-script=${_GCPMACHINE_SCRIPT} --image-family ubuntu-1804-lts --image-project ubuntu-os-cloud

function createNode () {
  _NODE=$1
  _GCPMACHINE_NAME=$(echo $_NODE|awk -F: '{ print $1}')
  _GCPMACHINE_TYPE=$(echo $_NODE|awk -F: '{ print $2}')
  _GCPMACHINE_SCRIPT=$(echo $_NODE|awk -F: '{ print $3}')
  echo "================================================="
  echo "Creating node name: ${_GCPMACHINE_NAME}"
  echo "type: ${_GCPMACHINE_TYPE}"
  echo "init script: ${_GCPMACHINE_SCRIPT}"

  gcloud compute instances create ${_GCPMACHINE_NAME}\
   --machine-type=${_GCPMACHINE_TYPE}\
   --zone ${_GCPZONE}\
   --subnet ${_GCPSUBNET}\
   --metadata-from-file=startup-script=${_GCPMACHINE_SCRIPT}\
   --image-family ubuntu-1804-lts\
   --image-project ubuntu-os-cloud
}

for _N in ${_GCPMACHINE_NODES[@]}; do
  createNode $_N
done
