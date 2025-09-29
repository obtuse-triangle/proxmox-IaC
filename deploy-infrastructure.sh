#!/bin/bash
# deploy-infrastructure.sh - Proxmox LXC 인프라 배포

set -e

echo "🚀 Deploying Proxmox LXC infrastructure..."

cd terraform
terraform init
terraform plan
terraform apply

echo ""
echo "✅ Infrastructure deployment completed!"
echo "📝 Next step: Run ./deploy-applications.sh"