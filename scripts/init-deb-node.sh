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
cd ${_K8SAUTO_ROOT}/ansible/
git clone https://github.com/zbitmanis/kube-node.git
cd ${_K8SAUTO_ROOT}/ansible/kube-node
ansible-galaxy install -r requirements.yml
[ -d "${_K8SAUTO_ROOT}/ansible/kube-node/group_vars/" ] || mkdir -p ${_K8SAUTO_ROOT}/ansible/kube-node/group_vars/
cat <<EOF > ${_K8SAUTO_ROOT}/ansible/kube-node/group_vars/k8s.yaml
install_kubernetes_node_type: node
EOF
ansible-playbook -i inventory/hosts node.yaml
cd ${_K8SAUTO_ROOT}/k8sautojoin
${_K8SAUTO_ROOT}/k8sautojoin/k8sautojoin.py --watch -c clustera -f ${_GCLOUD_SA_FILE} -p ${_GCLOUD_PROJECT_ID}
