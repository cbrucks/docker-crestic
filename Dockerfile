FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CRESTIC_VERSION="master"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="cbrucks"

# install packages
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
  curl \
  python3 \
  py3-pip \
  tar \
  unzip && \
  python -m ensurepip && \
  pip3 install --no-cache --upgrade pip setuptools appdirs && \
  echo "**** install autorestic ****" && \
  echo "**** install crestic ****" && \
  cd /tmp && \
  curl https://raw.githubusercontent.com/nils-werner/crestic/${CRESTIC_VERSION}/crestic.py --output /usr/local/bin/crestic && \
  chmod +x /usr/local/bin/crestic && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
VOLUME /sources /backups