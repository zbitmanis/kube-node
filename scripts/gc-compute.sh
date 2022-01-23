#!/bin/bash
source gc-config.sh

#gcloud compute instances create ${_GCPMACHINE_NAME} --machine-type=${_GCPMACHINE_TYPR}  --provisioning-model=SPOT --zone ${_GCPZONE} --metadata-from-file=startup-script=${_GCPMACHINE_SCRIPT} --image-family ubuntu-1804-lts --image-project ubuntu-os-cloud 
gcloud compute instances create ${_GCPMACHINE_NAME} --machine-type=${_GCPMACHINE_TYPR}  --zone ${_GCPZONE} --subnet ${_GCPSUBNET} --metadata-from-file=startup-script=${_GCPMACHINE_SCRIPT} --image-family ubuntu-1804-lts --image-project ubuntu-os-cloud 
