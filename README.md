<div align="left">
  <h1><code>matrix</code></h1>
</div>

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)][License-Apache]
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)][License-MIT]

A cross-platform <a href="https://github.com/features/actions">GitHub Actions</a> bisection harness.

## Usage

Run the generator script to scaffold a new target:

```sh
# Prompts: Name, Issue, GIT URL, GIT REF
./scripts/generate
```

This creates a directory in `targets/<name>/<issue>/` containing:

    ├── config      # Defines the upstream REPO and REF (tag/commit)
    ├── main        # Primary entrypoint script
    └── patches/    # Directory for `.patch` files - automatically applied after checkout

## Platforms

Matrix abstracts platform-specific logic to isolate and reproduce cross-platform bugs across multiple runners and architectures by scaffolding environments and applying standardized patches.

The following <a href="https://docs.github.com/en/actions/reference/runners/github-hosted-runners">platforms and runners</a> are supported:

| OS | Architecture | Identifier | Runner Label |
| :--- | :--- | :--- | :--- |
| Linux | x86_64 | `x86_64-linux` | `ubuntu-latest` |
| Linux | ARM64 | `aarch64-linux` | `ubuntu-24.04-arm` |
| macOS | x86_64 | `x86_64-darwin` | `macos-15-intel` |
| macOS | ARM64 | `aarch64-darwin` | `macos-latest` |

## Entrypoint

The entrypoint uses a hook-based pattern to handle environment divergence and is organized into three logical blocks:

1. **Hooks:** Shell functions defining platform-specific setups (e.g.: installing dependencies).
2. **Registration**: Mapping hooks to runners using the [Platform API](#platform-api).
3. **Execution**: The `__main__` function containing the shared reproduction logic.

### Platform API

The `platform.sh` library provides helper functions to restrict commands to specific systems:

```sh
# Run on specific OS
__platform_run_os "linux" <command>
__platform_run_os "darwin" <command>

# Run on specific Architecture
__platform_run_arch "x86_64" <command>
__platform_run_arch "aarch64" <command>

# Run on specific OS/Arch combination
__platform_run "x86_64-linux" <command>
__platform_run "aarch64-darwin" <command>
```

## Workflow

Manually dispatch the workflow via the **Actions** tab.

| Input | Default | Description |
| :--- | :--- | :--- |
| `target` | *Required* | Path to the target directory (e.g: `rust-lang/bisect-pr-127`) |
| `upterm` | `false` | Starts an `upterm` session after workflow failure |
| `x86_64-linux` | `true` | Enable the workflow on `x86_64-linux` |
| `aarch64-linux` | `true` | Enable the workflow on `aarch64-linux` |
| `x86_64-darwin` | `true` | Enable the workflow on `x86_64-darwin` |
| `aarch64-darwin` | `true` | Enable the workflow on `aarch64-darwin` |

## License

<sup>
Licensed under <a href="LICENSE-APACHE">Apache License, Version 2.0</a> or <a href="LICENSE-MIT">MIT License</a> at your discretion.
</sup>

## Contribution

<sup>
Contributions to this project will be dual-licensed under <a href="LICENSE-APACHE">Apache-2.0</a> and <a href="LICENSE-MIT">MIT</a> by default, unless specifically indicated otherwise.
</sup>

[License-Apache]: https://opensource.org/licenses/Apache-2.0
[License-MIT]: https://opensource.org/licenses/MIT
