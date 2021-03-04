provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.21.1"

  cidr_block = var.vpc_cidr_block

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.38.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}

module "blue_target_group_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = ["blue"]
  context    = module.this.context
}

module "green_target_group_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = ["green"]
  context    = module.this.context
}

module "alb" {
  source  = "cloudposse/alb/aws"
  version = "0.29.6"

  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = var.internal
  http_enabled                            = var.http_enabled
  access_logs_enabled                     = var.access_logs_enabled
  alb_access_logs_s3_bucket_force_destroy = var.alb_access_logs_s3_bucket_force_destroy
  cross_zone_load_balancing_enabled       = var.cross_zone_load_balancing_enabled
  http2_enabled                           = var.http2_enabled
  idle_timeout                            = var.idle_timeout
  ip_address_type                         = var.ip_address_type
  deletion_protection_enabled             = var.deletion_protection_enabled
  deregistration_delay                    = var.deregistration_delay
  health_check_path                       = var.health_check_path
  health_check_port                       = var.health_check_port
  health_check_timeout                    = var.health_check_timeout
  health_check_healthy_threshold          = var.health_check_healthy_threshold
  health_check_unhealthy_threshold        = var.health_check_unhealthy_threshold
  health_check_interval                   = var.health_check_interval
  health_check_matcher                    = var.health_check_matcher
  target_group_port                       = var.target_group_port
  target_group_target_type                = var.target_group_target_type
  target_group_name                       = module.blue_target_group_label.id

  context = module.this.context
}

resource "aws_lb_target_group" "green" {
  name                 = module.green_target_group_label.id
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = module.vpc.vpc_id
  target_type          = var.target_group_target_type
  deregistration_delay = var.deregistration_delay

  health_check {
    protocol            = var.target_group_protocol
    path                = var.health_check_path
    port                = var.health_check_port
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  tags = module.green_target_group_label.tags
}

resource "aws_ecs_cluster" "default" {
  name = module.this.id
  tags = module.this.tags
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.51.0"

  container_name               = var.container_name
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  essential                    = var.container_essential
  readonly_root_filesystem     = var.container_readonly_root_filesystem
  environment                  = var.container_environment
  port_mappings                = var.container_port_mappings
}

module "ecs_alb_service_task" {
  source  = "cloudposse/ecs-alb-service-task/aws"
  version = "0.54.1"

  alb_security_group                 = module.vpc.vpc_default_security_group_id
  container_definition_json          = module.container_definition.json_map_encoded_list
  ecs_cluster_arn                    = aws_ecs_cluster.default.arn
  launch_type                        = var.ecs_launch_type
  vpc_id                             = module.vpc.vpc_id
  security_group_ids                 = [module.vpc.vpc_default_security_group_id]
  subnet_ids                         = module.subnets.public_subnet_ids
  ignore_changes_task_definition     = var.ignore_changes_task_definition
  network_mode                       = var.network_mode
  assign_public_ip                   = var.assign_public_ip
  propagate_tags                     = var.propagate_tags
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_controller_type         = var.deployment_controller_type
  desired_count                      = var.desired_count
  task_memory                        = var.task_memory
  task_cpu                           = var.task_cpu

  ecs_load_balancers = [
    {
      container_name   = var.container_name
      container_port   = 80
      elb_name         = null
      target_group_arn = module.alb.default_target_group_arn
    }
  ]

  context = module.this.context

  depends_on = [
    module.alb
  ]
}

module "code_deploy_blue_green" {
  source  = "../.."
  context = module.this.context

  minimum_healthy_hosts = null

  traffic_routing_config = {
    type       = "TimeBasedLinear"
    interval   = 10
    percentage = 10
  }

  deployment_style = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config = {
    deployment_ready_option = {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 10
    }
    terminate_blue_instances_on_deployment_success = {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service = [
    {
      cluster_name = aws_ecs_cluster.default.name
      service_name = module.ecs_alb_service_task.service_name
    }
  ]

  load_balancer_info = {
    target_group_pair_info = {
      prod_traffic_route = {
        listener_arns = [module.alb.http_listener_arn]
      }
      blue_target_group = {
        name = module.alb.default_target_group_arn
      }
      green_target_group = {
        name = aws_lb_target_group.green.arn
      }
    }
  }
}
