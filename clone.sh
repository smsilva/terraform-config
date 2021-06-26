#!/bin/bash
mkdir -p ${TEMP_INFRA_STACK_SOURCE_CODE?}

echo "Clone"
echo ""

if [ ! -e ${TEMP_INFRA_STACK_LIVE?} ]; then
  GIT_REMOTE_REPOSITORY="git@github.com:smsilva/${GIT_REPOSITORY_STACK_LIVE?}.git"

  echo "  git clone"
  echo "    ${GIT_REMOTE_REPOSITORY?} into: ${TEMP_INFRA_STACK_LIVE?}"
  echo ""
  
  git clone "${GIT_REMOTE_REPOSITORY?}" "${TEMP_INFRA_STACK_LIVE?}" --quiet
else
  echo "  Stack Infra Live Git Repository is already into:"
  echo "    ${TEMP_INFRA_STACK_LIVE?}"
fi

echo ""
