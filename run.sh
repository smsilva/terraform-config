#!/bin/bash
set -e

TEMP_DIR="${HOME?}/temp/deploy"
TEMP_INFRA_STACK_SOURCE_CODE="${TEMP_DIR?}/infra-stack-source-code"
TEMP_INFRA_STACK_LIVE="${TEMP_DIR?}/infra-stack-live"

GIT_REPOSITORY_STACK="terraform-demo-stack"

. ./clone.sh

for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})

  TERRAFORM_CONFIGURATION_FILE="${ENVIRONMENT_DIRECTORY}/terraform.tfvars"

  STACK_VERSION=$(cat ${TERRAFORM_CONFIGURATION_FILE?} | hclq get "stack.version" -r)

  . ./download.sh ${GIT_REPOSITORY_STACK?} ${STACK_VERSION?}
  . ./release.sh
  . ./push.sh
done
