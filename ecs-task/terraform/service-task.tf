resource "aws_ecs_service" "demo" {
  name = "demo"
  cluster = data.aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition
  desired_count = 1

  load_balancer {
    target_group_arn = data.aws_alb.alb.arn
    container_name = "rest"
    container_port = 8080
  }

  network_configuration {
    subnets = concat(data.aws_subnets.database.ids, data.aws_subnets.private.ids)
    security_groups = data.aws_security_groups.security_groups
  }

  service_connect_configuration {
    enabled = true
    namespace = local.config.namespace.name
    service {
      discovery_name = local.config.service.discovery_name
      port_name = local.config.port_name
      client_alias {
        dns_name = local.config.service.dns_name
        port = local.config.service.port
      }
    }
  }
  depends_on = [ aws_ecs_task_definition.task_definition ]
}