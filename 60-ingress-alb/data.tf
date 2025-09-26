data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project}/${var.common_tags.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "ingress_sg_id" {
    name = "/${var.project}/${var.common_tags.environment}/ingress_sg_id"  
}
data "aws_ssm_parameter" "acm_certificate_arn" {
    name = "/${var.project}/${var.common_tags.environment}/acm_certificate_arn"
}
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.common_tags.environment}/vpc_id"
}