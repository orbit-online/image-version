#!/usr/bin/env bash

main() {
  set -eo pipefail
  shopt -s inherit_errexit

  local ref=${1:?'Usage: image-version REF'}
  if [[ $ref = refs/tags/?[[:digit:]]* ]]; then
    local tag=${ref#'refs/tags/'}
    tag=${tag#'v'}
    printf "%s\n" "$tag"
  elif [[ $ref = refs/tags/?* ]]; then
    local tag=${ref#'refs/tags/'}
    printf "%s\n" "$tag"
  elif [[ $ref = refs/heads/?* ]]; then
    local branch=${ref#'refs/heads/'}
    [[ $branch != "main" ]] || branch=latest
    [[ $branch != "master" ]] || branch=latest
    printf "%s\n" "$branch"
  elif [[ $ref =~ ^[0-9a-f]{40}$ ]]; then
    ref="$(git rev-parse --short "$ref")"
    printf "%s\n" "$ref"
  else
    printf "image-version.sh: REF must start with refs/tags/, refs/heads/, or be a shasum. Got '%s'.\n" "$ref" >&2
    return 1
  fi
}

main "$@"
