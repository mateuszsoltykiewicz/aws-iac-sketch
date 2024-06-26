data "aws_vpc" "selected_vpc" {
  filter {
    name = "tag:Vpc"
    values = [local.config.alb.vpc_name]
  }
}

data "aws_subnets" "all_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }
  depends_on = [ data.aws_vpc.selected_vpc ]
}

data "aws_security_groups" "all_sgs" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }

  depends_on = [ data.aws_vpc.selected_vpc ]
}