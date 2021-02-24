#!/bin/bash
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )
barra="\033[0m\e[34m======================================================\033[1;37m"
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit
LIST="lista-arq"
BASICINST="ADMbot.sh apacheon.sh blockBT.sh budp.sh Crear-Demo.sh C-SSR.sh dns-netflix.sh dropbear.sh fai2ban.sh gestor.sh menu message.txt openvpn.sh paysnd.sh PDirect.py PGet.py POpen.py ports.sh PPriv.py PPub.py shadowsocks.sh Shadowsocks-libev.sh Shadowsocks-R.sh sockspy.sh speed.sh speedtest.py squid.sh squidpass.sh ssl.sh tcp.sh ultrahost Unlock-Pass-VULTR.sh usercodes utils.sh v2ray.sh"
FERNINST="menu message.txt ADMbot.sh PGet.py usercodes sockspy.sh POpen.py PPriv.py PPub.py PDirect.py speedtest.py speed.sh utils.sh dropbear.sh apacheon.sh openvpn.sh shadowsocks.sh ssl.sh squid.sh"
IVAR="/etc/http-instas"
IVAR2="/bin/http-server.sh"
IVAR3="/etc/keys-act"
SCPT_DIR="/etc/SCRIPT"
DIR="/etc/http-shell"
LIST="lista-arq"
LOG="/bin/gerar-sh-log"
[[ ! -e ${LOG} ]] && touch $LOG
[[ ! -e ${IVAR3} ]] && touch $IVAR3
[[ ! -e ${SCPT_DIR} ]] && mkdir ${SCPT_DIR}
wget -O $IVAR2 https://www.dropbox.com/s/hn66taw5qdi6gwa/http-server.sh?dl=0 > /dev/null 2>&1 && chmod 777 $IVAR2
[[ ! -e /usr/bin/trans ]] && wget -O /usr/bin/trans http://git.io/trans &> /dev/null
fun_trans () { 
local texto
local retorno
declare -A texto
SCPidioma="${SCPdir}/idioma"
[[ ! -e ${SCPidioma} ]] && touch ${SCPidioma}
local LINGUAGE=$(cat ${SCPidioma})
[[ -z $LINGUAGE ]] && LINGUAGE=es
[[ ! -e /etc/texto-adm ]] && touch /etc/texto-adm
source /etc/texto-adm
if [[ -z "$(echo ${texto[$@]})" ]]; then
 retorno="$(source trans -e google -b es:${LINGUAGE} "$@"|sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
 if [[ $retorno = "" ]];then
 retorno="$(source trans -e bing -b es:${LINGUAGE} "$@"|sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
 fi
 if [[ $retorno = "" ]];then 
 retorno="$(source trans -e yandex -b es:${LINGUAGE} "$@"|sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
 fi
echo "texto[$@]='$retorno'"  >> /etc/texto-adm
echo "$retorno"
else
echo "${texto[$@]}"
fi
}
meu_ip () {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
}
ofus () {
unset txtofus
number=$(expr length $1)
for((i=1; i<$number+1; i++)); do
txt[$i]=$(echo "$1" | cut -b $i)
case ${txt[$i]} in
".")txt[$i]="+";;
"+")txt[$i]=".";;
"1")txt[$i]="@";;
"@")txt[$i]="1";;
"2")txt[$i]="?";;
"?")txt[$i]="2";;
"3")txt[$i]="%";;
"%")txt[$i]="3";;
"/")txt[$i]="K";;
"K")txt[$i]="/";;
esac
txtofus+="${txt[$i]}"
done
echo "$txtofus" | rev
}
fun_list () {
unset KEY
KEY="$valuekey"
#CRIA DIR
[[ ! -e ${DIR} ]] && mkdir ${DIR}
[[ ! -e ${DIR}/${KEY} ]] && mkdir ${DIR}/${KEY}
#ADM BASIC
arqslist="$BASICINST"
for arqx in `echo "${arqslist}"`; do
[[ -e ${DIR}/${KEY}/$arqx ]] && continue #ANULA ARQUIVO CASO EXISTA
cp ${SCPT_DIR}/$arqx ${DIR}/${KEY}/
echo "$arqx" >> ${DIR}/${KEY}/${LIST}
done
echo "$nombrevalue" > ${DIR}/${KEY}.name
[[ ! -z $IPFIX ]] && echo "$IPFIX" > ${DIR}/${KEY}/keyfixa
}
gerar_key () {
while [[ ${nombrevalue} = "" ]]; do
read -p " $(fun_trans "Nombre de usuario de las keys"): " nombrevalue
tput cuu1 && tput dl1
done
while [[ ${int} != +([0-9]) ]]; do
read -p " $(fun_trans "Cantidad de keys a generar"): " int
tput cuu1 && tput dl1
done
i=0
echo -e "\033[1;32m $(fun_trans "Generando") ${int} keys a ${nombrevalue} "
echo -e "$barra"
while true; do
[[ $i = $int ]] && break
valuekey="$(date | md5sum | head -c10)"
valuekey+="$(echo $(($RANDOM*10))|head -c 5)"
fun_list "$valuekey"
keyfinal=$(ofus "$IP:8888/$valuekey/$LIST")
echo -e "\033[1;33m KEY: \033[1;37m$keyfinal"
let i=i+1
done
echo -e "$barra"
}
gerar_key_fixa () {
while [[ ${nombrevalue} = "" ]]; do
read -p " $(fun_trans "Nombre de usuario de la key"): " nombrevalue
tput cuu1 && tput dl1
done
while [[ ${IPFIX} != +([0-9.]) ]]; do
read -p " $(fun_trans "IP de usuario"): " IPFIX
tput cuu1 && tput dl1
done
nombrevalue+=[FIXA]
echo -e "\033[1;32m $(fun_trans "Generando") key fija a ${nombrevalue} con IP ${IPFIX}"
echo -e "$barra"
valuekey="$(date | md5sum | head -c10)"
valuekey+="$(echo $(($RANDOM*10))|head -c 5)"
fun_list "$valuekey"
keyfinal=$(ofus "$IP:8888/$valuekey/$LIST")
echo -e "\033[1;33m KEY: \033[1;37m$keyfinal"
echo "$keyfinal" >> $IVAR3
echo -e "$barra"
}
gerar_key_ferm () {
unset KEY
valuekey="$(date | md5sum | head -c10)"
valuekey+="$(echo $(($RANDOM*10))|head -c 5)"
KEY="$valuekey"
#CRIA DIR
[[ ! -e ${DIR} ]] && mkdir ${DIR}
[[ ! -e ${DIR}/${KEY} ]] && mkdir ${DIR}/${KEY}
i=0
for arqx in `ls ${SCPT_DIR}`; do
[[ $(echo $FERNINST|grep -w "${arqx}") ]] && continue
echo -e "\033[1;32m [$i] > \033[1;33m$(fun_trans "HERRAMIENTA") \033[1;31m[${arqx}]\033[0m"
arq_list[$i]="${arqx}"
let i++
done
let i=i-1
echo -e "$barra"
while [[ ${readvalue} != +([0-$i]) ]]; do
read -p " $(fun_trans "Digite una opción"): " readvalue
tput cuu1 && tput dl1
done
for arqx in `echo "${readvalue}"`; do
 #UNE ARQ
 [[ -e ${DIR}/${KEY}/${arq_list[$arqx]} ]] && continue #ANULA ARQUIVO CASO EXISTA
 cp ${SCPT_DIR}/${arq_list[$arqx]} ${DIR}/${KEY}/
 echo "${arq_list[$arqx]}" >> ${DIR}/${KEY}/${LIST}
 done
echo "TRUE" >> ${DIR}/${KEY}/FERRAMENTA
keyfinal=$(ofus "$IP:8888/$valuekey/$LIST")
echo "[HERRAMIENTA]" > ${DIR}/${KEY}.name
echo -e "\033[1;33m KEY: \033[1;37m$keyfinal"
echo -e "$barra"
}
remover_key () {
i=0
[[ -z $(ls $DIR|grep -v "ERROR-KEY") ]] && exit
echo -e " [$i] Retornar"
keys="$keys retorno"
let i++
for arqs in `ls $DIR|grep -v "ERROR-KEY"|grep -v ".name"`; do
arqsx=$(ofus "$IP:8888/$arqs/$LIST")
if [[ $(cat ${DIR}/${arqs}.name|grep FIXA) ]]; then 
echo -e "\033[1;33m [$i] $arqsx ($(cat ${DIR}/${arqs}.name))\033[1;32m ($(cat ${DIR}/${arqs}/keyfixa))\033[1;37m" 
else 
[[ $(cat ${DIR}/${arqs}.name|grep HERRAMIENTA) ]] && echo -e "\033[1;36m [$i] $arqsx ($(cat ${DIR}/${arqs}.name))\033[1;37m" || echo -e "\033[1;37m [$i] $arqsx ($(cat ${DIR}/${arqs}.name))"
fi
keys="$keys $arqs"
let i++
done
keys=($keys)
echo -e "$barra"
while [[ -z ${keys[$value]} || -z $value ]]; do
read -p " $(fun_trans "Elija una key a eliminar"): " value
tput cuu1 && tput dl1
done
[[ $value = "0" ]] && exit
if [[ $(cat ${DIR}/${keys[$value]}.name|grep FIXA) ]]; then 
arqsx=$(ofus "$IP:8888/${keys[$value]}/$LIST")
num=$(sed -n "/${arqsx}/"= $IVAR3)
[[ ${num} = "" ]] || sed -i "$num""d" $IVAR3
fi
[[ -d "$DIR/${keys[$value]}" ]] && rm -rf $DIR/${keys[$value]}* || exit
}
atualizar_keyfixa () {
i=0
[[ -z $(ls $DIR|grep -v "ERROR-KEY") ]] && exit
for arqs in `ls $DIR|grep -v "ERROR-KEY"|grep -v ".name"`; do
 if [[ $(cat ${DIR}/${arqs}.name|grep FIXA) ]]; then #Keyfixa Atualiza
   for arqx in `echo "${BASICINST}"`; do
    cp ${SCPT_DIR}/$arqx ${DIR}/${arqs}/$arqx
   done
 arqsx=$(ofus "$IP:8888/$arqs/$LIST")
 echo -e "\033[1;33m[KEY]: $arqsx \033[1;32m($(fun_trans "KEY FIJA ACTUALIZADA")!)\033[1;37m"
 fi
let i++
done
echo -e "$barra"
}
start_gen () {
unset PIDGEN
PIDGEN=$(ps aux|grep -v grep|grep "http-server.sh")
if [[ ! $PIDGEN ]]; then
screen -dmS generador /bin/http-server.sh -start
else
killall http-server.sh
fi
}
message_gen () {
read -p " $(fun_trans "Nuevo mensaje"): " MSGNEW
echo "$MSGNEW" > ${SCPT_DIR}/message.txt
echo -e "$barra"
}
log_fun () {
echo -e "\033[1;31m $(fun_trans "KEY FIJAS BLOQUEADAS ")!" 
echo -e "$barra"
while read key; do
arqsu=$(echo $(ofus "$key") | sed -e "s/$IP\|$LIST//g" | sed 's/:8888\|.$\|^.//g' | sed 's/^.//g'  )
[[ ! -d ${DIR}/${arqsu} ]] && echo -e "\033[1;33m KEY: \033[1;37m$key "
done < $IVAR3
echo -e "$barra"
}
atualizar_repo () {
echo -e "\033[1;33m $(fun_trans "Actualizando repositorio NEW ADM")"
(
wget -O /root/SCRIPT.tar.gz https://www.dropbox.com/s/72q7sv0nr7108ir/SCRIPT.tar.gz > /dev/null 2>&1 
tar xvfz /root/SCRIPT.tar.gz > /dev/null 2>&1 
cp -a /root/SCRIPT/. /etc/SCRIPT/ > /dev/null 2>&1 
rm -rf /root/SCRIPT.tar.gz > /dev/null 2>&1 
rm -rf /root/SCRIPT > /dev/null 2>&1
) && echo -e "$barra\n\033[1;32m $(fun_trans "Repositorio actualizado")!" || echo -e "$barra\n\033[1;31m $(fun_trans "Error al actualizar repositorio")!"
echo -e "$barra"
}
fun_gerar () {
meu_ip
unset PID_GEN
PID_GEN=$(ps x|grep -v grep|grep "http-server.sh")
[[ ! $PID_GEN ]] && PID_GEN="\033[1;31moff" || PID_GEN="\033[1;32monline"
echo -e "\033[1;32m        KEY GENERADOR VPS-MX"
echo -e "\033[1;33m               $(fun_trans "INSTALACIONES"): $(cat $IVAR)"
echo -e "$barra"
echo -e "\033[1;37m $(fun_trans "Directorio de archivos principales") \033[1;31m${SCPT_DIR}\033[0m"
echo -e "$barra"
echo -e "\033[1;32m [1] > \033[1;36m$(fun_trans "GENERAR KEYS ALEATORIA")"
echo -e "\033[1;32m [2] > \033[1;36m$(fun_trans "GENERAR KEY FIJA")"
echo -e "\033[1;32m [3] > \033[1;36m$(fun_trans "GENERAR KEY DE HERRAMIENTAS")"
echo -e "\033[1;32m [4] > \033[1;36m$(fun_trans "ELIMINAR KEYS")"
echo -e "\033[1;32m [5] > \033[1;36m$(fun_trans "VER LOG") \033[1;31m($(fun_trans "KEY FIJAS BLOQUEADAS"))"
echo -e "\033[1;32m [6] > \033[1;36m$(fun_trans "VER LOG") \033[1;31m($(fun_trans "REGISTRO"))"
echo -e "\033[1;32m [7] > \033[1;36m$(fun_trans "INICIAR - DETENER") KEYGEN $PID_GEN\033[0m"
echo -e "\033[1;32m [8] > \033[1;36m$(fun_trans "CAMBIAR MENSAJE")"
echo -e "\033[1;32m [9] > \033[1;36m$(fun_trans "ACTUALIZAR KEY FIJAS")"
echo -e "\033[1;32m [10] > \033[1;36m$(fun_trans "ACTUALIZAR REPOSITORIO") \033[1;31m${SCPT_DIR}"
echo -e "\033[1;32m [0] > \033[1;36m$(fun_trans "SALIR")"
echo -e "$barra"
while [[ ${varread} != @([0-9]|10) ]]; do
read -p "$(fun_trans "Digite una opción"): " varread
tput cuu1 && tput dl1
done
if [[ ${varread} = 1 ]]; then
gerar_key
elif [[ ${varread} = 2 ]]; then
gerar_key_fixa
elif [[ ${varread} = 3 ]]; then
gerar_key_ferm
elif [[ ${varread} = 4 ]]; then
remover_key
elif [[ ${varread} = 5 ]]; then
log_fun
elif [[ ${varread} = 6 ]]; then
echo -ne "\033[1;36m"
cat /bin/gerar-sh-log
echo -e "$barra"
exit
elif [[ ${varread} = 7 ]]; then
start_gen
elif [[ ${varread} = 8 ]]; then
message_gen
elif [[ ${varread} = 9 ]]; then
atualizar_keyfixa
elif [[ ${varread} = 10 ]]; then
atualizar_repo
elif [[ ${varread} = 0 ]]; then
exit 0
fi
}
fun_gerar