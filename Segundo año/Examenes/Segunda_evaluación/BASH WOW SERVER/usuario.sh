#!/bin/bash

LOG_FILE="/var/log/instalacion_wow.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "====================================="
echo "🔑 Creando usuario en MySQL: $(date)"
echo "====================================="

# Solicita el nombre de usuario
read -p "Ingrese el nombre del usuario a crear: " NEW_USER

# Verifica que no esté vacío y contenga solo letras
if [[ -z "$NEW_USER" || "$NEW_USER" =~ [^a-zA-Z] ]]; then
    echo "❌ Error: El nombre de usuario no puede estar vacío y debe contener solo letras."
    exit 1
fi

# Solicita la contraseña sin mostrarla en pantalla
read -s -p "Ingrese la contraseña para $NEW_USER: " NEW_USER_PASS
echo

# Verifica que no esté vacía
if [[ -z "$NEW_USER_PASS" ]]; then
    echo "❌ Error: La contraseña no puede estar vacía."
    exit 1
fi

# Define el usuario root de MySQL
MYSQL_ROOT_USER="root"

# Ejecuta los comandos SQL en MySQL y captura errores
mysql -u "$MYSQL_ROOT_USER" <<EOF
DROP USER IF EXISTS '$NEW_USER'@'%';
DROP USER IF EXISTS '$NEW_USER'@'localhost';
CREATE USER '$NEW_USER'@'%' IDENTIFIED BY '$NEW_USER_PASS';
GRANT ALL PRIVILEGES ON *.* TO '$NEW_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Verifica si el comando anterior tuvo éxito
if [ $? -eq 0 ]; then
    echo "✔ Usuario '$NEW_USER' creado y configurado correctamente en MySQL."
else
    echo "❌ Error: No se pudo crear el usuario '$NEW_USER' en MySQL. Verifique los datos ingresados."
    exit 1
fi

echo "✅ Usuario creado exitosamente: $(date)"
