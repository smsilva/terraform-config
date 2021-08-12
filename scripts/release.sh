#!/bin/bash
RELEASE_FLAVOR=$1
RELEASE_STACK_SOURCE_CODE_VERSION=$2
RELEASE_ARTIFACT_FLAVOR_BRANCH=${RELEASE_FLAVOR?}
RELEASE_STACK_DIRECTORY_ARTIFACT=$3
RELEASE_STACK_DIRECTORY_SOURCE_CODE_ROOT=$4
RELEASE_STACK_PROJECT_NAME=$5
RELEASE_STACK_DIRECTORY_SOURCE_CODE="${RELEASE_STACK_DIRECTORY_SOURCE_CODE_ROOT?}/${RELEASE_STACK_PROJECT_NAME?}-${RELEASE_STACK_SOURCE_CODE_VERSION?}"
RELEASE_FLAVOR_DIRECTORY=$6

echo "Release"
echo ""
echo "  Parameters"
echo "    RELEASE_FLAVOR...........................: ${RELEASE_FLAVOR}"
echo "    RELEASE_STACK_SOURCE_CODE_VERSION........: ${RELEASE_STACK_SOURCE_CODE_VERSION}"
echo "    RELEASE_STACK_DIRECTORY_ARTIFACT.........: ${RELEASE_STACK_DIRECTORY_ARTIFACT}"
echo "    RELEASE_STACK_DIRECTORY_SOURCE_CODE_ROOT.: ${RELEASE_STACK_DIRECTORY_SOURCE_CODE_ROOT}"
echo "    RELEASE_STACK_DIRECTORY_SOURCE_CODE......: ${RELEASE_STACK_DIRECTORY_SOURCE_CODE}"
echo "    RELEASE_FLAVOR_DIRECTORY.................: ${RELEASE_FLAVOR_DIRECTORY}"
echo ""

cd ${RELEASE_STACK_DIRECTORY_ARTIFACT?} > /dev/null

git checkout ${RELEASE_ARTIFACT_FLAVOR_BRANCH?} --quiet 2> /dev/null

if [ $? == 0 ]; then
  git pull --rebase --quiet
  
  echo "  Deleting Artifact local old files"
  echo "    ${RELEASE_STACK_DIRECTORY_ARTIFACT?}/src"
  sudo rm -rf "${RELEASE_STACK_DIRECTORY_ARTIFACT?}/src"
  echo ""
  
  echo "  Stack Source Code copy"
  echo "    ${RELEASE_STACK_DIRECTORY_SOURCE_CODE?}/src to ${RELEASE_STACK_DIRECTORY_ARTIFACT?}/src"
  echo ""
  
  cp -r ${RELEASE_STACK_DIRECTORY_SOURCE_CODE?}/src ${RELEASE_STACK_DIRECTORY_ARTIFACT?}/src
  
  echo "  Flavor Configuration copy"
  echo "    ${RELEASE_FLAVOR_DIRECTORY?}/* to ${RELEASE_STACK_DIRECTORY_ARTIFACT?}/src/"
  
  cp -r ${RELEASE_FLAVOR_DIRECTORY?}/* ${RELEASE_STACK_DIRECTORY_ARTIFACT?}/src/
  
  echo ""

  cd - > /dev/null
else
  cd - > /dev/null
  
  echo "  ERROR"
  echo "    Remote branch not found: ${RELEASE_ARTIFACT_FLAVOR_BRANCH?}"  
  echo ""

  exit 1
fi

echo ""
