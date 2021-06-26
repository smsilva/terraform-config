#!/bin/bash
set -e

WORKDIR="${HOME?}/temp"
SOURCE_CODE_ORIGIN="${WORKDIR?}/origin"
SOURCE_CODE_TARGET="${WORKDIR?}/target"
rm -rf "${SOURCE_CODE_ORIGIN?}"
rm -rf "${SOURCE_CODE_TARGET?}"

PROJECT_STACK=$1
PROJECT_LIVE=$2

${PWD}/scripts/clone.sh ${PROJECT_LIVE?} ${SOURCE_CODE_TARGET?}

for ENVIRONMENT_DIRECTORY in $(find ${PWD}/environments/ -maxdepth 1 -type d | sed 1d); do
  SOURCE_CODE_VERSION=$(cat ${ENVIRONMENT_DIRECTORY}/terraform.tfvars | hclq get "project.version" -r)
  BRANCH_NAME=$(basename ${ENVIRONMENT_DIRECTORY})

  ${PWD}/scripts/download.sh \
    ${PROJECT_STACK?} \
    ${SOURCE_CODE_VERSION?} \
    ${SOURCE_CODE_ORIGIN?}
  
  ${PWD}/scripts/release.sh \
    ${BRANCH_NAME} \
    ${SOURCE_CODE_VERSION?} \
    ${SOURCE_CODE_TARGET?} \
    ${SOURCE_CODE_ORIGIN?} \
    ${PROJECT_STACK?} \
    ${ENVIRONMENT_DIRECTORY?}
  
  ${PWD}/scripts/push.sh \
    ${SOURCE_CODE_TARGET?}
done
