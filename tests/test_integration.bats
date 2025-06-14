#!/usr/bin/env bats

@test "integration: terraform, k8s, docker, monitor, backup" {
  run ./infrastructure/terraform_apply_wrapper.sh --help
  [ "$status" -eq 0 ]
  run ./kubernetes/k8s_cleanup.sh --help
  [ "$status" -eq 0 ]
  run ./containers/docker_cleanup.sh --help
  [ "$status" -eq 0 ]
  run ./monitoring/monitor_resources.sh --help
  [ "$status" -eq 0 ]
  run ./backups/backup_to_s3.sh --help
  [ "$status" -eq 0 ]
}
