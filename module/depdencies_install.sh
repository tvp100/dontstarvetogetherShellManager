#!/bin/bash
# 安装glibc.i686 libstdc++.i686依赖
# 有了这个依赖才能运行steamCMD

echo -e "\e[1;31m正在安装glibc和libstdc++依赖\e[0m"
sleep 1s

typeset -l IsUbuntu
IsUbuntu=`cat /etc/issue`
echo $IsUbuntu
if [[ "$IsUbuntu" =~ "ubuntu" ]]; then
	dpkg --add-architecture i386
	apt-get -y
	apt-get install -y lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 screen
else
	yum update -y
	yum install -y glibc.i686 libstdc++.i686 screen libcurl.i686
fi
