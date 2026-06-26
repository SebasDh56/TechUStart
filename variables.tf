variable "azure_region" {
  description = "Region de Azure donde se desplegaran los recursos"
  type        = string
  default     = "eastus"
}

variable "tamano_vm" {
  description = "Tamaño de la maquina virtual"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Usuario administrador de la maquina virtual"
  type        = string
  default     = "azureuser"
}

variable "public_key_path" {
  description = "Ruta de la llave publica SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}