# generate-changelog-action

GitHub Action for [lob/generate-changelog](https://github.com/lob/generate-changelog/). Intended to be used with [actions/create-release](https://github.com/actions/create-release).

**Note:** [Your repository must contain a `package.json` file.](https://github.com/lob/generate-changelog/issues/38#issuecomment-362726723)

Created during the GitHub Actions Hackathon 2020 and [selected as one of the winning projects!](https://docs.google.com/spreadsheets/d/1YL6mjJXGt3-75GejQCubsOvWwtYcGaqbJA7msnsh7Tg/edit#gid=0&range=A100:C100)

## Example workflow - create a release
Extends [actions/create-release: Example workflow - create a release](https://github.com/actions/create-release#example-workflow---create-a-release) to generate changelog from git commits and use it as the body for the GitHub release.

```yaml
on:
  push:
    # Sequence of patterns matched against refs/tags
    tags:
      - 'v*' # Push events to matching v*, i.e. v1.0, v20.15.10

name: Create Release

jobs:
  build:
    name: Create Release
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Changelog
        uses: scottbrenner/generate-changelog-action@master
        id: Changelog
      - name: Create Release
        id: create_release
        uses: actions/create-release@latest
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # This token is provided by Actions, you do not need to create your own token
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          body: |
            ${{ steps.Changelog.outputs.changelog }}
          draft: false
          prerelease: false
```

The above workflow will create a release that looks like:
![Release](release.png)

If your `package.json` isn't available in root, you can pass the directory of the `package.json`:

```yaml
      - name: Changelog
        uses: scottbrenner/generate-changelog-action@master
        id: Changelog
        with:
          package-dir: 'root/to/my/package.json'
```

If your use case does not need to generate changelog from latest and latest-1 tags, you can pass the custom flags. An example is when your release tag on git is generated after the changelog so you must use something like _git log v1..HEAD_ --oneline:

```yaml
      - name: Changelog
        uses: scottbrenner/generate-changelog-action@master
        id: Changelog
        with:
          package-dir: 'root/to/my/package.json'
          from-tag: v1.0
          to-tag: HEAD
```

For more information, see [actions/create-release: Usage](https://github.com/actions/create-release#usage) and [lob/generate-changelog: Usage](https://github.com/lob/generate-changelog#usage)


| Property                  | Default       | Description                                                                                                                   |
| ------------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| package-dir               | package.json  | The path for the package.json if it is not in root                                                                            |
| from-tag                  | "last tag"    | The tag to generate changelog from. If not set, fallbacks to git last tag -1. Ex.: v1.0                                       |
| to-tag                    | "current tag" | The tag to generate changelog up to. If not set, fallbacks to git last tag.   Ex.: v2.0                                       |
| type                      | Unset         | The type of changelog to generate: patch, minor, or major. If not set, fallbacks to unset.                                    |
| exclude                   | Unset         | Exclude selected commit types (comma separated). If not set, fallbacks to unset.                                              |
