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
    Standby_vm_name                 = var.Standby_vm_name
    Standby_private_ip_address      = var.Standby_private_ip_address
    Standby-subnet_id               = module.vnet.hub_subnet_ids["StandbySubnet"]
    DB_vm_01_name                   = var.DB_vm_01_name
    DB_01_private_ip_address        = var.DB_01_private_ip_address
    DB_vm_02_name                   = var.DB_vm_02_name
    DB_02_private_ip_address        = var.DB_02_private_ip_address
    DB_vm_BU_name                   = var.DB_vm_BU_name
    DB_BU_private_ip_address        = var.DB_BU_private_ip_address
    DB-subnet_id                    = module.vnet.hub_subnet_ids["DBSubnet"]
    storage_account_type            = var.storage_account_type
    ip_config_name                  = var.ip_config_name
    ip_address_allocation           = var.ip_address_allocation
    App_VM_Size                     = var.App_VM_Size
    App_Disk_Size                   = var.App_Disk_Size
    DB_VM_Size                      = var.DB_VM_Size
    DB_Disk_Size                    = var.DB_Disk_Size
    DB_BU_VM_Size                   = var.DB_BU_VM_Size
    DB_BU_Disk_Size                 = var.DB_BU_Disk_Size 
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
    Standby-subnet_id               = module.vnet.hub_subnet_ids["StandbySubnet"]
    DB-subnet_id                    = module.vnet.hub_subnet_ids["DBSubnet"]  
    depends_on                      = [module.appgw]
}

module "backup" {
    source                          = "./Modules/backup"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    rv_app_name                     = var.rv_app_name
    rv_db_name                      = var.rv_db_name
    backup_timezone                 = var.backup_timezone
    backup_frequency                = var.backup_frequency
    backup_time                     = var.backup_time
    frontvm_id                      = module.vm.Front_vm_id
    backvm_id                       = module.vm.back_vm_id
    Standbyvm_id                    = module.vm.Standby_vm_id
    dbvm-01_id                      = module.vm.db-01_vm_id
    dbvm-02_id                      = module.vm.db-02_vm_id
    dbvm-BU_id                      = module.vm.db-BU_vm_id
    depends_on                      = [module.appgw]
}

module "loganalytics" {
    source                          = "./Modules/la"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    la_name                         = var.la_name
    dcr_name                        = var.dcr_name
    la_sku                          = var.la_sku
    frontvm_id                      = module.vm.Front_vm_id
    backvm_id                       = module.vm.back_vm_id
    dbvm-01_id                      = module.vm.db-01_vm_id
    dbvm-02_id                      = module.vm.db-02_vm_id
    depends_on                      = [module.appgw]
}

module "lb" {
    source                          = "./Modules/lb"
    Hub_rg_name                     = module.rg.rg["MainRG"].name
    location                        = var.location
    lb_name                         = var.lb_name
    lb_subnet_id                    = module.vnet.hub_subnet_ids["FrontSubnet"]
    lb_private_ip_address           = var.lb_private_ip_address
    backvm_nic_id                   = module.vm.backVM_nic_id
    backvm_nic_name                 = module.vm.backVM_nic_name
    Standbyvm_nic_id                = module.vm.StandbyVM_nic_id
    Standbyvm_nic_name              = module.vm.StandbyVM_nic_name
    depends_on                      = [module.loganalytics]
}