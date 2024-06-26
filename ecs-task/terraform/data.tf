data "aws_ecs_cluster" "cluster" {
  cluster_name = local.config.cluster.name
}

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

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }

  tags = {
    Tier = "Private"
  }
  depends_on = [ data.aws_vpc.selected_vpc ]
}

data "aws_security_groups" "security_groups" {
  filter {
    name = "tag:Name"
    values = local.config.security-groups.names
  }
}

data "aws_alb" "alb" {
  name = "demo"
}