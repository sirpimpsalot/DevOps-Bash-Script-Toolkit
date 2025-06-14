#!/usr/bin/env bats

@test "backup_to_s3.sh help output" {
  run ../backups/backup_to_s3.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"backup_to_s3.sh"* ]]
}
