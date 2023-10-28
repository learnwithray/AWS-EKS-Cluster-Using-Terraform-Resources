# EKS Cluster Input Variables
variable "eks_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "eksdemo"
}
variable "eks_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks."
  type        = string
  default     = null
}
variable "eks_version" {
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used "
  type        = string
  default     = null
}
variable "eks_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled. Default is false"
  type        = bool
  default     = false
}
variable "eks_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled. Default is true. When it's set to `false` ensure to have a proper private access with `eks_endpoint_private_access = true`."
  type        = bool
  default     = true
}
variable "eks_public_access_cidrs" {
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. Terraform will only perform drift detection of its value when present in a configuration."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}






# EKS Node Group Variables
## Placeholder space you can create if required

variable "eks_ec2_ssh_key" {
  type    = string
  default = ""
}
variable "instance_types" {
  description = "Configuration block with scaling settings"
  type        = list(string)
  default     = ["t3.large"]
}
variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 50 for Windows, 20 all other node groups. Terraform will only perform drift detection if a configuration value is provided"
  type        = number
  default     = 20
}
variable "desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 1
}
variable "min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}
variable "max_size" {
  description = " Maximum number of worker nodes."
  type        = number
  default     = 2
}


# # EKS OIDC ROOT CA Thumbprint, eks oidc root ca thumbprint
# variable "eks_oidc_root_ca_thumbprint" {
#   type        = string
#   description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
#   default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
# }