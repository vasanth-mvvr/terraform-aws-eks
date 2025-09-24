data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.common_tag.environment}/vpc_id"
}
