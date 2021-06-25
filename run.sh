#!/bin/bash
TEMP_DIR="./temp"
TEMP_INFRA_STACK_SOURCE_CODE="${TEMP_DIR?}/infra-stack-source-code"
TEMP_INFRA_STACK_LIVE="${TEMP_DIR?}/infra-stack-live"

mkdir -p ${TEMP_INFRA_STACK_SOURCE_CODE?}
mkdir -p ${TEMP_INFRA_STACK_LIVE?}

release() {
  download ${STACK_VERSION?}

  echo "release: ${STACK_VERSION?} ${ENVIRONMENT?} ${TERRAFORM_CONFIGURATION_FILE?}"
}

download() {
  STACK_VERSION=$1
  
  DOWNLOAD_FILE_NAME_REMOTE="v${STACK_VERSION?}.tar.gz"
  DOWNLOAD_FILE_NAME_LOCAL="${TEMP_INFRA_STACK_SOURCE_CODE?}/terraform-${DOWNLOAD_FILE_NAME_REMOTE?}"

  if [ ! -f ${DOWNLOAD_FILE_NAME_LOCAL?} ]; then
    echo ""
    echo "Downloading stack version... (${DOWNLOAD_FILE_NAME_REMOTE} / ${DOWNLOAD_FILE_NAME_LOCAL?})"

    wget \
      --quiet "https://github.com/smsilva/terraform/archive/refs/tags/${DOWNLOAD_FILE_NAME_REMOTE}" \
      --output-document ${DOWNLOAD_FILE_NAME_LOCAL?}

    echo "Extracting Source Code"
  
    file ${DOWNLOAD_FILE_NAME_LOCAL?}

    tar xvf ${DOWNLOAD_FILE_NAME_LOCAL?} --directory=${TEMP_INFRA_STACK_SOURCE_CODE?}

    echo ""
  fi
}

echo "Cloning Stack Infra Live Git Repository"

git clone git@github.com:smsilva/terraform-live.git ${TEMP_INFRA_STACK_LIVE?}

echo ""

for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})
  TERRAFORM_CONFIGURATION_FILE=${ENVIRONMENT_DIRECTORY}/terraform.tfvars

  echo "${ENVIRONMENT} (${TERRAFORM_CONFIGURATION_FILE})"

  STACK_VERSION=$(cat ${TERRAFORM_CONFIGURATION_FILE?} | hclq get "stack.version" -r)
  
  echo "stack: ${STACK_VERSION}"

  release ${STACK_VERSION?} ${ENVIRONMENT?} ${TERRAFORM_CONFIGURATION_FILE?}
done
