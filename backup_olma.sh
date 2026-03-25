#!/bin/bash

# Forçar o script a estar na pasta correta
cd /home/automacao/iot-stack

# Carregar variáveis com verificação (O comando IF)
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "Configurações carregadas com sucesso."
else
    echo "ERRO CRÍTICO: Arquivo .env não encontrado em $(pwd)"
    exit 1
fi

LOG="/home/automacao/backup_olma.log"
DATA_HORA=$(date +%Y%m%d_%H%M)
ARQUIVO="/home/automacao/iot-stack/backup_olma_${DATA_HORA}.tar.gz"

# timestamp no log
log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG"
}

log_msg "------------------------------------------"
log_msg "### INICIANDO BACKUP INDUSTRIAL - OLMA ###"

# 1- Pausa os containers 
log_msg "Parando containers para garantir integridade..."
sudo /usr/bin/docker compose -f /home/automacao/iot-stack/docker-compose.yml stop >> "$LOG" 2>&1

# 2- Entra na pasta para não haver erro de caminho relativo
cd /home/automacao/iot-stack/ || exit

# 3- compacta listando as pastas 
log_msg "Compactando volumes específicos..."
sudo /usr/bin/tar -cpzf "$ARQUIVO" data-mysql data-influxdb data-nodered data-grafana nginx >> "$LOG" 2>&1
sudo /usr/bin/chown automacao:automacao "$ARQUIVO"
sudo /usr/bin/chmod 644 "$ARQUIVO"
# 4- sobe os containers imediatamente
log_msg "Reiniciando containers..."
sudo /usr/bin/docker compose -f /home/automacao/iot-stack/docker-compose.yml start >> "$LOG" 2>&1
log_msg "Containers operacionais."

# 5- envia para a Estação de Trabalho
log_msg "Enviando para a Estação de Trabalho via SCP..."
# força busca do arquivo recem criado para evitar erro de variavel
ARQUIVO_RECENTE=$(/usr/bin/ls -t /home/automacao/iot-stack/backup_olma_*.tar.gz | /usr/bin/head -1)
/usr/bin/scp -P $PORTA_SSH -i /home/automacao/.ssh/id_ed25519 "$ARQUIVO_RECENTE" AUTOMAÇÃO@$IP_WINDOWS_BANCADA:"C:/Users/AUTOMAÇÃO/Documents/BackupsVolumeLinux/" >> "$LOG" 2>&1

# 6- GESTÃO DE ARQUIVOS (Manter os 2 últimos)
log_msg "Limpando backups antigos no Mini PC..."
/usr/bin/ls -t /home/automacao/iot-stack/backup_olma_*.tar.gz | /usr/bin/tail -n +3 | /usr/bin/xargs -r rm >> "$LOG" 2>&1

log_msg "### BACKUP CONCLUÍDO COM SUCESSO ###"
