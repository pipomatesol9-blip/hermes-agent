FROM ghcr.io/nousresearch/hermes-agent:latest

# Script keepalive HTTP
COPY http-keepalive.sh /http-keepalive.sh
RUN chmod +x /http-keepalive.sh

RUN mkdir -p /etc/services.d/http-keepalive
RUN printf '#!/bin/sh\nexec /http-keepalive.sh\n' \
    > /etc/services.d/http-keepalive/run \
    && chmod +x /etc/services.d/http-keepalive/run

# Pre-configura Hermes antes de que arranque
COPY config.yaml /opt/data/config.yaml

EXPOSE 10000
