resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  container_definitions = files("./container/definition.json")
  network_mode = "awsvpc"
}