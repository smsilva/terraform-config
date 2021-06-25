#!/bin/bash
ENVIRONMENT=$1
STACK_VERSION=$2

echo "${ENVIRONMENT?}: ${STACK_VERSION?}"

TERRAFORM_VARIABLES_FILE="${ENVIRONMENT?}/terraform.tfvars"

if [ ! -f ${TERRAFORM_VARIABLES_FILE} ]; then
  echo "File ${TERRAFORM_VARIABLES_FILE} doesn't exists"
  exit -1
fi
