locals {
  public_subnet = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
}