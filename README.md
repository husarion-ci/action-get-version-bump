# action-get-version-bump
This GitHub Action determines which version (major.minor.patch) to bump based on the hints in the head commit message.

# Requirements

This action uses bash to analyze the commit message. It was tested and
runs successfully on ubuntu runners

# Overview

The action analyzes the head commit message (`github.event.commits[0].message`). The user can include a `bump::` snippet in their commit message to instruct the action:
* `bump::major` will be recognized as a request to bump the major version
* `bump::minor` will be recognized as a request to bump the minor version
* `bump::patch` will be recognized as a request to bump the patch version

## Inputs

Currently this action has no inputs

## Outputs

The action has the following outputs:

* `bump` (string): If either of the above `bump::` commands is found in the commit message, the output will be 'major', 'minor' or 'patch', respectively. Otherwise, it will be equal to 'none'.

# Example

The following example is a simple workflow that uses the action.
```
name: Version Bump
on:
  push:
    branch: master

jobs:

  get-bump:
    name: Get version bump
    runs-on: ubuntu-latest
    outputs:
      bump: ${{ steps.get-version-bump.outputs.bump }}
    steps:
      -
        name: Get version bump
        id: get-version-bump
        uses: husarion-ci/action-get-version-bump@v0.1.0

  bump-version:
    name: Bump version
    runs-on: ubuntu-latest
    needs: get-bump
    if: ${{ needs.get-bump.outputs.bump != 'none' }}
    steps:
      -
        name: Bump version
        run: echo "Bumping ${{ needs.get-bump.outputs.bump }} version"
```

In the example, this action is used in a separate `get-bump` job,
and the subsequent `bump-version` job is only run if the `get-bump`
detects a version bump command.