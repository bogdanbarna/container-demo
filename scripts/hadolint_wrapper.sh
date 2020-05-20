#!/usr/bin/env bash

set -e


# Use hadolint binary if installed, else install it
if hash hadolint 2>/dev/null; then
  HADOLINT="hadolint"
else
  HADOLINT="${HOME}/hadolint"
  # Download hadolint binary and set it as executable
  curl -sL -o "${HADOLINT}" \
    "https://github.com/hadolint/hadolint/releases/download/v1.16.0/hadolint-$(uname -s)-$(uname -m)"
  chmod 700 "${HADOLINT}"
  # List files whose name starts with 'Dockerfile'
  # eg. Dockerfile, Dockerfile.build, etc.
  git ls-files --exclude='Dockerfile*' --ignored | xargs --max-lines=1 "${HADOLINT}"
fi

echo "All good!" && exit 0
