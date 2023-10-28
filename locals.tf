# Define Local Values in Terraform
locals {
  organization = var.organization
  team         = var.team
  environment  = var.environment
  name         = "${local.organization}-${local.team}-${local.environment}"
  tags = {
    organization = local.organization
    department   = local.team
    environment  = local.environment
  }
}