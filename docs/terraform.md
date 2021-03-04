<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 2.0 |
| local | >= 1.2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| sns_topic | cloudposse/sns-topic/aws | 0.16.0 |
| this | cloudposse/label/null | 0.24.1 |

## Resources

| Name |
|------|
| [aws_codedeploy_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) |
| [aws_codedeploy_deployment_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config) |
| [aws_codedeploy_deployment_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| alarm\_configuration | Configuration of deployment to stop when a CloudWatch alarm detects that a metric has fallen below or exceeded a defined threshold.<br> alarms:<br>   A list of alarms configured for the deployment group.<br> ignore\_poll\_alarm\_failure:<br>   Indicates whether a deployment should continue if information about the current state of alarms cannot be retrieved from CloudWatch. | <pre>object({<br>    alarms                    = list(string)<br>    ignore_poll_alarm_failure = bool<br>  })</pre> | `null` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| auto\_rollback\_configuration\_events | The event type or types that trigger a rollback. Supported types are `DEPLOYMENT_FAILURE` and `DEPLOYMENT_STOP_ON_ALARM`. | `string` | `"DEPLOYMENT_FAILURE"` | no |
| autoscaling\_groups | A list of Autoscaling Groups associated with the deployment group. | `list(string)` | `[]` | no |
| blue\_green\_deployment\_config | Configuration block of the blue/green deployment options for a deployment group, <br>see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#blue_green_deployment_config | `any` | `null` | no |
| compute\_platform | The compute platform can either be `ECS`, `Lambda`, or `Server` | `string` | `"ECS"` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| create\_default\_service\_role | Whether to create default IAM role ARN that allows deployments. | `bool` | `true` | no |
| create\_default\_sns\_topic | Whether to create default SNS topic through which notifications are sent. | `bool` | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| deployment\_style | Configuration of the type of deployment, either in-place or blue/green, <br>you want to run and whether to route deployment traffic behind a load balancer.<br><br>deployment\_option:<br>  Indicates whether to route deployment traffic behind a load balancer. <br>  Possible values: `WITH_TRAFFIC_CONTROL`, `WITHOUT_TRAFFIC_CONTROL`.<br>deployment\_type:<br>  Indicates whether to run an in-place deployment or a blue/green deployment.<br>  Possible values: `IN_PLACE`, `BLUE_GREEN`. | <pre>object({<br>    deployment_option = string<br>    deployment_type   = string<br>  })</pre> | `null` | no |
| ec2\_tag\_filter | A list of sets of tag filters. If multiple tag groups are specified, <br>any instance that matches to at least one tag filter of every tag group is selected.<br><br>key:<br>  The key of the tag filter.<br>type:<br>  The type of the tag filter, either `KEY_ONLY`, `VALUE_ONLY`, or `KEY_AND_VALUE`.<br>value:<br>  The value of the tag filter. | <pre>list(object({<br>    key   = string<br>    type  = string<br>    value = string<br>  }))</pre> | `null` | no |
| ecs\_service | Configuration block(s) of the ECS services for a deployment group.<br><br>cluster\_name:<br>  The name of the ECS cluster. <br>service\_name:<br>  The name of the ECS service. | <pre>list(object({<br>    cluster_name = string<br>    service_name = string<br>  }))</pre> | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| load\_balancer\_info | Single configuration block of the load balancer to use in a blue/green deployment, <br>see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group#load_balancer_info | `map(any)` | `null` | no |
| minimum\_healthy\_hosts | type:<br>  The type can either be `FLEET_PERCENT` or `HOST_COUNT`.<br>value:<br>  The value when the type is `FLEET_PERCENT` represents the minimum number of healthy instances <br>  as a percentage of the total number of instances in the deployment.<br>  When the type is `HOST_COUNT`, the value represents the minimum number of healthy instances as an absolute value. | <pre>object({<br>    type  = string<br>    value = number<br>  })</pre> | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| service\_role\_arn | The service IAM role ARN that allows deployments. | `string` | `null` | no |
| sns\_topic\_arn | The ARN of the SNS topic through which notifications are sent. | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| traffic\_routing\_config | type:<br>  Type of traffic routing config. One of `TimeBasedCanary`, `TimeBasedLinear`, `AllAtOnce`.<br>interval:<br>  The number of minutes between the first and second traffic shifts of a deployment.<br>percentage:<br>  The percentage of traffic to shift in the first increment of a deployment. | <pre>object({<br>    type       = string<br>    interval   = number<br>    percentage = number<br>  })</pre> | `null` | no |
| trigger\_events | The event type or types for which notifications are triggered. <br>Some values that are supported: <br>  `DeploymentStart`, `DeploymentSuccess`, `DeploymentFailure`, `DeploymentStop`, <br>  `DeploymentRollback`, `InstanceStart`, `InstanceSuccess`, `InstanceFailure`. <br>See the CodeDeploy documentation for all possible values.<br>http://docs.aws.amazon.com/codedeploy/latest/userguide/monitoring-sns-event-notifications-create-trigger.html | `list(string)` | <pre>[<br>  "DeploymentFailure"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| deployment\_config\_id | The deployment config ID. |
| deployment\_config\_name | The deployment group's config name. |
| group\_id | The application group ID. |
| id | The application ID. |
| name | The application's name. |
<!-- markdownlint-restore -->
