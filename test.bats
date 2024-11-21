#!/usr/bin/env bats
# shellcheck disable=2030,2031

setup_file() {
  bats_require_minimum_version 1.5.0
}

@test 'refs/heads/main=latest' {
  run bin/image-version refs/heads/main
  [ "$output" = "latest" ]
}

@test 'refs/heads/master=latest' {
  run bin/image-version refs/heads/master
  [ "$output" = "latest" ]
}

@test 'refs/heads/ft-refactor=ft-refactor' {
  run bin/image-version refs/heads/ft-refactor
  [ "$output" = "ft-refactor" ]
}

@test 'refs/tags/v1.0.3=1.0.3' {
  run bin/image-version refs/tags/v1.0.3
  [ "$output" = "1.0.3" ]
}

@test 'refs/tags/1.0.3=1.0.3' {
  run bin/image-version refs/tags/1.0.3
  [ "$output" = "1.0.3" ]
}

@test 'refs/tags/very-pinned=very-pinned' {
  run bin/image-version refs/tags/very-pinned
  [ "$output" = "very-pinned" ]
}

@test 'refs/tags/very-pinned=v3ry-pinned' {
  run bin/image-version refs/tags/v3ry-pinned
  [ "$output" = "3ry-pinned" ]
}

@test 'refs/tags/v=v' {
  run bin/image-version refs/tags/v
  [ "$output" = "v" ]
}

@test 'refs/tags/f1.0.3=f1.0.3' {
  run bin/image-version refs/tags/f1.0.3
  [ "$output" = "f1.0.3" ]
}

@test 'e02d09699ffb56440f34cb7448a0bc436e3ae212=e02d0969' {
  run bin/image-version e02d09699ffb56440f34cb7448a0bc436e3ae212
  [ "$output" = "e02d0969" ]
}

@test 'e02d09699ffb56440f34cb7448=error' {
  run -1 bin/image-version e02d09699ffb56440f34cb7448
}

@test 'master=error' {
  run -1 bin/image-version master
}

@test 'v1.0.3=error' {
  run -1 bin/image-version v1.0.3
}

@test 'refs/heads=error' {
  run -1 bin/image-version refs/heads
}

@test 'refs/tags=error' {
  run -1 bin/image-version refs/tags
}

@test '-p mytool-v refs/heads/main=latest' {
  run bin/image-version -p mytool-v refs/heads/main
  [ "$output" = "latest" ]
}

@test '-p mytool-v refs/heads/mytool-vmain=mytool-vmain' {
  run bin/image-version -p mytool-v refs/heads/mytool-vmain
  [ "$output" = "mytool-vmain" ]
}

@test '-p mytool-v refs/tags/v1.0.3=v1.0.3' {
  run bin/image-version -p mytool-v refs/tags/v1.0.3
  [ "$output" = "v1.0.3" ]
}

@test '-p mytool-v refs/tags/mytool-v1.0.3=1.0.3' {
  run bin/image-version -p mytool-v refs/tags/mytool-v1.0.3
  [ "$output" = "1.0.3" ]
}

@test '-p mytool-v refs/tags/mytool-v1=1' {
  run bin/image-version -p mytool-v refs/tags/mytool-v1
  [ "$output" = "1" ]
}

@test '-p v refs/tags/mytool-v1.0.3=mytool-v1.0.3' {
  run bin/image-version -p v refs/tags/mytool-v1.0.3
  [ "$output" = "mytool-v1.0.3" ]
}

@test '-p mytool-v refs/tags/1.0.3=1.0.3' {
  run bin/image-version -p mytool-v refs/tags/1.0.3
  [ "$output" = "1.0.3" ]
}

@test '-p mytool-v refs/tags/mytool-very-pinned=mytool-very-pinned' {
  run bin/image-version -p mytool-v refs/tags/mytool-very-pinned
  [ "$output" = "mytool-very-pinned" ]
}

@test '-p mytool-v refs/tags/mytool-v3ry-pinned=3ry-pinned' {
  run bin/image-version -p mytool-v refs/tags/mytool-v3ry-pinned
  [ "$output" = "3ry-pinned" ]
}

@test '-p mytool-v refs/tags/mytool-v=mytool-v' {
  run bin/image-version -p mytool-v refs/tags/mytool-v
  [ "$output" = "mytool-v" ]
}
