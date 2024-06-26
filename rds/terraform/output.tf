output "cluster_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "cluster_master_password" {
  sensitive = true
  value = module.aurora.cluster_master_password
}