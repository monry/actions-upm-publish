#!/bin/bash

set -e

cat << EOS | sed -i '1r /dev/stdin' Assets/CHANGELOG.md

## [${INPUT_RELEASE_VERSION##v}] - $(date "+%Y-%m-%d")

${INPUT_RELEASE_SUMMARY}

$(echo "${INPUT_RELEASE_BODY}" | sed 's/^#/\#\#/')
EOS
cat Assets/package.json | jq -Mr '. | .version = "'"${INPUT_RELEASE_VERSION##v}"'"' | tee Assets/package.json > /dev/null

echo "DEBUG"
cat Assets/package.json
echo "DEBUG"

echo $(cat .npmrc | grep '^registry=' | sed 's/^registry=https://')'/:_authToken="'${INPUT_NPM_AUTH_TOKEN}'"' >> ~/.npmrc
npm publish Assets

git config --global user.email "github-actions@example.com"
git config --global user.name "GitHub Actions"
git checkout -b "temporary-$(date '+%Y%m%d%H%M%S')"
git add .
git commit -m ":up: Bump up version: ${INPUT_RELEASE_VERSION}" && git push "https://${INPUT_GITHUB_ACTOR}}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_GITHUB_REPOSITORY}.git" HEAD:${INPUT_RELEASE_BRANCH} || true
git tag -d ${INPUT_RELEASE_VERSION}
git tag ${INPUT_RELEASE_VERSION}
git push --tags --force
