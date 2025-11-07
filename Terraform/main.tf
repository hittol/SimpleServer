# ===================================================================
# module area
# ===================================================================

module "rg" {
    source      = "./Modules/rg"
    rg_setting  = var.rg_setting
}
module "vnet" {
    source                          = "./Modules/vnet"
    location                        = var.location
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    hub_vnet_name                   = var.hub_vnet_name
    hub_vnet_address_space          = var.hub_vnet_address_space
    hub_subnets                     = var.hub_subnets
    network_security_groups_rule    = var.nsg_rule
    depends_on                      = [module.rg]      
}

module "vm" {
    source                          = "./Modules/vm"
    rg_name                         = module.rg.rg["MainRG"].name
    location                        = var.location
    Front_vm_name                   = var.Front_vm_name
    Front_private_ip_address        = var.Front_private_ip_address
    Front-subnet_id                 = module.vnet.hub_subnet_ids["FrontSubnet"]
    Back_vm_name                    = var.Back_vm_name
    Back_private_ip_address         = var.Back_private_ip_address
    Back-subnet_id                  = module.vnet.hub_subnet_ids["BackSubnet"]
    DB_vm_name                      = var.DB_vm_name
    DB_private_ip_address           = var.DB_private_ip_address
    DB-subnet_id                    = module.vnet.hub_subnet_ids["DBSubnet"]
    storage_account_type            = var.storage_account_type
    ip_config_name                  = var.ip_config_name
    ip_address_allocation           = var.ip_address_allocation
    App_VM_Size                     = var.App_VM_Size
    App_Disk_Size                   = var.App_Disk_Size
    DB_VM_Size                      = var.DB_VM_Size
    DB_Disk_Size                    = var.DB_Disk_Size
    vm_caching                      = var.vm_caching
    admin_username                  = var.admin_username
    UbuntuServer                    = var.UbuntuServer
    depends_on                      = [module.vnet]
}

module "appgw" {
    source                          = "./Modules/appgw"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    appgw_name                      = var.appgw_name
    waf_name                        = var.waf_name
    appgw-subnet_id                 = module.vnet.hub_subnet_ids["ApplicationGatewaySubnet"]
    Front_VM_ipaddress              = module.vm.FrontVM_private_ip_address
    depends_on                      = [module.vm]
}

module "natgw" {
    source                          = "./Modules/natgw"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    natgw_name                      = var.natgw_name
    Front-subnet_id                 = module.vnet.hub_subnet_ids["FrontSubnet"]
    Back-subnet_id                  = module.vnet.hub_subnet_ids["BackSubnet"]
    DB-subnet_id                    = module.vnet.hub_subnet_ids["DBSubnet"]
    depends_on                      = [module.appgw]
}

module "backup" {
    source                          = "./Modules/backup"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    rv_app_name                     = var.rv_app_name
    rv_db_name                      = var.rv_db_name
    frontvm_id                      = module.vm.Front_vm_id
    backvm-01_id                    = module.vm.back-01_vm_id
    dbvm-01_id                      = module.vm.db-01_vm_id
    depends_on                      = [module.appgw]
}

module "loganalytics" {
    source                          = "./Modules/la"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    la_name                         = var.la_name
    dcr_name                        = var.dcr_name
    frontvm_id                      = module.vm.Front_vm_id
    backvm-01_id                    = module.vm.back-01_vm_id
    dbvm-01_id                      = module.vm.db-01_vm_id
    depends_on                      = [module.appgw]
}