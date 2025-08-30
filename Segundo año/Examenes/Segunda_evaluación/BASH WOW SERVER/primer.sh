#!/bin/bash

LOG_FILE="/var/log/instalacion_wow.log"

# Redirigir salida estándar y errores al archivo de log y mostrarlo en pantalla
exec > >(tee -a "$LOG_FILE") 2>&1

# ==============================
# 🚀 INICIO DE INSTALACIÓN
# ==============================
echo "====================================="
echo "🚀 Inicio de instalación: $(date)"
echo "====================================="

# ==============================
# 🚀 ACTUALIZACIÓN DEL SISTEMA
# ==============================
echo "¿Deseas actualizar el sistema? (s/n)"
read -r respuesta
if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
    apt update && apt upgrade -y && apt install git -y
    echo "✔ Sistema actualizado correctamente."
else
    echo "⚠ Omitiendo actualización..."
fi

# ==============================
# 📂 CREACIÓN DE DIRECTORIOS
# ==============================
# Solicitar el nombre del directorio
read -p "Ingrese el nombre del directorio donde se instalará el servidor: " DIR_NAME
DIR_NAME=${DIR_NAME:-Serverwow}

# Verificar si el directorio existe
if [[ ! -d "$DIR_NAME" ]]; then
    mkdir "$DIR_NAME"
    echo "✔ Directorio '$DIR_NAME' creado."
else
    echo "⚠ El directorio '$DIR_NAME' ya existe."
fi

# Entrar en el directorio o salir si falla
cd "$DIR_NAME" || { echo "❌ Error: No se pudo acceder al directorio '$DIR_NAME'."; exit 1; }

# ==============================
# 🛠️ CLONACIÓN DEL REPO
# ==============================
if [[ ! -d "azerothcore-wotlk" ]]; then
    git clone https://github.com/azerothcore/azerothcore-wotlk.git
    echo "✔ Repositorio clonado correctamente."
else
    echo "⚠ El repositorio ya está clonado."
fi

cd azerothcore-wotlk || { echo "❌ Error: No se pudo entrar en azerothcore-wotlk"; exit 1; }

# ==============================
# 📌 INSTALAR DEPENDENCIAS
# ==============================
echo "¿Deseas instalar dependencias? (s/n)"
read -r respuesta
if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
    ./acore.sh install-deps
    echo "✔ Dependencias instaladas correctamente."
else
    echo "⚠ Omitiendo instalación de dependencias..."
fi

# ==============================
# 🔨 COMPILACIÓN DEL SERVIDOR
# ==============================
echo "¿Deseas compilar AzerothCore? (s/n)"
read -r respuesta
if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
    ./acore.sh compiler all
    echo "✔ Compilación finalizada correctamente."
else
    echo "⚠ Omitiendo compilación..."
fi

# ==============================
# 🎮 DESCARGA DEL CLIENTE
# ==============================
echo "¿Deseas descargar los datos del cliente? (s/n)"
read -r respuesta
if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
    ./acore.sh client-data
    echo "✔ Cliente descargado correctamente."
else
    echo "⚠ Omitiendo descarga del cliente..."
fi

# ==============================
# ⚙️ COPIAR ARCHIVOS DE CONFIGURACIÓN
# ==============================
if cp env/dist/etc/authserver.conf.dist env/dist/etc/authserver.conf; then
    echo "✔ authserver.conf copiado correctamente."
else
    echo "❌ Error al copiar authserver.conf."
    exit 1
fi

if cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf; then
    echo "✔ worldserver.conf copiado correctamente."
else
    echo "❌ Error al copiar worldserver.conf."
    exit 1
fi

while true; do
    read -p "Ingrese el nombre del directorio donde tienes los scripts (o 'exit' para salir): " SCRIPT_DIR
    if [[ "$SCRIPT_DIR" == "exit" ]]; then
        echo "Saliendo del proceso..."
        exit 0
    elif cd "$SCRIPT_DIR"; then
        echo "✔ Accedido al directorio '$SCRIPT_DIR' correctamente."
        break
    else
        echo "❌ Error: No se pudo acceder al directorio '$SCRIPT_DIR'. Inténtalo de nuevo."
    fi
done
# ==============================
# 🔑 CREACIÓN DEL USUARIO MYSQL
# ==============================
echo "🔑 Creando usuario MySQL..."
./usuario.sh

# ==============================
# 🛠️ CONFIGURACIÓN DEL REALMLIST
# ==============================
echo "🛠️ Actualizando realmlist..."
./realm.sh

# ==============================
# 🎉 FIN DE INSTALACIÓN
# ==============================
echo "====================================="
echo "🎉 Instalación completada: $(date)"
echo "====================================="
