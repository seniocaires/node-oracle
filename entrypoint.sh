#!bin/bash

echo "Configurando variáveis de ambiente"
printenv | grep -v "no_proxy" >> /etc/environment

echo "Iniciando Cron"
cron -f

echo "Container iniciado"
tail -f /dev/null
