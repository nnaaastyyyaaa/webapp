output "worker_ssh" {
  value       = "127.0.0.1:2222"
  description = "Connect to Worker VM via SSH on this address"
}

output "db_ssh" {
  value       = "127.0.0.1:2223"
  description = "Connect to DB VM via SSH on this address"
}