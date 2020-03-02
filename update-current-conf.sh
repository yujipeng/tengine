#!/bin/bash



read -p "请输入要屏蔽的IP:Port[可只输入IP尾数和端口,直接回车为全量配置]:" IP_Port
echo -e "您输入的内容：$IP_Port"
if [[ $IP_Port != "" && $IP_Port != "\n" ]] ;then
	echo -e "您要屏蔽的内容如下："
	cat /mnt/tengine/conf/default/*.conf | grep $IP_Port -n5
	read -p "确认是否正确[0正确;1错误,退出;回车默认为正确]:" Check_IP_Port
	echo -e "您输入的内容：$Check_IP_Port"
	if [[ $Check_IP_Port == "1" ]] ;then
		echo -e "输入错误，退出程序"
		exit;
	fi
	cat /mnt/tengine/conf/default/*.conf | grep -v $IP_Port  > /mnt/tengine/conf/current.conf
	echo -e "屏蔽 $IP_Port 配置处理完成"
else 
	echo -e "无屏蔽内容，全量配置"
	cat /mnt/tengine/conf/default/*.conf  > /mnt/tengine/conf/current.conf
	echo -e "全量配置处理完成"
fi

