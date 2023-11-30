output "vm_ip" {
  value = azurerm_network_interface.example.private_ip_address
}

output "vm_username" {
  value = azurerm_linux_virtual_machine.example.admin_username
}
