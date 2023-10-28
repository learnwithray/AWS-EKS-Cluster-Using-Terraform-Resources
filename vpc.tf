# # Availability Zones data source allows access to the list of AWS Availability Zones. Declare the data source
# data "aws_availability_zones" "available" {
#   state = "available"
#   # exclude_names = [ "eu-west-2c"]
# }

# Create VPC using Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  # Details
  name = "${var.vpc_name}-${local.name}"
  cidr = var.vpc_cidr
  # azs             = data.aws_availability_zones.available.names # Using data Source aws_availability_zones. Earlier using var.azs
  azs             = var.vpc_azs
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  database_subnets                   = var.vpc_database_subnets
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  # create_database_internet_gateway_route = true
  # create_database_nat_gateway_route = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  # DNS Parameters in VPC
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  # Additional tags for the VPC
  tags     = local.tags
  vpc_tags = local.tags

  # Additional tags for the public subnets
  public_subnet_tags = {
    Name = "VPC Public Subnets"
    # "kubernetes.io/role/elb" = 1    
    # "kubernetes.io/cluster/${local.name}-${var.eks_name}" = "shared"  
  }
  # Additional tags for the private subnets
  private_subnet_tags = {
    Name = "VPC Private Subnets"
    # "kubernetes.io/role/elb" = 1    
    # "kubernetes.io/cluster/${local.name}-${var.eks_name}" = "shared"  
  }
  # Additional tags for the database subnets
  database_subnet_tags = {
    Name = "VPC Private Database Subnets"
  }
  # Instances launched into the Public subnet should be assigned a public IP address. Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  map_public_ip_on_launch = var.vpc_map_public_ip_on_launch
}