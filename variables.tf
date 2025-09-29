variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
}

variable "proxmox_api_token_secretSh" {
  type        = string
  description = "Proxmox API Token Secret"
  sensitive   = true # 이 값은 터미널에 노출되지 않도록 설정
}

variable "proxmox_api_user"{
  type        = string
  description = "Proxmox API User"
}
variable "proxmox_api_password"{
  type        = string
  description = "Proxmox API Password"
  sensitive   = true # 이 값은 터미널에 노출되지 않도록 설정
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to inject into VMs for Ansible access."
}

variable "lxc_root_password" {
  type        = string
  description = "Root password for the LXC container"
  sensitive   = true # 비밀번호는 터미널 출력에 노출되지 않도록 설정
}

variable "k8s_node_count_master" {
  type        = number
  description = "Number of master nodes"
  default     = 1
}

variable "k8s_node_count_worker" {
  type        = number
  description = "Number of worker nodes"
  default     = 2
}