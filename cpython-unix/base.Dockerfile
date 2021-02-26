# Debian Jessie.
FROM debian:8.10
MAINTAINER Gregory Szorc <gregory.szorc@gmail.com>

RUN groupadd -g 1000 build && \
    useradd -u 1000 -g 1000 -d /build -s /bin/bash -m build && \
    mkdir /tools && \
    chown -R build:build /build /tools

ENV HOME=/build \
    SHELL=/bin/bash \
    USER=build \
    LOGNAME=build \
    HOSTNAME=builder \
    DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash", "--login"]
WORKDIR '/build'

RUN for s in debian_jessie; do \
      echo "deb http://archive.debian.org/${s%_*}/ ${s#*_} main"; \
    done > /etc/apt/sources.list && \
    ( echo 'quiet "true";'; \
      echo 'APT::Get::Assume-Yes "true";'; \
      echo 'APT::Get::Force-Yes "true";'; \
      echo 'APT::Install-Recommends "false";'; \
      echo 'Acquire::Check-Valid-Until "false";'; \
      echo 'Acquire::Retries "5";'; \
    ) > /etc/apt/apt.conf.d/99cpython-portable

RUN ( echo 'amd64'; \
      echo 'arm64'; \
      echo 'armel'; \
      echo 'armhf'; \
      echo 'i386'; \
    ) > /var/lib/dpkg/arch

RUN apt-get update
