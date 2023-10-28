###### IAM Role for EKS Cluster
## Reference https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster


data "aws_iam_policy_document" "eks_master_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Create IAM Role for EKS Cluster
resource "aws_iam_role" "eks_master_role" {
  name               = "${local.name}-eks-master-assume-role"
  assume_role_policy = data.aws_iam_policy_document.eks_master_assume_role.json
}

# Associate IAM Policy to IAM Role
# This policy provides Kubernetes the permissions it requires to manage resources on your behalf. 
resource "aws_iam_role_policy_attachment" "eks-terraform-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_master_role.name
}


# Enable Security Groups for Pods
# Policy used by VPC Resource Controller to manage ENI and IPs for worker nodes.
resource "aws_iam_role_policy_attachment" "eks-terraform-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_master_role.name
}



###### Create IAM Role for EKS Node Group

data "aws_iam_policy_document" "eks_node_group_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
  version = "2012-10-17"
}


# IAM Role EKS Node Group 
resource "aws_iam_role" "eks_node_group_role" {
  name               = "${local.name}-eks-node-group-assume-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role.json
}
# Associate IAM Policy to IAM Role
# This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
resource "aws_iam_role_policy_attachment" "eks-terraform-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

# This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes.
resource "aws_iam_role_policy_attachment" "eks-terraform-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

# Provides read-only access to Amazon EC2 Container Registry repositories.
resource "aws_iam_role_policy_attachment" "eks-terraform-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}



























# # Create IAM Role
# resource "aws_iam_role" "eks_master_role" {
#   name = "${local.name}-eks-master-role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# # Associate IAM Policy to IAM Role
# resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_master_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_master_role.name
# }


# # IAM Role for EKS Node Group 
# resource "aws_iam_role" "eks_node_group_assume_role" {
#   name = "eks-node_group-assume_role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_nodegroup_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_nodegroup_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_nodegroup_role.name
# }
