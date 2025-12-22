output "Front_vm_id" {
  value       = azurerm_linux_virtual_machine.FrontVM.id
}

output "back_vm_id" {
  value       = azurerm_linux_virtual_machine.BackVM.id
}

output "Standby_vm_id" {
  value       = azurerm_linux_virtual_machine.StandbyVM.id
}

output "db-01_vm_id" {
  value       = azurerm_linux_virtual_machine.DBVM-01.id
}

output "db-02_vm_id" {
  value       = azurerm_linux_virtual_machine.DBVM-02.id
}

output "db-BU_vm_id" {
  value       = azurerm_linux_virtual_machine.DBVM-BU.id
}

output "FrontVM_private_ip_address" {
  value       = azurerm_network_interface.nic_FrontVM.private_ip_address
}

output "backVM_private_ip_address" {
  value       = azurerm_network_interface.nic_BackVM.private_ip_address
}

output "StandbyVM_private_ip_address" {
  value       = azurerm_network_interface.nic_StandbyVM.private_ip_address
}

output "dbVM-01_private_ip_address" {
  value       = azurerm_network_interface.nic_DBVM-01.private_ip_address
}

output "backVM_nic_id" {
  value       = azurerm_network_interface.nic_BackVM.id
}

output "backVM_nic_name" {
  value       = azurerm_network_interface.nic_BackVM.ip_configuration[0].name
}

output "StandbyVM_nic_id" {
  value       = azurerm_network_interface.nic_StandbyVM.id
}

output "StandbyVM_nic_name" {
  value       = azurerm_network_interface.nic_StandbyVM.ip_configuration[0].name
}