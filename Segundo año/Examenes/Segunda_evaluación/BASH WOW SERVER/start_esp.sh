#!/bin/bash

LOG_FILE="/var/log/instalacion_wow.log"
exec > >(tee -a "$LOG_FILE") 2>&1

AUTHSERVER_CMD="$HOME/azerothcore-wotlk/acore.sh run-authserver"
WORLDSERVER_CMD="$HOME/azerothcore-wotlk/acore.sh run-worldserver"
AUTHSESSION="auth-session"
WORLDSESSION="world-session"

echo "====================================="
echo "🚀 Iniciando servidores: $(date)"
echo "====================================="

# =============================
# VERIFICAR QUE TMUX ESTÉ INSTALADO
# =============================
if ! command -v tmux &> /dev/null; then
    echo "❌ Error: tmux no está instalado. Instálalo con: sudo apt install tmux"
    exit 1
fi

# =============================
# CREAR SESIÓN DE AUTHSERVER
# =============================
if tmux has-session -t $AUTHSESSION 2>/dev/null; then
    echo "⚠ La sesión $AUTHSESSION ya está en ejecución."
else
    tmux new-session -d -s $AUTHSESSION
    echo "✔ Sesión de authserver creada: $AUTHSESSION"
    tmux send-keys -t $AUTHSESSION "$AUTHSERVER_CMD" C-m
    echo "✔ Ejecutado \"$AUTHSERVER_CMD\" dentro de $AUTHSESSION"
fi

# =============================
# CREAR SESIÓN DE WORLDSERVER
# =============================
if tmux has-session -t $WORLDSESSION 2>/dev/null; then
    echo "⚠ La sesión $WORLDSESSION ya está en ejecución."
else
    tmux new-session -d -s $WORLDSESSION
    echo "✔ Sesión de worldserver creada: $WORLDSESSION"
    tmux send-keys -t $WORLDSESSION "$WORLDSERVER_CMD" C-m
    echo "✔ Ejecutado \"$WORLDSERVER_CMD\" dentro de $WORLDSESSION"
fi

# =============================
# INFORMACIÓN PARA EL USUARIO
# =============================
echo "💡 Para adjuntarte a una sesión en ejecución usa:"
echo "   tmux attach -t $AUTHSESSION  # Para authserver"
echo "   tmux attach -t $WORLDSESSION  # Para worldserver"
echo "   tmux ls  # Para ver todas las sesiones activas"

echo "✅ Servidores iniciados correctamente: $(date)"
