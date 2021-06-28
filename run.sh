#!/bin/bash
set -e

terraform init

terraform apply -auto-approve

./scripts/run.sh \
  terraform-demo-stack \
  terraform-demo-live
