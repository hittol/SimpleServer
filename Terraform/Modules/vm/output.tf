output "Front_vm_id" {
  value       = azurerm_linux_virtual_machine.FrontVM.id
}

output "back-01_vm_id" {
  value       = azurerm_linux_virtual_machine.BackVM-01.id
}

output "db-01_vm_id" {
  value       = azurerm_linux_virtual_machine.DBVM-01.id
}

output "FrontVM_private_ip_address" {
  value       = azurerm_network_interface.nic_FrontVM.private_ip_address
}

output "backVM-01_private_ip_address" {
  value       = azurerm_network_interface.nic_BackVM-01.private_ip_address
}

output "dbVM-01_private_ip_address" {
  value       = azurerm_network_interface.nic_DBVM-01.private_ip_address
}