# inventory-only.tf
# Terraform은 인프라 생성과 Ansible 인벤토리 파일 생성만 담당

# Ansible 인벤토리 생성 후 알림
resource "null_resource" "post_infrastructure" {
  
  # 인프라가 변경될 때마다 실행
  triggers = {
    inventory_content = resource.local_file.ansible_inventory.content
    master_ids        = join(",", [for vm in proxmox_lxc.k3s_masters : vm.id])
    worker_ids        = join(",", [for vm in proxmox_lxc.k3s_workers : vm.id])
  }

  depends_on = [
    local_file.ansible_inventory,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "🎉 Infrastructure deployment completed!"
      echo "📋 Ansible inventory generated: ../ansible/inventory.yml"
      echo ""
      echo "📝 Next steps:"
      echo "1. Install Ansible collections:"
      echo "   cd ../ansible && ansible-galaxy collection install -r requirements.yml"
      echo ""
      echo "2. Deploy K8s applications:"
      echo "   cd ../ansible && ansible-playbook -i inventory.yml playbook.yml"
      echo ""
      echo "3. Get kubeconfig (after K8s deployment):"
      echo "   scp root@${replace(values(proxmox_lxc.k3s_masters)[0].network[0].ip, "/17", "")}:/etc/rancher/k3s/k3s.yaml ~/.kube/config"
      echo "   sed -i '' 's/127.0.0.1/${replace(values(proxmox_lxc.k3s_masters)[0].network[0].ip, "/17", "")}/g' ~/.kube/config"
    EOT
  }
}