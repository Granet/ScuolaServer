#!/bin/bash

# Controllo root
if [ $USER != 'root' ]; then
echo "[/!\]Tu sei root? NO. Riprova."
exit
fi

function print_menu(){
echo""
echo -e "\n$up \e[40;38;5;82m SCELTA OPERAZIONI DA ESEGUIRE \e[0m\n"
echo ""
echo -e "\e[32;44m[1]\e[0m - Crea nuovo host con impostazioni di default."
echo -e "\e[32;44m[2]\e[0m - Crea nuovo host con impostazioni personalizzate."
echo -e "\e[32;44m[3]\e[0m - Disabilita un host temporaneamente (sarà solamente disabilitato l'host)."
echo -e "\e[32;44m[4]\e[0m - Disabilita un host permanentemente (sarà cancellato il file .conf del relativo host e disabilitato) ."
echo -e "\e[32;44m[5]\e[0m - Cancella in modo irreversibile i file di un relativo host e disabilitarlo."
echo ""
echo -e "\e[32;44m[6]\e[0m - Crea nuovo host con impostazioni di default da file."
echo -e "\e[32;44m[7]\e[0m - Disabilita un host temporaneamente (sarà solamente disabilitato l'host) da file."
echo -e "\e[32;44m[8]\e[0m - Disabilita un host permanentemente (sarà cancellato il file .conf del relativo host e disabilitato) da file."
echo -e "\e[32;44m[9]\e[0m - Cancella in modo irreversibile i file di un relativo host e disabilitarlo da file."
echo ""
echo -e "\e[32;44m[10]\e[0m - Esci dal programma"
echo -e "\e[32;44m[0]\e[0m - Crediti"
echo ""
echo -e -n "$up Inserisci scelta: "
}

function del(){
	echo "Specifica la directory del VirtualHost:"
	read directory
	rm -rf /var/www/$directory/
}

function user_default(){
	echo "Inserisci nome del VirtualHost: "
	read nome

	mkdir /var/www/$nome
	VIRTUAL="
	<VirtualHost *:80>\n
        ServerName $nome.fermi.local\n
        ServerAlias $nome\n
        DocumentRoot /var/www/$nome/\n
        Alias /phpmyadmin /usr/share/phpmyadmin\n
	</VirtualHost>
	"
	echo -e $VIRTUAL > /etc/apache2/sites-available/$nome
	a2ensite $nome
	service apache2 reload && echo -e "\e[42m Il VirtualHost $nome è stato abilitato con successo! \e[0m"
	sleep 2
}

function user_customize(){
	echo "Inserisci nome del VirtualHost:"
	read nome
	echo "Inserisci percorso directory del VirtualHost:"
	read directory

	mkdir directory
	VIRTUAL="
	<VirtualHost *:80>\n
        ServerName $nome.fermi.local\n
        ServerAlias $nome\n
        DocumentRoot $directory\n
        Alias /phpmyadmin /usr/share/phpmyadmin\n
	</VirtualHost>
	"
	echo -e $VIRTUAL > /etc/apache2/sites-available/$nome
	a2ensite $nome
	echo ""
	service apache2 reload && echo -e "\e[42m Il VirtualHost $nome è stato abilitato con successo! \e[0m"
	sleep 2
}

function dis_temp(){
	echo "Inserisci nome del VirtualHost da disabilitare temporaneamente:"
	read nome
	a2dissite $nome
	service apache2 reload && echo -e "\e[42m Il VirtualHost $nome è stato disabilitato temporaneamente con successo! \e[0m"
	sleep 2
}

function dis_perm(){
	echo "Inserisci nome del VirtualHost da disabilitare permanentemente:"
	read nome
	a2dissite $nome
	rm -rf /etc/apache2/sites-available/$nome
	service apache2 reload && echo -e "\e[42m Il VirtualHost $nome è stato disabilitato permanentemente con successo! \e[0m"
	sleep 2
}

function delete_perm(){
	echo "Inserisci nome del VirtualHost da cancellare irreversibilmente:"
	read nome
	a2dissite $nome
	rm -rf /etc/apache2/sites-available/$nome
	rm -rf /var/www/$nome/ || echo -e "\e[31mDirectory non trovata, inserisci la directory perfavore! \e[0m" del
	service apache2 reload && echo -e "\e[42m Il VirtualHost $nome è stato cancellato irreversibilmente con successo! \e[0m"
	sleep 2
}

function user_default_file(){
	while read LINE
		do
		mkdir /var/www/$LINE
		VIRTUAL="
		<VirtualHost *:80>\n
	        ServerName $LINE.fermi.local\n
	        ServerAlias $LINE\n
	        DocumentRoot /var/www/$LINE/\n
	        Alias /phpmyadmin /usr/share/phpmyadmin\n
		</VirtualHost>
		"
		echo -e $VIRTUAL > /etc/apache2/sites-available/$LINE
		a2ensite $LINE
		service apache2 reload && echo -e "\e[42m Il VirtualHost $LINE è stato abilitato con successo! \e[0m"
		done < users.txt
}

function dis_temp_file(){
	while read LINE
		do
		a2dissite $LINE
		rm -rf /etc/apache2/sites-available/$LINE
		rm -rf /var/www/$LINE/ || echo -e "\e[31mDirectory non trovata, inserisci la directory perfavore! \e[0m" del
		service apache2 reload && echo -e "\e[42m Il VirtualHost $LINE è stato cancellato irreversibilmente con successo! \e[0m"
		done < users.txt
}

function dis_perm_file(){
	while read LINE
		do
		a2dissite $LINE
		rm -rf /etc/apache2/sites-available/$LINE
		service apache2 reload && echo -e "\e[42m Il VirtualHost $LINE è stato disabilitato permanentemente con successo! \e[0m"
		done < users.txt
}

function delete_perm_file(){
	while read LINE
		do
		a2dissite $LINE
		rm -rf /etc/apache2/sites-available/$LINE
		rm -rf /var/www/$LINE/ || echo -e "\e[31mDirectory non trovata, inserisci la directory perfavore! \e[0m" del
		service apache2 reload && echo -e "\e[42m Il VirtualHost $LINE è stato cancellato irreversibilmente con successo! \e[0m"
		done < users.txt
}

function credits(){
	clear
	echo -e "\e[43mScript realizzato da Francesco Russo aka(Granet) anno 2015-2016 V B Informatica. Progetto scolastico abbbusivo in compagnia del Prof. Saro Messina e del collega Concetto Pollicina\e[0m"
	echo ""
	echo -e "\e[41m Premi INVIO per continuare...\e[0m"
	read
}


selection=
until [ "$selection" = "11" ]; do
print_menu
read selection
echo ""
case $selection in
1 ) user_default;clear;print_menu ;;
2 ) user_customize;clear;print_menu ;;
3 ) dis_temp;clear;print_menu ;;
4 ) dis_perm;clear;print_menu ;;
5 ) delete_perm;clear;print_menu ;;
6 ) user_default_file;clear;print_menu ;;
7 ) dis_temp_file;clear; print_menu ;;
8 ) dis_perm_file;clear;print_menu ;;
9 ) delete_perm_file;clear;print_menu ;;
0 ) credits;clear;print_menu ;;
10 ) exit ;;
* ) echo -e "Per favore inserisci 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 o 0"
esac
done
