#!/bin/sh 
_GCPREGION=europe-central2
#_GCPREGION=europe-north1
_GCPVPC=vpc-kube
_GCPSUBNET=snet-kube-central2
#_GCPSUBNET=snet-kube-north

gcloud compute networks create ${_GCPVPC} --subnet-mode custom

gcloud compute networks subnets create ${_GCPSUBNET} --region=${_GCPREGION} --network=${_GCPVPC} --range 172.29.0.0/24

gcloud compute networks subnets list --filter="network:${_GCPVPC}"

