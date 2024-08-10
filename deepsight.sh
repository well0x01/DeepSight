#!/bin/bash

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

# Leitura do domínio
colorize "${green}${bold}" "Enter domain to enumerate subdomains:- "
read domain

# Inicialização
colorize "${red}${bold}" "[+] BOOT OF WELL0X01"

# Criar diretório
if [ ! -d "$domain" ]; then
    mkdir $domain
fi

# Enumeração de subdomínios
colorize "${yellow}${bold}" "[+] Enumerating subdomains with Subfinder..."
subfinder -d ${domain} -all -recursive -o $domain/subfinder.txt -silent

# Enumeração Cert.sh
colorize "${yellow}${bold}" "[+] Enumerating subdomains with crt.sh..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | anew $domain/cert.txt

# Combinando resultados
colorize "${blue}${bold}" "Domains saved at $domain/domains.txt..."
cat $domain/subfinder.txt $domain/cert.txt | anew $domain/domains.txt

# Enumeração DNS
colorize "${yellow}${bold}" "[+] Enumerating DNS with dnsx..."
cat ${domain}/domains.txt | dnsx -silent -a -resp-only -o $domain/dnsx.txt

# Enumeração CIDR
colorize "${yellow}${bold}" "[+] Enumerating CIDR with mapcidr..."
mapcidr -cl $domain/dnsx.txt -silent -aggregate -o $domain/mapcidr.txt

# Enumeração Naabu
colorize "${yellow}${bold}" "[+] Enumerating open ports with Naabu..."
naabu -l $domain/mapcidr.txt -p 80,81,82,88,135,143,300,443,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152 -silent -sa | anew $domain/naabuIP.txt
