module "vpc" {
  source = "git::https://github.com/vasanth-mvvr/expense-aws-terraform.git?ref=main"
  project = var.project
}