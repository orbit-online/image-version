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
jobs:
  release:
    steps:
    - id: version
      uses: orbit-online/image-version@v0.9.0
    ...
    - name: Build & push
      uses: docker/build-push-action@v4
      with:
        file: docker/Dockerfile
        tags: orbit-online/image-version:${{ steps.version.outputs.version }}
        push: true
```
