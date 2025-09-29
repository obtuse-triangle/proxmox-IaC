# ansible-trigger.tf

resource "null_resource" "run_ansible" {
  
  # k3s 노드들이나 인벤토리 파일이 변경될 때만 이 리소스가 다시 실행되도록 함
  triggers = {
    inventory_content = resource.local_file.ansible_inventory.content
    master_ids        = join(",", [for vm in proxmox_lxc.k3s_masters : vm.id])
    worker_ids        = join(",", [for vm in proxmox_lxc.k3s_workers : vm.id])
  }

  # Ansible 인벤토리 파일이 먼저 생성되어야 하므로 depends_on 추가
  depends_on = [
    local_file.ansible_inventory,
  ]

  provisioner "local-exec" {
    # Terraform 폴더에서 ansible 폴더의 플레이북을 실행
    command = "cd ../ansible && ansible-playbook -i inventory.yml playbook.yml"
    
    # 플레이북 실행 중에 문제가 생기면 Terraform 실행도 실패하도록 설정
    on_failure = fail
  }
}