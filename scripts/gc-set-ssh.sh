#!/bin/bash
source gc-config.sh
source gc-info.sh

_IP=`getPrivateIP $_GCPMACHINE_NAME $_GCPZONE`
_EIP=`getExternalIP $_GCPMACHINE_NAME $_GCPZONE` 

updateSSHHost gc-master $_EIP 

echo "IP $_IP EIP $_EIP"
