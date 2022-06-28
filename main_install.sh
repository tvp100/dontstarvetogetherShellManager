#!/bin/bash
# 安装饥荒的主程序

mainMode=
dstInstallMode=
dstManageMode=
dstConfigMode=
cluster_token=
uninstallMode=
storeManageMode=
modManageMode=

activeWorld=`sed -n "s/dev=\(.*\)/\1/gp" ./resources/application.properties`
preMainDir="${HOME}/.klei/DoNotStarveTogether"
useDir="${preMainDir}/${activeWorld}"
modDir="${HOME}/steamapps/DST/mods"


KU_ID=
had_KU_ID=
KU_MOD=
had_KU_MOD=
cluster_name=
cluster_description=
cluster_password=
max_players=
Imark=
YMark=
topStatus=
downStatus=
Iactive=

function getBriefInfo() {
	cluster_name=`sed -n "s/cluster_name = \(.*\)/\1/gp" ${useDir}/cluster.ini`
	echo -e "\e[1;36m***************\e[0m"
	echo -e "当前激活的世界:${cluster_name}"
	topStatus=`screen -ls | grep "topWorld" >> /dev/null && echo "success" || echo "failure"`
	downStatus=`screen -ls | grep "downWorld" >> /dev/null && echo "success" || echo "failure"`
	echo -e "服务器运行状态"
	if [ $topStatus == "success" ]
	then
		echo -e "地上世界:\e[1;32m正在运行\e[0m"
	else
		echo -e "地上世界:\e[1;31m已停止\e[0m"
	fi
	if [ $downStatus == "success" ]
	then
		echo -e "地下世界:\e[1;32m正在运行\e[0m"
	else
		echo -e "地下世界:\e[1;31m已停止\e[0m"
	fi
	echo -e "\e[1;36m***************\e[0m"
}


function getStatusInfo() {
	cluster_name=`sed -n "s/cluster_name = \(.*\)/\1/gp" ${useDir}/cluster.ini`
	cluster_description=`sed -n "s/cluster_description = \(.*\)/\1/gp" "${useDir}"/cluster.ini`
	cluster_password=`sed -n "s/cluster_password = \(.*\)/\1/gp" ${useDir}/cluster.ini`
	max_players=`sed -n "s/max_players = \(.*\)/\1/gp" ${useDir}/cluster.ini`
	echo -e "\e[1;36m***************\e[0m"
	echo -e "当前激活的世界:${cluster_name}"
	echo -e "世界标记:${activeWorld}"
	echo -e "世界名称:${cluster_name}"
	echo -e "世界描述:${cluster_description}"
	echo -e "密码:${cluster_password}"
	echo -e "最大人数:${max_players}"
	echo -e "\e[1;36m***************\e[0m"
	topStatus=`screen -ls | grep "topWorld" >> /dev/null && echo "success" || echo "failure"`
	downStatus=`screen -ls | grep "downWorld" >> /dev/null && echo "success" || echo "failure"`
	echo -e "服务器运行状态"
	if [ $topStatus == "success" ]
	then
		echo -e "地上世界:\e[1;32m正在运行\e[0m"
	else
		echo -e "地上世界:\e[1;31m已停止\e[0m"
	fi
	if [ $downStatus == "success" ]
	then
		echo -e "地下世界:\e[1;32m正在运行\e[0m"
	else
		echo -e "地下世界:\e[1;31m已停止\e[0m"
	fi
}


function getMark() {
	echo "请输入一个标记--------------这个是你存档的文件夹名"
	echo -e "标记是 \e[1;31m唯一\e[0m 的,请不要输入已有的标记"
	echo "请务必输入正确, 不能为空"
	echo -e "\e[1;31m注意只能是英文的\e[0m"
	read -p "请输入:" Imark
	read -p "确定标记输入正确(保证是全英文的)?[Y/y]" YMark
	if [ $YMark == Y ] || [ $YMark == y ]
	then
		sed -i "s/\(dev\).*/\1=${Imark}/g" ./resources/application.properties
		activeWorld=$Imark
		useDir="${preMainDir}/${activeWorld}"
	else
		echo -e "退出执行,你可以在 \e[1;31m5.管理存档\e[0m 中重新开始"
		exit 0
	fi
}

