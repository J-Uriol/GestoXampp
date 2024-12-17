#!/bin/bash

# Script para gestionar XAMPP y MySQL
LOG_FILE="$HOME/xampp_log.txt"
XAMPP_DIR="/opt/lampp"

# Pedir la contraseña de administrador al inicio
echo "Por favor, introduce tu contraseña de administrador para poder continuar con las acciones de XAMPP."
sudo -v  # Esto mantiene el sudo activo durante la sesión

# Función para verificar si XAMPP está instalado
verificar_xampp_instalado() {
    if [ -d "$XAMPP_DIR" ]; then
        echo "✅ XAMPP está instalado."
        return 0
    else
        echo "❌ XAMPP no está instalado."
        return 1
    fi
}

# Función para verificar si MySQL está en ejecución
comprobar_mysql() {
    # Verificar si el proceso de MySQL está en ejecución
    if pgrep -x "mysqld" > /dev/null; then
        echo "✅ MySQL está en ejecución."
    else
        echo "❌ MySQL no está en ejecución."
    fi
}

# Función para iniciar XAMPP
iniciar_xampp() {
    echo "Iniciando XAMPP..."
    echo "$SUDO_PASSWORD" | sudo -S /opt/lampp/lampp start
    echo "$(date): XAMPP iniciado" >> "$LOG_FILE"
    sleep 2
    clear
    echo "✅ XAMPP iniciado correctamente."
}

# Función para detener XAMPP
parar_xampp() {
    echo "Parando XAMPP..."
    echo "$SUDO_PASSWORD" | sudo -S /opt/lampp/lampp stop
    echo "$(date): XAMPP detenido" >> "$LOG_FILE"
    sleep 2
    clear
    echo "✅ XAMPP detenido correctamente."
}

# Función para iniciar MySQL
iniciar_mysql() {
    echo "¿Quieres iniciar MySQL? | 1.- Sí | 2.- No"
    read -r mysql_opcion
    case $mysql_opcion in
        1)
            echo "Iniciando MySQL..."
            echo "$SUDO_PASSWORD" | sudo -S /opt/lampp/bin/mysql
            echo "$(date): MySQL iniciado" >> "$LOG_FILE"
            ;;
        2)
            echo "❌ MySQL no se iniciará."
            ;;
        *)
            echo "⚠️ Opción no válida."
            ;;
    esac
}

# Función para reiniciar XAMPP
reiniciar_xampp() {
    echo "Reiniciando XAMPP..."
    echo "$SUDO_PASSWORD" | sudo -S /opt/lampp/lampp restart
    echo "$(date): XAMPP reiniciado" >> "$LOG_FILE"
    sleep 2
    clear
    echo "✅ XAMPP reiniciado correctamente."
}

# Función para instalar XAMPP
instalar_xampp() {
    echo "Iniciando la instalación de XAMPP..."
    echo "Este proceso puede tardar unos minutos..."
    echo "$SUDO_PASSWORD" | sudo -S wget https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.1.12/xampp-linux-x64-8.1.12-0-installer.run
    echo "$SUDO_PASSWORD" | sudo -S chmod +x xampp-linux-x64-8.1.12-0-installer.run
    echo "$SUDO_PASSWORD" | sudo -S ./xampp-linux-x64-8.1.12-0-installer.run
    echo "$(date): XAMPP instalado" >> "$LOG_FILE"
    clear
    echo "✅ XAMPP instalado correctamente."
}

# Función para iniciar XAMPP en modo gráfico
iniciar_xampp_grafico() {
    echo "Iniciando XAMPP en modo gráfico..."
    echo "$SUDO_PASSWORD" | sudo -S /opt/lampp/manager-linux-x64.run
    echo "$(date): XAMPP en modo gráfico iniciado" >> "$LOG_FILE"
    clear
    echo "✅ XAMPP en modo gráfico iniciado."
}

# Función para reinstalar XAMPP de manera limpia
reinstalar_xampp() {
    echo "ADVERTENCIA: Esta operación eliminará todos los archivos de configuración y bases de datos de XAMPP, incluidos los datos de MySQL y otros servicios que hayas configurado."
    echo "Si deseas continuar con la reinstalación limpia, presiona 1. Si deseas cancelar, presiona cualquier otra tecla."
    read -r confirmacion
    if [ "$confirmacion" == "1" ]; then
        echo "Reinstalando XAMPP..."

        # Detener XAMPP si está en ejecución
        echo "$SUDO_PASSWORD" | sudo -S /opt/lampp/lampp stop
        sleep 2

        # Eliminar XAMPP
        echo "$SUDO_PASSWORD" | sudo -S rm -rf /opt/lampp
        echo "$(date): XAMPP desinstalado" >> "$LOG_FILE"

        # Instalar XAMPP nuevamente
        instalar_xampp
    else
        echo "Reinstalación cancelada. El proceso se ha detenido."
    fi
}

# Menú principal
if ! verificar_xampp_instalado; then
    echo "¿Deseas instalar XAMPP? | 1.- Sí | 2.- No"
    read -r opcion_instalar
    case $opcion_instalar in
        1)
            instalar_xampp
            ;;
        2)
            echo "👋 Saliendo del script. ¡Adiós!"
            exit 0
            ;;
        *)
            echo "⚠️ Opción no válida. Saliendo..."
            exit 1
            ;;
    esac
fi

# Si XAMPP está instalado, mostrar el menú de operaciones
while true; do
    echo "======== GESTOR DE XAMPP ========"
    comprobar_mysql
    echo "1.- Iniciar XAMPP"
    echo "2.- Parar XAMPP"
    echo "3.- Iniciar XAMPP en modo gráfico"
    if verificar_xampp_instalado; then
        echo "4.- Reinstalar XAMPP (eliminará todos los datos)"
    fi
    echo "5.- Reiniciar XAMPP"
    echo "6.- Salir"
    echo "================================="
    read -r opcion

    case $opcion in
        1)
            iniciar_xampp
            iniciar_mysql
            ;;
        2)
            parar_xampp
            ;;
        3)
            iniciar_xampp_grafico
            ;;
        4)
            reinstalar_xampp
            ;;
        5)
            reiniciar_xampp
            ;;
        6)
            echo "👋 Saliendo del script. ¡Adiós!"
            exit 0
            ;;
        *)
            echo "⚠️ Opción no válida. Inténtalo de nuevo."
            ;;
    esac
    clear
done

