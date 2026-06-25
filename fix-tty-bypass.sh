#!/usr/bin/with-contenv bash

echo "[Fix] Aplicando bypass de TTY en la raíz..."

if [ -f /etc/services.d/main-hermes/run ]; then
    echo "[Fix] Detectado script de s6 original."
    mv /etc/services.d/main-hermes/run /etc/services.d/main-hermes/run.bak
    
    ORIGINAL_CMD=$(tail -n 1 /etc/services.d/main-hermes/run.bak)
    
    cat << EOF > /etc/services.d/main-hermes/run
#!/usr/bin/with-contenv bash
echo "[s6-run] Iniciando Hermes Agent manteniendo STDIN simulado..."
exec sleep infinity | $ORIGINAL_CMD
EOF

    chmod +x /etc/services.d/main-hermes/run
    echo "[Fix] Script de s6 modificado con éxito."
else
    echo "[Fix] [Error] No se encontró el servicio en /etc/services.d/main-hermes/run"
fi
