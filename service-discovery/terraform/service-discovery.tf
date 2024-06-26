resource "aws_service_discovery_service" "service_discovery" {
  name = local.config.service_discovery.name
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_dns.id

    dns_records {
      ttl = 10
      type = "A"
    }
  }
  depends_on = [ aws_service_discovery_private_dns_namespace.private_dns ]
}