# DeepSight - Reconnaissance Automation Script

Este é um script de automação de reconhecimento desenvolvido por **well0x01**. Ele realiza a enumeração de subdomínios, resolução DNS, CIDR e portas abertas de forma automatizada, utilizando diversas ferramentas poderosas.

## Ferramentas Necessárias

Para que o script funcione corretamente, você precisará instalar as seguintes ferramentas:

1. **Subfinder** - Ferramenta para descobrir subdomínios.
2. **crt.sh** - Interface web para consulta de certificados SSL.
3. **dnsx** - Ferramenta para resolução de DNS.
4. **mapcidr** - Ferramenta para manipulação e agregação de CIDR.
5. **naabu** - Scanner de portas TCP de alto desempenho.
6. **jq** - Processador de JSON leve e flexível.
7. **anew** - Ferramenta para gerenciamento de listas de forma eficiente.

### Instalação das Ferramentas

No Linux, você pode instalar as ferramentas usando os seguintes comandos:

```bash
# Instalação de Subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Instalação de dnsx
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

# Instalação de mapcidr
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

# Instalação de naabu
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# Instalação de jq
sudo apt-get install jq -y

# Instalação de anew
go install -v github.com/tomnomnom/anew@latest
```

## Uso

```bash
chmod +x deepsight.sh
./deepsight.sh
```

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para enviar um pull request ou abrir uma issue para melhorias e correções.

## Créditos

Desenvolvido por well0x01.


![recon results](https://github.com/well0x01/recon.sh/blob/main/results-recon-sh.png)
