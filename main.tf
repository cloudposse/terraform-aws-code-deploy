locals {
  enabled = module.this.enabled

  count                               = local.enabled ? 1 : 0
  id                                  = local.enabled ? join("", aws_codedeploy_app.default.*.id) : null
  name                                = local.enabled ? join("", aws_codedeploy_app.default.*.name) : null
  group_id                            = local.enabled ? join("", aws_codedeploy_deployment_group.default.*.id) : null
  deployment_config_name              = local.enabled ? join("", aws_codedeploy_deployment_config.default.*.id) : null
  deployment_config_id                = local.enabled ? join("", aws_codedeploy_deployment_config.default.*.deployment_config_id) : null
  auto_rollback_configuration_enabled = local.enabled && var.auto_rollback_configuration_events != null && length(var.auto_rollback_configuration_events) > 0
  alarm_configuration_enabled         = local.enabled && var.alarm_configuration != null
  default_sns_topic_enabled           = local.enabled && var.create_default_sns_topic
  sns_topic_arn                       = local.default_sns_topic_enabled ? module.sns_topic.sns_topic.arn : var.sns_topic_arn
  default_service_role_enabled        = local.enabled && var.create_default_service_role
  default_service_role_count          = local.default_service_role_enabled ? 1 : 0
  service_role_arn                    = local.default_service_role_enabled ? join("", aws_iam_role.default.*.arn) : var.service_role_arn
  default_policy_arn = {
    Server = "arn:${join("", data.aws_partition.current.*.partition)}:iam::aws:policy/service-role/AWSCodeDeployRole"
    Lambda = "arn:${join("", data.aws_partition.current.*.partition)}:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
    ECS    = "arn:${join("", data.aws_partition.current.*.partition)}:iam::aws:policy/AWSCodeDeployRoleForECS"
  }
}

data "aws_iam_policy_document" "assume_role" {
  count = local.default_service_role_count

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_partition" "current" {
  count = local.default_service_role_count
}

resource "aws_iam_role" "default" {
  count              = local.default_service_role_count
  name               = module.this.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = module.this.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = local.default_service_role_count
  policy_arn = format("%s", lookup(local.default_policy_arn, var.compute_platform))
  role       = join("", aws_iam_role.default.*.name)
}

module "sns_topic" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.20.1"

  enabled = local.default_sns_topic_enabled
  context = module.this.context
}

resource "aws_codedeploy_app" "default" {
  count            = local.count
  name             = module.this.id
  compute_platform = var.compute_platform

  tags = module.this.tags
}

resource "aws_codedeploy_deployment_config" "default" {
  count                  = local.count
  deployment_config_name = module.this.id
  compute_platform       = var.compute_platform

  dynamic "minimum_healthy_hosts" {
    for_each = var.minimum_healthy_hosts == null ? [] : [var.minimum_healthy_hosts]
    content {
      type  = minimum_healthy_hosts.value.type
      value = minimum_healthy_hosts.value.value
    }
  }

  dynamic "traffic_routing_config" {
    for_each = var.traffic_routing_config == null ? [] : [var.traffic_routing_config]

    content {
      type = traffic_routing_config.value.type

      dynamic "time_based_linear" {
        for_each = var.traffic_routing_config != null && lookup(var.traffic_routing_config, "type", null) == "TimeBasedLinear" ? [var.traffic_routing_config] : []

        content {
          interval   = traffic_routing_config.value.interval
          percentage = traffic_routing_config.value.percentage
        }
      }

      dynamic "time_based_canary" {
        for_each = var.traffic_routing_config != null && lookup(var.traffic_routing_config, "type", null) == "TimeBasedCanary" ? [var.traffic_routing_config] : []

        content {
          interval   = traffic_routing_config.value.interval
          percentage = traffic_routing_config.value.percentage
        }
      }
    }
  }
}

