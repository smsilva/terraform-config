locals {
  flavors = [
    "sandbox",
    "stage",
    "prod"
  ]
}

module "template" {
  source = "./modules/template"

  for_each            = toset(local.flavors)
  environment         = each.key
  templates_directory = "templates"
  destination         = ".flavors"
}
