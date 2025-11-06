variable "location" {
  type = string  
}

variable "Hub_rg_name" {
  type = string  
}

# ===================================================================
# VNet
# ===================================================================

variable "hub_vnet_name" {
  type        = string 
}

variable "hub_vnet_address_space" {
  type        = list(string)
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes = list(string)
    nsg_key          = optional(string)
  }))
}

# ===================================================================
# NSG
# ===================================================================

variable "network_security_groups_rule" {
  type = map(object({
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = string
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    }))
  }))
  default = {}
}