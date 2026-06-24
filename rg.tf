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
    for_each = var.nic
name = each.value.name
location = each.value.location
resource_group_name = each.value.resource_group_name
  ip_configuration {
name = each.value.name
private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation

subnet_id                     = azurerm_subnet.subnets[each.value.ip_configuration.subnet_key].id
  }
  depends_on = [azurerm_subnet.example1]
}
resource "azurerm_virtual_machine" "main" {
for_each = var.virtual_machine
name = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = azurerm_network_interface.network_interface[each.value.network_interface_ids.network_interface].id
  vm_size               = each.value.vm_size


  storage_image_reference {
publisher = each.value.storage_image_reference.publisher
offer     = each.value.storage_image_reference.offer
sku       = each.value.storage_image_reference.sku
version   = each.value.storage_image_reference.version
  }
  storage_os_disk {
name = each.value.storage_os_disk.name
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