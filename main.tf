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
  source      = "./web_front"
  bucket_name = "sandbox-web-front-bucket"
}

module "web_api" {
  source = "./web_api"
}
