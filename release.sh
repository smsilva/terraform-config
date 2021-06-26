#!/bin/bash
RELEASE_ENVIRONMENT=$1
RELEASE_VERSION=$2
RELEASE_STACK_LIVE_BRANCH=${RELEASE_ENVIRONMENT?}
RELEASE_STACK_DIRECTORY_LIVE=$3
RELEASE_STACK_DIRECTORY_SOURCE_CODE=$4

echo "Release"
echo ""
echo "  Environment (branch)"
echo "    ${RELEASE_ENVIRONMENT?}"
echo ""
echo "  Source code version"
echo "    ${RELEASE_VERSION?}"
echo ""

echo "    RELEASE_ENVIRONMENT.................: ${RELEASE_ENVIRONMENT}"
echo "    RELEASE_VERSION.....................: ${RELEASE_VERSION}"
echo "    RELEASE_STACK_DIRECTORY_LIVE........: ${RELEASE_STACK_DIRECTORY_LIVE}"
echo "    RELEASE_STACK_DIRECTORY_SOURCE_CODE.: ${RELEASE_STACK_DIRECTORY_SOURCE_CODE}"

echo ""

cd ${RELEASE_STACK_DIRECTORY_LIVE?} > /dev/null

git checkout ${RELEASE_STACK_LIVE_BRANCH?} --quiet

git pull --rebase --quiet

cd - > /dev/null

ENVIRONMENT_LIVE_DIRECTORY="${RELEASE_STACK_DIRECTORY_LIVE?}"

echo "  Deleting old files"
echo "    ${ENVIRONMENT_LIVE_DIRECTORY?}/src/*"
sudo rm -rf "${ENVIRONMENT_LIVE_DIRECTORY?}/src/*"
echo ""

PROJECT_SOURCE_CODE_DIRECTORY="${RELEASE_STACK_DIRECTORY_SOURCE_CODE?}/${GIT_REPOSITORY_STACK?}-${RELEASE_VERSION?}"

echo "  Source code copy"
echo "     ${PROJECT_SOURCE_CODE_DIRECTORY?}/src/* to ${RELEASE_STACK_DIRECTORY_LIVE?}/src/"
echo ""

cp -r "${PROJECT_SOURCE_CODE_DIRECTORY?}/src/*" ${RELEASE_STACK_DIRECTORY_LIVE?}/src/

echo "  Environment Configuration copy"
echo "    ${TERRAFORM_CONFIGURATION_FILE?} to ${ENVIRONMENT_LIVE_DIRECTORY?}/src/"

cp "${TERRAFORM_CONFIGURATION_FILE?}" "${ENVIRONMENT_LIVE_DIRECTORY?}/src/"

echo ""
echo ""
