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
subnet = {
    subnet1 = {
        name = "subnet1"
        resource_group_name = "zakisrg"
        virtual_network_name = "zakisvnet"
        resource_group_location = "West Europe"
    address_prefixes     = ["10.0.1.0/24"]
    }
    subnet2 = {
        name = "subnet2"
        resource_group_name = "zakisrg"
        virtual_network_name = "zakisvnet"
        resource_group_location = "West Europe"
    address_prefixes     = ["10.0.2.0/24"]
    }
}