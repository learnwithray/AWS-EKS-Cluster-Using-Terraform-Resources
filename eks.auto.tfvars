# EKS Master variables defined below
eks_name                    = "eks-terraform"
eks_service_ipv4_cidr       = "172.20.0.0/16"
eks_version                 = "1.28"
eks_endpoint_private_access = false
eks_endpoint_public_access  = true
eks_public_access_cidrs     = ["0.0.0.0/0"]
# EKS Node variables defined below
eks_ec2_ssh_key = "cloud-bunner"
instance_types  = ["t3.large"]
disk_size       = 20
desired_size    = 1
min_size        = 1
max_size        = 2
# # Thumbprint of Root CA for EKS OIDC
# eks_oidc_root_ca_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
