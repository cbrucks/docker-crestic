FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CRESTIC_VERSION=0.6.0
ARG RESTIC_VERSION=0.12.1
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
  python3 -m ensurepip && \
  pip3 install --no-cache --upgrade pip setuptools wheel && \
  cd /tmp && \
  echo "**** install autorestic ****" && \
  # download the released restic version
  curl https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_arm64.bz2 && \
  # unpack the compressed restic executable
  tar -xf restic_${RESTIC_VERSION}_linux_arm64.bz2 && \
  # copy and rename the restic executable to a bin folder
  cp restic_${RESTIC_VERSION}_linux_amd64 /usr/local/bin/restic
  echo "**** install crestic ****" && \
  # download the creatic file
  curl https://raw.githubusercontent.com/nils-werner/crestic/v${CRESTIC_VERSION}/crestic.py && \
  cp crestic.py /usr/local/bin/crestic
  chmod +x /usr/local/bin/crestic && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
VOLUME /sources /backups