function changeClusterName() {
	echo "输入你的世界名称"
	read -p "请输入:" cluster_name
	sed -i "s/\(cluster_name\).*/\1 = ${cluster_name}/g" ${useDir}/cluster.ini
	sed -i "/${activeWorld}=/d" ./resources/application.properties
	echo "${activeWorld}=${cluster_name}" >> ./resources/application.properties 
}

function changeClusterDescription() {
	echo "输入你的世界描述"
	read -p "请输入:" cluster_description
	sed -i "s/\(cluster_description\).*/\1 = ${cluster_description}/g" ${useDir}/cluster.ini
}

function changePassword() {
	echo "输入你的密码"
	read -p "请输入:" cluster_password
	sed -i "s/\(cluster_password\).*/\1 = ${cluster_password}/g" ${useDir}/cluster.ini
}

function changeMaxPlayers() {
	echo "输入你的最大人数"
	read -p "请输入:" max_players
	sed -i "s/\(max_players\).*/\1 = ${max_players}/g" ${useDir}/cluster.ini
}

function getToken() {
	read -p "请输入token:" cluster_token
	echo $cluster_token > ${useDir}/cluster_token.txt
}

function dstInstall(){
	echo -e "\e[1;31m请先安装glibc等依赖以及screen工具，再安装steamCMD\n"
	echo -e "\e[1;32m1.安装glibc等依赖以及screen工具\n"
	echo -e "2.安装steamCMD以及饥荒\n"
	echo -e "0.退出程序\e[0m\n"
	read -p "请选择:" dstInstallMode
	case $dstInstallMode in
		"1")
			bash ./module/depdencies_install.sh
			;;
		"2")
			bash ./module/steam_install.sh
			bash ./module/dst_install.sh
			getMark
			bash ./module/basic_config.sh
			echo -e "\e[1;36m以下的配置都可以在 \e[1;31m3.配置饥荒 \e[1;36m中修改"
			echo -e "如果没有想好可以先按 \e[1;31m回车 \e[1;36m跳过"
			echo -e "但必须确保 \e[1;31m配置正确 \e[1;36m再启动游戏\e[0m"
			changeClusterName
			changeClusterDescription
			changePassword
			changeMaxPlayers
			getToken
			echo -e "\e[1;32m安装完成，可以直接以默认配置启动游戏了\e[0m"
			sed -i "/.*/d" ${HOME}/steamapps/DST/mods/dedicated_server_mods_setup.lua
			typeset -l IsUbuntu
			IsUbuntu=`cat /etc/issue`
			if [[ "$IsUbuntu" =~ "ubuntu" ]]; then
			echo ""
			else
				cp /usr/lib/libcurl.so.4 ~/steamapps/DST/bin/lib32/libcurl-gnutls.so.4
			fi
			;;
		*)
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			dstInstall
			;;
	esac
}

function dstManage() {
	echo -e "\e[1;32m1.启动饥荒"
	echo -e "2.停止饥荒"
	echo -e "3.重启饥荒"
	echo -e "4.只启动地上世界"
	echo -e "5.手动更新饥荒"
	echo -e "0.退出程序\e[0m"
	read -p "请选择:" dstManageMode
	case $dstManageMode in
		"1")
			screen -dmS topWorld bash ./module/top.sh
			screen -dmS downWorld bash ./module/down.sh
			echo "正在启动..."
			;;
		"2")
			screen -dr topWorld -p 0 -X stuff "^C"
			screen -dr downWorld -p 0 -X stuff "^C"	
			echo "正在停止..."
			echo "请等待10秒钟"
			echo "正在保存数据..."
			sleep 10s
			echo "停止成功!"
			;;
		"3")
			screen -dr topWorld -p 0 -X stuff "^C"
			screen -dr downWorld -p 0 -X stuff "^C"	
			echo "正在重启..."
			echo "请等待10秒钟"
			echo "正在保存数据..."
			sleep 10s
			screen -dmS topWorld bash module/top.sh
			screen -dmS downWorld bash module/down.sh
			echo "重启成功!"
			;;
		"4")
			screen -dmS topWorld bash module/top.sh
			;;
		"5")
			echo "正在更新..."	
			echo "请等待10秒钟"
			echo "正在保存数据..."
			screen -dr topWorld -p 0 -X stuff "^C"
			screen -dr downWorld -p 0 -X stuff "^C"	
			sleep 10s
			bash ./module/dst_install.sh
			;;
		"0" )
			echo -e "\e[1;31m成功退出脚本!\e[0m"
			exit 0
			;;
		* )
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			dstManage
			;;
	esac
}

