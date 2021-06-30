locals {
  environments = [
    "sandbox",
    "stage",
    "prod"
  ]
}

module "template" {
  source = "./modules/template"

  for_each            = toset(local.environments)
  environment         = each.key
  templates_directory = "templates"
  destination         = ".environments"
}
