FROM ubuntu:bionic AS runtime

RUN set -xe \
    && apt-get update \
    && apt-get install -y git inotify-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM runtime AS builder

ARG GW_URL=https://github.com/gitwatch/gitwatch.git
ARG GH_VERSION=7a6fa177ba7792f76351bd0b987026a8e5bdc454

RUN set -xe \
    && git clone ${GW_URL} /source \
    && cd /source \
    && git checkout ${GH_VERSION} \
    && install -b gitwatch.sh /usr/local/bin/gitwatch

FROM runtime

COPY --from=builder /usr/local/bin/gitwatch /usr/local/bin/gitwatch

ENTRYPOINT [ "/usr/local/bin/gitwatch" ]