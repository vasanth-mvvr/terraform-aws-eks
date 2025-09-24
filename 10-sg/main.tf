module "cluster" {
  source = "git::https://github.com/vasanth-mvvr/aws_security_group.git?ref=main"
  project = var.project
  environment = var.environment
  common_tags = var.common_tag
  sg_description = "SG for eks control pane"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "eks-control-pane"
}

module "node" {
  source = "git::https://github.com/vasanth-mvvr/aws_security_group.git?ref=main"
  project = var.project
  environment = var.environment
  common_tags = var.common_tag
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for eks node"
  sg_name = "eks-node"
}

module "ingress" {
  source = "git::https://github.com/vasanth-mvvr/aws_security_group.git?ref=main"
  project = var.project
  environment = var.environment
  common_tags = var.common_tag
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for ingress "
  sg_name = "ingress"
}
module "bastion" {
  source = "git::https://github.com/vasanth-mvvr/aws_security_group.git?ref=main"
  project = var.project
  environment = var.environment
  common_tags = var.common_tag
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for Bastion"
  sg_name = "bastion"
}
module "db" {
  source = "git::https://github.com/vasanth-mvvr/aws_security_group.git?ref=main"
  project = var.project
  environment = var.environment
  common_tags = var.common_tag
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for db"
  sg_name = "sg"
}


resource "aws_security_group_rule" "node_cluster" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = module.cluster.sg_id
  security_group_id = module.node.sg_id
}
resource "aws_security_group_rule" "cluster_node" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = module.node.sg_id
  security_group_id = module.cluster.sg_id
}

resource "aws_security_group_rule" "node_vpc" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.node.sg_id
}

resource "aws_security_group_rule" "cluster_bastion" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "TCP"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.cluster.sg_id
}

resource "aws_security_group_rule" "node_bastion" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.node.sg_id
}
resource "aws_security_group_rule" "bastion_public" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "TCP"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = module.cluster.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
    type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "TCP"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.db.sg_id
}
resource "aws_security_group_rule" "db_node" {
    type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "TCP"
  source_security_group_id = module.node.sg_id
  security_group_id = module.db.sg_id
}
resource "aws_security_group_rule" "ingress_public_https" {
    type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress.sg_id
}

resource "aws_security_group_rule" "ingress_public_http" {
    type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress.sg_id
}
resource "aws_security_group_rule" "ingress_public_https" {
    type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress.sg_id
}

resource "aws_security_group_rule" "node_ingress" {
  type = "ingress"
  from_port = 30000
  to_port = 32768
  protocol = "TCP"
  source_security_group_id = module.ingress.sg_id
  security_group_id = module.node.sg_id
}