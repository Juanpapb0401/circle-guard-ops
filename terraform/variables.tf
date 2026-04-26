variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
  default     = "circleguard-rg"
}

variable "cluster_name" {
  description = "Nombre del cluster AKS"
  type        = string
  default     = "circleguard-aks"
}

variable "acr_name" {
  description = "Nombre del Azure Container Registry (debe ser globalmente único)"
  type        = string
  default     = "circleguardacr"
}

variable "node_count" {
  description = "Número de nodos en el node pool"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "Tamaño de VM para los nodos AKS (Standard_B2ms recomendado para créditos estudiante)"
  type        = string
  default     = "Standard_B2ms"
}
