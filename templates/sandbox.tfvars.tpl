environment = {
  name    = "sandbox"
  version = "2.0.3"
  region  = "us-east-1"
}

instances = {
  count = "2"
  type  = "t2.nano"
}

cidr = "10.240.0.0/16"

private_subnet_cidr_blocks = [
  "10.240.1.0/24",
  "10.240.2.0/24",
]

public_subnet_cidr_blocks = [
  "10.240.101.0/24",
  "10.240.102.0/24",
]
