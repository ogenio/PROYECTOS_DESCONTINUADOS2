#!/bin/bash
Alex="/etc/cntd" && [[ ! -d ${Alex} ]] && exit
Alex >/dev/null 2>&1
clear
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit 1
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit
#
#codigo by powermx
#vpspack
trojanports=`lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN" | grep trojan | awk '{print substr($9,3); }' > /tmp/trojan.txt && echo | cat /tmp/trojan.txt | tr '\n' ' ' > /etc/trojanports.txt && cat /etc/trojanports.txt`;
psiports=`netstat -tunlp | grep psiphond | grep 0.0.0.0: | awk '{print substr($4,17); }' > /tmp/psi.txt && echo | cat /tmp/psi.txt | tr '\n' ' ' > /etc/psiports.txt && cat /etc/psiports.txt`;
clashon=`if netstat -tunlp | grep clash 1> /dev/null 2> /dev/null; then
echo -e "\e[1;32mON"
else
echo -e "\e[1;31mOFF"
fi`;

fun_ip () {
if [[ -e /etc/MEUIPADM ]]; then
IP="$(cat /etc/MEUIPADM)"
else
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
echo "$MEU_IP2" > /etc/MEUIPADM
fi
}
export fun_ip
fun_ip
clash_install(){
clear
msg -bar
echo -e "\033[1;33m $(fun_trans "Se instalará el servidor de Clash")\033[0m"
echo -e "\033[1;33m $(fun_trans "Debes tener instalado previamente") \e[32mGO Lang\033[0m"
echo -e "\033[1;33m $(fun_trans "Debes tener instalado previamente") \033[1;32mTrojan Server\033[0m"
echo -e "\033[1;33m $(fun_trans "IMPORTANTE DEBES TENER LIBRES PUERTOS") \033[1;32m7890 / 7891 / 7892 / 9090\033[0m"
msg -bar
msg -ama " SI YA TIENES INSTALADA SOLO IGNORALO"
msg -bar
read -p "desea instalar go lang [ s | n ]: " goinst  
[[ "$goinst" = "s" || "$goinst" = "S" ]] && goinst
msg -bar
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p "$(fun_trans "Desea Instalar Clash") [S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then
killall clash 1> /dev/null 2> /dev/null
msg -bar
echo -e "Δ $(fun_trans "Instalando Servidor Clash")"
msg -bar
go get -u -v github.com/Dreamacro/clash 1> /dev/null 2> /dev/null
clear
msg -bar
echo -e "Δ $(fun_trans "Creando Directorios y Archivos")"
msg -bar
mkdir /root/.config 1> /dev/null 2> /dev/null
mkdir /root/.config/clash 1> /dev/null 2> /dev/null
curl -o /root/.config/clash/config.yaml https://raw.githubusercontent.com/kirrathmx/dl/master/c.yaml 1> /dev/null 2> /dev/null
clear
msg -bar
echo -e "\033[1;33mΔ $(fun_trans "Escriba el puerto de Trojan Server")"
msg -bar
read -p "puerto: " troport
sed -i "s/puertodelservidor/$troport/g" /root/.config/clash/config.yaml
sed -i "s/ipdelservidor/$IP/g" /root/.config/clash/config.yaml
msg -bar
echo -e "\033[1;33mΔ $(fun_trans "Escriba el password de Trojan Server")"
msg -bar
read -p "password: " tropass
sed -i "s/clavedelservidor/$tropass/g" /root/.config/clash/config.yaml
msg -bar
echo -e "\033[1;33mΔ $(fun_trans "Escriba el SNI de su metodo")"
msg -bar
read -p "SNI ?: " trosni
sed -i "s/snidelmetodo/$trosni/g" /root/.config/clash/config.yaml
msg -bar
echo -e "Δ $(fun_trans "Iniciando Servidor")"
msg -bar
screen -dmS clashse clash
cp /root/.config/clash/config.yaml /var/www/html/clash.yaml
clear
msg -bar
echo -e "\033[1;33mClash Server Instalado"
echo -e "\033[1;32mRuta de Configuracion: /root/.config/clash/config.yaml"
echo -e "\033[1;32mRuta de archivo de importacion de servidor Clash: http://$IP:81/clash.yaml"
msg -bar
fi
}
trojan_install(){
clear
msg -bar
echo -e "\033[1;33m $(fun_trans "Se instalará el servidor de Trojan")\033[0m"
echo -e "\033[1;33m $(fun_trans "Si ya tenías una instalacion Previa, esta se eliminara")\033[0m"
echo -e "\033[1;33m $(fun_trans "Se instalará GO Lang") Una Ves Que Responda (s)\033[0m"
echo -e "\033[1;33m IMPORTANTE DEBES TENER LIBRES LOS PUERTOS 80 / 443\033[0m"
msg -bar
msg -ama " SI YA TIENES INSTALADA SOLO IGNORALO"
msg -bar
read -p "desea instalar go lang [ s | n ]: " goinst  
[[ "$goinst" = "s" || "$goinst" = "S" ]] && goinst
msg -bar
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p " $(fun_trans "Desea Instalar Trojan") [S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then
killall trojan
rm -rf /etc/newadm/trojancert/trojan.key &>/dev/null
rm -rf /etc/newadm/trojancert/trojan.crt
goinst
bash -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
clear
msg -bar
echo -e "Δ $(fun_trans "Generando Certificado SSL")"
msg -bar
mkdir /etc/newadm/trojancert 1> /dev/null 2> /dev/null
curl -o /usr/local/etc/trojan/config.json https://raw.githubusercontent.com/powermx/dl/master/config.json 1> /dev/null 2> /dev/null
openssl genrsa 2048 > /etc/newadm/trojancert/trojan.key
chmod 400 /etc/newadm/trojancert/trojan.key
openssl req -new -x509 -nodes -sha256 -days 365 -key /etc/newadm/trojancert/trojan.key -out /etc/newadm/trojancert/trojan.crt
msg -bar
echo -e "\033[1;37mΔ $(fun_trans "Generando Configuracion")"
sed -i '13i        "cert":"/etc/newadm/trojancert/trojan.crt",' /usr/local/etc/trojan/config.json
sed -i '14i        "key":"/etc/newadm/trojancert/trojan.key",' /usr/local/etc/trojan/config.json
msg -bar
echo -e "\033[1;33mΔ $(fun_trans "Escriba el puerto de Trojan Server")"
msg -bar
read -p "digite el puerto: " trojanport
sed -i 's/443/'$trojanport'/g' /usr/local/etc/trojan/config.json
msg -bar
echo -e "\033[1;33mΔ $(fun_trans "Escriba el password de Trojan Server")"
msg -bar
read -p "dijite su contraseña: " trojanpass
sed -i 's/conectedmx/'$trojanpass'/g' /usr/local/etc/trojan/config.json
msg -bar
echo -e "\033[1;32mΔ$(fun_trans " Iniciando Trojan Server")"
screen -dmS trojanserv trojan /usr/local/etc/trojan/config.json
clear
msg -bar
echo -e "\033[1;33mTrojan Server Instalado"
echo -e "\033[1;33mEl puerto del servidor es: \033[1;32m $trojanport"
echo -e "\033[1;33mEl password del servidor es: \033[1;32m $trojanpass"
echo -e "\033[1;33mSi necesitas cambiar el password edita el archivo o Reinstala tu servidor"
echo -e "\033[1;32mRuta de Configuracion: /usr/local/etc/trojan/config.json"
msg -bar
fi
}
psiphon_install(){
clear
msg -bar
echo -e "\033[1;33m Se instalará el servidor de Psiphon\033[0m"
echo -e "\033[1;33m Si ya tenías una instalacion Previa, esta se eliminara\033[0m"
echo -e "\033[1;33m $(fun_trans "Se instalará GO Lang") Una Ves Que Responda (s)\033[0m"
msg -bar
msg -ama " SI YA TIENES INSTALADA SOLO IGNORALO"
msg -bar
read -p "desea instalar go lang [ s | n ]: " goinst  
[[ "$goinst" = "s" || "$goinst" = "S" ]] && goinst
msg -bar
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p "Desea Instalar Psihpon [S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then
rm -rf /root/psi
kill $(ps aux | grep 'psiphond' | awk '{print $2}') 1> /dev/null 2> /dev/null
killall psiphond 1> /dev/null 2> /dev/null
cd /root
mkdir psi &>/dev/null
cd psi
psi=`cat /root/psi.txt`;
ship=$(wget -qO- ipv4.icanhazip.com)
curl -o /root/psi/psiphond https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core-binaries/master/psiphond/psiphond 1> /dev/null 2> /dev/null
chmod 777 psiphond
msg -bar
echo -e "\033[1;33m Escribe el puerto para Psiphon SSH:\033[0m"
msg -bar
read -p "SSH: " sh
msg -bar
echo -e "\033[1;33m Escribe el puerto para Psiphon OSSH:\033[0m"
read -p "OSSH: " osh
msg -bar
echo -e "\033[1;33m Escribe el puerto para Psiphon FRONTED-MEEK:\033[0m"
msg -bar
read -p "FRONTED-MEEK: " fm
msg -bar
echo -e "\033[1;33m Escribe el puerto para Psiphon UNFRONTED-MEEK:\033[0m"
msg -bar
read -p "UNFRONTED-MEEK: " umo
./psiphond --ipaddress $IP --protocol SSH:$sh --protocol OSSH:$osh --protocol FRONTED-MEEK-OSSH:$fm --protocol UNFRONTED-MEEK-OSSH:$umo generate
chmod 666 psiphond.config
chmod 666 psiphond-traffic-rules.config
chmod 666 psiphond-osl.config
chmod 666 psiphond-tactics.config
chmod 666 server-entry.dat
cat server-entry.dat >> /root/psi.txt
screen -dmS psiserver ./psiphond run
cd /root
msg -bar
echo -e "\033[1;33m LA CONFIGURACION DE TU SERVIDOR ES:\033[0m"
msg -bar
echo -e "\033[1;32m $psi \033[0m"
msg -bar
echo -e "\033[1;33m PROTOCOLOS HABILITADOS:\033[0m"
msg -bar
echo -e "\033[1;33m → SSH:\033[1;32m $sh \033[0m"
echo -e "\033[1;33m → OSSH:\033[1;32m $osh \033[0m"
echo -e "\033[1;33m → FRONTED-MEEK-OSSH:\033[1;32m $fm \033[0m"
echo -e "\033[1;33m → UNFRONTED-MEEK-OSSH:\033[1;32m $umo \033[0m"
msg -bar
echo -e "\033[1;33m DIRECTORIO DE ARCHIVOS:\033[1;32m /root/psi \033[0m"
msg -bar
fi
}

