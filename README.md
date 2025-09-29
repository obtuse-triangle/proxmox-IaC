# Proxmox Infrastructure as Code

Terraform + Ansible로 관리되는 Proxmox 기반 Kubernetes 클러스터 인프라스트럭처

## 🚀 빠른 시작

### 방법 1: 자동화 스크립트 사용 (권장)

```bash
# 1. 인프라 배포 (Proxmox LXC)
./deploy-infrastructure.sh

# 2. 애플리케이션 배포 (K8s + Dashboard)
./deploy-applications.sh

# 3. kubeconfig 설정
./setup-kubeconfig.sh
```

### 방법 2: 수동 실행

```bash
# 1. 인프라 배포
cd terraform
terraform init && terraform apply

# 2. Ansible 컬렉션 설치
cd ../ansible
ansible-galaxy collection install -r requirements.yml

# 3. K8s 애플리케이션 배포
ansible-playbook -i inventory.yml playbook.yml

# 4. kubeconfig 설정 (마스터 IP는 인벤토리 파일에서 확인)
scp root@<MASTER_IP>:/etc/rancher/k3s/k3s.yaml ~/.kube/config
sed -i '' 's/127.0.0.1/<MASTER_IP>/g' ~/.kube/config
```

## 🏗️ 분리된 아키텍처

### 단계별 실행

1. **Terraform** (인프라): Proxmox LXC 컨테이너 생성 + 인벤토리 파일 생성
2. **Ansible** (애플리케이션): K3s + MetalLB + Dashboard 배포
3. **kubeconfig** (로컬): kubectl 접근 설정

### 장점

- ✅ **독립적 실행**: 각 단계를 별도로 실행/디버깅 가능
- ✅ **빠른 재배포**: 애플리케이션만 재배포 시 Ansible만 실행
- ✅ **명확한 분리**: 인프라 vs 애플리케이션 명확히 구분
- ✅ **유연성**: 필요한 부분만 선택적 실행 가능

- **Load Balancer**: MetalLB
- **Ingress Controller**: Traefik (K3s 내장)
- **DNS**: dashboard.local.io

## ⚠️ 중요 사항

### Helm Repository 의존성

Terraform Helm provider는 repository 관리를 지원하지 않으므로:

1. **최초 실행 전**: `./setup-helm-repos.sh` 실행 필수
2. **terraform destroy 후**: 다시 `./setup-helm-repos.sh` 실행 필요
3. **CI/CD에서**: setup 스크립트를 terraform 실행 전에 포함

### SSL 인증서 처리

Dashboard는 HTTPS backend를 요구하므로 ServersTransport에서 SSL 검증 우회:

```yaml
# dashboard-serverstransport.yaml
spec:
  insecureSkipVerify: true
```

## 🔄 전체 재배포 프로세스

```bash
# 1. 인프라 삭제
terraform destroy

# 2. Helm repository 재설정
./setup-helm-repos.sh

# 3. 인프라 재생성
terraform apply
```

## 📝 트러블슈팅

### Dashboard 404 오류

- IngressRoute 설정 확인
- ServersTransport 배포 상태 확인

### SSL 인증서 오류

- ServersTransport의 insecureSkipVerify 설정 확인
- Dashboard 서비스 endpoint 확인

### Helm Chart 오류

- Repository 추가 상태 확인: `helm repo list`
- Repository 업데이트: `helm repo update`
