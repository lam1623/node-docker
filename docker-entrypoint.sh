#!/bin/sh
# vim:sw=4:ts=4:et

set -e

entrypoint_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ -d "/docker-entrypoint.d/" ]; then
    entrypoint_log "$0: Searching for shell scripts in /docker-entrypoint.d/"
    find "/docker-entrypoint.d/" -type f -name "*.sh" -print | sort -V | while read -r f; do
        if [ -x "$f" ]; then
            entrypoint_log "$0: Executing $f"
            "$f"
        else
            entrypoint_log "$0: Ignoring $f, not executable"
        fi
    done

    entrypoint_log "$0: Configuration complete; ready to proceed"
else
    entrypoint_log "$0: No /docker-entrypoint.d/ directory found, skipping configuration"
fi


exec "$@"

