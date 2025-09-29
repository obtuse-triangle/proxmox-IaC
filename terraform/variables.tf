variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
}

variable "proxmox_api_token_secretSh" {
  type        = string
  description = "Proxmox API Token Secret"
  sensitive   = true
}

variable "proxmox_api_user"{
  type        = string
  description = "Proxmox API User"
}
variable "proxmox_api_password"{
  type        = string
  description = "Proxmox API Password"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to inject into VMs for Ansible access."
}

variable "lxc_root_password" {
  type        = string
  description = "Root password for the LXC container"
  sensitive   = true
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

variable "k3s_token" {
  description = "The secret token for joining the k3s cluster."
  type        = string
  sensitive   = true
}