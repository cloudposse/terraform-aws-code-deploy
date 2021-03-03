variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "ecs_launch_type" {
  type        = string
  description = "ECS launch type"
}

variable "container_name" {
  type        = string
  description = "The name of the container. Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
}

variable "container_image" {
  type        = string
  description = "The image used to start the container. Images in the Docker Hub registry available by default"
}

variable "container_memory" {
  type        = number
  description = "The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
}

variable "container_memory_reservation" {
  type        = number
  description = "The amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
}

variable "container_port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))

  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
}

variable "container_essential" {
  type        = bool
  description = "Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value"
}

variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps"
}

variable "container_readonly_root_filesystem" {
  type        = bool
  description = "Determines whether a container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value"
}

variable "network_mode" {
  type        = string
  description = "The network mode to use for the task. This is required to be `awsvpc` for `FARGATE` `launch_type`"
}

variable "task_cpu" {
  type        = number
  description = "The number of CPU units used by the task. If using `FARGATE` launch type `task_cpu` must match supported memory values (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
}

variable "task_memory" {
  type        = number
  description = "The amount of memory (in MiB) used by the task. If using Fargate launch type `task_memory` must match supported cpu value (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running"
}

variable "deployment_controller_type" {
  type        = string
  description = "Type of deployment controller. Valid values are `CODE_DEPLOY` and `ECS`"
}

variable "deployment_maximum_percent" {
  type        = number
  description = "The upper limit of the number of tasks (as a percentage of `desired_count`) that can be running in a service during a deployment"
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "The lower limit (as a percentage of `desired_count`) of the number of tasks that must remain running and healthy in a service during a deployment"
}

variable "ignore_changes_task_definition" {
  type        = bool
  description = "Whether to ignore changes in container definition and task definition in the ECS service"
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are `true` or `false`. Default `false`"
}

variable "propagate_tags" {
  type        = string
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION"
}

variable "internal" {
  type        = bool
  description = "A boolean flag to determine whether the ALB should be internal"
}

variable "http_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable HTTP listener"
}

variable "access_logs_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable access_logs"
}

variable "cross_zone_load_balancing_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable cross zone load balancing"
}

variable "http2_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable HTTP/2"
}

variable "idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle"
}

variable "ip_address_type" {
  type        = string
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`."
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable deletion protection for ALB"
}

variable "alb_access_logs_s3_bucket_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the ALB access logs S3 bucket so that the bucket can be destroyed without error"
}

variable "target_group_port" {
  type        = number
  description = "The port for the default target group"
}

variable "target_group_target_type" {
  type        = string
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}

variable "target_group_protocol" {
  type        = string
  description = "The protocol for the default target group HTTP or HTTPS"
}

variable "deregistration_delay" {
  type        = number
  description = "The amount of time to wait in seconds while deregistering target"
}

variable "health_check_path" {
  type        = string
  description = "The destination for the health check request"
}

variable "health_check_port" {
  type        = string
  description = "The port to use for the healthcheck"
}

variable "health_check_timeout" {
  type        = number
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  description = "The number of consecutive health checks successes required before healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  description = "The number of consecutive health check failures required before unhealthy"
}

variable "health_check_interval" {
  type        = number
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  description = "The HTTP response codes to indicate a healthy check"
}
