# action-get-version-bump
This GitHub Action determines which version (major.minor.patch) to bump
based on the hints in the body of a Pull Request, or in a user-provided string.

# Requirements

This action uses bash to analyze the commit message. It was tested and
runs successfully on ubuntu runners, without any prior setup required.

# Overview

By default, the action analyzes the body of a PR (`github.event.pull_request.body`).
It searches for one of the following `bump::<version>` instructions:
* `bump::major` will be recognized as a request to bump the major version
* `bump::minor` will be recognized as a request to bump the minor version
* `bump::patch` will be recognized as a request to bump the patch version

## Inputs

The action has the following inputs:

### text

An optional input. If provided, it will be used instead of the PR body.

## Outputs

The action has the following outputs:

### `bump`

If either of the above `bump::<version>` commands is found in the commit message, the output will be 'major', 'minor' or 'patch', respectively.
Otherwise, no `bump` output is set.

If more than one `bump::<version>` command is found, the higher order versions take precedence (i.e. if both `bump::major` and `bump::minor` are found,
the value of `bump` will be `major`).

# Example

The following example is a simple workflow that uses the action.
```
name: Version Bump
on:
  pull_request:
    branches: master
    type: [closed]

jobs:
  get-bump:
    if: github.event.pull_request.merged == true
    name: Get version bump
    runs-on: ubuntu-latest
    outputs:
      bump: ${{ steps.get-version-bump.outputs.bump }}
    steps:
      -
        name: Get version bump
        id: get-version-bump
        uses: husarion-ci/action-get-version-bump@v0.2.0

  bump-version:
    name: Bump version
    runs-on: ubuntu-latest
    needs: get-bump
    if: needs.get-bump.outputs.bump != 'none' && github.event.pull_request.merged == true
    steps:
      -
        name: Bump version
        run: echo "Bumping ${{ needs.get-bump.outputs.bump }} version"
```

In the example, this action is used in a separate `get-bump` job,
and the subsequent `bump-version` job is only run if the `get-bump`
detects a version bump command.

The `github.event.pull_request.merged == true` condition is used
to trigger the workflow only when a PR is merged.