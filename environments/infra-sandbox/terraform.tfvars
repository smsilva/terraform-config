stack = {
  version = "1.0.1"
}

resource_tags = {
  project     = "demo-project",
  environment = "infra-sandbox",
  owner       = "me@example.com"
}

ec2_instance_type = "t2.nano"

instance_count = 2
