FROM python:3.10.0-slim-buster

LABEL maintainer='Luba'

WORKDIR /usr/src/app

ENV \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

RUN apt-get -qq update && \
  apt-get -qq -y install \
  gcc \
  redis-server \
  libcurl4-openssl-dev \
  libssl-dev

ARG WITH_NEW_RELIC=true
ENV WITH_NEW_RELIC=$WITH_NEW_RELIC
ENV NEW_RELIC_LICENSE_KEY=$NEWRELIC_KEY
ENV NEW_RELIC_LOG_FILE_NAME="STDOUT"
ENV APP_NAME="testing-celery"

# Copying Requirements
COPY Pipfile* ./

RUN pip install -q --no-cache-dir \
  pipenv===2023.3.20 && \
  pipenv install --system

COPY ./ ./

COPY ./entrypoint.sh /sbin/entrypoint.sh
RUN sed -i 's/\r$//g' /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

