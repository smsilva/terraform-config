#!/bin/bash
mkdir -p ${TEMP_INFRA_STACK_SOURCE_CODE?}

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
