#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "Authentikasi pada server"
IZIN=$( curl icanhazip.com | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permintaan Diterima...${NC}"
else
echo -e "${red}Permintaan Ditolak!${NC}";
echo "Hanya untuk pengguna terdaftar"
rm -f setup.sh
exit 0
fi
mkdir /var/lib/premium-script;
mkdir /etc/v2ray;
echo "Tolong masukan domain yang sudah dipointing agar v2ray service work"
read -p "Hostname / Domain: " host
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo "$host" >> /etc/v2ray/domain

#installer ssh Only 
cd
wget https://raw.githubusercontent.com/4hidessh/hidessh/main/berantakan/ujiv2ray.sh && chmod +x ujiv2ray.sh  && screen -S ujiv2ray.sh ./ujiv2ray.sh
sleep 3
#install websocker SSH dan Dropbear
cd
wget https://raw.githubusercontent.com/4hidessh/hidessh/main/webscoket/all-install.sh && chmod +x all-install.sh && ./all-install.sh
sleep 3
#install v2ray
wget https://raw.githubusercontent.com/4hidessh/hidessh/main/vmess/setu.sh && chmod +x setu.sh && screen -S setu.sh ./setu.sh

#install L2TP
#wget https://adiscript.vercel.app/vpn/ipsec.sh && chmod +x ipsec.sh && screen -S ipsec ./ipsec.sh
#wget https://adiscript.vercel.app/vpn/set-br.sh && chmod +x set-br.sh && ./set-br.sh

rm -f /root/ssh-vpn.sh
#rm -f /root/sstp.sh
#rm -f /root/wg.sh
#rm -f /root/ss.sh
#rm -f /root/ssr.sh
rm -f /root/ins-vt.sh
#rm -f /root/ipsec.sh
#rm -f /root/set-br.sh
cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://adiscript.vercel.app/vpn

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -O /etc/set.sh "https://adiscript.vercel.app/vpn/set.sh"
chmod +x /etc/set.sh
history -c
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=================================-Script Premium-===========================" | tee -a log-install.txt
echo " Harap Reboot Manual ! "
sleep 3
rm -f adi.sh
rm -f setup.sh
rm -f setup-opok.sh
rm -f opok.sh
