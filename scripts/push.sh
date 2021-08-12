#!/bin/bash
set -e

PUSH_STACK_SOURCE_CODE_TARGET=$1
PUSH_SOURCE_CODE_VERSION=$2

cd ${PUSH_STACK_SOURCE_CODE_TARGET?}

echo "Push"
echo ""

echo "  Looking for changes"
echo "    ${PUSH_STACK_SOURCE_CODE_TARGET?}"
echo ""

git add .

if ! git diff-index --quiet HEAD --; then
  echo "  Need to update Artifact Repo."
  echo ""

  git commit -m "build-${PUSH_SOURCE_CODE_VERSION?}"

  git pull --rebase

  git push
else
  echo "  Nothing to do."
fi

cd - > /dev/null

echo ""
echo ""

echo "Finished"
