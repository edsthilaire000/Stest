#!/usr/bin/env bash
# ===================================================
#  🧩 ZERO.sh — Script de arranque para servidor Minecraft
# ===================================================
# Autor: Edsthilaire (Zero)
# Versión: 1.3 (Simplificada)
#
# Descripción:
#   Script optimizado para iniciar un servidor de Minecraft con Aikar Flags.
#   Permite elegir cuánta memoria (1 GB a 8 GB) usar.
#   Reinicia automáticamente el servidor si se detiene.
#
# ===================================================
# 📘 INSTRUCCIONES PARA USUARIOS:
#
# 1️⃣ Coloca este archivo (ZERO.sh) en la carpeta de tu servidor.
# 2️⃣ Asegúrate de que tu servidor se llame "server.jar".
# 3️⃣ Abre la terminal en esa carpeta.
# 4️⃣ Da permisos de ejecución con:
#       chmod +x ZERO.sh
# 5️⃣ Ejecuta el script con:
#       ./ZERO.sh
#
# ✅ Si aparece “Permission denied”, usa:
#       bash ZERO.sh
#
# Para detenerlo, presiona CTRL + C.
#
# ===================================================


# ==== VERIFICAR PERMISOS ====
if [ ! -x "$0" ]; then
    echo "⚙️  Aplicando permisos de ejecución automáticamente..."
    chmod +x "$0" 2>/dev/null || echo "❌ No se pudieron aplicar permisos. Usa: chmod +x ZERO.sh"
fi


# ==== SELECCIÓN DE MEMORIA ====
echo "💾 Configuración de memoria del servidor:"
echo "---------------------------------------"
echo "  1 -> 1 GB"
echo "  2 -> 2 GB"
echo "  4 -> 4 GB"
echo "  6 -> 6 GB"
echo "  8 -> 8 GB (máximo recomendado)"
echo "---------------------------------------"
read -p "👉 Ingresa cuánta memoria (GB) deseas usar [1-8]: " MEMORY_GB

# Validar entrada
if ! [[ "$MEMORY_GB" =~ ^[0-9]+$ ]] || [ "$MEMORY_GB" -lt 1 ] || [ "$MEMORY_GB" -gt 8 ]; then
    echo "⚠️  Valor inválido. Usando 2 GB por defecto."
    MEMORY_GB=2
fi

MEMORY_MB=$((MEMORY_GB * 1024))
echo "✅ Se usará ${MEMORY_GB}GB de memoria (${MEMORY_MB}MB)."


# ==== INICIAR SERVIDOR MINECRAFT ====
while true; do
    clear
    echo "========================================"
    echo " 🧠 ZERO SERVER LAUNCHER v1.3"
    echo " 🚀 Iniciando servidor con ${MEMORY_GB}GB de RAM..."
    echo "========================================"
    echo

    java -Xms${MEMORY_MB}M -Xmx${MEMORY_MB}M \
         -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
         -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
         -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
         -XX:InitiatingHeapOccupancyPercent=15 \
         -XX:G1MixedGCLiveThresholdPercent=90 \
         -XX:G1RSetUpdatingPauseTimePercent=5 \
         -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
         -XX:MaxTenuringThreshold=1 \
         -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true \
         -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 \
         -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 \
         -jar server.jar --nogui

    echo
    echo "🌀 El servidor se ha detenido."
    echo "Reiniciando en 5 segundos... (Presiona Ctrl+C para cancelar)"
    sleep 5
done
