region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "cdp"

stage = "test"

name = "ecs-alb"

vpc_cidr_block = "172.16.0.0/16"

ecs_launch_type = "FARGATE"

network_mode = "awsvpc"

ignore_changes_task_definition = true

assign_public_ip = false

propagate_tags = "TASK_DEFINITION"

deployment_minimum_healthy_percent = 100

deployment_maximum_percent = 200

deployment_controller_type = "CODE_DEPLOY"

desired_count = 1

task_memory = 512

task_cpu = 256

container_name = "nginx"

container_image = "nginx:latest"

container_memory = 256

container_memory_reservation = 128

container_cpu = 256

container_essential = true

container_readonly_root_filesystem = false

container_environment = [
  {
    name  = "string_var"
    value = "I am a string"
  },
  {
    name  = "true_boolean_var"
    value = true
  },
  {
    name  = "false_boolean_var"
    value = false
  },
  {
    name  = "integer_var"
    value = 42
  }
]

container_port_mappings = [
  {
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
  },
  {
    containerPort = 443
    hostPort      = 443
    protocol      = "tcp"
  }
]

internal = false

http_enabled = true

access_logs_enabled = false

alb_access_logs_s3_bucket_force_destroy = true

cross_zone_load_balancing_enabled = true

http2_enabled = true

idle_timeout = 60

ip_address_type = "ipv4"

deletion_protection_enabled = false

deregistration_delay = 15

health_check_path = "/"

health_check_port = "traffic-port"

health_check_timeout = 10

health_check_healthy_threshold = 2

health_check_unhealthy_threshold = 2

health_check_interval = 15

health_check_matcher = "200-399"

target_group_port = 80

target_group_target_type = "ip"

target_group_protocol = "HTTP"