# ===================================================================
# Create Recovery Vault
# ===================================================================

resource "azurerm_recovery_services_vault" "rv-app" {
  name                = var.rv_app_name
  location            = var.location
  resource_group_name = var.Hub_rg_name
  storage_mode_type   = "LocallyRedundant"
  sku                 = "Standard"
}

resource "azurerm_recovery_services_vault" "rv-db" {
  name                = var.rv_db_name
  location            = var.location
  resource_group_name = var.Hub_rg_name
  storage_mode_type   = "LocallyRedundant"
  sku                 = "Standard"
}

# ===================================================================
# Create Backup Policy VM
# ===================================================================

resource "azurerm_backup_policy_vm" "app-backup-policy" {
  name                            = "${var.rv_app_name}-policy"
  resource_group_name             = var.Hub_rg_name
  recovery_vault_name             = azurerm_recovery_services_vault.rv-app.name
  instant_restore_retention_days  = "5"

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_policy_vm" "db-backup-policy" {
  name                            = "${var.rv_db_name}-policy"
  resource_group_name             = var.Hub_rg_name
  recovery_vault_name             = azurerm_recovery_services_vault.rv-db.name
  instant_restore_retention_days  = "5"

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_protected_vm" "front_backup" {
  resource_group_name = var.Hub_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.rv-app.name
  source_vm_id        = var.frontvm_id
  backup_policy_id    = azurerm_backup_policy_vm.app-backup-policy.id
}

resource "azurerm_backup_protected_vm" "back01_backup" {
  resource_group_name = var.Hub_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.rv-app.name
  source_vm_id        = var.backvm-01_id
  backup_policy_id    = azurerm_backup_policy_vm.app-backup-policy.id
}

resource "azurerm_backup_protected_vm" "db_backup" {
  resource_group_name = var.Hub_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.rv-db.name
  source_vm_id        = var.dbvm-01_id
  backup_policy_id    = azurerm_backup_policy_vm.db-backup-policy.id
}

