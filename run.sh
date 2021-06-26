#!/bin/bash
set -e

TEMP_DIR="${HOME?}/temp"
TEMP_INFRA_STACK_SOURCE_CODE="${TEMP_DIR?}/source-code"
TEMP_INFRA_STACK_LIVE="${TEMP_DIR?}/live"

rm -rf "${TEMP_INFRA_STACK_LIVE?}"
rm -rf "${TEMP_INFRA_STACK_SOURCE_CODE?}"

GIT_REPOSITORY_STACK="terraform-demo-stack"
GIT_REPOSITORY_STACK_LIVE="terraform-demo-live"

. ./clone.sh ${GIT_REPOSITORY_STACK_LIVE?} ${TEMP_INFRA_STACK_LIVE?}

for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})

  TERRAFORM_CONFIGURATION_FILE="${ENVIRONMENT_DIRECTORY}/terraform.tfvars"

  STACK_VERSION=$(cat ${TERRAFORM_CONFIGURATION_FILE?} | hclq get "project.version" -r)

  . ./download.sh ${GIT_REPOSITORY_STACK?} ${STACK_VERSION?} ${TEMP_INFRA_STACK_SOURCE_CODE?}
  . ./release.sh ${ENVIRONMENT} ${STACK_VERSION?} ${TEMP_INFRA_STACK_LIVE?} ${TEMP_INFRA_STACK_SOURCE_CODE?} 
  . ./push.sh
done