function dstConfig() {
	echo -e "\e[1;32m1.更改token"
	echo -e "2.更改世界名称"
	echo -e "3.更改世界描述"
	echo -e "4.更改密码"
	echo -e "5.更改最大人数"
	echo -e "6.添加管理员"
	echo -e "7.删除管理员"
	echo -e "8.查看管理员名单"
	echo -e "0.退出程序\e[0m"
	read -p "请输入:" dstConfigMode
	case $dstConfigMode in
		"1")
			getToken
			;;
		"2")
			changeClusterName
			;;
		"3")
			changeClusterDescription
			;;
		"4")
			changePassword
			;;
		"5")
			changeMaxPlayers
			;;
		"6")
			echo "输入KU_ID,一次可以添加多个人,输入 , 分割"
			echo -e "\e[1;31m是小写的逗号，不要有空格\e[0m"
			echo -e "eg:KU_AAA,KU_BBB,KU_CCC"
			read -p "请输入:" KU_ID
			KU_ID=${KU_ID//,/ }
			for iKU_ID in ${KU_ID[@]}
			do
				cat ${useDir}/adminlist.txt | grep "${iKU_ID}" >> /dev/null && had_KU_ID=Y || had_KU_ID=N
				if [ $had_KU_ID == N ]
				then
					echo ${iKU_ID} >> ${useDir}/adminlist.txt
				fi
			done
			;;
		"7")
			echo "输入KU_ID,一次可以删除多个人,输入 , 分割"
			echo -e "\e[1;31m是小写的逗号，不要有空格\e[0m"
			echo -e "eg:KU_AAA,KU_BBB,KU_CCC"
			read -p "请输入:" KU_ID
			KU_ID=${KU_ID//,/ }
			for iKU_ID in ${KU_ID[@]}
			do
				cat ${useDir}/adminlist.txt | grep "${iKU_ID}" >> /dev/null && had_KU_ID=Y || had_KU_ID=N
				if [ $had_KU_ID == Y ]
				then
					sed -i "/${iKU_ID}/d" ${useDir}/adminlist.txt
				fi
			done
			;;
		"8")
			echo -e "\e[1;31m只能显示KU_ID\e[0m"
			cat ${useDir}/adminlist.txt
			;;
		"0" )
			echo -e "\e[1;31m成功退出脚本!\e[0m"
			exit 0
			;;
		* )
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			dstConfig
			;;
	esac
}


function getUninstall() {
	echo -e "\e[1;32m1.完全卸载steam和饥荒"
	echo -e "0.退出程序\e[0m"
	read -p "请选择:" uninstallMode
	case $uninstallMode in
		"1")
			echo "确定真的要删除steam和饥荒吗?"
			read -p "输入Y/y确认:" Ireally
			if [ $Ireally == "Y" ] || [ $Ireally == "y" ]
			then
				rm -rf ~/.klei/ ~/Steam/ ~/steamCMD/ ~/steamapps/ ~/.steam/
				echo -e "\e[1;32m删除成功!\e[0m"
			else
				echo -e "\e[1;31m取消删除!\e[0m"
				exit 0
			fi
			;;
		"0" )
			echo -e "\e[1;31m成功退出脚本!\e[0m"
			exit 0
			;;
		* )
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			getUninstall
			;;
	esac
}

