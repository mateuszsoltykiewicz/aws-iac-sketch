module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.config.vpc.name
  cidr = local.config.vpc.cidr
  azs = local.config.vpc.azs

  private_subnets = local.config.vpc.private_subnets
  public_subnets = local.config.vpc.public_subnets
  database_subnets = local.config.database_subnets

  enable_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true

  create_database_subnet_group = true
  create_database_subnet_route_table = true
  create_database_internet_gateway_route = true

  tags = {
    Terraform = "true"
    Namespace = local.config.namespace.name
    Vpc = local.config.vpc.name
  }
}