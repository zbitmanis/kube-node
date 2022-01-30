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
_GCPMACHINE_NODES=(kube-cluster-master:e2-standard-2:init-deb-master.sh kube-cluster-node01:e2-standard-2:init-deb-node.sh kube-cluster-node02:e2-standard-2:init-deb-node.sh) 

