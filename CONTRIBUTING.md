# Contributing to DevOps Bash Script Toolkit

Thank you for your interest in contributing! Please follow these guidelines:

## Getting Started
- Fork the repository and clone it locally.
- Create a new branch for your feature or bugfix.

## Code Style
- All scripts must be POSIX-compliant Bash.
- Run ShellCheck locally before submitting a PR.
- Add in-script documentation and usage examples.

## Testing
- Add or update Bats-core tests for your scripts in the `tests/` directory.
- Ensure all tests pass on Ubuntu and macOS (CI will verify).

## Pull Requests
- Use the PR template provided.
- Fill out all sections, including script category and OS tested.
- Reference related issues if applicable.

## Security
- Do not include hardcoded secrets or credentials.
- Report security issues via the process in `SECURITY.md` (to be added).

Thank you for helping improve the toolkit!
