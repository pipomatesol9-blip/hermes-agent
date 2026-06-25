FROM docker.io/nousresearch/hermes-agent:latest

# Copia el script keepalive
COPY http-keepalive.sh /http-keepalive.sh
RUN chmod +x /http-keepalive.sh

# Registra el keepalive como servicio s6
RUN mkdir -p /etc/services.d/http-keepalive
RUN printf '#!/bin/sh\nexec /http-keepalive.sh\n' \
    > /etc/services.d/http-keepalive/run \
    && chmod +x /etc/services.d/http-keepalive/run

EXPOSE 10000
