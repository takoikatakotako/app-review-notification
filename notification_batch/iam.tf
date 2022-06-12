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

##############################################################
# CodeBuild 用のロールのポリシー
##############################################################
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
