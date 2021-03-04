output "id" {
  description = "The application ID."
  value       = module.code_deploy_blue_green.id
}

output "name" {
  description = "The application's name."
  value       = module.code_deploy_blue_green.name
}

output "group_id" {
  description = "The application group ID."
  value       = module.code_deploy_blue_green.group_id
}

output "deployment_config_name" {
  description = "The deployment group's config name."
  value       = module.code_deploy_blue_green.deployment_config_name
}

output "deployment_config_id" {
  description = "The deployment config ID."
  value       = module.code_deploy_blue_green.deployment_config_id
}
