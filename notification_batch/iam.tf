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
resource "aws_iam_policy" "policy" {
  name        = "ojicaht-policy"
  description = "for ojichat"
  policy      = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
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
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

# IAM Role
resource "aws_iam_role" "role" {
  name               = "ojichat-role"
  description        = "role for ojichat"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

data "aws_iam_policy_document" "role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "schedule_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "event_role_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}
