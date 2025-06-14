#!/usr/bin/env bats

@test "env_to_k8s_secrets.sh help output" {
  run ../security/env_to_k8s_secrets.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"env_to_k8s_secrets.sh"* ]]
}
