# NGINX Service
resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = "${aws_ecs_cluster.ecs-test.id}"
  task_definition = "${aws_ecs_task_definition.nginx-def.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"
  depends_on      = ["aws_iam_role_policy_attachment.ecs-service-attach"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.nginx-tg.id}"
    container_name   = "nginx"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

resource "aws_ecs_task_definition" "nginx-def" {
  family = "nginx"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "nginx:latest",
    "essential": true,
    "name": "nginx",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-logs/nginx",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs-logs/nginx"
}
