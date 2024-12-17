#!/bin/bash

# Script para gestionar XAMPP
XAMPP_DIR="/opt/lampp"
XAMPP_INSTALLER="xampp-linux-x64-8.2.4-0-installer.run"

# Colores para el menú
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
        wget "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.4/$XAMPP_INSTALLER"
    fi
    chmod +x "$XAMPP_INSTALLER"
    sudo ./"$XAMPP_INSTALLER"
    rm "$XAMPP_INSTALLER"
    echo -e "${GREEN}✅ XAMPP instalado correctamente.${NC}"
}

# Función para iniciar XAMPP
iniciar_xampp() {
    echo -e "${CYAN}Iniciando XAMPP...${NC}"
    sudo /opt/lampp/bin/mysql start
}

# Función para detener XAMPP
detener_xampp() {
    echo -e "${CYAN}Deteniendo XAMPP...${NC}"
    sudo "$XAMPP_DIR/xampp" stop
}

# Función para iniciar MySQL
iniciar_mysql() {
    echo -e "${CYAN}Iniciando MySQL...${NC}"
    sudo "$XAMPP_DIR/xampp" startmysql
}

# Función para detener MySQL
detener_mysql() {
    echo -e "${CYAN}Deteniendo MySQL...${NC}"
    sudo "$XAMPP_DIR/xampp" stopmysql
}

# Función para mostrar el menú principal
mostrar_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        ${YELLOW}GESTOR DE XAMPP${CYAN}             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}XAMPP${CYAN}                               ║${NC}"
    echo -e "${CYAN}║   1. Instalar XAMPP                ║${NC}"
    echo -e "${CYAN}║   2. Iniciar XAMPP                 ║${NC}"
    echo -e "${CYAN}║   3. Detener XAMPP                 ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}MySQL${CYAN}                               ║${NC}"
    echo -e "${CYAN}║   4. Iniciar MySQL                 ║${NC}"
    echo -e "${CYAN}║   5. Detener MySQL                 ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Otros${CYAN}                               ║${NC}"
    echo -e "${CYAN}║   6. Salir                         ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Selecciona una opción:${NC} "
}

# Menú principal
while true; do
    mostrar_menu
    read -r opcion

    case $opcion in
        1)
            if ! verificar_xampp_instalado; then
                instalar_xampp
            else
                echo -e "${YELLOW}XAMPP ya está instalado.${NC}"
            fi
            ;;
        2)
            if verificar_xampp_instalado; then
                iniciar_xampp
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        3)
            if verificar_xampp_instalado; then
                detener_xampp
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
                detener_mysql
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        6)
            echo -e "${GREEN}Saliendo del script. ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Opción no válida. Por favor, intenta de nuevo.${NC}"
            ;;
    esac
    read -p "Presiona Enter para continuar..."
done


