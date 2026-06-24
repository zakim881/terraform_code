rg_names = {
    "rg1" = "zakisrg"
}
vnet = {
  vnet1 = {
    name                = "vnet1"
    location            = "West Europe"
    resource_group_name = "zakisrg"
    address_space       = ["10.0.0.0/16"]
  }
  vnet2 = {
    name                = "vnet2"
    location            = "West Europe"
    resource_group_name = "zakisrg"
    address_space       = ["10.1.0.0/16"]
  }
}