function storeManage() {
	echo -e "\e[1;32m1.查看存档"
	echo -e "2.激活存档"
	echo -e "3.新建存档"
	echo -e "4.删除存档"
	echo -e "0.退出程序\e[0m"
	read -p "请选择:" storeManageMode
	case $storeManageMode in
		"1")
			echo -e "\e[1;36m***************\e[0m"
			echo -e "你目前的存档"
			echo -e "\e[1;36m***************\e[0m"
			cat ./resources/application.properties | tail -n +2 | awk 'BEGIN{FS="="} {print $1 "\t " $2}'
			echo -e "\e[1;36m***************\e[0m"
			;;
		"2")
			echo -e "\e[1;36m***************\e[0m"
			echo -e "你目前的存档"
			echo -e "\e[1;36m***************\e[0m"
			cat ./resources/application.properties | tail -n +2 | awk 'BEGIN{FS="="} {print $1 "\t " $2}'
			echo -e "\e[1;36m***************\e[0m"
			echo -e "\e[1;36m你正在激活存档..."
			echo -e "\e[1;31m请确保输入正确!!!\e[0m"
			read -p "请输入世界标记:" Iactive
			sed -i "s/\(dev\).*/\1=${Iactive}/g" ./resources/application.properties
			;;
		"3")
			echo -e "\e[1;36m***************\e[0m"
			echo -e "你目前的存档"
			echo -e "\e[1;36m***************\e[0m"
			cat ./resources/application.properties | tail -n +2 | awk 'BEGIN{FS="="} {print $1 "\t " $2}'
			echo -e "\e[1;36m***************\e[0m"
			echo -e "\e[1;36m你正在新建存档...\e[0m"
			echo -e "\e存档新建完后会自动 [1;31m激活!!!\e[0m"
			getMark
			bash ./module/basic_config.sh
			echo -e "\e[1;36m以下的配置都可以在 \e[1;31m3.配置饥荒 \e[1;36m中修改"
			echo -e "如果没有想好可以先按 \e[1;31m回车 \e[1;36m跳过"
			echo -e "但必须确保 \e[1;31m配置正确 \e[1;36m再启动游戏\e[0m"
			changeClusterName
			changeClusterDescription
			changePassword
			changeMaxPlayers
			getToken
			echo -e "安装完成，可以直接以默认配置启动游戏了"
			;;
		"4")
			echo -e "\e[1;36m***************\e[0m"
			echo -e "你目前的存档"
			echo -e "\e[1;36m***************\e[0m"
			cat ./resources/application.properties | tail -n +2 | awk 'BEGIN{FS="="} {print $1 "\t " $2}'
			echo -e "\e[1;36m***************\e[0m"
			echo -e "\e[1;36m你正在删除存档..."
			echo -e "\e[1;31m请确保输入正确!!!\e[0m"
			read -p "请输入世界标记:" Iactive
			sed -i "/${Iactive}=/d" ./resources/application.properties
			rm -rf ${preMainDir}/${Iactive}
			;;
		"0" )
			echo -e "\e[1;31m成功退出脚本!\e[0m"
			exit 0
			;;
		* )
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			storeManage
			;;
	esac
}


