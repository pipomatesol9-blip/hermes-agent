#!/bin/sh
# Espera a que Hermes esté listo
sleep 5

# Configura el proveedor de IA
hermes config set provider openai_compatible
hermes config set base_url "$OPENAI_BASE_URL"
hermes config set api_key "$OPENAI_API_KEY"
hermes config set model "$MODEL"

# Configura Telegram
hermes config set messaging.telegram.bot_token "$HERMES_TELEGRAM_BOT_TOKEN"
hermes config set messaging.telegram.allowed_users "$HERMES_TELEGRAM_ALLOWED_USERS"

# Arranca el gateway en background
hermes gateway start &

echo "[03-setup-telegram] Gateway configurado y arrancado"
