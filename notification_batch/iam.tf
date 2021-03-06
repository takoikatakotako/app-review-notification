##############################################################
# CodeBuild 用のロール
##############################################################
resource "aws_iam_role" "build_image_role" {
  name               = "build-image-role"
  assume_role_policy = data.aws_iam_policy_document.build_image_assume_role_policy_document.json
}

data "aws_iam_policy_document" "build_image_assume_role_policy_document" {
  statement {
    sid     = "CodebuildExecution"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "build_image_role_policy" {
  role   = aws_iam_role.build_image_role.name
  policy = data.aws_iam_policy_document.build_image_role_policy_document.json
}

data "aws_iam_policy_document" "build_image_role_policy_document" {
  statement {
    sid = "Logging"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    sid = "PushECR"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}



##############################################################
# Fargate 用のロールのポリシー
##############################################################
resource "aws_iam_role" "notification_batch_role" {
  name               = "notification-batch-role"
  description        = "notification batch role"
  assume_role_policy = data.aws_iam_policy_document.notification_batch_assume_role_policy_document.json
}

data "aws_iam_policy_document" "notification_batch_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "notification_batch_policy" {
  name        = "notification-batch-policy"
  description = "notification batch policy"
  policy      = data.aws_iam_policy_document.notification_batch_policy_document.json
}

data "aws_iam_policy_document" "notification_batch_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecs:RunTask",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "iam:PassRole",
      "log:*",
      "dynamodb:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "schedule_policy_attachment" {
  role       = aws_iam_role.notification_batch_role.name
  policy_arn = aws_iam_policy.notification_batch_policy.arn
}

resource "aws_iam_role_policy_attachment" "event_role_policy_attachment" {
  role       = aws_iam_role.notification_batch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}
