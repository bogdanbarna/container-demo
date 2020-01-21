# Container Demo


---
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [About](#about)
- [Usage](#usage)
  - [Misc](#misc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
---


## About

This repository contains a couple of container demos meant for consumption by
[3Pillar Global](https://3pillarglobal.com)'s internal *DevOps Community of Practice*.


## Usage

For building this Docker image, the following will do:

```
docker build . -t devops-cop-container-demo
```

For added benefit, `export DOCKER_BUILDKIT=1` before the build to use [buildkit, the new build backend](https://github.com/moby/buildkit).

For installing pre-commit hooks, run:
```
pre-commit install
```

For running hadolint, dockle, and trivy, the scripts directory contains wrapper bash scripts to all three,
e.g.
```
scripts/trivy_wrapper.sh devops-cop-container-demo
```

As CICD good practices,
  - use [pre-commit hooks](pre-commit.com/),
  - run the app code lint and test inside as part of a [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/),
  - lint the Dockerfile with [Hadolint](https://github.com/hadolint/hadolint),
  - lint the Docker image with [Dockle](https://github.com/goodwithtech/dockle),
  - and scan for vulnerabilities with [Trivy](https://github.com/homoluctus/gitrivy/).

Enabling [Docker Content Trust](https://docs.docker.com/engine/security/trust/content_trust/) is normally recommended, but as mentioned in [this open issue](https://github.com/moby/moby/issues/25852) it does not work with locally built images.


### Misc

Always clean up after yourself:

```
docker system prune -a
```
(_Note: be mindful about running this on production systems, though._)
