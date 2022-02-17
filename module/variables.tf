# Please set this Service Principal ENV var
variable "client_id" {
  description = "Service Principal client id"
  type        = string
}

# Please set this Service Principal ENV var
variable "client_secret" {
  description = "Service Principal client secret"
  type        = string
}

# Please set this gitlab_token ENV var
variable "certmanager_email" {
  description = "Certmanager email for the gitlab runner helm Chart"
  type        = string
  default     = ""
}

# Please set this dynatrace_api_token ENV var

variable "resource_group_name" {
  description = "Name of Resource Group"
  type        = string
}

# VNET

variable "vnet_subnet_id" {
  description = "If not empty, it will NOT create a vnet and subnet. Instead it will use FULL RESOURCE ID from Azure"
  default     = ""
}


# AKS
variable "agent_count" {
  description = "The number of nodes"
  type        = number
}

variable "vm_family" {
  default     = "Standard_D2s_v3"
  description = "VM Size of nodes"
  type        = string
}

variable "os_disk_size_gb" {
  description = "Disk size of OS in gb"
  type        = number
  default     = 30
}

variable "poolmachine_name_application" {
  description = "Name of nodepool (for application)"
  type        = string
  default     = "poolapp"
}

variable "poolmachine_name_nginx_ingress" {
  description = "Name of nodepool (for nginx ingress)"
  type        = string
  default     = "poolnginx"
}

variable "os_type" {
  description = "OS Type"
  type        = string
  default     = "Linux"
}

variable "max_pods" {
  description = "Max number of pods per node"
  type        = number
  default     = 30
}

variable "enable_autoscaling_app_pool" {
  description = "Enable/disable autoscaling for app pool"
  type        = bool
  default     = false
}

variable "autoscaling_app_pool_max_count" {
  description = "Max number of nodes for app pool."
  type        = number
  default     = 4
}

variable "autoscaling_app_pool_min_count" {
  description = "Min number of nodes for app pool."
  type        = number
  default     = 2
}

variable "enable_autoscaling_nginx_pool" {
  description = "Enable/disable autoscaling for nginx pool"
  type        = bool
  default     = false
}

variable "autoscaling_nginx_pool_max_count" {
  description = "Max number of nodes for nginx pool."
  type        = number
  default     = 4
}

variable "autoscaling_nginx_pool_min_count" {
  description = "Min number of nodes for nginx pool."
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "Version of kubernetes"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for cluster"
  type        = string
}

variable "docker_bridge_cidr" {
  description = "CIDR for docker bridge"
  type        = string
  default     = "172.17.0.1/16"
}

variable "service_cidr" {
  description = "CIDR for internal addresses pods."
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP for DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "load_balancer_sku" {
  description = "SKU of loadbalancer."
  type        = string
  default     = "Standard"
}

variable "public_ip_sku" {
  description = "SKU of Public IP."
  type        = string
  default     = "Basic"
}

variable "api_server_authorized_ip_ranges" {
  description = "IP ranges to whitelist for incoming traffic to the masters."
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name for cluster"
  type        = string
}

variable "location" {
  description = "Location of cluster"
  type        = string
}

variable "rbac" {
  description = "If AKS cluster is rbac-role based"
  type        = bool
  default     = false
}

variable "enable_http_application_routing" {
  description = "If true, enable HTTP Application Routing"
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) Map of tags and values to apply to the resource"
  type        = map(string)
  default     = {}
}

# Helm and k8s
variable "k8s_kube_config" {
  description = "Path to Kube Config directory"
}

# Gitlab
variable "gitlab_projects_to_link" {
  default     = []
  description = "List of project path from gitlab"
}

variable "gitlab_projects_namespaces_ids" {
  default     = []
  description = "ids of parent project gitlab(or group)"
}

variable "gitlab_variable_environment_scope" {
  default     = "*"
  description = "Environment scope for gitlab variable"
}

# Nginx Ingress
variable "nginx_ingress_chart_version" {
  default     = "1.17.0"
  description = "Version of nginx-ingress chart to use."
}

variable "nginx_ingress_controller_image_tag" {
  default     = "0.25.1"
  description = "Tag image of nginx controller based in quay.io/kubernetes-ingress-controller/nginx-ingress-controller repository."
}

variable "nginx_ingress_run_as_user" {
  default     = 33
  description = "Userid to run nginx process."
}

variable "replica_count" {
  default     = 2
  description = "Number of replicas for nginx controller"
}

variable "vm_family_nginx_ingress" {
  default     = "Standard_D2s_v3"
  description = "VM Size of nginx ingress nodes"
  type        = string
}

variable "enable_autoscaling" {
  default     = false
  description = "Enable or disable autoscaling controller for nginx ingress"
}

