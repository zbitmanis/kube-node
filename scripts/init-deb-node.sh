#! /bin/bash
apt update
apt -y install python3-pip git 
pip3 install ansible 
mkdir -p /var/tmp/ansible/
cd /var/tmp/ansible/
git clone https://github.com/zbitmanis/kube-node.git
cd /var/tmp/ansible/kube-node
ansible-galaxy install -r requirements.yml
[ -d "/var/tmp/ansible/kube-node/group_vars/" ] || mkdir -p /var/tmp/ansible/kube-node/group_vars/
cat <<EOF > /var/tmp/ansible/kube-node/group_vars/k8s.yaml
install_kubernetes_node_type: node
EOF
ansible-playbook -i inventory/hosts node.yaml
