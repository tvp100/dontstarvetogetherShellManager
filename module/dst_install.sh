#!/bin/bash
# 安装&更新饥荒

cd ~/steamCMD
./steamcmd.sh +login anonymous +force_install_dir ~/steamapps/DST +app_update 343050 validate +quit
