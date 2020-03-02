#!/bin/bash


read -p "请输入tag标签[建议输入年月日时分秒，不可为空]:" tag
if [[ $tag == "" || $tag == "\n" ]] ;then
	echo -e "输出tag为空，退出更新程序"
	exit;
fi

read -p "请输入action标签[update:更新 ; rollback:回滚 ; 回车默认是更新]:" action
# 更新其他机器的nginx配置和重启
if [[ $action == "r" || $action == "rollback" ]] ;then
	echo -e "现在开始回滚"
	pssh -h /mnt/tengine/iplist.txt -l root -t -1 "sh /mnt/tengine/update-local-conf.sh $tag rollback"
else
	echo -e "现在开始更新"
	pssh -h /mnt/tengine/iplist.txt -l root -t -1 "sh /mnt/tengine/update-local-conf.sh $tag"
fi
	
echo -e "操作已完成"