variable "max_replica_count" {
  default     = 11
  description = "Max replicas for autoscaling"
}

variable "target_cpu_utilization" {
  default     = "50"
  description = "Target CPU utilization in order to autoscaling to be triggered"
}

variable "target_memory_utilization" {
  default     = "50"
  description = "Target memory utilization in order to autoscaling to be triggered"
}

variable "cpu_requests" {
  default = "300m"
}

variable "memory_requests" {
  default = "300Mi"
}

variable "cpu_limits_resource" {
  default = "500m"
}

variable "memory_limits_resource" {
  default = "512Mi"
}

variable "metrics_enabled" {
  default     = false
  type        = bool
  description = "Enable or disable promotheus metrics"
}

variable "stats_enabled" {
  default     = false
  type        = bool
  description = "Enable or disable stats page nginx"
}

variable "enable_local_traffic_policy" {
  default     = false
  type        = bool
  description = "Enable/disable real client ip log."
}

variable "whitelist_ips_loadbalancer" {
  default     = ""
  description = "Whitelist ip's allowed to get to ingress loadbalancer."
}

# Cert manager
variable "cert_manager_chart_version" {
  default     = "v1.0.1"
  type        = string
  description = "Cert manager helm chart version."
}

# Dynatrace
variable "install_dynatrace" {
  default     = false
  type        = bool
  description = "Install dynatrace APM?"
}

variable "dynatrace_namespace" {
  default     = "dynatrace"
  type        = string
  description = "Namespace of dynatrace installation"
}

variable "dynatrace_api_url" {
  default     = ""
  type        = string
  description = "URL for dynatrace API"
}

variable "monitor_dynatrace_active_gate" {
  default     = false
  type        = bool
  description = "Create Service Account to enable dynatrace monitoring via active gate?"
}


# Ip Prefix

variable "pip_ip_prefix" {
  default = ""
  type    = string
}

variable "ip_prefix_name" {
  type    = string
  default = ""
}

variable "ip_prefix_sku" {
  type    = string
  default = ""
}

variable "ip_prefix_length" {
  type    = string
  default = ""
}

variable "create_prefix_ip" {
  description = "If true, create a public ip prefix"
  type        = bool
  default     = false
}

variable "prometheus_kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "prometheus_namespace" {
  type    = string
  default = "default"
}

variable "enable_azure_policy" {
  description = "If true, create a public ip prefix"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "List of availability zones to place the nodes"
  type        = list(string)
  default     = []
}

variable "poolmachine_name_infra_nodepool" {
  default     = "poolinfra"
  type        = string
  description = "Infra node pool(for linkerd, for example)"
}

variable "vm_family_infra_nodepool" {
  default     = "Standard_D2s_v3"
  description = "VM Size of nodes"
  type        = string
}

variable "enable_autoscaling_infra_pool" {
  description = "Enable/disable autoscaling for infra pool"
  type        = bool
  default     = false
}

variable "infra_replica_count" {
  default     = 3
  description = "Number of replicas for infra controller"
}
variable "enable_linkerd" {
  default     = true
  type        = bool
  description = "Enable linkerd service mesh on cluster"
}

variable "autoscaling_infra_pool_max_count" {
  description = "Max number of nodes for infra pool."
  type        = number
  default     = 3
}

variable "autoscaling_infra_pool_min_count" {
  description = "Min number of nodes for infra pool."
  type        = number
  default     = 3
}
variable "linkerd_chart_version" {
  default     = "2.11.1"
  type        = string
  description = "Linkerd service mesh chart version"
}

variable "linkerd_ha" {
  default     = false
  type        = bool
  description = "Enable linker service mesh HA"
}

variable "linkerd_proxy_cpu_requests" {
  default     = "100m"
  type        = string
  description = "Linkerd proxy cpu requests"
}

variable "linkerd_proxy_memory_request" {
  default     = "20Mi"
  type        = string
  description = "Linkerd proxy memory requests"
}

variable "linkerd_proxy_memory_limit" {
  default     = "250Mi"
  type        = string
  description = "Linkerd proxy memory limit"
}

variable "linkerd_controller_replicas" {
  default     = 3
  type        = number
  description = "Linkerd controller replicas"
}

variable "linkerd_controller_resources_cpu_request" {
  default     = "100m"
  type        = string
  description = "Linkerd controller cpu requests"
}

variable "linkerd_controller_resources_memory_limit" {
  default     = "250Mi"
  type        = string
  description = "Linkerd controller memory limit"
}

variable "linkerd_controller_resources_memory_request" {
  default     = "50Mi"
  type        = string
  description = "Linkerd controller memory request"
}

variable "linkerd_identity_resources_memory_request" {
  default     = "10Mi"
  type        = string
  description = "Linkerd identity memory request"
}