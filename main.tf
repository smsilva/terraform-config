locals {
  environments = toset([
    "sandbox",
    "stage",
    "prod"
  ])
}

module "template" {
  source = "./modules/template"

  for_each            = local.environments
  environment         = each.key
  templates_directory = "templates"
  destination         = "environments"
}
