#!/bin/bash
set -e

PUSH_STACK_SOURCE_CODE_TARGET=$1

cd ${PUSH_STACK_SOURCE_CODE_TARGET?}

echo "Push"
echo ""

echo "  Looking for changes"
echo "    ${PUSH_STACK_SOURCE_CODE_TARGET?}"
echo ""

git add .

if ! git diff-index --quiet HEAD --; then
  echo "  Need to update Live Repo."
  echo ""

  git commit -m "Build"

  git pull --rebase

  git push
else
  echo "  Nothing to do."
fi

cd - > /dev/null

echo ""
echo ""

echo "Finished"
