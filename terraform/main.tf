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

  tags="terraform"

  rootfs {
    storage = "local"
    size    = "8G"
  }
  nameserver = "8.8.8.8"
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

  tags="terraform"

  rootfs{
    storage = "local"
    size    = "8G"
  }
  nameserver = "8.8.8.8"
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
