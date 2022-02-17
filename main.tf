provider "azurerm" {
  version = "~> 2.90.0"
  features {}
  skip_provider_registration = true
}


module "aks" {

  source = "./module"

  client_id = var.client_id
  client_secret = var.client_secret
  resource_group_name = "My-RG"

  # Will use existing subnet (Choose one)
  vnet_subnet_id  = "/subscriptions/xxxx-xxxx-xxxx-xxxx/resourceGroups/My-RG/providers/Microsoft.Network/virtualNetworks/VNT-My-VNET/subnets/SNT-My-Subnet"
  #########################

  agent_count = 4
  autoscaling_app_pool_min_count = 4
  autoscaling_app_pool_max_count = 5
  vm_family = "Standard_D2s_v3"
  os_disk_size_gb = 100
  os_type = "Linux"
  max_pods = 100
  kubernetes_version = "1.21.7"
  cluster_name = "k8s-linkerd"
  dns_prefix = "k8s-linkerd"
  location = "eastus"
  availability_zones = ["1"]
  rbac = true
  # Credentials

  # Helm
  k8s_kube_config = pathexpand("~/.kube/k8s-linkerd")


  #ip Prefix
  create_prefix_ip = true
  ip_prefix_name = "PIP-dev-hmg"
  ip_prefix_sku = "Standard"
  ip_prefix_length = 31

}
