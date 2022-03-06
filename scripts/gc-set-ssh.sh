#!/bin/bash
source gc-config.sh
source gc-info.sh

_IP=`getPrivateIP $_GCPMACHINE_NAME $_GCPZONE`
_EIP=`getExternalIP $_GCPMACHINE_NAME $_GCPZONE` 

function setSSHHost () {
_NODE=$1
_GCPMACHINE_NAME=$(echo $_NODE|awk -F: '{ print $1}')
_GCPMACHINE_TYPE=$(echo $_NODE|awk -F: '{ print $2}')
_GCPMACHINE_SCRIPT=$(echo $_NODE|awk -F: '{ print $3}')
_GCPMACHINE_SSHHOST=$(echo $_NODE|awk -F: '{ print $4}')

_IP=`getPrivateIP $_GCPMACHINE_NAME $_GCPZONE`
_EIP=`getExternalIP $_GCPMACHINE_NAME $_GCPZONE` 
updateSSHHost $_GCPMACHINE_SSHHOST $_EIP 
echo "$_GCPMACHINE_SSHHOST : IP $_IP EIP $_EIP"

}

for _N in ${_GCPMACHINE_NODES[@]}; do
   setSSHHost $_N
done
