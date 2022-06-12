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

# Fargate


