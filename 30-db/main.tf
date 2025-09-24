module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project}-${var.environment}"

  engine  = "mysql"
  engine_version = "8.0.41"
  instance_class = "db.t4g.micro"
  allocated_storage = 5

  db_name = "transactions"
  username = "root"
  port = 3306

  vpc_security_group_ids = [data.aws_ssm_parameter.db_sg_id.value]
  
  db_subnet_group_name = data.aws_ssm_parameter.database_subnet_group_name.value
  
  family = "mysql8.0"

  major_engine_version = "8.0"

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    }
  )

  manage_master_user_password = false
  password = "ExpenseApp1"

  skip_final_snapshot = true

  parameters = [
    {
        name = "character_set_client"
        value = "utf8mb4"
    },
    {
        name = "character_set_server"
        value = "utf8mb4"
    }
  ]
  
  options = [
    {
        option_name = "MARIADB_AUDIT_PLUGIN"

        option_settings = [
            {
                name = "SERVER_AUDIT_EVENTS"
                value = "CONNECT"
            },
            {
                name = "SERVER_AUDIT_FILE_ROTATIONS"
                value = "37"
            },
        ]
    },
  ]
    

}

# These record is used to connect to mysql 
module "records"{
  source = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_name = var.zone_name
  records= [

    {
      name = "db-${var.environment}"
      ttl = 1
      type = "CNAME"
      records = [
        module.db.db_instance_address
      ]
    }
  ]
}
