#!/bin/bash
echo "Release"
echo ""
echo "  Environment"
echo "    ${ENVIRONMENT?}"
echo ""
echo "  Source code version"
echo "    ${STACK_VERSION?}"
echo ""

cd ${TEMP_INFRA_STACK_LIVE?} > /dev/null

git checkout ${ENVIRONMENT?} --quiet

git pull --rebase > /dev/null

cd - > /dev/null

ENVIRONMENT_LIVE_DIRECTORY="${TEMP_INFRA_STACK_LIVE?}/src"

echo "  Deleting old files"
echo "    ${ENVIRONMENT_LIVE_DIRECTORY?}"
sudo rm -rf ${ENVIRONMENT_LIVE_DIRECTORY?}
echo ""

PROJECT_SOURCE_CODE_DIRECTORY="${TEMP_INFRA_STACK_SOURCE_CODE?}/${GIT_REPOSITORY_STACK?}-${STACK_VERSION?}"

echo "  Source code copy"
echo "     ${PROJECT_SOURCE_CODE_DIRECTORY?} to ${ENVIRONMENT_LIVE_DIRECTORY?}"
echo ""

cp -r ${PROJECT_SOURCE_CODE_DIRECTORY?} ${ENVIRONMENT_LIVE_DIRECTORY?}

echo "  Environment Configuration copy"
echo "    ${TERRAFORM_CONFIGURATION_FILE?} to ${ENVIRONMENT_LIVE_DIRECTORY?}/"

cp ${TERRAFORM_CONFIGURATION_FILE?} ${ENVIRONMENT_LIVE_DIRECTORY?}/

echo ""
echo ""