function modManage() {
	echo -e "\e[1;32m1.安装MOD"
	echo -e "2.启用MOD"
	echo -e "3.停用MOD"
	echo -e "0.退出程序\e[0m"
	if [ ! -f "${useDir}/Master/modoverrides.lua" ]
	then
		touch ${useDir}/Master/modoverrides.lua
		touch ${useDir}/Master/lua.modoverrides
		echo "}" >> ${useDir}/Master/lua.modoverrides
		echo "return {" >> ${useDir}/Master/lua.modoverrides
	fi
	if [ ! -f "${useDir}/Cave/modoverrides.lua" ]
	then
		touch ${useDir}/Cave/modoverrides.lua
		touch ${useDir}/Cave/lua.modoverrides
		echo "}" >> ${useDir}/Cave/lua.modoverrides
		echo "return {" >> ${useDir}/Cave/lua.modoverrides
	fi
	read -p "请选择:" modManageMode
	case $modManageMode in
		"1")
			echo "输入MOD_ID,一次可以安装多个,输入 , 分割"
			echo -e "\e[1;31m是小写的逗号，不要有空格\e[0m"
			echo -e "eg:369596587,378160973"
			read -p "请输入:" KU_MOD
			KU_MOD=${KU_MOD//,/ }
			for iKU_MOD in ${KU_MOD[@]}
			do
				cat ${modDir}/dedicated_server_mods_setup.lua | grep ${iKU_MOD} >> /dev/null && had_KU_MOD=Y || had_KU_MOD=N
				if [ $had_KU_MOD == N ]
				then
								echo "ServerModSetup(\"${iKU_MOD}\")" >> ${modDir}/dedicated_server_mods_setup.lua
				fi
			done
			;;
		"2")
			echo "输入MOD_ID,一次可以启用多个,输入 , 分割"
			echo -e "\e[1;31m是小写的逗号，不要有空格\e[0m"
			echo -e "eg:369596587,378160973"
			echo -e "未安装的mod会自动安装，然后启用!"
			read -p "请输入:" KU_MOD
			KU_MOD=${KU_MOD//,/ }	
			for iKU_MOD in ${KU_MOD[@]}
			do
				cat ${modDir}/dedicated_server_mods_setup.lua | grep ${iKU_MOD} >> /dev/null && had_KU_MOD=Y || had_KU_MOD=N
				if [ $had_KU_MOD == N ]
				then
								echo "ServerModSetup(\"${iKU_MOD}\")" >> ${modDir}/dedicated_server_mods_setup.lua
				fi
			done
			for iKU_MOD in ${KU_MOD[@]}
			do
				cat ${useDir}/Master/lua.modoverrides | grep ${iKU_MOD} >> /dev/null && had_KU_MOD=Y || had_KU_MOD=N
				if [ $had_KU_MOD == N ]
				then
					sed -i "$ i \[\"workshop-${iKU_MOD}\"\] = \{ enabled = true \}," ${useDir}/Master/lua.modoverrides
				fi
				cat ${useDir}/Cave/lua.modoverrides | grep ${iKU_MOD} >> /dev/null && had_KU_MOD=Y || had_KU_MOD=N
				if [ $had_KU_MOD == N ]
				then
					sed -i "$ i \[\"workshop-${iKU_MOD}\"\] = \{ enabled = true \}," ${useDir}/Cave/lua.modoverrides
				fi
			done
			sed -i "1,2 s/,//g" ${useDir}/Master/lua.modoverrides
			tac ${useDir}/Master/lua.modoverrides > ${useDir}/Master/modoverrides.lua
			sed -i "1,2 s/,//g" ${useDir}/Cave/lua.modoverrides
			tac ${useDir}/Cave/lua.modoverrides > ${useDir}/Cave/modoverrides.lua
			;;
		"3")
			echo "输入MOD_ID,一次可以停用多个,输入 , 分割"
			echo -e "\e[1;31m是小写的逗号，不要有空格\e[0m"
			echo -e "eg:369596587,378160973"
			read -p "请输入:" KU_MOD
			KU_MOD=${KU_MOD//,/ }
			for iKU_MOD in ${KU_MOD[@]}
			do 
				cat ${useDir}/Master/lua.modoverrides | grep ${iKU_MOD} >> /dev/null && had_KU_MOD=Y || had_KU_MOD=N
				if [ $had_KU_MOD == Y ]
				then
					sed -i "/${iKU_MOD}/d" ${useDir}/Master/lua.modoverrides
				fi
				cat ${useDir}/Cave/lua.modoverrides | grep ${iKU_MOD} >> /dev/null && had_KU_MOD=Y || had_KU_MOD=N
				if [ $had_KU_MOD == Y ]
				then
					sed -i "/${iKU_MOD}/d" ${useDir}/Cave/lua.modoverrides
				fi
			done	
			sed -i "1,2 s/,//g" ${useDir}/Master/lua.modoverrides
			tac ${useDir}/Master/lua.modoverrides > ${useDir}/Master/modoverrides.lua
			sed -i "1,2 s/,//g" ${useDir}/Cave/lua.modoverrides
			tac ${useDir}/Cave/lua.modoverrides > ${useDir}/Cave/modoverrides.lua
			;;
		"0")
			echo -e "\e[1;31m成功退出脚本!\e[0m"
			exit 0
			;;
		* )
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			modManage
			;;
	esac
}


function main() {
	echo -e "\e[1;36m欢迎使用 饥荒 管理程序"
	echo -e "请输入 数字 选择模式"
	echo -e "\e[1;32m1.安装饥荒"
	echo -e "2.管理饥荒"
	echo -e "3.配置饥荒"
	echo -e "4.配置世界----------只能在第一次启动游戏前使用"
	echo -e "5.管理存档"
	echo -e "6.卸载"
	echo -e "7.查看服务器状态"
	echo -e "8.MOD管理"
	echo -e "0.退出程序\e[0m\n"
	read -p "请选择:" mainMode
	case $mainMode in
		"1" )
			dstInstall
			;;
		"2" )
			dstManage
			;;
		"3" )
			dstConfig
			;;
		"4" )
			echo -e "待开发~"
			;;
		"5" )
			storeManage
			;;
		"6" )
			getUninstall
			;;
		"7" )
			getStatusInfo
			;;
		"8" )
			modManage
			;;
		"0" )
			echo -e "\e[1;31m成功退出脚本!\e[0m"
			exit 0
			;;
		* )
			echo -e "\e[1;31m输入错误\e[0m"
			sleep 1s
			main
			;;
	esac
}

main
