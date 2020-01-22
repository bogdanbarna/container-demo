# Multi-stage build using wheel lets us compile on first image,
# create wheel files for all dependencies
# and install them in the second image without installing the compilers.

### Base
FROM python:3.7.6-stretch as base
LABEL maintainer="IDK <idk@nope.biz>"

COPY requirements/prod-requirements.txt /tmp/
RUN \
  apt-get update -yq && \
  apt-get install -yq --no-install-recommends \
    cowsay=3.* && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* && \
  pip --no-cache-dir install -r /tmp/prod-requirements.txt
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# fail if error at any stage in the pipe below
RUN echo "this was a multi-stage build..." | /usr/games/cowsay

COPY src /app

### Test
FROM base as test
COPY requirements/test-requirements.txt /tmp/
RUN pip --no-cache-dir install -r /tmp/test-requirements.txt

RUN \
  pylint --disable=R,C,W /app/hello.py && \
  bandit -v -r app && \
  radon mi -s app && \
  radon cc -s app

### Release
FROM gcr.io/distroless/python3:debug as release
COPY --from=base /app /app
COPY --from=base /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages
ENV PYTHONPATH=/usr/local/lib/python3.7/site-packages

WORKDIR /app
USER 1001

CMD [ "hello.py" ]
