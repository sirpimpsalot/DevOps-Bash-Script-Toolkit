#!/usr/bin/env bats

@test "k8s_cleanup.sh help output" {
  run ../kubernetes/k8s_cleanup.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"k8s_cleanup.sh"* ]]
}
