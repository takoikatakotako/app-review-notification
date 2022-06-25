###############################################
# Build Batch Image
###############################################
resource "aws_codebuild_project" "build_notification_batch_image" {
  name          = "build-notification-batch-image"
  description   = "build notification batch image"
  build_timeout = "10"
  service_role  = aws_iam_role.build_image_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  # LocalCache で問題がある場合は S3 を使ったキャッシュを検討
  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/takoikatakotako/app-review-terraform.git"
    buildspec = data.template_file.api_buildspec_template_file.rendered

    git_submodules_config {
      fetch_submodules = false
    }
  }
}

data "template_file" "api_buildspec_template_file" {
  template = file("${path.module}/template/buildspec-tpl.yml")

  vars = {
    repository_url = aws_ecr_repository.notification_batch_repository.repository_url
  }
}


###############################################
# Notification Batch Repository
###############################################
resource "aws_ecr_repository" "notification_batch_repository" {
  name = "notification-batch-repository"
}


###############################################
# Notification Batch Fargate
###############################################
resource "aws_ecs_cluster" "notification_batch_cluster" {
  name = "notification-batch-cluster"
}

resource "aws_cloudwatch_log_group" "notification_batch_log_group" {
  name = "/ecs/notification-batch"
}

resource "aws_ecs_task_definition" "notification_batch_task_definition" {
  family                   = "notification-batch-task-definition"
  task_role_arn            = aws_iam_role.notification_batch_role.arn
  container_definitions    = data.template_file.notification_batch_container_definitions.rendered
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.notification_batch_role.arn
}

data "template_file" "notification_batch_container_definitions" {
  template = <<EOF
[
  {
    "cpu": 0,
    "environment": [],
    "name": "notification-batch",
    "image": "${aws_ecr_repository.notification_batch_repository.repository_url}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.notification_batch_log_group.name}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "/"
      }
    },
    "essential": true
  }
]
EOF
}

# scueduled task
resource "aws_cloudwatch_event_rule" "notification_batch_event_rule" {
  name                = "notification-batch-event-rule"
  schedule_expression = "cron(0 23 * * ? *)" # JST 08:00
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "notification_batch_event_target" {
  rule     = aws_cloudwatch_event_rule.notification_batch_event_rule.name
  arn      = aws_ecs_cluster.notification_batch_cluster.arn
  role_arn = aws_iam_role.notification_batch_role.arn

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.notification_batch_task_definition.arn
    task_count          = 1
    launch_type         = "FARGATE"

    network_configuration {
      subnets          = [local.public_subnet_a_id]
      assign_public_ip = true
    }
  }
}
