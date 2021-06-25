#!/bin/bash

for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})
  TERRAFORM_CONFIGURATION_FILE=${ENVIRONMENT_DIRECTORY}/terraform.tfvars

  echo "${ENVIRONMENT} (${TERRAFORM_CONFIGURATION_FILE})"

  STACK_VERSION=$(cat ${TERRAFORM_CONFIGURATION_FILE?} | hclq get "stack.version" -r)
  
  echo "stack: ${STACK_VERSION}"
  
  DOWNLOAD_FILE_NAME_REMOTE="v${STACK_VERSION?}.tar.gz"
  DOWNLOAD_FILE_NAME_LOCAL="terraform-${DOWNLOAD_FILE_NAME_REMOTE?}"

  if [ ! -f ${DOWNLOAD_FILE_NAME_LOCAL?} ]; then
    echo ""
    echo "Downloading stack version... (${DOWNLOAD_FILE_NAME_REMOTE} / ${DOWNLOAD_FILE_NAME_LOCAL?})"

    wget \
      --quiet "https://github.com/smsilva/terraform/archive/refs/tags/${DOWNLOAD_FILE_NAME_REMOTE} "\
      --output-document ${DOWNLOAD_FILE_NAME_LOCAL?}

    echo "Extracting Source Code"

    tar xvf ${DOWNLOAD_FILE_NAME_LOCAL?}

    echo ""
  fi
done

wget https://github.com/smsilva/terraform/archive/refs/tags/v1.0.0.tar.gz --output-document terraform-v1.0.0.tar.gz
