#!/bin/bash

echo -e "\e[1;31m真的要删除steam和饥荒吗"
echo -e "输入 \e[1;36my 或 Y\e[1;31m 确认删除"
echo -e "输入其他任意字符取消删除\e[0m"
read -p "请输入[y/Y]:" IsSure
if [ $IsSure == Y ] || [ $IsSure == y ]
then
	echo -e "\e[1;32m删除成功\e[0m"
	rm -rf ~/steamapps/ ~/steamCMD/ ~/.klei/ ~/.steam/ ~/Steam/
else
	echo -e "\e[1;31m取消删除\e[0m"
fi
