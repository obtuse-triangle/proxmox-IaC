# Terraform이 사용할 Provider를 지정하고 버전을 고정합니다.
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

# Proxmox Provider에 대한 접속 정보를 설정합니다.
provider "proxmox" {
  pm_api_url = "https://10.3.0.1:8006/api2/json"
  # pm_api_token_id = var.proxmox_api_token_id
  # pm_api_token_secret = var.proxmox_api_token_secretSh
  pm_user = var.proxmox_api_user
  pm_password = var.proxmox_api_password
  pm_tls_insecure = true # 사설 인증서를 사용하는 경우 true로 설정
  pm_debug = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}


# 로컬 변수로 노드 목록 생성
locals {
  master_nodes = { for i in range(1, var.k8s_node_count_master+1) : "k3s-master-${i}" => "10.3.20.${i}" }
  worker_nodes = { for i in range(1, var.k8s_node_count_worker+1) : "k3s-worker-${i}" => "10.3.21.${i}" }
}
# --- 마스터 노드 LXC 생성 ---
resource "proxmox_lxc" "k3s_masters" {
  for_each = local.master_nodes

  target_node = "sh"
  hostname    = each.key
  ostemplate  = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst" # LXC 템플릿 경로
  password = var.lxc_root_password
  ssh_public_keys = var.ssh_public_key
  cores  = 2
  memory = 4096
  unprivileged = false # k3s 설치를 위해 특권(privileged) 컨테이너로 생성
  start = true
  # onboot = true # Ansible 이 시작

  tags="terraform"

  rootfs {
    storage = "local" # 실제 스토리지 이름
    size    = "8G"
  }
  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "${each.value}/17"
    gw     = "10.3.0.1"
  }
  
  # ✅ [핵심] k3s가 컨테이너를 실행할 수 있도록 중첩(Nesting) 기능을 활성화합니다.
  features {
    nesting = true
  }
}

# --- 워커 노드 LXC 생성 ---
resource "proxmox_lxc" "k3s_workers" {
  for_each = local.worker_nodes
  target_node = "sh"
  hostname    = each.key
  ostemplate  = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  password        = var.lxc_root_password
  ssh_public_keys = var.ssh_public_key
  cores  = 2
  memory = 2048
  unprivileged = false
  start = true
  # onboot = true # Ansible 이 시작

  tags="terraform"

  rootfs{
    storage = "local"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "${each.value}/17"
    gw     = "10.3.0.1"
  }
  features {
    nesting = true
  }

}
