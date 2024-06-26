module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = local.config.alb.name
  vpc_id = data.aws_vpc.selected_vpc.id
  subnets = toset(data.aws_subnets.all_vpc.ids)

  create_security_group = false

  listeners = {
    external-https-http-redirect = {
      port = 443
      protocol = "HTTPS"
      certificate_arn = "arn:aws:iam:211125452360:server-certificate/demo"

      forward = {
        target_group_key = "http-redirect"
      }
    }
  }

  security_groups = [toset(data.aws_security_groups.all_sgs.ids)]

  tags = {
    Name = local.config.alb.name
    Vpc = data.aws_vpc.selected_vpc.id
    Subnets = toset(data.aws_subnets.all_vpc.ids)
  }


  target_groups = {
    "http-redirect" = {
      protocol = "HTTP"
      port = 8080
      target_type = "ip"
    }

  }
}