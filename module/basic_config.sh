#!/bin/bash
# 设置基础配置
# cluster.ini server.ini cluster_token.txt worldgenoverride.lua
# 等配置

active=`sed -n "s/dev=\(.*\)/\1/gp" ./resources/application.properties`

foldDir=~/.klei/DoNotStarveTogether/${active}

mkdir -p $foldDir
mkdir -p ${foldDir}/Master
mkdir -p ${foldDir}/Cave

nowDir=`pwd`

cd $foldDir
touch cluster_token.txt whitelist.txt blocklist.txt adminlist.txt

cd ${nowDir}/module/properties
cp cluster.ini ${foldDir}
cp top.lua tserver.ini ${foldDir}/Master
cp down.lua dserver.ini ${foldDir}/Cave
mv ${foldDir}/Master/top.lua ${foldDir}/Master/worldgenoverride.lua
mv ${foldDir}/Master/tserver.ini ${foldDir}/Master/server.ini
mv ${foldDir}/Cave/down.lua ${foldDir}/Cave/worldgenoverride.lua
mv ${foldDir}/Cave/dserver.ini ${foldDir}/Cave/server.ini
