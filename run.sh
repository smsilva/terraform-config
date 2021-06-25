#!/bin/bash
set -e

TEMP_DIR="${HOME?}/temp/deploy"
TEMP_INFRA_STACK_SOURCE_CODE="${TEMP_DIR?}/infra-stack-source-code"
TEMP_INFRA_STACK_LIVE="${TEMP_DIR?}/infra-stack-live"

GIT_REPOSITORY_STACK="terraform-demo-stack"

mkdir -p ${TEMP_INFRA_STACK_SOURCE_CODE?}

release() {
  STACK_VERSION=$1
  
  REMOTE_FILE_NAME="v${STACK_VERSION?}.tar.gz"
  LOCAL_FILE_NAME="${TEMP_INFRA_STACK_SOURCE_CODE?}/${GIT_REPOSITORY_STACK?}-${REMOTE_FILE_NAME?}"

  STACK_DIRECTORY="${TEMP_INFRA_STACK_SOURCE_CODE?}/${GIT_REPOSITORY_STACK?}-${STACK_VERSION?}"

  if [ ! -e ${STACK_DIRECTORY?} ]; then
    REMOTE_FILE_URI="https://github.com/smsilva/${GIT_REPOSITORY_STACK}/archive/refs/tags/${REMOTE_FILE_NAME}"

    echo "Downloading stack version..."
    echo "${REMOTE_FILE_URI?}"

    wget \
      --quiet "${REMOTE_FILE_URI?}" \
      --output-document ${LOCAL_FILE_NAME?}

    echo ""
    echo "Extracting Source Code"
    echo "${TEMP_INFRA_STACK_SOURCE_CODE?}"
  
    tar xvf ${LOCAL_FILE_NAME?} --directory=${TEMP_INFRA_STACK_SOURCE_CODE?}
    
    [ -e ${LOCAL_FILE_NAME?} ] && rm ${LOCAL_FILE_NAME?}

    echo ""
  fi

  echo "[RELEASE] ${ENVIRONMENT?}-${STACK_VERSION?} [${TERRAFORM_CONFIGURATION_FILE?}]"
  echo ""

  ENVIRONMENT_LIVE_DIRECTORY=${TEMP_INFRA_STACK_LIVE?}/${ENVIRONMENT?}

  echo "  Removing old environment: ${ENVIRONMENT_LIVE_DIRECTORY?}"
  sudo rm -rf ${ENVIRONMENT_LIVE_DIRECTORY?}
  mkdir -p ${ENVIRONMENT_LIVE_DIRECTORY?}
  echo ""

  PROJECT_SOURCE_CODE_DIRECTORY="${TEMP_INFRA_STACK_SOURCE_CODE?}/${GIT_REPOSITORY_STACK?}-${STACK_VERSION?}"

  echo "  Copying the Stack Source Code ${PROJECT_SOURCE_CODE_DIRECTORY?}/ to ${ENVIRONMENT_LIVE_DIRECTORY?}"
  echo ""

  cp -R ${PROJECT_SOURCE_CODE_DIRECTORY?}/ ${ENVIRONMENT_LIVE_DIRECTORY?}

  echo "  Copying the ${TERRAFORM_CONFIGURATION_FILE?} configuration file to ${ENVIRONMENT_LIVE_DIRECTORY?}/${GIT_REPOSITORY_STACK?}-${STACK_VERSION?}"
  cp ${TERRAFORM_CONFIGURATION_FILE?} ${ENVIRONMENT_LIVE_DIRECTORY?}/${GIT_REPOSITORY_STACK?}-${STACK_VERSION?}

  echo ""
  echo ""
}

echo "[START]"
echo ""

if [ ! -e ${TEMP_INFRA_STACK_LIVE?} ]; then
  echo "  Clonning Stack Infra Live Git Repository into: [${TEMP_INFRA_STACK_LIVE?}]"
  echo ""

  git clone "git@github.com:smsilva/${GIT_REPOSITORY_STACK?}.git" "${TEMP_INFRA_STACK_LIVE?}"
  
  echo ""
else
  echo "  Stack Infra Live Git Repository is already into: ${TEMP_INFRA_STACK_LIVE?}"
fi

echo ""
echo ""

# Read Environments and create one Release for each one into Stack Live Repository
for ENVIRONMENT_DIRECTORY in $(find ./environments/ -type d | sed 1d); do
  ENVIRONMENT=$(basename ${ENVIRONMENT_DIRECTORY})

  TERRAFORM_CONFIGURATION_FILE="${ENVIRONMENT_DIRECTORY}/terraform.tfvars"

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
