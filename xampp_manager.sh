#!/bin/bash

# Script para gestionar XAMPP
XAMPP_DIR="/opt/lampp"
XAMPP_INSTALLER="xampp-linux-x64-8.2.4-0-installer.run"
XAMPP_VERSION="8.2.4"

# Colores para el menú
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para verificar si XAMPP está instalado
verificar_xampp_instalado() {
    if [ -d "$XAMPP_DIR" ] && [ -f "$XAMPP_DIR/xampp" ]; then
        echo -e "${GREEN}✅ XAMPP está instalado.${NC}"
        return 0
    else
        echo -e "${YELLOW}❌ XAMPP no está instalado.${NC}"
        return 1
    fi
}

# Función para instalar XAMPP
instalar_xampp() {
    echo -e "${CYAN}Iniciando la instalación de XAMPP...${NC}"
    if [ ! -f "$XAMPP_INSTALLER" ]; then
        wget "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/$XAMPP_VERSION/$XAMPP_INSTALLER"
    fi
    chmod +x "$XAMPP_INSTALLER"
    sudo ./"$XAMPP_INSTALLER"
    rm "$XAMPP_INSTALLER"
    echo -e "${GREEN}✅ XAMPP instalado correctamente.${NC}"
}

# Función para desinstalar XAMPP
desinstalar_xampp() {
    echo -e "${RED}⚠️  ADVERTENCIA: Estás a punto de desinstalar XAMPP.${NC}"
    echo -e "${RED}Esto eliminará todos los archivos y configuraciones de XAMPP.${NC}"
    echo -e "${YELLOW}¿Estás seguro de que quieres continuar? (s/N)${NC}"
    read -r confirmacion
    if [[ $confirmacion =~ ^[Ss]$ ]]; then
        echo -e "${CYAN}Desinstalando XAMPP...${NC}"
        sudo "$XAMPP_DIR/uninstall"
        sudo rm -rf "$XAMPP_DIR"
        echo -e "${GREEN}✅ XAMPP ha sido desinstalado correctamente.${NC}"
    else
        echo -e "${YELLOW}Desinstalación cancelada.${NC}"
    fi
}

# Función para iniciar XAMPP
iniciar_xampp() {
    echo -e "${CYAN}Iniciando XAMPP...${NC}"
    sudo "$XAMPP_DIR/xampp" start
}

# Función para detener XAMPP
detener_xampp() {
    echo -e "${CYAN}Deteniendo XAMPP...${NC}"
    sudo "$XAMPP_DIR/xampp" stop
}

# Función para reiniciar XAMPP
reiniciar_xampp() {
    echo -e "${CYAN}Reiniciando XAMPP...${NC}"
    sudo "$XAMPP_DIR/xampp" restart
}

# Función para iniciar MySQL
iniciar_mysql() {
    echo -e "${CYAN}Iniciando MySQL...${NC}"
    echo -e "${YELLOW}Ingrese el nombre de usuario de MySQL (deje en blanco para usar root):${NC}"
    read -r mysql_user
    if [ -z "$mysql_user" ]; then
        mysql_user="root"
    fi
    sudo /opt/lampp/bin/mysql -u "$mysql_user" -p
    clear
}

# Función para mostrar logs
mostrar_logs() {
    echo -e "${CYAN}Seleccione el log que desea ver:${NC}"
    echo "1. Apache error log"
    echo "2. MySQL error log"
    echo "3. PHP error log"
    echo "4. Salir"
    echo "Selecione una opcion: "

    read -r opcion_log


    case $opcion_log in
        1) sudo tail -n 50 "$XAMPP_DIR/logs/error_log" ;;
        2) sudo tail -n 50 "$XAMPP_DIR/var/mysql/$(hostname).err" ;;
        3) sudo tail -n 50 "$XAMPP_DIR/logs/php_error_log" ;;
        4) echo "Saliendo...";;
        *) echo -e "${YELLOW}Opción no válida.${NC}" ;;
    esac
}

# Función para verificar el estado de los servicios
verificar_estado_servicios() {
    echo -e "${CYAN}Estado de los servicios:${NC}"
    sudo "$XAMPP_DIR/xampp" status
}

# Función para abrir phpMyAdmin en el navegador
abrir_phpmyadmin() {
    echo -e "${CYAN}Abriendo phpMyAdmin en el navegador...${NC}"
    xdg-open "http://localhost/phpmyadmin/" &>/dev/null
}

