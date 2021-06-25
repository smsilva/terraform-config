#!/bin/bash
cd ${TEMP_INFRA_STACK_LIVE?}

echo "[GIT] Find for changes to commit into: ${TEMP_INFRA_STACK_LIVE?}"

GIT_DIFF_LINE_COUNT=$(git diff | wc -l)

echo ""

if [[ ${GIT_DIFF_LINE_COUNT} > 0 ]]; then
  echo "  Need to update Live Repo. (lines in diff output: ${GIT_DIFF_LINE_COUNT})"

  git add .

  git commit -m "Build"

  git pull --rebase

  git push
else
  echo "  Nothing to do."
fi

cd - > /dev/null

echo ""
echo "[END]"
