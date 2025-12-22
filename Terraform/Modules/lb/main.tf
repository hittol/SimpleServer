# ===================================================================
# Create LoadBalancer
# ===================================================================

resource "azurerm_lb" "backend_ilb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.Hub_rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "${var.lb_name}-ip"
    subnet_id                     = var.lb_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.lb_private_ip_address
  }
}

# ===================================================================
# Create Backend&Probe
# ===================================================================

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                    = "${var.lb_name}-be-pool"
  loadbalancer_id         = azurerm_lb.backend_ilb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "back-vm" {
  network_interface_id    = var.backvm_nic_id
  ip_configuration_name   = var.backvm_nic_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "standby-vm" {
  network_interface_id    = var.Standbyvm_nic_id
  ip_configuration_name   = var.Standbyvm_nic_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_lb_probe" "backend_probe" {
  name                = "Backend-probe"
  loadbalancer_id     = azurerm_lb.backend_ilb.id
  protocol            = "Http"
  port                = 8080
  request_path        = "/healthz"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "was_rule" {
  name                           = "Backend-8080"
  loadbalancer_id                = azurerm_lb.backend_ilb.id
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "${var.lb_name}-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.backend_probe.id
}
