############################################################################################################
##  EKS Outputs       
############################################################################################################

#######  EKS Cluster Outputs
output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = aws_eks_cluster.eks_terraform_cluster.id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.eks_terraform_cluster.arn
}

output "eks_cluster_certificate_authority_data" {
  description = "The Kubernetes Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.eks_terraform_cluster.certificate_authority[0].data
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = aws_eks_cluster.eks_terraform_cluster.endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = aws_eks_cluster.eks_terraform_cluster.version
}

output "eks_cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster."
  value       = aws_iam_role.eks_master_role.name
}

output "eks_cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = aws_iam_role.eks_master_role.arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = aws_eks_cluster.eks_terraform_cluster.identity[0].oidc[0].issuer
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster."
  value       = aws_eks_cluster.eks_terraform_cluster.vpc_config[0].cluster_security_group_id
}


############################################################################################################
##  EKS Node Group Outputs - Public
############################################################################################################
output "node_group_public_id" {
  description = "Public Node Group ID"
  value       = aws_eks_node_group.eks_terraform_node_group_public.id
}

output "node_group_public_arn" {
  description = "Public Node Group ARN"
  value       = aws_eks_node_group.eks_terraform_node_group_public.arn
}

output "node_group_public_status" {
  description = "Public Node Group status"
  value       = aws_eks_node_group.eks_terraform_node_group_public.status
}

output "node_group_public_version" {
  description = "Public Node Group Kubernetes Version"
  value       = aws_eks_node_group.eks_terraform_node_group_public.version
}

###########################################################################################################
#  EKS Node Group Outputs - Private
###########################################################################################################
output "node_group_private_id" {
  description = "Private Node Group ID"
  value       = aws_eks_node_group.eks_terraform_node_group_private.id
}

output "node_group_private_arn" {
  description = "Private Node Group ARN"
  value       = aws_eks_node_group.eks_terraform_node_group_private.arn
}

output "node_group_private_status" {
  description = "Private Node Group status"
  value       = aws_eks_node_group.eks_terraform_node_group_private.status
}

output "node_group_private_version" {
  description = "Private Node Group Kubernetes Version"
  value       = aws_eks_node_group.eks_terraform_node_group_private.version
}


# ############################################################################################################
# ##  Output: AWS IAM Open ID Connect Provider ARN
# ############################################################################################################
# output "eks_cluster_openid_connect_provider_arn" {
#   description = "The ARN assigned by AWS IAM Open ID Connect"
#   value       = aws_iam_openid_connect_provider.eks_terrform_cluster_oidc_provider.arn
# }
# # Extract OIDC URL from OIDC Provider ARN
# locals {
#   eks_cluster_openid_connect_provider_arn_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.eks_terrform_cluster_oidc_provider.arn}"), 1)
# }
# # OIDC (Open ID Connect) Provider URL 
# output "eks_cluster_openid_connect_provider_arn_extract_from_arn" {
#   description = "AWS IAM Open ID Connect Provider extract from ARN"
#   value       = local.eks_cluster_openid_connect_provider_arn_extract_from_arn
# }







# ############ testing will be removed
# output "eks_cluster_openid_connect_provider_arn" {
#   description = "The URL on the EKS cluster OIDC Issuer"
#   value       = aws_eks_cluster.eks_terraform_cluster.identity[0].oidc[0].issuer
# }

# locals {
#   cluster_oidc_issuer_url = aws_eks_cluster.eks_terraform_cluster.identity[0].oidc[0].issuer
#   //cluster_oidc_issuer_url_no_https = replace(local.cluster_oidc_issuer_url, "^https://", "")
#   eks_cluster_openid_connect_provider_arn_extract_from_arn = element(split("https://", "${aws_eks_cluster.eks_terraform_cluster.identity[0].oidc[0].issuer}"), 1)
# }

# output "eks_cluster_openid_connect_provider_arn_extract_from_arn" {
#   description = "The URL on the EKS cluster OIDC Issuer without 'https://'"
#   value       = local.eks_cluster_openid_connect_provider_arn_extract_from_arn
# }

