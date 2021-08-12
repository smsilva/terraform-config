#!/bin/bash
RELEASE_FLAVOR=$1
RELEASE_VERSION=$2
RELEASE_STACK_LIVE_BRANCH=${RELEASE_FLAVOR?}
RELEASE_STACK_DIRECTORY_LIVE=$3
RELEASE_STACK_DIRECTORY_SOURCE_CODE=$4
RELEASE_STACK_PROJECT_NAME=$5
RELEASE_PROJECT_SOURCE_CODE_DIRECTORY="${RELEASE_STACK_DIRECTORY_SOURCE_CODE?}/${RELEASE_STACK_PROJECT_NAME?}-${RELEASE_VERSION?}"
RELEASE_ENVIRONMENT_DIRECTORY=$6

echo "Release"
echo ""
echo "  Parameters"
echo "    RELEASE_FLAVOR........................: ${RELEASE_FLAVOR}"
echo "    RELEASE_VERSION.......................: ${RELEASE_VERSION}"
echo "    RELEASE_STACK_DIRECTORY_LIVE..........: ${RELEASE_STACK_DIRECTORY_LIVE}"
echo "    RELEASE_STACK_DIRECTORY_SOURCE_CODE...: ${RELEASE_STACK_DIRECTORY_SOURCE_CODE}"
echo "    RELEASE_PROJECT_SOURCE_CODE_DIRECTORY.: ${RELEASE_PROJECT_SOURCE_CODE_DIRECTORY}"
echo "    RELEASE_ENVIRONMENT_DIRECTORY.........: ${RELEASE_ENVIRONMENT_DIRECTORY}"
echo ""

cd ${RELEASE_STACK_DIRECTORY_LIVE?} > /dev/null

git checkout ${RELEASE_STACK_LIVE_BRANCH?} --quiet 2> /dev/null

if [ $? == 0 ]; then
  git pull --rebase --quiet
  
  echo "  Deleting old files"
  echo "    ${RELEASE_STACK_DIRECTORY_LIVE?}/src"
  sudo rm -rf "${RELEASE_STACK_DIRECTORY_LIVE?}/src"
  echo ""
  
  echo "  Source code copy"
  echo "     ${RELEASE_PROJECT_SOURCE_CODE_DIRECTORY?}/src to ${RELEASE_STACK_DIRECTORY_LIVE?}/src"
  echo ""
  
  cp -r ${RELEASE_PROJECT_SOURCE_CODE_DIRECTORY?}/src ${RELEASE_STACK_DIRECTORY_LIVE?}/src
  
  echo "  Environment Configuration copy"
  echo "    ${RELEASE_ENVIRONMENT_DIRECTORY?}/* to ${RELEASE_STACK_DIRECTORY_LIVE?}/src/"
  
  cp -r ${RELEASE_ENVIRONMENT_DIRECTORY?}/* ${RELEASE_STACK_DIRECTORY_LIVE?}/src/
  
  echo ""

  cd - > /dev/null
else
  cd - > /dev/null
  
  echo "  ERROR"
  echo "    Remote branch not found: ${RELEASE_STACK_LIVE_BRANCH?}"  
  echo ""

  exit 1
fi

echo ""
