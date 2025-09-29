# kubernetes-resources.tf (kubectl 종속성 완전 제거)

# 모든 Kubernetes 리소스는 Ansible에서 처리 (playbook.yml 참조)
# - MetalLB 설치 및 설정
# - Dashboard Admin 계정 생성
# - Dashboard ServersTransport 설정  
# - Dashboard IngressRoute 설정
# - Admin 토큰 생성 및 출력