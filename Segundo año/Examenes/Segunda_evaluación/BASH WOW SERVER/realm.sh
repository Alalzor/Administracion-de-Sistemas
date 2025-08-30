#!/bin/bash

LOG_FILE="/var/log/instalacion_wow.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "====================================="
echo "🛠️ Actualizando Realmlist en MySQL: $(date)"
echo "====================================="

# Solicita la nueva dirección del realmlist
read -p "Ingrese la nueva dirección del realmlist: " NUEVA_DIRECCION

# Verifica que sea una dirección IP válida
if [[ -z "$NUEVA_DIRECCION" ]]; then
    echo "❌ Error: La dirección IP no puede estar vacía."
    exit 1
elif ! [[ "$NUEVA_DIRECCION" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Error: La dirección IP no es válida."
    exit 1
fi

# Solicita el nuevo nombre del realmlist
read -p "Ingrese el nuevo nombre del realmlist: " NUEVO_NOMBRE

# Verifica que no esté vacío y solo contenga letras
if [[ -z "$NUEVO_NOMBRE" ]]; then
    echo "❌ Error: El nombre del realmlist no puede estar vacío."
    exit 1
elif ! [[ "$NUEVO_NOMBRE" =~ ^[a-zA-Z]+$ ]]; then
    echo "❌ Error: El nombre del realmlist solo puede contener letras."
    exit 1
fi

# Define la base de datos y el usuario root de MySQL
MYSQL_ROOT_USER="root"
MYSQL_DB="acore_auth"

# Solicita la contraseña de MySQL
read -s -p "Ingrese la contraseña de MySQL: " MYSQL_ROOT_PASS
echo

# Ejecuta los comandos SQL
mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" "$MYSQL_DB" <<EOF
UPDATE realmlist SET address = '$NUEVA_DIRECCION' WHERE id = 1;
UPDATE realmlist SET name = '$NUEVO_NOMBRE' WHERE id = 1;
FLUSH PRIVILEGES;
EOF

# Verifica si el comando tuvo éxito
if [ $? -eq 0 ]; then
    echo "✔ Realmlist actualizado con dirección '$NUEVA_DIRECCION' y nombre '$NUEVO_NOMBRE'."
else
    echo "❌ Error: No se pudo actualizar el realmlist. Verifique los datos ingresados."
    exit 1
fi

echo "✅ Realmlist actualizado exitosamente: $(date)"
