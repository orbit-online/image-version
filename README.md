# image-version

CLI tool and GitHub action to determine the container image version based on a git ref.  
Take a look at [program-version](https://github.com/orbit-online/program-version) if
you need the `--version` variant that programs normally output.

## Behavior

| git ref                                                        | image version |
| -------------------------------------------------------------- | ------------- |
| `refs/heads/main`                                              | `latest`      |
| `refs/heads/master`                                            | `latest`      |
| `refs/heads/ft-refactor`                                       | `ft-refactor` |
| `refs/tags/v1.0.3`                                             | `1.0.3`       |
| `refs/tags/1.0.3`                                              | `1.0.3`       |
| `refs/tags/very-pinned` (only removes `v` prefix on `v[0-9]*`) | `very-pinned` |
| `refs/tags/f1.0.3` (treated just like branches)                | `f1.0.3`      |
| `refs/tags/v`                                                  | `v`           |
| `e02d09699ffb56440f34cb7448a0bc436e3ae212` (i.e. non-symbolic) | `e02d0969`    |
| `e02d09699ffb56440f34cb7448` (not 40 hex chars)                | error         |
| `master` (no `refs/heads/` prefix)                             | error         |
| `v1.0.3` (no `refs/tags/` prefix)                              | error         |
| `refs/heads/` (empty branch name)                              | error         |
| `refs/tags/` (empty tag name)                                  | error         |

## CLI

### Installation

With [μpkg](https://github.com/orbit-online/upkg)

```
upkg install -g orbit-online/image-version@<VERSION>
```

### Usage

```
image-version REF
```

When using μpkg you can retrieve the installed version of your package and
pass that straight to this tool (`git symbolic-ref` is used as a fallback
in order for it to work in your git repo while developing):

```
PKGROOT=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
version=$(image-version "$(jq -re '.version // empty' "$PKGROOT/upkg.json" 2>/dev/null || git -C "$PKGROOT" symbolic-ref HEAD)")
```

## GitHub action

### Parameters

- `ref`: The git ref to calculate the version from, defaults to
  `${{ github.ref }}`.

### Usage

```
name: Release

on:
  push:
    branches: [ '*' ]
    tags: [ 'v*' ]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
    - id: image_version
      uses: orbit-online/image-version@v0.9.0
    - uses: actions/checkout@v4
    - uses: docker/setup-buildx-action@v2
    - uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_HUB_USERNAME }}
        password: ${{ secrets.DOCKER_HUB_TOKEN_RW }}
    - name: Build & push
      uses: docker/build-push-action@v4
      with:
        file: Dockerfile
        tags: orbit-online/my-prog:${{ steps.image_version.outputs.version }}
        push: true
```
