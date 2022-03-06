#! /bin/bash
_GCLOUD_SA_FILE=/var/tmp/k8sauto/service_accounts/k8sfs.json
_GCLOUD_PROJECT_ID=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google") 
_K8SAUTO_ROOT=/var/tmp/k8sauto/
mkdir -p ${_K8SAUTO_ROOT}
mkdir -p ${_K8SAUTO_ROOT}/ansible
mkdir -p ${_K8SAUTO_ROOT}/service_accounts/
apt update
apt -y install python3-pip git python3-venv
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/firestore-sa" -H "Metadata-Flavor: Google"  |base64 -d  |tee -a ${_GCLOUD_SA_FILE}
python3 -m venv ${_K8SAUTO_ROOT}/venv
source ${_K8SAUTO_ROOT}/venv/bin/activate
pip3 install setuptools-rust 
pip3 install --upgrade pip setuptools
pip3 install ansible
cd ${_K8SAUTO_ROOT}
git clone https://github.com/zbitmanis/k8sautojoin.git
pip3 install -r k8sautojoin/requirements.txt
${_K8SAUTO_ROOT}/k8sautojoin/k8sautojoin.py --delete -c clustera  -f ${_GCLOUD_SA_FILE} -p ${_GCLOUD_PROJECT_ID}
cd ${_K8SAUTO_ROOT}/ansible/
git clone https://github.com/zbitmanis/kube-node.git
cd ${_K8SAUTO_ROOT}/ansible/kube-node
ansible-galaxy install -r requirements.yml
[ -d "${_K8SAUTO_ROOT}/ansible/kube-node/group_vars/" ] || mkdir -p ${_K8SAUTO_ROOT}/ansible/kube-node/group_vars/
cat <<EOF > ${_K8SAUTO_ROOT}/ansible/kube-node/group_vars/k8s.yaml
install_kubernetes_node_type: master
EOF
ansible-playbook -i inventory/hosts node.yaml
cd ${_K8SAUTO_ROOT}/k8sautojoin
_KUBE_JOIN_COMMAND=$(kubeadm token create  --print-join-command)
_MASTER=$(echo $_KUBE_JOIN_COMMAND|awk '{ print $3 }')
_TOKEN=$(echo $_KUBE_JOIN_COMMAND|awk '{ print $5 }')
_HASH=$(echo $_KUBE_JOIN_COMMAND|awk '{ print $7 }')
${_K8SAUTO_ROOT}/k8sautojoin/k8sautojoin.py --set -c clustera -t ${_TOKEN} -m $_MASTER -a $_HASH  -f ${_GCLOUD_SA_FILE} -p ${_GCLOUD_PROJECT_ID}
