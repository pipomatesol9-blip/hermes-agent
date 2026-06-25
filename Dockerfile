FROM docker.io/nousresearch/hermes-agent:latest

# Script keepalive HTTP
COPY http-keepalive.sh /http-keepalive.sh
RUN chmod +x /http-keepalive.sh

RUN mkdir -p /etc/services.d/http-keepalive
RUN printf '#!/bin/sh\nexec /http-keepalive.sh\n' \
    > /etc/services.d/http-keepalive/run \
    && chmod +x /etc/services.d/http-keepalive/run
# Copiar el parcheador de entorno
COPY fix-tty-bypass.sh /etc/cont-init.d/00-fix-tty-bypass.sh

# Dar permisos de ejecución totales
RUN chmod +x /etc/cont-init.d/00-fix-tty-bypass.sh

# Asegurar permisos de ejecución dentro del contenedor
RUN chmod +x /etc/cont-init.d/00-fix-tty-bypass.sh

EXPOSE 10000
