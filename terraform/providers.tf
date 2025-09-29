# providers.tf

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

# data "http" "kubernetes-dashboard" {
#   url = "https://kubernetes.github.io/dashboard/"
# }

# MetalLB는 null_resource로 직접 kubectl apply 사용