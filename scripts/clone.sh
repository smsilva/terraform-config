#!/bin/bash
set -e

CLONE_GIT_ACCOUNT="smsilva"
CLONE_GIT_REPO_NAME=$1
CLONE_GIT_REPO_REMOTE="git@github.com:${CLONE_GIT_ACCOUNT?}/${CLONE_GIT_REPO_NAME?}.git"
CLONE_GIT_REPO_LOCAL=$2

echo "Clone"
echo ""

echo "  Parameters"
echo "    CLONE_GIT_ACCOUNT.....: ${CLONE_GIT_ACCOUNT}"
echo "    CLONE_GIT_REPO_NAME...: ${CLONE_GIT_REPO_NAME}"
echo "    CLONE_GIT_REPO_REMOTE.: ${CLONE_GIT_REPO_REMOTE}"
echo "    CLONE_GIT_REPO_LOCAL..: ${CLONE_GIT_REPO_LOCAL}"
echo ""

if [ ! -e ${CLONE_GIT_REPO_LOCAL?} ]; then
  echo "  git clone"
  echo "    ${CLONE_GIT_REPO_REMOTE?} into: ${CLONE_GIT_REPO_LOCAL?}"
  echo ""
  
  git clone "${CLONE_GIT_REPO_REMOTE?}" "${CLONE_GIT_REPO_LOCAL?}" --quiet
else
  echo "  Stack Infra Live Git Repository is already into:"
  echo "    ${CLONE_GIT_REPO_LOCAL?}"
fi

echo ""
