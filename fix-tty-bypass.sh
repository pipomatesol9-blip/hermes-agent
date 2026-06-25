#!/usr/bin/with-contenv bash

echo "[Fix] Forzando pre-configuración desatendida de Hermes Agent..."

# Definir el contenido del config.yaml dummy/básico para saltarse el CLI setup
# Las variables importantes las seguirá leyendo de Render (HERMES_TELEGRAM_BOT_TOKEN, etc.)
read -r -d '' CONFIG_CONTENT << 'EOF'
version: "1"
agent:
  name: "Hermes Agent"
  profile: "default"
model:
  provider: "openai"
  name: "minimaxai/minimax-m2.7"
gateway:
  enabled: true
  autostart: true
  platform: "telegram"
EOF

# Inyectar el archivo en todos los directorios HOME posibles del contenedor
PATHS=("/root/.hermes" "/opt/hermes/.hermes" "/home/hermes/.hermes")

for dir in "${PATHS[@]}"; do
    mkdir -p "$dir"
    echo "$CONFIG_CONTENT" > "$dir/config.yaml"
    chmod 755 "$dir/config.yaml"
    echo "[Fix] Configuración escrita en $dir/config.yaml"
done

# --- PLAN B ALTERNATIVO ---
# Si Hermes aún así intentara buscar la TTY, vamos a modificar su servicio de s6 
# apuntando el comando directamente a ejecutar de forma explícita el modo pasarela/servidor si está disponible.
if [ -f /etc/services.d/main-hermes/run ]; then
    echo "[Fix] Modificando s6 run para forzar ejecución desatendida..."
    mv /etc/services.d/main-hermes/run /etc/services.d/main-hermes/run.bak
    
    cat << 'EOF' > /etc/services.d/main-hermes/run
#!/usr/bin/with-contenv bash
echo "[s6] Ejecutando Hermes Agent en bucle desatendido..."
# Ejecutamos el agente redirigiendo la entrada a un bucle infinito en background
exec sleep infinity | /opt/hermes/bin/hermes-agent --gateway 2>&1
EOF
    chmod +x /etc/services.d/main-hermes/run
fi
