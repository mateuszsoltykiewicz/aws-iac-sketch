resource "aws_ecs_cluster" "cluster" {
  name = local.config.cluster.name

  tags = {
    Name = local.config.cluster.name
    Terraform = "true"
    Vpc = data.aws_vpc.selected_vpc
  }
}