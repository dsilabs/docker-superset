#
# dockerfile for superset
#

FROM ubuntu:16.04

MAINTAINER Herb Lainchbury <herb@dynamic-solutions.com>

RUN apt-get update

RUN apt-get -y install build-essential libssl-dev libffi-dev python-dev python-pip libsasl2-dev libldap2-dev

# get the latest pip and setuptools
RUN pip install --upgrade setuptools pip

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=$PATH:/home/superset/.bin \
    PYTHONPATH=/home/superset/.superset:$PYTHONPATH

# install python libraries
RUN pip install superset
RUN fabmanager create-admin \
  --username 'admin' \
  --firstname 'admin' \
  --lastname 'user' \
  --email 'admin@testco.com' \
  --password 'admin' \
  --app superset
RUN superset db upgrade \
  && superset load_examples \
  && superset init

# Configure Filesysten
WORKDIR /home/superset
COPY superset .
VOLUME /home/superset/.superset

# Deploy application
EXPOSE 8088

CMD superset runserver -d
