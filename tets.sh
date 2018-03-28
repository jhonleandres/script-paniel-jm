#!/bin/bash

dialog --title 'Pesquisa de Banco' --inputbox "digite o Ip do Servidor: " 0 0 2>/tmp/ip

dialog --title 'Pesquisa de Banco' --passwordbox "digite a senha: " 0 0 2>/tmp/senha

dialog --title 'Pesquisa de Banco' --inputbox "Digite o Nome do Banco: " 0 0 2>/tmp/banco

host=$(cat /tmp/ip)
senha=$(cat /tmp/senha)
Banco=$(cat /tmp/banco)

mysql -u root -p$senha -h $host -e "select SCHEMA_NAME from information_schema.schemata where SCHEMA_NAME='$Banco';" > /tmp/list.txt

dialog --title 'Pesquisa de Banco' --textbox /tmp/list.txt 15 50
echo > /tmp/ip
echo > /tmp/senha
echo > /tmp/banco