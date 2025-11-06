output "vm_id" {
  value       = azurerm_linux_virtual_machine.FrontVM.id
}

output "FrontVM_private_ip_address" {
  value       = azurerm_network_interface.nic_FrontVM.private_ip_address
}