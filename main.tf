provider "aws" {
  profile    = "default"
  region     = "ap-northeast-1"
  access_key = local.access_key
  secret_key = local.secret_key
}
