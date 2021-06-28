data "template_file" "tfvars" {
  template = file("${var.templates_directory}/${var.environment}.tfvars.tpl")
}

resource "local_file" "file" {
  content         = data.template_file.tfvars.rendered
  filename        = "${var.destination}/${var.environment}/terraform.tfvars"
  file_permission = "0644"
}
