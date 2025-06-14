#!/usr/bin/env bats

@test "build_deploy.sh help output" {
  run ../ci-cd/build_deploy.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"build_deploy.sh"* ]]
}
