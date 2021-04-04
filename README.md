# generate-changelog-action

GitHub Action for [lob/generate-changelog](https://github.com/lob/generate-changelog/). Intended to be used with [actions/create-release](https://github.com/actions/create-release).

Created during the GitHub Actions Hackathon 2020 and [selected as one of the winning projects!](https://docs.google.com/spreadsheets/d/1YL6mjJXGt3-75GejQCubsOvWwtYcGaqbJA7msnsh7Tg/edit#gid=0&range=A100:C100)

## Usage

**Note:** [Your repository must contain a `package.json` file](https://github.com/lob/generate-changelog/issues/38#issuecomment-362726723), although an empty file such as [the one in this repository](https://github.com/ScottBrenner/generate-changelog-action/blob/master/package.json) is fine.

If your `package.json` isn't available in root directory of your repository, you can pass the path of the `package.json` file by setting `package-dir` as follows:

```yaml
- name: Changelog
  uses: scottbrenner/generate-changelog-action@master
  id: Changelog
  with:
    package-dir: 'root/to/my/package.json'
```

By default, this Action generates changelogs using commits between the previous tag and the most recent tag. Generate changelogs from specific tag or range (e.g. `v1.2.3` or `v1.2.3..v1.2.4`) by passing the `from-tag` and `to-tag` inputs. An example is when your release tag on git is generated after the changelog so you must use something like `git log v1..HEAD --oneline`:

```yaml
- name: Changelog
  uses: scottbrenner/generate-changelog-action@master
  id: Changelog
  with:
    from-tag: v1.0
    to-tag: HEAD
```

This Action additionally supports the following inputs, in accordance with [lob/generate-changelog's CLI options](https://github.com/lob/generate-changelog/#cli).
| Property                  | Default       | Description                                                                                                                   |
| ------------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `package-dir`             | `package.json`| The path for the package.json if it is not in root                                                                            |
| `from-tag`                | "last tag"    | The tag to generate changelog from. If not set, fallbacks to git last tag -1. Ex.: v1.0                                       |
| `to-tag`                  | "current tag" | The tag to generate changelog up to. If not set, fallbacks to git last tag.   Ex.: v2.0                                       |
| `type`                    | Unset         | The type of changelog to generate: patch, minor, or major. If not set, fallbacks to unset.                                    |
| `exclude`                 | Unset         | Exclude selected commit types (comma separated). If not set, fallbacks to unset.                                              |
| `allow-unknown`           | Unset         | Allow unknown commit types. If not set, fallbacks to unset.

For more information, see [actions/create-release: Usage](https://github.com/actions/create-release#usage), [lob/generate-changelog: Usage](https://github.com/lob/generate-changelog#usage), and [jobs.<job_id>.steps[*].with](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepswith).


## Example workflow - create a release
See [this repository's release.yml](https://github.com/ScottBrenner/generate-changelog-action/blob/master/.github/workflows/release.yml) for an example workflow which extends [actions/create-release: Example workflow - create a release](https://github.com/actions/create-release#example-workflow---create-a-release) to generate a changelog from git commits and use it as the body for the GitHub release.

This workflow automatically creates [this repository's releases](https://github.com/ScottBrenner/generate-changelog-action/releases).
