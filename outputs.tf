output "public_ip_address" {
  description = "Direccion IP publica de la maquina virtual"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "web_url" {
  description = "URL publica del servidor Apache"
  value       = "http://${azurerm_public_ip.public_ip.ip_address}"
}

output "ssh_connection" {
  description = "Comando para conectarse por SSH a la VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.public_ip.ip_address}"
}