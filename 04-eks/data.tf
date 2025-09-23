data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

# data "aws_ssm_parameter" "public_subnet_ids" {
#   name = "/${var.project}/${var.common_tag.environment}/public_subnet_ids"
  
# }
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.common_tag.environment}/private_subnet_ids"
  
}
data "aws_ssm_parameter" "cluster_sg_id" {
  name = "/${var.project}/${var.environment}/cluster_sg_id"
}

data "aws_ssm_parameter" "node_sg_id" {
  name = "/${var.project}/${var.environment}/node_sg_id"
}

data "aws_vpc" "vpc_id" {
  default = true
}