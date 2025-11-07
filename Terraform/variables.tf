# ===================================================================
# Resource Group
# ===================================================================

variable "location" {
  type = string
}

variable "rg_setting" {
  type = map(object({
    location = optional(string, "koreacentral")
    name     = string
  }))
}
# ===================================================================
# VNET
# ===================================================================


variable "hub_vnet_name" {
  type        = string 
}

variable "hub_vnet_address_space" {
  type        = list(string)
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes                = list(string)
    nsg_key                         = optional(string)
    default_outbound_access_enabled = optional(bool)
  }))
}

variable "nsg_rule"  {
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
  default     = {}
}

# ===================================================================
# VM
# ===================================================================

variable "ip_config_name" {
    type        = string
}

variable "ip_address_allocation" {
    type        = string
}

variable "Front_vm_name" {
  type        = string
}

variable "Front_private_ip_address" {
  type        = string
}

variable "Back_vm_name" {
  type        = string
}

variable "Back_private_ip_address" {
  type        = string
}

variable "DB_vm_name" {
  type        = string
}

variable "DB_private_ip_address" {
  type        = string
}

variable "App_VM_Size" {
    type        = string   
}

variable "App_Disk_Size" {
    type        = string   
}

variable "DB_VM_Size" {
    type        = string   
}

variable "DB_Disk_Size" {
    type        = string   
}

variable "storage_account_type" {
    type        = string   
}

variable "vm_caching" {
    type        = string 
}

variable "UbuntuServer" {
    type = object({
        publisher   = string
        offer       = string
        sku         = string
        version     = string
  })
}

variable "admin_username" {
  type        = string
}


# ===================================================================
# AppGW&WAF
# ===================================================================

variable "appgw_name" {
  type        = string
}

variable "waf_name" {
  type        = string
}

# ===================================================================
# AppGW&WAF
# ===================================================================

variable "natgw_name" {
  type        = string
}

# ===================================================================
# Backup
# ===================================================================

variable "rv_app_name" {
  type        = string
}

variable "rv_db_name" {
  type        = string
}

# ===================================================================
# Log Analytics
# ===================================================================

variable "la_name" {
  type        = string
}

variable "dcr_name" {
  type        = string
}