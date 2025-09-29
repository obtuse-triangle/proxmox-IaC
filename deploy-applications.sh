#!/bin/bash
# deploy-applications.sh - K8s 애플리케이션 배포

set -e

echo "🔧 Installing Ansible collections..."
cd ansible
ansible-galaxy collection install -r requirements.yml

echo ""
echo "🚀 Deploying Kubernetes applications..."
ansible-playbook -i inventory.yml playbook.yml

echo ""
echo "✅ Application deployment completed!"
echo "📝 Follow the kubeconfig setup instructions from the Ansible output above."