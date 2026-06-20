variable "azure_region" {
  description = "Region de Azure"
  type        = string
  default     = "eastus"
}

variable "tamano_vm" {
  description = "Tamaño de la maquina virtual"
  type        = string
  default     = "Standard_B1s"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}