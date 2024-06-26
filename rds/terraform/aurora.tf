module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name = local.config.rds.name
  
  engine = "aurora-postgresql"
  engine_version = local.config.rds.engine_version
  instance_class = local.config.rds.instance_class
  master_username = "demo"
  master_password = random_password.master_password.result

  port = 5432
  
  vpc_id = data.aws_vpc.selected_vpc
  subnets = data.aws_subnets.database
  create_security_group = false
  security_group_name = local.config.sg_database.name

  publicly_accessible = false
  skip_final_snapshot = true
  apply_immediately = true

  instances = {
    aurora1 = {}
    aurora2 = {}
  }

  tags = {
    Name = local.config.rds.name
    Terraform = "true"
    Vpc = data.aws_vpc.selected_vpc
    Subnets = data.aws_subnets.database
    EngineV = local.config.rds.engine_version
  }
}

resource "random_password" "master_password" {
  length = 16
  special = true
}