resource "aws_ssm_parameter" "cluster_sg_id" {
  name = "/${var.project}/${var.environment}/cluster_sg_id"
  type = "String"
  value = module.cluster.sg_id
}

resource "aws_ssm_parameter" "node_sg_id" {
  name = "/${var.project}/${var.environment}/node_sg_id"
  type = "String"
  value = module.node.sg_id
}