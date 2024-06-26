data "aws_vpc" "selected_vpc" {
  filter {
    name = "tag:Vpc"
    values = [local.config.vpc.name]
  }
}