FROM ghcr.io/linuxserver/baseimage-alpine:3.14 AS base

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CRESTIC_TAG=v0.6.0
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="cbrucks"

# install packages
RUN \
  cd /tmp &&
  echo "**** install restic ****" && \
  apk add --no-cache restic rclone && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    python3 \
    py3-pip \
    tar \
    unzip && \
  python3 -m ensurepip && \
  pip3 install --no-cache --upgrade pip setuptools wheel && \
  echo "**** install crestic ****" && \
  curl https://raw.githubusercontent.com/nils-werner/crestic/${CRESTIC_TAG}/crestic.py --output /usr/local/bin/crestic && \
  chmod +x /usr/local/bin/crestic && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
#COPY root/ /

# ports and volumes
VOLUME /config /sources /backups