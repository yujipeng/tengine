#!/bin/bash


tag=$1
cmd=$2

# 参数说明
if [[ $tag == "" ]] ;then
	echo -e "缺少tag参数"
	echo -e "更新使用方法：shell cmd $tag "
	echo -e "回滚使用方法：shell cmd $tag rollback"
	exit
fi


# 更新配置文件目录
tagdir="/usr/local/nginx/conf-"$tag
if [[ $cmd == "r" || $cmd == "rollback" ]] ;then
	/bin/rm -rf /usr/local/nginx/conf/ 
	/bin/mv $tagdir /usr/local/nginx/conf/ 
else
	/bin/mv /usr/local/nginx/conf/ $tagdir
	/bin/cp -rf /mnt/tengine/conf /usr/local/nginx/
fi

#重新加载
/usr/local/nginx/sbin/nginx -t
/usr/local/nginx/sbin/nginx -s reload
