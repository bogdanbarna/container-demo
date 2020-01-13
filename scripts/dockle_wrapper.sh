#!/usr/bin/env bash

set -v
set -e



# Exit if no $DOCKER_IMAGE variable is present
if [[ -z "$DOCKER_IMAGE" ]]; then
	exit 1
fi

# Use trivy binary if installed, else install it
if hash dockle 2>/dev/null; then
  DOCKLE=dockle
else
	DOCKLE_DIR="${HOME}/dockle"
	DOCKLE="${DOCKLE_DIR}/dockle"

	mkdir -p "${DOCKLE_DIR}"
	VERSION=$(curl --silent https://api.github.com/repos/goodwithtech/dockle/releases/latest | jq -r '.tag_name' | sed -E 's/[A-Za-z]+//')
	TARBALL="dockle_${VERSION}_Linux-64bit.tar.gz"
  wget "https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/${TARBALL}"
  tar zxvf "${TARBALL}" -C "${DOCKLE_DIR}"
  chmod 700 "${DOCKLE}"
fi

# Ignore CIS-DI-0001 	Create a user for the container
# Ignore CIS-DI-0005 	Enable Content trust for Docker
# Ignore DKL-DI-0006 	Avoid latest tag
"${DOCKLE}" --ignore CIS-DI-0001 --ignore CIS-DI-0005 --ignore DKL-DI-0006 --exit-code 1 "${DOCKER_IMAGE}"

exit 0
