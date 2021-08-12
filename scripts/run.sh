#!/bin/bash
set -e

WORKDIR="${HOME?}/temp"
SOURCE_CODE_ORIGIN="${WORKDIR?}/origin"
SOURCE_CODE_TARGET="${WORKDIR?}/target"
rm -rf "${SOURCE_CODE_ORIGIN?}"
rm -rf "${SOURCE_CODE_TARGET?}"

PROJECT_STACK=$1
PROJECT_ARTIFACT=$2

${PWD}/scripts/clone.sh ${PROJECT_ARTIFACT?} ${SOURCE_CODE_TARGET?}

for FLAVOR_DIRECTORY in $(find ${PWD}/.flavors/ -maxdepth 1 -type d | sed 1d); do
  SOURCE_CODE_VERSION=$(cat ${FLAVOR_DIRECTORY}/terraform.tfvars | hclq get "environment.version" -r)
  BRANCH_NAME=$(basename ${FLAVOR_DIRECTORY})

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
    ${FLAVOR_DIRECTORY?}
  
  ${PWD}/scripts/push.sh \
    ${SOURCE_CODE_TARGET?} \
    ${SOURCE_CODE_VERSION?}
done
