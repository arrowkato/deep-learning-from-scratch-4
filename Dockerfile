FROM python:3.12.5-slim-bookworm
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# DL4006対策 https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    make git unzip wget curl zsh \
    docker.io

WORKDIR /tmp
RUN git clone https://github.com/awslabs/git-secrets.git
WORKDIR /tmp/git-secrets
RUN make install
WORKDIR $APP_HOME

# poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT=1

RUN curl -sSL https://install.python-poetry.org | python - --version 1.8.2

# RUN pip install --upgrade --no-cache-dir pip \
#     && pip install --no-cache-dir poetry \
#     && poetry install


RUN pip install --upgrade --no-cache-dir pip
RUN pip install --no-cache-dir poetry
RUN poetry install
