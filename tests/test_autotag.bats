#!/usr/bin/env bats

@test "autotag.sh help output" {
  run ../ci-cd/autotag.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"autotag.sh"* ]]
}
