module "vpc" {
  source = "git::https://github.com/vasanth-mvvr/expense-aws-terraform.git?ref=main"
  project = var.project
  common_tags = var.common_tag
  public_subnet_cidrs = var.public_subnet
  private_subnet_cidrs = var.private_subnet
  database_subnet_cidrs = var.database_subnet
  is_peering_required = var.is_peering_required
}