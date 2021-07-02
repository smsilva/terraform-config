environment = {
  name    = "sandbox"
  version = "2.0.0"
  region  = "us-east-2"
}

instances = {
  count = 1
  type  = "t2.nano"
}

cidr = "10.240.0.0/16"

private_subnet_cidr_blocks = [
  "10.240.1.0/18",
  "10.240.2.0/18",
  "10.240.3.0/18",
]

public_subnet_cidr_blocks = [
  "10.240.101.0/18",
  "10.240.102.0/18",
  "10.240.103.0/18",
]
