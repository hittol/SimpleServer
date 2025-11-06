output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
}

output "hub_subnet_ids" {
  value = {
    for k, v in azurerm_subnet.hub : k => v.id
  }
}

output "hub_subnet_cidrs" {
  value       = { for k, s in azurerm_subnet.hub : k => s.address_prefixes[0] }
}