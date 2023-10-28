############################################################################################################
##  Create AWS EKS Cluster 
############################################################################################################
# reference https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_eks_cluster" "eks_terraform_cluster" {
  name     = "${local.name}-${var.eks_name}"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.eks_version
  # EKS network interface will be place in public subnet of VPC. Cluster plan -> network interface
  vpc_config {
    subnet_ids              = module.vpc.public_subnets
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.eks_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }

  # List of the desired control plane logging to enable. Enabling EKS Cluster Control Plane Logging.
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-terraform-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-terraform-AmazonEKSVPCResourceController,
  ]
}





############################################################################################################
##  Create AWS EKS Node Group - Public
############################################################################################################
# Reference Node Group: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
# reference AMI: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
resource "aws_eks_node_group" "eks_terraform_node_group_public" {
  cluster_name    = aws_eks_cluster.eks_terraform_cluster.name
  node_group_name = "${local.name}-eks-terraform-node-group-public"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = module.vpc.public_subnets
  version         = var.eks_version # Kubernetes version. Defaults to EKS Cluster Kubernetes version.


  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = var.disk_size
  instance_types = var.instance_types
  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  # Configuration block with remote access settings
  remote_access {
    ec2_ssh_key = var.eks_ec2_ssh_key
  }

  # Desired unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-terraform-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-terraform-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-terraform-AmazonEC2ContainerRegistryReadOnly,
    # kubernetes_config_map_v1.aws_auth
  ]

  tags = {
    Name = "${var.eks_name}-Public-Node-Group"
  }
}



############################################################################################################
##  Create AWS EKS Node Group - Private
############################################################################################################
# Reference Node Group: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
# reference AMI: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
resource "aws_eks_node_group" "eks_terraform_node_group_private" {
  cluster_name    = aws_eks_cluster.eks_terraform_cluster.name
  node_group_name = "${local.name}-eks-terraform-node-group-private"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = module.vpc.private_subnets
  version         = var.eks_version # Kubernetes version. Defaults to EKS Cluster Kubernetes version.   


  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = var.disk_size
  instance_types = var.instance_types
  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  # Configuration block with remote access settings
  remote_access {
    ec2_ssh_key = var.eks_ec2_ssh_key
  }

  # Desired unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-terraform-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-terraform-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-terraform-AmazonEC2ContainerRegistryReadOnly,
    # kubernetes_config_map_v1.aws_auth
  ]
  tags = {
    Name = "${var.eks_name}-Private-Node-Group"
  }
}







# # Use this data source to lookup information about the current AWS partition in which Terraform is working.
# # reference : https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/data-sources/partition
# # reference : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider.html


# data "aws_partition" "current" {}

# data "tls_certificate" "eks_cluster_issuer_url" {
#   url = aws_eks_cluster.eks_terraform_cluster.identity[0].oidc[0].issuer
# }

# # Provides an IAM OpenID Connect provider. A list of server certificate thumbprints for the OpenID Connect identity provider's server certificate
# resource "aws_iam_openid_connect_provider" "eks_terrform_cluster_oidc_provider" {
#   client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
#   thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
#   url             = data.tls_certificate.eks_cluster_issuer_url.url
#   tags = {
#     name = "${var.eks_name}-irsa"
#   }
#   # tags = merge(
#   #   {
#   #     Name = "${var.eks_name}-eks-irsa"
#   #   },
#   #   local.common_tags
#   # )
#   depends_on = [
#     aws_eks_cluster.eks_terraform_cluster
#   ]
# }

# ### remote_access -> ec2_ssh_key: Key Pair name that provides access for remote communication with the worker nodes in the EKS Node Group. If you specify this configuration, but do not specify source_security_group_ids when you create an EKS Node Group, either port 3389 for Windows, or port 22 for all other operating systems is opened on the worker nodes to the Internet (0.0.0.0/0). For Windows nodes, this will allow you to use RDP, for all others this allows you to SSH into the worker nodes.



