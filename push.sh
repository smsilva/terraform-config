#!/bin/bash
cd ${TEMP_INFRA_STACK_LIVE?}

echo "Push"
echo ""

echo "  Looking for changes"
echo "    ${TEMP_INFRA_STACK_LIVE?}"
echo ""

git add .

if ! git diff-index --quiet HEAD --; then
  echo "  Need to update Live Repo. (lines in diff output: ${GIT_DIFF_LINE_COUNT})"

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
