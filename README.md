# image-version

GitHub action to determine the container image version based on a git ref
(defaults to `${{ github.ref }}`).

## Behavior

| git ref                                                        | image version |
| -------------------------------------------------------------- | ------------- |
| `refs/heads/main`                                              | `latest`      |
| `refs/heads/master`                                            | `latest`      |
| `refs/heads/ft-refactor`                                       | `ft-refactor` |
| `refs/tags/v1.0.3`                                             | `1.0.3`       |
| `refs/tags/1.0.3`                                              | `1.0.3`       |
| `e02d09699ffb56440f34cb7448a0bc436e3ae212 (i.e. non-symbolic)` | `e02d096`     |

## Usage:

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
    - id: version
      uses: orbit-online/image-version@v0.9.0
    - uses: actions/checkout@v3
    - uses: docker/setup-buildx-action@v2
    - uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_HUB_USERNAME }}
        password: ${{ secrets.DOCKER_HUB_TOKEN_RW }}
    - name: Build & push
      uses: docker/build-push-action@v4
      with:
        file: Dockerfile
        tags: orbit-online/image-version:${{ steps.version.outputs.version }}
        push: true
```
