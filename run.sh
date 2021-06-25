#!/bin/bash
set -e

TEMP_DIR="${HOME?}/temp/deploy"
TEMP_INFRA_STACK_SOURCE_CODE="${TEMP_DIR?}/infra-stack-source-code"
TEMP_INFRA_STACK_LIVE="${TEMP_DIR?}/infra-stack-live"

mkdir -p ${TEMP_INFRA_STACK_SOURCE_CODE?}

release() {
  download ${STACK_VERSION?}

  echo "[RELEASE] ${ENVIRONMENT?}-${STACK_VERSION?} [${TERRAFORM_CONFIGURATION_FILE?}]"
  echo ""

  ENVIRONMENT_LIVE_DIRECTORY=${TEMP_INFRA_STACK_LIVE?}/${ENVIRONMENT?}

  echo "  Removing old environment: ${ENVIRONMENT_LIVE_DIRECTORY?}"
  sudo rm -rf ${ENVIRONMENT_LIVE_DIRECTORY?}
  mkdir -p ${ENVIRONMENT_LIVE_DIRECTORY?}
  echo ""

  PROJECT_SOURCE_CODE_DIRECTORY="${TEMP_INFRA_STACK_SOURCE_CODE?}/terraform-${STACK_VERSION?}/variables"

  echo "  Copying the Stack Source Code ${PROJECT_SOURCE_CODE_DIRECTORY?}/ to ${ENVIRONMENT_LIVE_DIRECTORY?}"
  echo ""

  cp -R ${PROJECT_SOURCE_CODE_DIRECTORY?}/ ${ENVIRONMENT_LIVE_DIRECTORY?}

  echo "  Copying the ${TERRAFORM_CONFIGURATION_FILE?} configuration file to ${ENVIRONMENT_LIVE_DIRECTORY?}/variables"
  cp ${TERRAFORM_CONFIGURATION_FILE?} ${ENVIRONMENT_LIVE_DIRECTORY?}/variables

  echo ""
  echo ""
}

download() {
  STACK_VERSION=$1
  
  DOWNLOAD_FILE_NAME_REMOTE="v${STACK_VERSION?}.tar.gz"
  DOWNLOAD_FILE_NAME_LOCAL="${TEMP_INFRA_STACK_SOURCE_CODE?}/terraform-${DOWNLOAD_FILE_NAME_REMOTE?}"

  if [ ! -e ${TEMP_INFRA_STACK_SOURCE_CODE?}/terraform-${STACK_VERSION?} ]; then
    echo ""
    echo "Downloading stack version... (${DOWNLOAD_FILE_NAME_REMOTE} / ${DOWNLOAD_FILE_NAME_LOCAL?})"

    wget \
      --quiet "https://github.com/smsilva/terraform/archive/refs/tags/${DOWNLOAD_FILE_NAME_REMOTE}" \
      --output-document ${DOWNLOAD_FILE_NAME_LOCAL?}

    echo "Extracting Source Code"
  
    tar xvf ${DOWNLOAD_FILE_NAME_LOCAL?} --directory=${TEMP_INFRA_STACK_SOURCE_CODE?}
    
    [ -e ${DOWNLOAD_FILE_NAME_LOCAL?} ] && rm ${DOWNLOAD_FILE_NAME_LOCAL?}

    echo ""
  fi
}

echo "[START]"
echo ""

if [ ! -e ${TEMP_INFRA_STACK_LIVE?} ]; then
  echo "  Cloning Stack Infra Live Git Repository into: [${TEMP_INFRA_STACK_LIVE?}]"
  echo ""

  git clone "git@github.com:smsilva/terraform-live.git" "${TEMP_INFRA_STACK_LIVE?}"
  
  echo ""
else
  echo "  Stack Infra Live Git Repository already into: ${TEMP_INFRA_STACK_LIVE?}"
fi

echo ""
echo ""

for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})
  TERRAFORM_CONFIGURATION_FILE=${ENVIRONMENT_DIRECTORY}/terraform.tfvars

  STACK_VERSION=$(cat ${TERRAFORM_CONFIGURATION_FILE?} | hclq get "stack.version" -r)
  
  release ${STACK_VERSION?} ${ENVIRONMENT?} ${TERRAFORM_CONFIGURATION_FILE?}
done

cd ${TEMP_INFRA_STACK_LIVE?}

echo "[GIT] Find for changes to commit into: ${TEMP_INFRA_STACK_LIVE?}"

GIT_DIFF_LINE_COUNT=$(git diff | wc -l)

echo ""

if [[ ${GIT_DIFF_LINE_COUNT} > 0 ]]; then
  echo "  Need to update Live Repo. (lines in diff output: ${GIT_DIFF_LINE_COUNT})"

  git add .

  git commit -m "Build"

  git pull --rebase

  git push
else
  echo "  Nothing to do."
fi

cd - > /dev/null

echo ""
echo "[END]"
