#!/bin/bash
#
#
#

user=$(whiptail --title "Entrada de nome do usuário" --inputbox "Digite seu Usuário:" --fb 10 60 3>&1 1>&2 2>&3)
statussaida=$?
#if [ $statussaida = 0 ]; then
#    echo "O nome digitado foi: $nome" 
#else
#    echo "Entrada cancelada pelo usuário."
#fi

senha=$(whiptail --title "Caixa de Senha" --passwordbox "Digite sua senha." --fb 10 50 3>&1 1>&2 2>&3)
status=$?
#if [ $status = 0 ]; then
#    echo "A senha digitada foi: $senha"
#else
#    echo "Entrada cancelada."
#fi

result_user_id=`mysql -h $dbHost --user=$dbUser --password=$dbPassword --skip-column-names -e "select id from a_user where user = ${user}"`

result_senha_id=`mysql -h $dbHost --user=$dbUser --password=$dbPassword --skip-column-names -e "select txt_senha from a_user where user = ${result_user_id}"`

if [ user=result_user_id ] && [ senha=result_senha_id ]; then
	#statements

		while true
		do
		# 10=tamanho 30=tamanho 3=quantidade de opcoes
		OPCFILE="/tmp/.opcmenu"
		NOMEUS="/tmp/.nomeus"
		SENHA1="/tmp/.senha1"
		SENHA2="/tmp/.senha2"
		FDELUSER="/tmp/.deluser"
		cat /etc/passwd | cut -d: -f1 | nl > /tmp/.usuario_lista

		dialog --menu "Escolha uma opção abaixo" 10 30 3 \
		"1" "Adicionar usuario" \
		"2" "remover usuarios" \
		"3" "listar usuarios" 2> $OPCFILE
		#O direcionamento do dialog padrao é o 2>!!

		case $? in
		1)
		break ;;

		255)
		break ;;
		esac



		listar (){
		dialog --textbox /tmp/.usuario_lista 0 0
		}

		adicionar (){
		dialog --inputbox "Digite o nome do novo usuário" 7 40 2> $NOMEUS
		USERNAME=`cat $NOMEUS`

		dialog --passwordbox "Digite a senha" 0 0 2> $SENHA1
		dialog --passwordbox "Digite sua senha novamente" 0 0 2> $SENHA2

		PASSWORD=$(cat $SENHA1)
		if [ "$(cat $SENHA1)" = "$(cat $SENHA2)" ] ; then
		dialog --yesno "confirma a criação do usuario $USERNAME ?" 7 45

		case $? in
		0)
		useradd -m -d /home/$USERNAME -s /bin/bash $USERNAME
		#passwd $USERNAME --> esse comando abaixo substitiu o comando passwd e faz com que o script fique 100% dentro do dialog. Não mostra a mensagem para adicionar novamente a senha do usuario criado.!!
		echo "$USERNAME:$PASSWORD" | chpasswd
		dialog --msgbox "Usuario criado com sucesso !!" 7 50 ;;
		esac
		else
		dialog --msgbox "As senhas não conferem !!" 7 30
		fi
		}

		remover (){
		dialog --inputbox " Digite o nome do usuario a ser excluido" 7 50 2> $FDELUSER
		DELUSER=$(cat $FDELUSER)
		deluser $DELUSER

		case $? in
		0)
		dialog --msgbox "O usuario foi excluido com sucesso! " 5 40 ;;
		*)
		dialog --msgbox "Nome do usuario incorreto ou inexistente " 5 30 ;;
		esac
		}

		case $(cat $OPCFILE) in
		1)
		adicionar;;
		2)
		remover;;
		3)
		listar;;
		esac

		done

		rm -f /tmp/.usuario_lista
		rm -f "$OPCFILE"
		rm -f "$NOMEUS"
		rm -f "$SENHA1"
		rm -f "$SENHA2"
		rm -f "$FDELUSER"

fi