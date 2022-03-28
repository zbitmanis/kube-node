#!/bin/bash
source gc-config.sh

#gcloud compute instances create ${_GCPCLUSTER_NAME} --machine-type=${_GCPCLUSTER_TYPR}  --provisioning-model=SPOT --zone ${_GCPZONE} --metadata-from-file=startup-script=${_GCPCLUSTER_SCRIPT} --image-family ubuntu-1804-lts --image-project ubuntu-os-cloud

function createCluster  () {
  _NODE=$1
  _GCPCLUSTER_NAME=$(echo $_NODE|awk -F: '{ print $1}')
  _GCPCLUSTER_TYPE=$(echo $_NODE|awk -F: '{ print $2}')
  _GCPCLUSTER_SCRIPT=$(echo $_NODE|awk -F: '{ print $3}')

  echo "================================================="
  echo "Creating node name: ${_GCPCLUSTER_NAME}"
  echo "type: ${_GCPCLUSTER_TYPE}"
  echo "init script: ${_GCPCLUSTER_SCRIPT}"
  
  export PROJECT_ID=`gcloud config get-value project`
  export M_TYPE=$_GCPCLUSTER_TYPE 
  export ZONE=us-west2-a
  export CLUSTER_NAME=_GCPCLUSTER_NAME
  

  gcloud container clusters create $_GCPCLUSTER_NAME \
  --cluster-version latest \
  --machine-type=$_GCPCLUSTER_TYPE \
  --num-nodes 1 \
  --zone $_GCPZONE \
  --project $PROJECT_ID

gcloud container clusters get-credentials $_GCPCLUSTER_NAME \
    --zone  $_GCPZON \
    --project $PROJECT_ID

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)
}

gcloud services enable container.googleapis.com
for _N in ${_GCPCLUSTER_CLUSTERS[@]}; do
  createCluster $_N
done
