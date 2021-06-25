#!/bin/bash
cd ${TEMP_INFRA_STACK_LIVE?}

echo "[GIT] Find for changes to commit into: ${TEMP_INFRA_STACK_LIVE?}"

git add .

if ! git diff-index --quiet HEAD --; then
  echo "  Need to update Live Repo. (lines in diff output: ${GIT_DIFF_LINE_COUNT})"

  touch ${GIT_REPOSITORY_STACK}_${STACK_VERSION?}_release_$(date +"%Y%m%d_%H%M%S").txt

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
