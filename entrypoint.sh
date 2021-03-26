#!/bin/sh -l
# shellcheck disable=SC2039

if [ "$1" ] && [ "$1" != "package.json" ]; then
  cp "$1" package.json
fi

[ -z "$FROM_TAG" ] && { echo "No from-tag passed. Fallbacking to git previous tag."; previous_tag=$(git tag --sort version:refname | tail -n 2 | head -n 1); } || { echo "From-tag detected. Using it's value."; previous_tag=$FROM_TAG; }
[ -z "$TO_TAG"   ] && { echo "No to-tag passed. Fallbacking to git previous tag."  ;      new_tag=$(git tag --sort version:refname | tail -n 1);             } || { echo "To-tag detected. Using it's value.";        new_tag=$FROM_TAG; }
changelog=$(generate-changelog -t "$previous_tag..$new_tag" --file -)

changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A'}"
changelog="${changelog//$'\r'/'%0D'}"

echo "$changelog"

echo "::set-output name=changelog::$changelog"
