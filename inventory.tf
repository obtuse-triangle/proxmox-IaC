# inventory.tf

# 1. 인벤토리 파일의 템플릿 정의
resource "local_file" "ansible_inventory" {
  filename = "./ansible/inventory.yml" # Ansible 폴더에 inventory.yml 생성
  content  = templatefile("${path.module}/inventory.yml.tftpl", {
    masters = proxmox_lxc.k3s_masters
    workers = proxmox_lxc.k3s_workers
  })
}

# 2. 템플릿 파일 (inventory.yml.tftpl) 생성
# Terraform 폴더 안에 inventory.yml.tftpl 이라는 파일을 만듭니다.