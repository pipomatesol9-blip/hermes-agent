FROM docker.io/nousresearch/hermes-agent:latest

# Script keepalive HTTP
COPY http-keepalive.sh /http-keepalive.sh
RUN chmod +x /http-keepalive.sh

RUN mkdir -p /etc/services.d/http-keepalive
RUN printf '#!/bin/sh\nexec /http-keepalive.sh\n' \
    > /etc/services.d/http-keepalive/run \
    && chmod +x /etc/services.d/http-keepalive/run

# Pre-configura Hermes antes de que arranque
COPY config.yaml /opt/data/config.yaml
# Copiar el script desde la raíz del repositorio hacia la ruta de s6 del contenedor
COPY fix-tty-bypass.sh /etc/cont-init.d/00-fix-tty-bypass.sh

# Asegurar permisos de ejecución dentro del contenedor
RUN chmod +x /etc/cont-init.d/00-fix-tty-bypass.sh

EXPOSE 10000
