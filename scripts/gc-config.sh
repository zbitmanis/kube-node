#!/bin/bash
_GCPREGION=europe-central2
_GCPVPC=vpc-kube
_GCPSUBNET=snet-kube-central2
_GCPZONE=europe-central2-a

_GCPMACHINE_SCRIPT=./init-deb.sh
_GCPMACHINE_TYPE=e2-standard-2
_GCPMACHINE_TYPE=e2-micro
_GCPMACHINE_TYPE=e2-medium
_GCPMACHINE_NAME=kube-cluster-master
_GCPMACHINE_NODES=(kube-cluster-master:e2-standard-2:init-deb-master.sh:gc-master kube-cluster-node01:e2-standard-2:init-deb-node.sh:gc-node01) 
_GCPSERVICE_ACCOUNT_FILE=~/.config/gcloud/service_accounts/k8scfs.json
_GCPSERVICE_ACCOUNT=$(base64 ${_GCPSERVICE_ACCOUNT_FILE})

