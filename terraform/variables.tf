locals {
  config = {
    development = {
      aws_profile         = "sandbox"
      route53_zone_id     = "Z06272247TSQ89OL8QZN"
      domain              = "sandbox.swiswiswift.com"
      acm_certificate_arn = "arn:aws:acm:us-east-1:397693451628:certificate/cb4062b6-32b4-48c4-9d46-58c7a906846e"
    }

    production = {
      aws_profile         = "review"
      route53_zone_id     = "Z04405773OSCRT4AMPBDO"
      domain              = "review.swiswiswift.com"
      acm_certificate_arn = "arn:aws:acm:us-east-1:772281501799:certificate/041caa0c-a884-4ef9-a746-2a1db6b8a28c"
    }
  }

  aws_profile         = local.config[terraform.workspace].aws_profile
  route53_zone_id     = local.config[terraform.workspace].route53_zone_id
  domain              = local.config[terraform.workspace].domain
  acm_certificate_arn = local.config[terraform.workspace].acm_certificate_arn
}