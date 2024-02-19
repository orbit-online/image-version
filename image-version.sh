#!/usr/bin/env bash

main() {
  set -eo pipefail; shopt -s inherit_errexit

  local ref=${1:?'Usage: image-version REF'}
  if [[ $ref =~ ^refs/tags/v?[0-9]+ ]]; then
    local tag=${ref#'refs/tags/'}
    printf "%s\n" "${tag#v}"
  elif [[ $ref = refs/tags/?* ]]; then
    local tag=${ref#'refs/tags/'}
    printf "%s\n" "$tag"
  elif [[ $ref = refs/heads/?* ]]; then
    local branch=${ref#'refs/heads/'}
    [[ $branch != "main" ]] || branch=latest
    [[ $branch != "master" ]] || branch=latest
    printf "%s\n" "$branch"
  elif [[ $ref =~ ^[0-9a-f]{40}$ ]]; then
    printf "%s\n" "${ref:0:8}"
  else
    printf "image-version.sh: REF must start with refs/tags/, refs/heads/, or be a shasum. Got '%s'.\n" "$ref" >&2
    return 1
  fi
}

main "$@"
