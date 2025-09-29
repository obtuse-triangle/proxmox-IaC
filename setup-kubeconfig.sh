#!/bin/bash
# setup-kubeconfig.sh - kubeconfig 설정 자동화

set -e

# Ansible 인벤토리에서 마스터 노드 IP 추출
MASTER_IP=$(grep -A 5 "k3s_master:" ansible/inventory.yml | grep "ansible_host:" | awk '{print $2}')

if [ -z "$MASTER_IP" ]; then
    echo "❌ Error: Could not find master node IP in ansible/inventory.yml"
    echo "📝 Make sure you have run deploy-infrastructure.sh first"
    exit 1
fi

echo "🔧 Setting up kubeconfig for master node: $MASTER_IP"

# kubeconfig 디렉토리 생성
mkdir -p ~/.kube

# 기존 config 백업
if [ -f ~/.kube/config ]; then
    cp ~/.kube/config ~/.kube/config.backup.$(date +%Y%m%d_%H%M%S)
    echo "📦 Existing kubeconfig backed up"
fi

# K3s kubeconfig 가져오기
echo "📥 Downloading kubeconfig from master node..."
scp -o StrictHostKeyChecking=no root@$MASTER_IP:/etc/rancher/k3s/k3s.yaml ~/.kube/config

# 서버 주소를 실제 마스터 노드 IP로 변경
echo "🔧 Updating server IP in kubeconfig..."
sed -i '' "s/127.0.0.1/$MASTER_IP/g" ~/.kube/config

# 연결 테스트
echo "🧪 Testing connection..."
if kubectl get nodes > /dev/null 2>&1; then
    echo "✅ kubeconfig setup completed successfully!"
    echo ""
    kubectl get nodes
    echo ""
    echo "🌐 Dashboard access:"
    echo "   URL: https://$MASTER_IP (Host: dashboard.local.io header)"
    echo "   Or: https://10.3.50.100 (MetalLB LoadBalancer)"
else
    echo "❌ Connection test failed. Please check your setup."
    exit 1
fi