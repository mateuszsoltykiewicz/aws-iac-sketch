resource "aws_security_group" "https" {
  name = local.config.sg_https.name
  description = local.config.sg_https.description
  vpc_id = data.aws_vpc.selected_vpc.id
  
  ingress = {
    from_port = 443
    to_port = 443
    protocol = tcp
    cidr_blocks = local.config.sg_https.cidr
  }
  egress = {
    from_port = 443
    to_port = 443
    protocol = tcp
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.config.sg_https.name
    Vpc = local.config.vpc.name
  }

}

resource "aws_security_group" "http" {
  name = local.config.sg_http.name
  description = local.config.sg_http.description
  vpc_id = data.aws_vpc.selected_vpc.id
  ingress = {
    from_port = 8080
    to_port = 8080
    protocol = tcp
    cidr_blocks = local.config.sg_http.cidr
  }
  egress = {
    from_port = 8080
    to_port = 8080
    protocol = tcp
    cidr_blocks = local.config.sg_http.cidr
  }

  tags = {
    Name = local.config.sg_http.name
    Vpc = local.config.vpc.name
  }

}

resource "aws_security_group" "ecstasktodb" {
  name = local.config.sg_ecstasktodb.name
  description = local.config.sg_http.description
  vpc_id = data.aws_vpc.selected_vpc.id
  ingress = {
    from_port = 5432
    to_port = 5432
    protocol = tcp
    cidr_blocks = local.config.sg_ecstasktodb.cidr
  }
  egress = {
    from_port = 5432
    to_port = 5432
    protocol = tcp
    cidr_blocks = local.config.sg_ecstasktodb.cidr
  }

  tags = {
    Name = local.config.sg_ecstasktodb.name
    Vpc = local.config.vpc.name
  }
}

resource "aws_security_group" "sg_database" {
  name = local.config.sg_database.name
  description = local.config.sg_database.description
  vpc_id = data.aws_vpc.selected_vpc.id
  ingress = [
    {
      from_port = 5432
      to_port = 5432
      protocol = tcp
      cidr_blocks = local.config.sg_database.cidr
    },
    {
      from_port = 5432
      to_port = 5432
      protocol = tcp
      security_groups = aws_security_group.ecstasktodb.id
    }
  ]

  tags = {
    Name = local.config.sg_ecstasktodb.name
    Vpc = local.config.vpc.name
  }
  depends_on = [ aws_security_group.ecstasktodb ]
}

resource "aws_security_group" "sg_container_task" {
  name = local.config.sg_container_task.name
  description = local.config.sg_container_task.description
  vpc_id = data.aws_vpc.selected_vpc.id
  ingress = [
    {
      from_port = 80
      to_port = 80
      protocol = tcp
      cidr_blocks = local.config.sg_container_task.cidr
    }
  ]
  egress = [
    {
      from_port = 80
      to_port = 80
      protocol = tcp
      cidr_blocks = local.config.sg_container_task.cidr
    }
  ]

  tags = {
    Name = local.config.sg_container_task.name
    Vpc = local.config.vpc.name
  }
}