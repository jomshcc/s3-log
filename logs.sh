#!/usr/bin/env sh

# Phasing this script out. Uses `jq` to filter out worthless log entries.
# Previously, it could append entries to a permanent .json archive, with the
# archive file determined per-entry by the S3 bucket name. Something similar is
# probably going to become automatic behavior in the TypeScript module, but
# categorized by origin or URL.

set -o pipefail

PUB_IP=$(curl -fs https://ip.seeip.org/) ||
    { echo "[log error]: couldn't resolve public ip." >&2; exit 1; }

filter() {
    jq -c 'select(.ua | startswith("S3Console") | not) |
           select(.user_id // "" | endswith("user/api-util") | not) |
           select(.ip != "'"$PUB_IP"'")'
}

filter

# if [ -z "${outdir:-}" ]; then
# elif ! [ -d "${outdir}" -a -w "${outdir}" ]; then
#     echo 'Bad out directory'
#     exit 1
# else
#     filter | split
# fi
