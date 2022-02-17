provider "azurerm" {
  version = "~> 2.90.0"
  features {}
  skip_provider_registration = true
}


module "aks" {

  source = "./module"

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

  # Nginx Ingress
  nginx_ingress_controller_image_tag = "v1.1.0"
  nginx_ingress_run_as_user = 101 # if nginx_ingress_controller_image_tag >= 0.27.0, value must be 101. Otherwise, 33 (default)
  nginx_ingress_chart_version = "4.0.13"
  replica_count = 2
  enable_autoscaling = true
  load_balancer_sku = "Standard" # Needs to match with "public_ip_sku" value
  public_ip_sku = "Standard" # Needs to match with "load_balancer_sku" value

  # Cert-manager
  cert_manager_chart_version = "v1.4.0"

  #ip Prefix
  create_prefix_ip = true
  ip_prefix_name = "PIP-dev-hmg"
  ip_prefix_sku = "Standard"
  ip_prefix_length = 31

  enable_local_traffic_policy = true
  max_replica_count = 11
  target_cpu_utilization = "60"
  target_memory_utilization = "60"
  cpu_requests = "250m"
  memory_requests = "256Mi"
  cpu_limits_resource = "500m"
  memory_limits_resource = "512Mi"
  metrics_enabled = true
  stats_enabled = true
  vm_family_nginx_ingress = "Standard_D2s_v3"
}
