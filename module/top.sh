#!/bin/bash
# 开启地上世界

active=`sed -n "s/dev=\(.*\)/\1/gp" ./resources/application.properties`

cd ~/steamapps/DST/bin
./dontstarve_dedicated_server_nullrenderer -console \
-cluster ${active} -shard Master

