#!/bin/bash

# Script para gestionar XAMPP
XAMPP_DIR="/opt/lampp"
XAMPP_INSTALLER="xampp-linux-x64-8.2.4-0-installer.run"

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
        wget "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.4/$XAMPP_INSTALLER"
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

# Función para iniciar MySQL
iniciar_mysql() {
    echo -e "${CYAN}Iniciando MySQL...${NC}"
    sudo /opt/lampp/bin/mysql 
    clear
}



# Función para mostrar el menú principal
mostrar_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        ${YELLOW}GESTOR DE XAMPP${CYAN}             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}XAMPP${CYAN}                               ║${NC}"
    echo -e "${CYAN}║   1. Iniciar XAMPP                 ║${NC}"
    echo -e "${CYAN}║   2. Detener XAMPP                 ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}MySQL${CYAN}                               ║${NC}"
    echo -e "${CYAN}║   3. Iniciar MySQL                 ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Administración${CYAN}                      ║${NC}"
    echo -e "${CYAN}║   4. Instalar/Desinstalar XAMPP    ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}Otros${CYAN}                               ║${NC}"
    echo -e "${CYAN}║   5. Salir                         ║${NC}"
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
                iniciar_mysql
            else
                echo -e "${YELLOW}XAMPP no está instalado. Instálalo primero.${NC}"
            fi
            ;;
        4)
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
        5)
            echo -e "${GREEN}Saliendo del script. ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Opción no válida. Por favor, intenta de nuevo.${NC}"
            ;;
    esac
    read -p "Presiona Enter para continuar..."
done
