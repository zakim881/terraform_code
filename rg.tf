resource "azurerm_resource_group" "rg" {
for_each = var.rg_names
name     = each.value
location = "West Europe"
}
resource "azurerm_virtual_network" "example" {
  for_each = var.vnet
    name = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

depends_on = [azurerm_resource_group.rg]
}
resource "azurerm_subnet" "example1" {
  for_each = var.subnet
  name = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  depends_on = [azurerm_virtual_network.example]
}

resource "azurerm_network_interface" "example2" {
  for_each            = var.nic
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration.name
    subnet_id                     = azurerm_subnet.example1[each.value.ip_configuration.subnet_key].id  # resolved here
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
  }

  depends_on = [azurerm_subnet.example1]
}

resource "azurerm_virtual_machine" "main" {
  for_each            = var.virtual_machine
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  network_interface_ids = [azurerm_network_interface.example2[each.value.nic_key].id]  # resolved here
  vm_size             = each.value.vm_size

  storage_image_reference {
    publisher = each.value.storage_image_reference.publisher
    offer     = each.value.storage_image_reference.offer
    sku       = each.value.storage_image_reference.sku
    version   = each.value.storage_image_reference.version
  }
  storage_os_disk {
    name              = each.value.storage_os_disk.name
    caching           = each.value.storage_os_disk.caching
    managed_disk_type = each.value.storage_os_disk.managed_disk_type
    create_option     = each.value.storage_os_disk.create_option
  }
  os_profile {
    computer_name  = each.value.name
    admin_username = each.value.os_profile.admin_username
    admin_password = each.value.os_profile.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = each.value.os_profile_linux_config.disable_password_authentication
  }

  depends_on = [azurerm_network_interface.example2]
}
resource "azurerm_network_security_group" "example3" {
  for_each            = var.nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = each.value.security_rule.name
    priority                   = each.value.security_rule.priority
    direction                  = each.value.security_rule.direction
    access                     = each.value.security_rule.access
    protocol                   = each.value.security_rule.protocol
    source_port_range          = each.value.security_rule.source_port_range
    destination_port_range     = each.value.security_rule.destination_port_range
    source_address_prefix      = each.value.security_rule.source_address_prefix
    destination_address_prefix = each.value.security_rule.destination_address_prefix
  }
}

# subnet1 association - hardcoded subnet key
resource "azurerm_subnet_network_security_group_association" "subnet1" {
  subnet_id                 = azurerm_subnet.example1["subnet1"].id
  network_security_group_id = azurerm_network_security_group.example3["nsg1"].id
}

# subnet2 association - hardcoded subnet key
resource "azurerm_subnet_network_security_group_association" "subnet2" {
  subnet_id                 = azurerm_subnet.example1["subnet2"].id
  network_security_group_id = azurerm_network_security_group.example3["nsg1"].id
}