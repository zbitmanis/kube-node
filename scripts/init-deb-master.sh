#! /bin/bash
apt update
apt -y install python3-pip git 
mkdir -p /var/tmp/ansible/
mkdir -p /var/tmp/k8sauto/
mkdir -p /var/tmp/k8sauto/service_accounts/
_GCLOUD_SA_FILE=/var/tmp/k8sauto/service_accounts/k8sfs.json
_GCLOUD_PROJECT_ID=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google") 
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/firestore-sa" -H "Metadata-Flavor: Google"  |base64 -d  |tee -a ${_GCLOUD_SA_FILE}
python3 -m venv /var/tmp/k8sauto/venv
source /var/tmp/k8sauto/venv/bin/activate
pip3 install ansible
cd /var/tmp/k8sauto
git clone https://github.com/zbitmanis/k8sautojoin.git
pip3 install -r k8sautojoin/requirements.txt
cd /var/tmp/k8sauto/ansible/
git clone https://github.com/zbitmanis/kube-node.git
cd /var/tmp/k8sauto/ansible/kube-node
ansible-galaxy install -r requirements.yml
[ -d "/var/tmp/ansible/kube-node/group_vars/" ] || mkdir -p /var/tmp/ansible/kube-node/group_vars/
cat <<EOF > /var/tmp/ansible/kube-node/group_vars/k8s.yaml
install_kubernetes_node_type: master
EOF
ansible-playbook -i inventory/hosts node.yaml
cd /var/tmp/k8sauto/k8sautojoin
_KUBE_JOIN_COMMAND=$(kubeadm token create  --print-join-command)
_MASTER=$(echo _KUBE_JOIN_COMMAND|awk '{ print $3 }')
_TOKEN=$(echo _KUBE_JOIN_COMMAND|awk '{ print $5 }')
_HASH=$(echo _KUBE_JOIN_COMMAND|awk '{ print $7 }')
/var/tmp/k8sauto/k8sautojoin/k8sautojoin.py --set -c clustera -t ${_TOKEN} -m $_MASTER -a $_HASH  -f ${_GCLOUD_SA_FILE} -p ${_GCLOUD_PROJECT_ID}
