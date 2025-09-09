#!/bin/bash

# ============================
# Subdomain + Port Enumeration Script
# Autor: well0x01 (rev. melhorada)
# ============================

# Função para cores
colorize() {
    local color=$1
    shift
    echo -e "${color}$@${reset}"
}

# Cores
reset="\e[0m"
white="\e[97m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
bold="\e[1m"
purple="\e[35m"
yellow="\e[33m"

# Verificação de dependências
tools=(subfinder jq anew dnsx mapcidr naabu curl awk sort uniq)
for tool in "${tools[@]}"; do
    if ! command -v $tool &>/dev/null; then
        echo -e "${red}[!] Ferramenta não encontrada: $tool${reset}"
        exit 1
    fi
done

# Leitura do domínio (argumento ou input)
if [ -z "$1" ]; then
    read -p "Enter domain to enumerate subdomains: " domain
else
    domain=$1
fi

# Inicialização
colorize "${red}${bold}" "[+] BOOT OF WELL0X01"
start=$(date)

# Criar diretório
mkdir -p $domain

# ============================
# Enumeração de subdomínios
# ============================
colorize "${yellow}${bold}" "[+] Enumerating subdomains with Subfinder..."
subfinder -d ${domain} -all -recursive -o $domain/subfinder.txt -silent

colorize "${yellow}${bold}" "[+] Enumerating subdomains with crt.sh..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" \
| jq -r '.[].name_value' 2>/dev/null \
| sed 's/\*\.//g' | sort -u | anew $domain/cert.txt

# Combinar resultados
colorize "${blue}${bold}" "[+] Saving combined domains..."
cat $domain/subfinder.txt $domain/cert.txt | sort -u | anew $domain/domains.txt

# ============================
# Resolução DNS
# ============================
colorize "${yellow}${bold}" "[+] Resolving DNS with dnsx..."
dnsx -silent -a -resp -l $domain/domains.txt -o $domain/dnsx.txt

# ============================
# Extração de IPs e CIDR
# ============================
colorize "${yellow}${bold}" "[+] Extracting IPs and aggregating with mapcidr..."
awk '{print $3}' $domain/dnsx.txt \
| grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u \
| mapcidr -aggregate -o $domain/mapcidr.txt

# ============================
# Enumeração de portas
# ============================
colorize "${yellow}${bold}" "[+] Scanning ports with Naabu (top 100)..."
naabu -l $domain/mapcidr.txt -top-ports 100  
anew $domain/naabuIP.txt

# Finalização
end=$(date)
colorize "${green}${bold}" "[+] Recon finalizado!"
echo -e "${blue}Started: $start${reset}"
echo -e "${blue}Finished: $end${reset}"
echo -e "${purple}[+] Results stored in folder: $domain${reset}"
