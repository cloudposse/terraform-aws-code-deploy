output "id" {
  description = "The application ID."
  value       = try(local.id, null)
}

output "name" {
  description = "The application's name."
  value       = try(local.name, null)
}

output "group_id" {
  description = "The application group ID."
  value       = try(local.group_id, null)
}

output "group_name" {
  description = "The application group ID."
  value       = try(local.group_name, null)
}

output "deployment_config_name" {
  description = "The deployment group's config name."
  value       = try(local.deployment_config_name, null)
}

output "deployment_config_id" {
  description = "The deployment config ID."
  value       = try(local.deployment_config_id, null)
}
