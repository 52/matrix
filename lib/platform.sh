#!/bin/sh

# Detects the host system platform.
#
# This function identifies the OS and CPU architecture of the
# current host by querying system information via uname(1).
#
# Results are normalized to canonical identifiers and exported.
#
# Globals:
#
# - PLATFORM_OS   - Set to the detected OS identifier.
# - PLATFORM_ARCH - Set to the detected architecture identifier.
# - PLATFORM_ID   - Set to "${PLATFORM_ARCH}-${PLATFORM_OS}".
#
# Exits with error when an "unknown" platform is detected.
__platform_detect() {
    __raw_os=$(uname -s)
    __raw_arch=$(uname -m)

    case "${__raw_os}" in
        Linux|linux)   __os="linux" ;;
        Darwin|darwin) __os="darwin" ;;
        *)             __os="unknown" ;;
    esac

    case "${__raw_arch}" in
        x86_64|amd64)  __arch="x86_64" ;;
        aarch64|arm64) __arch="aarch64" ;;
        *)             __arch="unknown" ;;
    esac

    if [ "${__os}" = "unknown" ] || [ "${__arch}" = "unknown" ]; then
        echo "::platform::error::CRITICAL: Unknown system detected."
        echo "::platform::error::OS: ${__raw_os}"
        echo "::platform::error::Arch: ${__raw_arch}"
        exit 1
    fi

    PLATFORM_OS="${__os}"
    PLATFORM_ARCH="${__arch}"
    PLATFORM_ID="${PLATFORM_ARCH}-${PLATFORM_OS}"
}

__platform_detect

readonly PLATFORM_OS
readonly PLATFORM_ARCH
readonly PLATFORM_ID

# Runs a command on a specific platform.
# Executes the command only if the current platform matches the target.
#
# Arguments:
#
# - $1        - Target platform identifier (e.g. "x86_64-linux").
# - $2 ... $n - Command and arguments to execute.
#
# Returns the exit status of the command, or 0 if no match.
__platform_run() {
    __target="${1}"
    shift

    if [ "${__target}" = "${PLATFORM_ID}" ]; then
        "${@}"
        return "${?}"
    fi

    return 0
}

# Runs a command on a specific operating system.
# Executes the command only if the current OS matches the target.
#
# Arguments:
#
# - $1        - Target OS identifier ("linux" or "darwin").
# - $2 ... $n - Command and arguments to execute.
#
# Returns the exit status of the command, or 0 if no match.
__platform_run_os() {
    __target_os="${1}"
    shift

    if [ "${__target_os}" = "${PLATFORM_OS}" ]; then
        "${@}"
        return "${?}"
    fi

    return 0
}

# Runs a command on a specific architecture.
# Executes the command only if the current architecture matches the target.
#
# Arguments:
#
# - $1        - Target architecture identifier ("x86_64" or "aarch64").
# - $2 ... $n - Command and arguments to execute.
#
# Returns the exit status of the command, or 0 if no match.
__platform_run_arch() {
    __target_arch="${1}"
    shift

    if [ "${__target_arch}" = "${PLATFORM_ARCH}" ]; then
        "${@}"
        return "${?}"
    fi

    return 0
}
