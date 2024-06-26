data "aws_vpc" "selected_vpc" {
  filter {
    name = "tag:Vpc"
    values = [local.config.vpc.name]
  }
}

data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }

  tags = {
    Tier = "Database"
  }
  depends_on = [ data.aws_vpc.selected_vpc ]
}

data "aws_security_group" "ecstodb" {
  name = local.config.sg_ecstasktodb.ecstodb
  vpc_id = data.aws_vpc.selected_vpc.id

  depends_on = [ data.aws_vpc.selected_vpc ]
}