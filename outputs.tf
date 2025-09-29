# outputs.tf

output "master_ips" {
  value = { for name, lxc in proxmox_lxc.k3s_masters : name => lxc.network.0.ip }
}

output "worker_ips" {
  value = { for name, lxc in proxmox_lxc.k3s_workers : name => lxc.network.0.ip }
}