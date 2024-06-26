resource "aws_service_discovery_private_dns_namespace" "private_dns" {
  name = local.config.dns.name
  description = "Namespace for the demo job application"
  vpc = data.aws_vpc.selected_vpc
}