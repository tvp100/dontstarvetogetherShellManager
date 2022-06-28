#!/bin/bash
# 安装steamCMD工具

echo "正在安装steamcmd"
sleep 1s

mkdir ~/steamCMD
cd ~/steamCMD
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
#wget http://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz --no-cookie --no-check-certificate
#cp steamcmd_linux.tar.gz ~/steamCMD
tar -xzv -f steamcmd_linux.tar.gz
