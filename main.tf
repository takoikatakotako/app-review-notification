provider "aws" {
  profile    = "default"
  region     = "ap-northeast-1"
  access_key = local.access_key
  secret_key = local.secret_key
}

module "dynamodb" {
  source = "./dynamodb"
}

module "notification_batch" {
  source = "./notification_batch"
}

module "web_front" {
  source              = "./web_front"
  domain              = local.domain
  route53_zone_id     = local.route53_zone_id
  acm_certificate_arn = local.acm_certificate_arn
}

module "web_api" {
  source = "./web_api"
}
