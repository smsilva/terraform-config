#!/bin/bash
set -e

PROJECT_SOURCE_CODE_NAME="terraform-demo-stack"
PROJECT_LIVE_CODE_NAME="terraform-demo-live"

TEMPORARY_DIRECTORY="${HOME?}/temp"

STACK_SOURCE_CODE_ORIGIN="${TEMPORARY_DIRECTORY?}/origin"
STACK_SOURCE_CODE_TARGET="${TEMPORARY_DIRECTORY?}/target"

rm -rf "${STACK_SOURCE_CODE_ORIGIN?}"
rm -rf "${STACK_SOURCE_CODE_TARGET?}"

. ./clone.sh ${PROJECT_LIVE_CODE_NAME?} ${STACK_SOURCE_CODE_TARGET?}

for ENVIRONMENT_DIRECTORY in $(find ${PWD}/environments/ -type d | sed 1d); do
  SOURCE_CODE_VERSION=$(cat ${ENVIRONMENT_DIRECTORY}/terraform.tfvars | hclq get "project.version" -r)
  BRANCH_NAME=$(basename ${ENVIRONMENT_DIRECTORY})

  . ./download.sh \
    ${PROJECT_SOURCE_CODE_NAME?} \
    ${SOURCE_CODE_VERSION?} \
    ${STACK_SOURCE_CODE_ORIGIN?}
  
  . ./release.sh \
    ${BRANCH_NAME} \
    ${SOURCE_CODE_VERSION?} \
    ${STACK_SOURCE_CODE_TARGET?} \
    ${STACK_SOURCE_CODE_ORIGIN?} \
    ${PROJECT_SOURCE_CODE_NAME?} \
    ${ENVIRONMENT_DIRECTORY?}
  
  . ./push.sh \
    ${STACK_SOURCE_CODE_TARGET?}
done
