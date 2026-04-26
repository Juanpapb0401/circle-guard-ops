output "aks_cluster_name" {
  description = "Nombre del cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  description = "URL del ACR (usar en Jenkinsfile como ACR_LOGIN_SERVER)"
  value       = azurerm_container_registry.acr.login_server
}

output "resource_group_name" {
  description = "Nombre del resource group"
  value       = azurerm_resource_group.rg.name
}

output "kube_config" {
  description = "kubeconfig raw (sensible)"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "get_credentials_cmd" {
  description = "Comando para obtener kubeconfig tras el apply"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}
