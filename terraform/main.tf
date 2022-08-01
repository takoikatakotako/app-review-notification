provider "aws" {
  profile                  = local.aws_profile
  region                   = "ap-northeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

module "dynamodb" {
  source = "./dynamodb"
}

module "notification_batch" {
  source = "./notification_batch"
}

module "web_front" {
  source              = "./web_front"
  domain              = local.front_domain
  route53_zone_id     = local.route53_zone_id
  acm_certificate_arn = local.front_acm_certificate_arn
}

module "web_api" {
  source              = "./web_api"
  domain              = local.api_domain
  route53_zone_id     = local.route53_zone_id
  acm_certificate_arn = local.api_acm_certificate_arn
}
