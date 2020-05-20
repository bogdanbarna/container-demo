#!/usr/bin/env bash

set -x
set -e

usage() {
  echo "Usage: $0 [-t <IMAGE_TAG>]" 1>&2;
  exit 1;
}

while getopts ":t:" option; do
    case "${option}" in
        t)
            IMAGE_TAG=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

# Exit if no $IMAGE_TAG variable is present
if [[ -z "$IMAGE_TAG" ]]; then
	exit 1
fi


export TRIVY_TIMEOUT_SEC=360s

# Use trivy binary if installed, else install it
if hash trivy 2>/dev/null; then
  TRIVY=trivy
else
  TRIVY_DIR="${HOME}/trivy"
  TRIVY="${TRIVY_DIR}/trivy"

  mkdir -p "${HOME}/trivy"
  VERSION=$(curl --silent https://api.github.com/repos/aquasecurity/trivy/releases/latest | jq -r '.tag_name' | sed -E 's/[A-Za-z]+//')
  VERSION="0.1.6"
  TARBALL="trivy_${VERSION}_Linux-64bit.tar.gz"
  wget "https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/${TARBALL}"
  tar xzvf "${TARBALL}" -C "${TRIVY_DIR}"
  chmod 700 "${TRIVY}"
fi

$TRIVY --debug --clear-cache --ignore-unfixed --exit-code 0 --severity HIGH --no-progress --auto-refresh "$IMAGE_TAG"
$TRIVY --debug --clear-cache --ignore-unfixed --exit-code 1 --severity CRITICAL --no-progress --auto-refresh "$IMAGE_TAG"

exit 0
