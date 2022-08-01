locals {
  config = {
    development = {
      aws_profile               = "sandbox"
      route53_zone_id           = "Z06272247TSQ89OL8QZN"
      front_domain              = "sandbox.swiswiswift.com"
      front_acm_certificate_arn = "arn:aws:acm:us-east-1:397693451628:certificate/cb4062b6-32b4-48c4-9d46-58c7a906846e"
      api_domain                = "api.sandbox.swiswiswift.com"
      api_acm_certificate_arn   = "arn:aws:acm:ap-northeast-1:397693451628:certificate/55e559af-bf12-427f-8740-5958afbc7788"
    }

    production = {
      aws_profile             = "review"
      route53_zone_id         = "Z04405773OSCRT4AMPBDO"
      front_domain            = "review.swiswiswift.com"
      front_certificate_arn   = "arn:aws:acm:us-east-1:772281501799:certificate/041caa0c-a884-4ef9-a746-2a1db6b8a28c"
      api_domain              = "api.sandbox.swiswiswift.com"
      api_acm_certificate_arn = "arn:aws:acm:us-east-1:397693451628:certificate/cb4062b6-32b4-48c4-9d46-58c7a906846e"
    }
  }

  aws_profile               = local.config[terraform.workspace].aws_profile
  route53_zone_id           = local.config[terraform.workspace].route53_zone_id
  front_domain              = local.config[terraform.workspace].front_domain
  front_acm_certificate_arn = local.config[terraform.workspace].front_acm_certificate_arn
  api_domain                = local.config[terraform.workspace].api_domain
  api_acm_certificate_arn   = local.config[terraform.workspace].api_acm_certificate_arn
}