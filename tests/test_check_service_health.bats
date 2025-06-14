#!/usr/bin/env bats

@test "check_service_health.sh help output" {
  run ../monitoring/check_service_health.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"check_service_health.sh"* ]]
}
