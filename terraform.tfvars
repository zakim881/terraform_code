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
nic = {
  "zaki_nic" = {
name                = "zaki-nic"
location            = "West Europe"
resource_group_name = "zakisrg"
ip_configuration = {
    name                          = "internal"
    subnet_id = azurerm_subnet.subnets["subnet1"].id
    private_ip_address_allocation = "Dynamic"
  }
}
  "zakis_nic" = {
name                = "zakis-nic"
location            = "West Europe"
resource_group_name = "zakisrg"
ip_configuration = {
    name                          = "internal"
    subnet_id = azurerm_subnet.subnets["subnet2"].id
    private_ip_address_allocation = "Dynamic"
  }
}
}
virtual_machine = {
    vm1 = {
        name = "zakisvm1"
location              = "West Europe"
  resource_group_name   = "zakisrg"
  network_interface_ids = azurerm_network_interface.network_interface["internal"]
  vm_size               = "Standard_E2pds_v6"
   storage_os_disk = {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-arm64"
    version   = "latest"
    }
os_profile = {
       computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
}
os_profile_linux_config = {
    disable_password_authentication = false
}
}
vm2 = {
name = "zakisvm2"
location              = "West Europe"
  resource_group_name   = "zakisrg"
  network_interface_ids = azurerm_network_interface.network_interface["zakis-nic"]
  vm_size               = "Standard_E2pds_v6"
   storage_os_disk = {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-arm64"
    version   = "latest"
    }
os_profile = {
       computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
}
os_profile_linux_config = {
    disable_password_authentication = false
}
}
}