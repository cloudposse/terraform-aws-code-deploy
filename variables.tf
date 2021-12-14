variable "compute_platform" {
  type        = string
  default     = "ECS"
  description = "The compute platform can either be `ECS`, `Lambda`, or `Server`"
}

variable "minimum_healthy_hosts" {
  type = object({
    type  = string
    value = number
  })
  default     = null
  description = <<-DOC
    type:
      The type can either be `FLEET_PERCENT` or `HOST_COUNT`.
    value:
      The value when the type is `FLEET_PERCENT` represents the minimum number of healthy instances 
      as a percentage of the total number of instances in the deployment.
      When the type is `HOST_COUNT`, the value represents the minimum number of healthy instances as an absolute value.
  DOC
}

variable "traffic_routing_config" {
  type = object({
    type       = string
    interval   = number
    percentage = number
  })
  default     = null
  description = <<-DOC
    type:
      Type of traffic routing config. One of `TimeBasedCanary`, `TimeBasedLinear`, `AllAtOnce`.
    interval:
      The number of minutes between the first and second traffic shifts of a deployment.
    percentage:
      The percentage of traffic to shift in the first increment of a deployment.
  DOC
}

variable "create_default_service_role" {
  type        = bool
  default     = true
  description = "Whether to create default IAM role ARN that allows deployments."
}

variable "service_role_arn" {
  type        = string
  default     = null
  description = "The service IAM role ARN that allows deployments."
}

variable "create_default_sns_topic" {
  type        = bool
  default     = true
  description = "Whether to create default SNS topic through which notifications are sent."
}

variable "sns_topic_arn" {
  type        = string
  default     = ""
  description = "The ARN of the SNS topic through which notifications are sent."
}

variable "autoscaling_groups" {
  type        = list(string)
  description = "A list of Autoscaling Groups associated with the deployment group."
  default     = []
}

variable "alarm_configuration" {
  type = object({
    alarms                    = list(string)
    ignore_poll_alarm_failure = bool
  })
  default     = null
  description = <<-DOC
     Configuration of deployment to stop when a CloudWatch alarm detects that a metric has fallen below or exceeded a defined threshold.
      alarms:
        A list of alarms configured for the deployment group.
      ignore_poll_alarm_failure:
        Indicates whether a deployment should continue if information about the current state of alarms cannot be retrieved from CloudWatch.
  DOC
}

variable "auto_rollback_configuration_events" {
  type        = string
  default     = "DEPLOYMENT_FAILURE"
  description = "The event type or types that trigger a rollback. Supported types are `DEPLOYMENT_FAILURE` and `DEPLOYMENT_STOP_ON_ALARM`."

}

variable "blue_green_deployment_config" {
  type        = any
  default     = null
  description = <<-DOC
    Configuration block of the blue/green deployment options for a deployment group, 
    see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#blue_green_deployment_config
  DOC
}

variable "deployment_style" {
  type = object({
    deployment_option = string
    deployment_type   = string
  })
  default     = null
  description = <<-DOC
    Configuration of the type of deployment, either in-place or blue/green, 
    you want to run and whether to route deployment traffic behind a load balancer.

    deployment_option:
      Indicates whether to route deployment traffic behind a load balancer. 
      Possible values: `WITH_TRAFFIC_CONTROL`, `WITHOUT_TRAFFIC_CONTROL`.
    deployment_type:
      Indicates whether to run an in-place deployment or a blue/green deployment.
      Possible values: `IN_PLACE`, `BLUE_GREEN`.
  DOC
}

variable "ec2_tag_filter" {
  type = set(object({
    key   = string
    type  = string
    value = string
  }))
  default     = []
  description = <<-DOC
    The Amazon EC2 tags on which to filter. The deployment group includes EC2 instances with any of the specified tags.
    Cannot be used in the same call as ec2TagSet.
  DOC
}

variable "ec2_tag_set" {
  type = set(object(
    {
      ec2_tag_filter = set(object(
        {
          key   = string
          type  = string
          value = string
        }
      ))
    }
  ))
  default     = []
  description = <<-DOC
    A list of sets of tag filters. If multiple tag groups are specified,
    any instance that matches to at least one tag filter of every tag group is selected.

    key:
      The key of the tag filter.
    type:
      The type of the tag filter, either `KEY_ONLY`, `VALUE_ONLY`, or `KEY_AND_VALUE`.
    value:
      The value of the tag filter.
  DOC
}

variable "ecs_service" {
  type = list(object({
    cluster_name = string
    service_name = string
  }))
  default     = null
  description = <<-DOC
    Configuration block(s) of the ECS services for a deployment group.

    cluster_name:
      The name of the ECS cluster. 
    service_name:
      The name of the ECS service.
  DOC
}

variable "load_balancer_info" {
  type        = map(any)
  default     = null
  description = <<-DOC
    Single configuration block of the load balancer to use in a blue/green deployment, 
    see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#load_balancer_info
  DOC
}

variable "trigger_events" {
  type        = list(string)
  default     = ["DeploymentFailure"]
  description = <<-DOC
    The event type or types for which notifications are triggered. 
    Some values that are supported: 
      `DeploymentStart`, `DeploymentSuccess`, `DeploymentFailure`, `DeploymentStop`, 
      `DeploymentRollback`, `InstanceStart`, `InstanceSuccess`, `InstanceFailure`. 
    See the CodeDeploy documentation for all possible values.
    http://docs.aws.amazon.com/codedeploy/latest/userguide/monitoring-sns-event-notifications-create-trigger.html 
  DOC
}
