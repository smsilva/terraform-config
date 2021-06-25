#!/bin/bash

download() {
  STACK_VERSION=$1

  TEMP_DIR="./temp/stack"
  mkdir -p ${TEMP_DIR?}
  
  DOWNLOAD_FILE_NAME_REMOTE="v${STACK_VERSION?}.tar.gz"
  DOWNLOAD_FILE_NAME_LOCAL="${TEMP_DIR?}/terraform-${DOWNLOAD_FILE_NAME_REMOTE?}"

  if [ ! -f ${DOWNLOAD_FILE_NAME_LOCAL?} ]; then
    echo ""
    echo "Downloading stack version... (${DOWNLOAD_FILE_NAME_REMOTE} / ${DOWNLOAD_FILE_NAME_LOCAL?})"

    wget \
      --quiet "https://github.com/smsilva/terraform/archive/refs/tags/${DOWNLOAD_FILE_NAME_REMOTE}" \
      --output-document ${DOWNLOAD_FILE_NAME_LOCAL?}

    echo "Extracting Source Code"
  
    file ${DOWNLOAD_FILE_NAME_LOCAL?}

    tar xvf ${DOWNLOAD_FILE_NAME_LOCAL?} --directory=${TEMP_DIR?}

    echo ""
  fi
}

for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})
  TERRAFORM_CONFIGURATION_FILE=${ENVIRONMENT_DIRECTORY}/terraform.tfvars

  echo "${ENVIRONMENT} (${TERRAFORM_CONFIGURATION_FILE})"

  STACK_VERSION=$(cat ${TERRAFORM_CONFIGURATION_FILE?} | hclq get "stack.version" -r)
  
  echo "stack: ${STACK_VERSION}"

  download ${STACK_VERSION}
done
