FROM python:3.7.3-stretch
LABEL maintainer="IDK <idk@nope.biz>"

COPY requirements/prod-requirements.txt /tmp/
RUN \
  apt-get update -yq && \
  apt-get install -yq --no-install-recommends cowsay && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* && \
	pip --no-cache-dir install -r /tmp/prod-requirements.txt

COPY src /app

WORKDIR /app
USER 1001
ENV PYTHONPATH=/usr/local/lib/python3.7/site-packages

CMD [ "python3", "hello.py" ]
