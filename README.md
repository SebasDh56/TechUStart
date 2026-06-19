# TechUStart - Infraestructura como Código con Terraform

## Descripción

Este proyecto implementa una solución de Infraestructura como Código (IaC) utilizando Terraform para automatizar la creación de una máquina virtual Linux en Microsoft Azure. La infraestructura incluye la configuración de red, seguridad, una dirección IP pública y la instalación automática del servidor web Apache.

## Objetivos

* Automatizar la creación de recursos en Azure mediante Terraform.
* Configurar una máquina virtual Linux Ubuntu.
* Implementar una red virtual y una subred.
* Configurar una dirección IP pública.
* Restringir el acceso mediante un grupo de seguridad de red.
* Habilitar el acceso HTTP a través del puerto 80.
* Automatizar la instalación del servidor web Apache.

## Estructura del Proyecto

```text
TechUStart/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── .terraform/
└── .terraform.lock.hcl
```

## Variables

El archivo `variables.tf` define las siguientes variables:

| Variable     | Tipo   | Valor por defecto |
| ------------ | ------ | ----------------- |
| azure_region | string | eastus            |
| tamano_vm    | string | Standard_B1s      |

## Recursos Implementados

* Grupo de Recursos (`azurerm_resource_group`)
* Red Virtual (`azurerm_virtual_network`)
* Subred (`azurerm_subnet`)
* Dirección IP Pública (`azurerm_public_ip`)
* Grupo de Seguridad de Red (`azurerm_network_security_group`)
* Regla de acceso HTTP por el puerto 80
* Interfaz de Red (`azurerm_network_interface`)
* Asociación del grupo de seguridad con la interfaz de red
* Máquina Virtual Linux Ubuntu (`azurerm_linux_virtual_machine`)
* Script de automatización mediante `custom_data`
* Salida de la dirección IP pública (`output`)

## Requisitos

* Terraform 1.15 o superior.
* Proveedor AzureRM 4.x.
* Azure CLI instalado.
* Una suscripción activa de Microsoft Azure.

## Inicialización del Proyecto

Ejecutar:

```bash
terraform init
```

## Validación de la Configuración

Ejecutar:

```bash
terraform validate
```

Resultado esperado:

```text
Success! The configuration is valid.
```

## Planificación de la Infraestructura

Ejecutar:

```bash
terraform plan
```

## Despliegue de los Recursos

Ejecutar:

```bash
terraform apply
```

## Automatización

La máquina virtual ejecuta automáticamente un script Bash durante el arranque para:

1. Actualizar los paquetes del sistema.
2. Instalar Apache.
3. Habilitar el servicio Apache.
4. Iniciar el servidor web.

Script utilizado:

```bash
#!/bin/bash
apt update
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
```

## Salida

El archivo `outputs.tf` permite visualizar la dirección IP pública asignada a la máquina virtual:

```hcl
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
```

## Autor

Proyecto desarrollado para la asignatura de DevOps utilizando Terraform y Microsoft Azure.

## Tecnologías Utilizadas

* Terraform
* Microsoft Azure
* AzureRM Provider
* Ubuntu Server
* Apache HTTP Servers
* GitHub Codespaces
