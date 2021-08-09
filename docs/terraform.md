<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_codedeploy_deployment_config_label"></a> [aws\_codedeploy\_deployment\_config\_label](#module\_aws\_codedeploy\_deployment\_config\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_sns_topic"></a> [sns\_topic](#module\_sns\_topic) | cloudposse/sns-topic/aws | 0.16.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_codedeploy_app.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_config.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config) | resource |
| [aws_codedeploy_deployment_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_id.deployment_config_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_alarm_configuration"></a> [alarm\_configuration](#input\_alarm\_configuration) | Configuration of deployment to stop when a CloudWatch alarm detects that a metric has fallen below or exceeded a defined threshold.<br> alarms:<br>   A list of alarms configured for the deployment group.<br> ignore\_poll\_alarm\_failure:<br>   Indicates whether a deployment should continue if information about the current state of alarms cannot be retrieved from CloudWatch. | <pre>object({<br>    alarms                    = list(string)<br>    ignore_poll_alarm_failure = bool<br>  })</pre> | `null` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_auto_rollback_configuration_events"></a> [auto\_rollback\_configuration\_events](#input\_auto\_rollback\_configuration\_events) | The event type or types that trigger a rollback. Supported types are `DEPLOYMENT_FAILURE` and `DEPLOYMENT_STOP_ON_ALARM`. | `string` | `"DEPLOYMENT_FAILURE"` | no |
| <a name="input_autoscaling_groups"></a> [autoscaling\_groups](#input\_autoscaling\_groups) | A list of Autoscaling Groups associated with the deployment group. | `list(string)` | `[]` | no |
| <a name="input_blue_green_deployment_config"></a> [blue\_green\_deployment\_config](#input\_blue\_green\_deployment\_config) | Configuration block of the blue/green deployment options for a deployment group, <br>see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#blue_green_deployment_config | `any` | `null` | no |
| <a name="input_compute_platform"></a> [compute\_platform](#input\_compute\_platform) | The compute platform can either be `ECS`, `Lambda`, or `Server` | `string` | `"ECS"` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_create_default_service_role"></a> [create\_default\_service\_role](#input\_create\_default\_service\_role) | Whether to create default IAM role ARN that allows deployments. | `bool` | `true` | no |
| <a name="input_create_default_sns_topic"></a> [create\_default\_sns\_topic](#input\_create\_default\_sns\_topic) | Whether to create default SNS topic through which notifications are sent. | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_deployment_style"></a> [deployment\_style](#input\_deployment\_style) | Configuration of the type of deployment, either in-place or blue/green, <br>you want to run and whether to route deployment traffic behind a load balancer.<br><br>deployment\_option:<br>  Indicates whether to route deployment traffic behind a load balancer. <br>  Possible values: `WITH_TRAFFIC_CONTROL`, `WITHOUT_TRAFFIC_CONTROL`.<br>deployment\_type:<br>  Indicates whether to run an in-place deployment or a blue/green deployment.<br>  Possible values: `IN_PLACE`, `BLUE_GREEN`. | <pre>object({<br>    deployment_option = string<br>    deployment_type   = string<br>  })</pre> | `null` | no |
| <a name="input_ec2_tag_filter"></a> [ec2\_tag\_filter](#input\_ec2\_tag\_filter) | A list of sets of tag filters. If multiple tag groups are specified, <br>any instance that matches to at least one tag filter of every tag group is selected.<br><br>key:<br>  The key of the tag filter.<br>type:<br>  The type of the tag filter, either `KEY_ONLY`, `VALUE_ONLY`, or `KEY_AND_VALUE`.<br>value:<br>  The value of the tag filter. | <pre>list(object({<br>    key   = string<br>    type  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_ecs_service"></a> [ecs\_service](#input\_ecs\_service) | Configuration block(s) of the ECS services for a deployment group.<br><br>cluster\_name:<br>  The name of the ECS cluster. <br>service\_name:<br>  The name of the ECS service. | <pre>list(object({<br>    cluster_name = string<br>    service_name = string<br>  }))</pre> | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_load_balancer_info"></a> [load\_balancer\_info](#input\_load\_balancer\_info) | Single configuration block of the load balancer to use in a blue/green deployment, <br>see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#load_balancer_info | `map(any)` | `null` | no |
| <a name="input_minimum_healthy_hosts"></a> [minimum\_healthy\_hosts](#input\_minimum\_healthy\_hosts) | type:<br>  The type can either be `FLEET_PERCENT` or `HOST_COUNT`.<br>value:<br>  The value when the type is `FLEET_PERCENT` represents the minimum number of healthy instances <br>  as a percentage of the total number of instances in the deployment.<br>  When the type is `HOST_COUNT`, the value represents the minimum number of healthy instances as an absolute value. | <pre>object({<br>    type  = string<br>    value = number<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_service_role_arn"></a> [service\_role\_arn](#input\_service\_role\_arn) | The service IAM role ARN that allows deployments. | `string` | `null` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The ARN of the SNS topic through which notifications are sent. | `string` | `""` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_traffic_routing_config"></a> [traffic\_routing\_config](#input\_traffic\_routing\_config) | type:<br>  Type of traffic routing config. One of `TimeBasedCanary`, `TimeBasedLinear`, `AllAtOnce`.<br>interval:<br>  The number of minutes between the first and second traffic shifts of a deployment.<br>percentage:<br>  The percentage of traffic to shift in the first increment of a deployment. | <pre>object({<br>    type       = string<br>    interval   = number<br>    percentage = number<br>  })</pre> | `null` | no |
| <a name="input_trigger_events"></a> [trigger\_events](#input\_trigger\_events) | The event type or types for which notifications are triggered. <br>Some values that are supported: <br>  `DeploymentStart`, `DeploymentSuccess`, `DeploymentFailure`, `DeploymentStop`, <br>  `DeploymentRollback`, `InstanceStart`, `InstanceSuccess`, `InstanceFailure`. <br>See the CodeDeploy documentation for all possible values.<br>http://docs.aws.amazon.com/codedeploy/latest/userguide/monitoring-sns-event-notifications-create-trigger.html | `list(string)` | <pre>[<br>  "DeploymentFailure"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_config_id"></a> [deployment\_config\_id](#output\_deployment\_config\_id) | The deployment config ID. |
| <a name="output_deployment_config_name"></a> [deployment\_config\_name](#output\_deployment\_config\_name) | The deployment group's config name. |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | The application group ID. |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | The application group ID. |
| <a name="output_id"></a> [id](#output\_id) | The application ID. |
| <a name="output_name"></a> [name](#output\_name) | The application's name. |
<!-- markdownlint-restore -->