goinst(){
echo -e "A continuacion se instalara el paquete GO Lang"
echo -e "Continuar?"
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p "[S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then
echo -e "Instalando..."
cd
rm -rf /usr/local/go 1> /dev/null 2> /dev/null
wget https://golang.org/dl/go1.15.linux-amd64.tar.gz 1> /dev/null 2> /dev/null
tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz
if cat /root/.bashrc | grep GOROOT; then
echo -e "Ya existe un GoROOT - Skipping"
else
sed -i '$a export GOROOT=/usr/local/go' /root/.bashrc
sed -i '$a export GOPATH=$HOME/go' /root/.bashrc
sed -i '$a export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' /root/.bashrc
rm go1.15.linux-amd64.tar.gz
source /root/.bashrc
fi
sleep 5
echo -e "Reiniciando Fuente de Terminal..."
fi
echo -e "\033[1;33m Para finalizar el proceso de Instalacion de GO escribe :\033[0m"
echo -e "\033[1;32m source ~/.profile\033[0m"
}

dockeri(){
echo -e "A continuacion se instalara el paquete Docker"
echo -e "Continuar?"
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p "[S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then
echo -e "Instalando..."
cd
apt-get install docker.io -y 1> /dev/null 2> /dev/null
apt-get install docker-compose -y 1> /dev/null 2> /dev/null
fi

}
clear
msg -bar
echo -e "\e[1;31m	$(fun_trans "HERRAMIENTA EXTRA")\e[0m"
msg -bar
msg -ama "	PUERTAS ACTIVAS"
echo -e "\e[1;37m  TROJAN:\e[32m $trojanport  \e[37mPSIPHON:\e[32m $psiports\e[0m"
msg -bar
msg -verm2 "[ 1 ] \e[1;36m$(fun_trans "TROJAN SERVER")\e[0m"
msg -verm2 "[ 2 ] \e[1;36m$(fun_trans "PSIPHON SERVER")\e[0m"
msg -verm2 "[ 3 ] \e[1;36m$(fun_trans "CLASH SERVER") $clashon\e[0m"
msg -verm2 "[ 4 ] \e[1;33m$(fun_trans "GO LANG ")\e[0m"
#msg -verm2 "[ 5 ] \e[1;33m$(fun_trans "DOCKER")\e[0m"
msg -bar
msg -ama "[ 0 ] \e[1;36m$(fun_trans "VOLVER")\e[0m"
msg -bar
read -p "$(fun_trans "SELECIONE UNA OPCION"): " extr
case $extr in
0)
exit 0 ;;
1)
trojan_install ;;
2)
psiphon_install ;;
3)
clash_install ;;
4)
goinst ;;
#5)
#dockeri ;;
*)
msg -bar
msg -ama " POR FAVOR SELECCIONE LA OPCION CORRECTA"
msg -bar
return 0
;;
esac
#fin