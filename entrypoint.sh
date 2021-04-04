#!/bin/sh -l
# shellcheck disable=SC2039

# For Docker Image CI test job
if [ "$REPO" = "ScottBrenner/generate-changelog-action" ]; then
  git clone --quiet https://github.com/"$REPO"
  cd generate-changelog-action || exit
fi

if [ -z "$PACKAGE_DIR" ]; then
  echo "No path for the package.json passed. Fallbacking to root directory."
else
  echo "package-dir detected. Using it's value."
  cp $PACKAGE_DIR package.json
fi

if [ -z "$FROM_TAG" ]; then
  echo "No from-tag passed. Fallbacking to git previous tag."
  previous_tag=$(git tag --sort version:refname | tail -n 2 | head -n 1)
else
  echo "From-tag detected. Using it's value."
  previous_tag=$FROM_TAG
fi

if [ -z "$TO_TAG"   ]; then
  echo "No to-tag passed. Fallbacking to git previous tag."
  new_tag=$(git tag --sort version:refname | tail -n 1)
else
  echo "To-tag detected. Using it's value."
  new_tag=$TO_TAG
fi

changelog=$(generate-changelog -t "$previous_tag..$new_tag" --file -)

changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A'}"
changelog="${changelog//$'\r'/'%0D'}"

echo "$changelog"

echo "::set-output name=changelog::$changelog"
