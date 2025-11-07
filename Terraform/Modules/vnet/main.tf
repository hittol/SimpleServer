# ===================================================================
# Create VNet
# ===================================================================
resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  address_space       = var.hub_vnet_address_space
  location            = var.location
  resource_group_name = var.Hub_rg_name
}

# ===================================================================
# Create Subnet
# ===================================================================

resource "azurerm_subnet" "hub" {
  for_each                        = var.hub_subnets
  name                            = each.key
  resource_group_name             = var.Hub_rg_name
  virtual_network_name            = azurerm_virtual_network.hub.name
  address_prefixes                = each.value.address_prefixes
  default_outbound_access_enabled = each.value.default_outbound_access_enabled
}


# ===================================================================
# Create NSG
# ===================================================================

resource "azurerm_network_security_group" "hub_nsg" {
  for_each            = var.network_security_groups_rule
  name                = each.key
  location            = var.location
  resource_group_name = var.Hub_rg_name

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# ===================================================================
# Connect NSG to Subnet
# ===================================================================

resource "azurerm_subnet_network_security_group_association" "hub_nsg_assoc" {
  for_each = { for k, v in var.hub_subnets : k => v if v.nsg_key != null }
  subnet_id                 = azurerm_subnet.hub[each.key].id
  network_security_group_id = azurerm_network_security_group.hub_nsg[each.value.nsg_key].id
}