resource "aws_codedeploy_deployment_group" "default" {
  count                  = local.count
  app_name               = local.name
  deployment_group_name  = module.this.id
  deployment_config_name = local.deployment_config_name
  service_role_arn       = local.service_role_arn
  autoscaling_groups     = var.autoscaling_groups

  dynamic "alarm_configuration" {
    for_each = local.alarm_configuration_enabled ? [var.alarm_configuration] : []

    content {
      alarms                    = lookup(alarm_configuration.value, "alarms", null)
      ignore_poll_alarm_failure = lookup(alarm_configuration.value, "ignore_poll_alarm_failure", null)
      enabled                   = local.alarm_configuration_enabled
    }
  }

  dynamic "auto_rollback_configuration" {
    for_each = local.auto_rollback_configuration_enabled ? [1] : [0]

    content {
      enabled = local.auto_rollback_configuration_enabled
      events  = [var.auto_rollback_configuration_events]
    }
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.blue_green_deployment_config == null ? [] : [var.blue_green_deployment_config]
    content {
      dynamic "deployment_ready_option" {
        for_each = lookup(blue_green_deployment_config.value, "deployment_ready_option", null) == null ? [] : [lookup(blue_green_deployment_config.value, "deployment_ready_option", {})]

        content {
          action_on_timeout    = lookup(deployment_ready_option.value, "action_on_timeout", null)
          wait_time_in_minutes = lookup(deployment_ready_option.value, "wait_time_in_minutes", null)
        }
      }

      dynamic "green_fleet_provisioning_option" {
        for_each = lookup(blue_green_deployment_config.value, "green_fleet_provisioning_option", null) == null ? [] : [lookup(blue_green_deployment_config.value, "green_fleet_provisioning_option", {})]

        content {
          action = lookup(green_fleet_provisioning_option.value, "action", null)
        }
      }

      dynamic "terminate_blue_instances_on_deployment_success" {
        for_each = lookup(blue_green_deployment_config.value, "terminate_blue_instances_on_deployment_success", null) == null ? [] : [lookup(blue_green_deployment_config.value, "terminate_blue_instances_on_deployment_success", {})]

        content {
          action                           = lookup(terminate_blue_instances_on_deployment_success.value, "action", null)
          termination_wait_time_in_minutes = lookup(terminate_blue_instances_on_deployment_success.value, "termination_wait_time_in_minutes", null)
        }
      }
    }
  }

  dynamic "deployment_style" {
    for_each = var.deployment_style == null ? [] : [var.deployment_style]

    content {
      deployment_option = deployment_style.value.deployment_option
      deployment_type   = deployment_style.value.deployment_type
    }
  }

  # Note that you cannot have both ec_tag_filter and ec2_tag_set vars set!
  # See https://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment-group.html for details
  dynamic "ec2_tag_filter" {
    for_each = length(var.ec2_tag_filter) > 0 ? [] : var.ec2_tag_filter
    content {
      key   = ec2_tag_filter.value["key"]
      type  = ec2_tag_filter.value["type"]
      value = ec2_tag_filter.value["value"]
    }
  }

  # Note that you cannot have both ec_tag_filter and ec2_tag_set vars set!
  # See https://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment-group.html for details
  dynamic "ec2_tag_set" {
    for_each = var.ec2_tag_filter == null ? [] : var.ec2_tag_filter
    content {
      dynamic "ec2_tag_filter" {
        for_each = ec2_tag_set.value.ec2_tag_filter
        content {
          key   = ec2_tag_filter.value["key"]
          type  = ec2_tag_filter.value["type"]
          value = ec2_tag_filter.value["value"]
        }
      }
    }
  }

  dynamic "ecs_service" {
    for_each = var.ecs_service == null ? [] : var.ecs_service

    content {
      cluster_name = ecs_service.value.cluster_name
      service_name = ecs_service.value.service_name
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.load_balancer_info == null ? [] : [var.load_balancer_info]

    content {
      dynamic "elb_info" {
        for_each = lookup(load_balancer_info.value, "elb_info", null) == null ? [] : [load_balancer_info.value.elb_info]

        content {
          name = elb_info.value.name
        }
      }

      dynamic "target_group_info" {
        for_each = lookup(load_balancer_info.value, "target_group_info", null) == null ? [] : [load_balancer_info.value.target_group_info]

        content {
          name = target_group_info.value.name
        }
      }

      dynamic "target_group_pair_info" {
        for_each = lookup(load_balancer_info.value, "target_group_pair_info", null) == null ? [] : [load_balancer_info.value.target_group_pair_info]

        content {

          dynamic "prod_traffic_route" {
            for_each = lookup(target_group_pair_info.value, "prod_traffic_route", null) == null ? [] : [target_group_pair_info.value.prod_traffic_route]

            content {
              listener_arns = prod_traffic_route.value.listener_arns
            }
          }

          dynamic "target_group" {
            for_each = lookup(target_group_pair_info.value, "target_group", null) == null ? [] : [target_group_pair_info.value.target_group]

            content {
              name = target_group.value.name
            }
          }

          dynamic "target_group" {
            for_each = lookup(target_group_pair_info.value, "blue_target_group", null) == null ? [] : [target_group_pair_info.value.blue_target_group]

            content {
              name = target_group.value.name
            }
          }

          dynamic "target_group" {
            for_each = lookup(target_group_pair_info.value, "green_target_group", null) == null ? [] : [target_group_pair_info.value.green_target_group]

            content {
              name = target_group.value.name
            }
          }

          dynamic "test_traffic_route" {
            for_each = lookup(target_group_pair_info.value, "test_traffic_route", null) == null ? [] : [target_group_pair_info.value.test_traffic_route]

            content {
              listener_arns = test_traffic_route.value.listener_arns
            }
          }
        }
      }
    }
  }

  dynamic "trigger_configuration" {
    for_each = local.sns_topic_arn == null ? [0] : [1]

    content {
      trigger_events     = var.trigger_events
      trigger_name       = module.this.id
      trigger_target_arn = local.sns_topic_arn
    }
  }

  tags = module.this.tags
}
