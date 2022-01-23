#!/bin/bash 

source gc-config.sh

function getPrivateIP () {

gcloud compute instances describe $1 \
  --zone=$2\
  --format='get(networkInterfaces[0].networkIP)' 
}

function getExternalIP () {

gcloud compute instances describe $1 \
  --zone=$2\
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
}

function updateSSHHost () {
sed -e "/Host $1/{n;s/Hostname .*/Hostname $2/;}" -i ~/.ssh/config
}
