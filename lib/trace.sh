#!/bin/sh

__TRACE_COLOR_RED="\033[0;91m"
__TRACE_COLOR_GREEN="\033[0;92m"
__TRACE_COLOR_YELLOW="\033[0;93m"
__TRACE_COLOR_BLUE="\033[0;94m"
__TRACE_COLOR_CYAN="\033[0;96m"
__TRACE_COLOR_RESET="\033[0m"

readonly __TRACE_COLOR_RED
readonly __TRACE_COLOR_GREEN
readonly __TRACE_COLOR_YELLOW
readonly __TRACE_COLOR_BLUE
readonly __TRACE_COLOR_CYAN
readonly __TRACE_COLOR_RESET

# Generates the current timestamp.
# Returns an empty POSIX time string on failure.
#
# Outputs the timestamp to stdout in "YYYY-MM-DD HH:MM:SS" format.
__trace_timestamp() {
    date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "0000-00-00 00:00:00"
}

# Formats a message with color, level, and timestamp.
# Composes a log line with ANSI color codes and a timestamp prefix.
#
# Arguments:
#
# - $1 - ANSI color code.
# - $2 - Log level label (e.g., "ERROR").
# - $3 - Message text.
#
# Outputs the formatted string to stdout.
__trace_format() {
    printf '%b\n' "${1}[$(__trace_timestamp)] [${2}]:${__TRACE_COLOR_RESET} ${3}"
}

# Prints an error message.
# Outputs a red-colored error log line to stderr.
#
# Arguments:
#
# - $1 - Message text.
trace_error() {
    __trace_format "${__TRACE_COLOR_RED}" "ERROR" "${1}" >&2
}

# Prints a warning message.
# Outputs a yellow-colored warning log line to stderr.
#
# Arguments:
#
# - $1 - Message text.
trace_warning() {
    __trace_format "${__TRACE_COLOR_YELLOW}" "WARNING" "${1}" >&2
}

# Prints a success message.
# Outputs a green-colored success log line to stdout.
#
# Arguments:
#
# - $1 - Message text.
trace_success() {
    __trace_format "${__TRACE_COLOR_GREEN}" "SUCCESS" "${1}"
}

# Prints an info message.
# Outputs a blue-colored info log line to stdout.
#
# Arguments:
#
# - $1 - Message text.
trace_info() {
    __trace_format "${__TRACE_COLOR_BLUE}" "INFO" "${1}"
}

# Prints a debug message.
# Outputs a cyan-colored debug log line to stdout.
#
# Arguments:
#
# - $1 - Message text.
trace_debug() {
    __trace_format "${__TRACE_COLOR_CYAN}" "DEBUG" "${1}"
}

# Prints a section header.
# Outputs a visual banner for seperating log sections.
#
# Arguments:
#
# - $1 - Header title.
trace_header() {
    printf '\n'
    printf '    ╭────────────────────────────────────────────────────╮\n'
    printf '    │  ◈   %s\n' "${1}"
    printf '    ╰────────────────────────────────────────────────────╯\n'
    printf '\n'
}
