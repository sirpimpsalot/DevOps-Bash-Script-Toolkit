# DevOps Bash Script Toolkit

A modular, POSIX-compliant toolkit of Bash scripts for infrastructure, CI/CD, Kubernetes, containers, monitoring, security, backups, and utilities. Designed for cross-platform use (Ubuntu, macOS, CentOS, Alpine) with robust testing and documentation.

## Folder Structure

- `infrastructure/` – Infrastructure automation scripts
- `ci-cd/` – CI/CD and version control scripts
- `kubernetes/` – Kubernetes management scripts
- `containers/` – Docker and container scripts
- `monitoring/` – System and service monitoring scripts
- `security/` – Security automation scripts
- `backups/` – Backup and data protection scripts
- `utilities/` – General system utility scripts
- `tests/` – Bats-core tests for all scripts
- `docs/` – Documentation and templates

## Getting Started

1. Clone the repository
2. Review the folder structure
3. Run ShellCheck and Bats tests (see workflows)

## Usage Examples

### Terraform Apply Wrapper
```sh
./infrastructure/terraform_apply_wrapper.sh --dir my-tf-dir --auto-approve
```

### Kubernetes Cleanup
```sh
./kubernetes/k8s_cleanup.sh --namespace dev --age 12
```

### Docker Cleanup
```sh
./containers/docker_cleanup.sh --prune --volumes
```

### Monitor Resources
```sh
./monitoring/monitor_resources.sh --cpu 90 --mem 85 --disk 80
```

### Backup to S3
```sh
./backups/backup_to_s3.sh --source ./data --bucket my-bucket --key-prefix backups
```

## Contributing
See `CONTRIBUTING.md` for guidelines.

## Security
See `SECURITY.md` for reporting and best practices.

## Changelog
See `CHANGELOG.md` for release history.