# Función para verificar actualizaciones
verificar_actualizaciones() {
    echo -e "${CYAN}Verificando actualizaciones de XAMPP...${NC}"
    latest_version=$(curl -s https://www.apachefriends.org/download.html | grep -oP 'XAMPP for Linux \K[0-9.]+' | head -n 1)
    if [ "$latest_version" != "$XAMPP_VERSION" ]; then
        echo -e "${YELLOW}Hay una nueva versión disponible: $latest_version${NC}"
        echo -e "${YELLOW}Tu versión actual es: $XAMPP_VERSION${NC}"
        echo -e "${YELLOW}Visita https://www.apachefriends.org/download.html para descargar la última versión.${NC}"
    else
        echo -e "${GREEN}XAMPP está actualizado a la última versión.${NC}"
    fi
}

# Función para mostrar el menú principal
mostrar_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        ${YELLOW}GESTOR DE XAMPP${CYAN}             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}XAMPP${CYAN}                              ║${NC}"
    echo -e "${CYAN}║   1. Iniciar XAMPP                 ║${NC}"
    echo -e "${CYAN}║   2. Detener XAMPP                 ║${NC}"
    echo -e "${CYAN}║   3. Reiniciar XAMPP               ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}MySQL${CYAN}                              ║${NC}"
    echo -e "${CYAN}║   4. Iniciar MySQL                 ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Monitoreo${CYAN}                          ║${NC}"
    echo -e "${CYAN}║   5. Ver logs                      ║${NC}"
    echo -e "${CYAN}║   6. Estado de servicios           ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Herramientas${CYAN}                       ║${NC}"
    echo -e "${CYAN}║   7. Abrir phpMyAdmin              ║${NC}"
    echo -e "${CYAN}║   8. Verificar actualizaciones     ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Administración${CYAN}                     ║${NC}"
    echo -e "${CYAN}║   9. Instalar/Desinstalar XAMPP    ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Otros${CYAN}                              ║${NC}"
    echo -e "${CYAN}║   0. Salir                         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Selecciona una opción:${NC} "
}

# Función para mostrar el submenú de administración
mostrar_submenu_admin() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║    ${YELLOW}ADMINISTRACIÓN DE XAMPP${CYAN}         ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║   1. Instalar XAMPP                ║${NC}"
    echo -e "${CYAN}║   2. Desinstalar XAMPP             ║${NC}"
    echo -e "${CYAN}║   3. Volver al menú principal      ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Selecciona una opción:${NC} "
}

# Menú principal
while true; do
    mostrar_menu
    read -r opcion

    case $opcion in
        1)
            if verificar_xampp_instalado; then
                iniciar_xampp
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        2)
            if verificar_xampp_instalado; then
                detener_xampp
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        3)
            if verificar_xampp_instalado; then
                reiniciar_xampp
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        4)
            if verificar_xampp_instalado; then
                iniciar_mysql
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        5)
            if verificar_xampp_instalado; then
                mostrar_logs
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        6)
            if verificar_xampp_instalado; then
                verificar_estado_servicios
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        7)
            if verificar_xampp_instalado; then
                abrir_phpmyadmin
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        8)
            if verificar_xampp_instalado; then
                verificar_actualizaciones
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        9)
            while true; do
                mostrar_submenu_admin
                read -r opcion_admin
                case $opcion_admin in
                    1)
                        if ! verificar_xampp_instalado; then
                            instalar_xampp
                        else
                            echo -e "${YELLOW}XAMPP ya está instalado.${NC}"
                        fi
                        ;;
                    2)
                        if verificar_xampp_instalado; then
                            desinstalar_xampp
                        else
                            echo -e "${YELLOW}XAMPP no está instalado.${NC}"
                        fi
                        ;;
                    3)
                        break
                        ;;
                    *)
                        echo -e "${YELLOW}Opción no válida. Por favor, intenta de nuevo.${NC}"
                        ;;
                esac
                read -p "Presiona Enter para continuar..."
            done
            ;;
        0)
            echo -e "${GREEN}Saliendo del script. ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Opción no válida. Por favor, intenta de nuevo.${NC}"
            ;;
    esac
    read -p "Presiona Enter para continuar..."
done
