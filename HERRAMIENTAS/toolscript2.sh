#!/bin/bash
barra="\033[0m\e[34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
[[ ! -e /bin/tsm ]] && echo "/root/toolscript2.sh" > /bin/tsm && chmod +x /bin/tsm #ACCESO RAPIDO
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} > /dev/null 2>&1
${comando[1]} > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
IP=$(cat /etc/IP)
x="ok"
menu ()
{
#TOOL-SCRIPTS
sshplusfree () {
    apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/SSHPLUS-MANAGER-FREE/master/Plus; chmod 777 Plus; ./Plus
}

#OPCIONES DE SISTEMA
atualizar () {
echo ""
fun_bar "apt-get update -y"
fun_bar "apt-get upgrade -y"
fun_bar "service ssh restart"
rm -rf $HOME/multiscript2.sh* > /dev/null 2>&1; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/toolscript2.sh > /dev/null 2>&1
echo ""
echo -e "\033[1;33m UPDATE COM SUCESSO -\033[1;32m OK !\033[1;37m"
sleep 4s
chmod +x toolscript2.sh; ./toolscript2.sh
}
remove_multiscripts () {
rm -rf $HOME/toolscript2.sh* && rm -rf /bin/tsm
}

while true $x != "ok"
do
_usor=$(printf '%-8s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
_usop=$(printf '%-1s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
clear
echo -e "$barra"
echo -e "\E[41;1;37mTOOL-SCRIPTS MANAGER             \033[1;32m[\033[1;37m VERSAO: r001 \033[1;32m]\E[0m"
echo -e "$barra"
echo -e "\033[1;31m[\033[1;36m01\033[1;31m] \033[1;33mBadUDP                \033[1;32m(FREE) "
echo -e "\033[1;31m[\033[1;36m02\033[1;31m] \033[1;33mCapturador-IP         \033[1;32m(FREE) "
echo -e "\033[1;31m[\033[1;36m03\033[1;31m] \033[1;33mInstall-SSL           \033[1;32m(FREE) "
echo -e "\033[1;31m[\033[1;36m04\033[1;31m] \033[1;33mOpenVPN-Install       \033[1;32m(FREE) " 
echo -e "\033[1;31m[\033[1;36m05\033[1;31m] \033[1;33mSpeedtest-Python      \033[1;32m(FREE) "
echo -e "\033[1;31m[\033[1;36m06\033[1;31m] \033[1;33mSSL-SHADOWSOCKS       \033[1;32m(FREE) " 
echo -e "\033[1;31m[\033[1;36m07\033[1;31m] \033[1;33mTCP-Tweaker-1.0       \033[1;32m(FREE) "
echo -e "\033[1;31m[\033[1;36m08\033[1;31m] \033[1;33mTestador-Velocidad    \033[1;32m(FREE) "
echo -e "\033[1;31m[\033[1;36m09\033[1;31m] \033[1;33mUser-Backup-1.2       \033[1;32m(FREE) "
echo -e "$barra"
echo -e "\033[1;31m[\033[1;36m10\033[1;31m] \033[1;35m[!] \033[1;32mACTUALIZAR                \033[1;31mRam:\033[1;37m $_usor "
echo -e "\033[1;31m[\033[1;36m11\033[1;31m] \033[1;35m[!] \033[1;31mDESINSTALAR \033[1;35m[\033[1;37m TSM \033[1;35m]       \033[1;31mNucleo:\033[1;37m $_usop "
echo -e "\033[1;31m[\033[1;36m00\033[1;31m] \033[1;37mSALIR \033[1;32m<\033[1;33m<\033[1;31m<                     \033[1;37m@admmanagerfree\033[0m \033[0m"
echo -e "$barra"
echo -ne "\033[1;32mOQUE DESEJA FAZER \033[1;33m?\033[1;31m?\033[1;37m : "; read x

case "$x" in 
   1 | 01)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/BadUDP/badudp.sh; chmod +x badudp.sh; ./badudp.sh
   exit;
   ;;
   2 | 02)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/Capturador-IP/IP; chmod +x IP; ./IP
   exit;
   ;;
   3 | 03)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/Install-SSL/sslinstall.sh; chmod +x sslinstall.sh; ./sslinstall.sh
   exit;
   ;;
   4 | 04)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/OpenVPN-Install/openvpn-install.sh; chmod +x openvpn-install.sh; ./openvpn-install.sh
   exit;
   ;;
   5 | 05)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/Speedtest-Python/speedtest.py && bash speedtest.py
   exit;
   ;;      
   6 | 06)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/SSL-SHADOWSOCKS/SSL; chmod +x SSL; ./SSL
   exit;
   ;;
   7 | 07)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/TCP-Tweaker-1.0/tcptweaker.sh; chmod +x tcptweaker.sh; ./tcptweaker.sh
   exit;
   ;;
   8 | 08)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/Testador-Velocidad/velocity; chmod +x velocity; ./velocity
   exit;
   ;; 
   9 | 09)
   clear
   apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/HERRAMIENTAS/User-Backup-1.2/userbackup.sh; chmod +x userbackup.sh; ./userbackup.sh
   exit;
   ;;
   10)
   clear
   atualizar
   exit;
   ;;
   11)
   clear
   remove_multiscripts
   exit;
   ;;
   0 | 00)
echo -e "\033[1;31mSaindo...\033[0m"
sleep 2
clear
exit;
;;
*)
echo -e "\n\033[1;31mOpcao invalida !\033[0m"
esac
done
}
menu
#fim