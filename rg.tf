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