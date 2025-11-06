variable "rg_name" {
  type = string  
}

variable "location" {
  type = string  
}


# ===================================================================
# VM Settings
# ===================================================================

variable "ip_config_name" {
    type = string
}

variable "ip_address_allocation" {
    type = string
}

variable "Front_vm_name" {
  type        = string
}

variable "Front_private_ip_address" {
  type        = string
}

variable "Front-subnet_id" {
  type = string   
}

variable "Back_vm_name" {
  type        = string
}

variable "Back_private_ip_address" {
  type        = string
}

variable "Back-subnet_id" {
  type = string   
}

variable "DB_vm_name" {
  type        = string
}

variable "DB_private_ip_address" {
  type        = string
}

variable "DB-subnet_id" {
  type = string   
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

variable "vm_caching" {
    type = string 
}

variable "storage_account_type" {
    type = string   
}

variable "admin_username" {
    type = string
}

variable "UbuntuServer" {
    type = object({
        publisher   = string
        offer       = string
        sku         = string
        version     = string
  })
}

