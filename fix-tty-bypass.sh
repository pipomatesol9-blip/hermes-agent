#!/usr/bin/with-contenv bash

echo "[Fix] Forzando entorno TTY virtual con comando script..."

# 1. Escribir la configuración base por si acaso
CONFIG_CONTENT="version: \"1\"
agent:
  name: \"Hermes Agent\"
  profile: \"default\"
model:
  provider: \"openai\"
  name: \"minimaxai/minimax-m2.7\"
gateway:
  enabled: true
  autostart: true
  platform: \"telegram\""

PATHS=("/root/.hermes" "/opt/hermes/.hermes" "/home/hermes/.hermes")
for dir in "${PATHS[@]}"; do
    mkdir -p "$dir"
    echo "$CONFIG_CONTENT" > "$dir/config.yaml"
done

# 2. Modificar el punto de entrada de s6 para engañar al binario
if [ -f /etc/services.d/main-hermes/run ]; then
    echo "[Fix] Reconfigurando el inicio del servicio s6..."
    
    # Si no lo hemos respaldado antes, lo respaldamos
    if [ ! -f /etc/services.d/main-hermes/run.bak ]; then
        mv /etc/services.d/main-hermes/run /etc/services.d/main-hermes/run.bak
    fi
    
    # Extraemos el comando ejecutor original
    ORIGINAL_CMD=$(tail -n 1 /etc/services.d/main-hermes/run.bak)
    
    # Si el original tenía un exec, removemos la palabra para manejarlo nosotros
    ORIGINAL_CMD=$(echo "$ORIGINAL_CMD" | sed 's/^exec //')

    # Creamos el nuevo run usando 'script /dev/null' que genera una TTY falsa impecable
    cat << EOF > /etc/services.d/main-hermes/run
#!/usr/bin/with-contenv bash
echo "[s6] Ejecutando bajo pseudo-TTY controlada..."
exec script -q -c "$ORIGINAL_CMD --gateway" /dev/null
EOF

    chmod +x /etc/services.d/main-hermes/run
    echo "[Fix] Modificación de TTY virtual completada."
fi
