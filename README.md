# tengine 

主要作用是在centos7 下的安装和更新命令，多机器同步依赖pssh

### 基本信息
脚本目录： /mnt/tengine/
```bash
[root@r92 ~]# cd /mnt/tengine/
[root@r92 tengine]# ll
总用量 2805
drwxr-xr-x  4 root root    4096 2月  25 21:36 conf
-rw-r--r--  1 root root      24 2月  25 23:42 iplist.txt
-rwxr--r-x  1 root root     385 2月  25 18:08 nginx.service
drwxr-xr-x 14 root root    4096 2月  25 17:06 tengine-2.3.2
-rw-r--r--  1 root root 2835884 2月  25 17:06 tengine-2.3.2.tar.gz
-rwxr-xr-x  1 root root     588 2月  25 19:44 tengine-install.sh
-rwxr-xr-x  1 root root    1418 2月  25 23:39 tengine-update.sh.bak
-rwxr-xr-x  1 root root      90 2月  25 23:16 update-conf.sh
-rwxr-xr-x  1 root root     837 2月  25 23:34 update-current-conf.sh
-rwxr-xr-x  1 root root     583 2月  25 23:23 update-local-conf.sh
-rwxr-xr-x  1 root root     653 2月  25 23:42 update-remote-conf.sh
```

### 文件说明：

| 文件/目录 | 说明  |
| ------------ | ------------ |
| conf | 这是配置文件目录，用于复制替换不同机器上的conf目录 |
| iplist.txt | 这是有nginx的机器列表，内网IP列表，在update-remote-conf.sh 中使用 |
| nginx.service | 这是开启启动文件，安装nginx时使用，在 tengine-install.sh 脚本中使用 |
| tengine-2.3.2 | 这是安装源码目录，安装nginx时使用，在 tengine-install.sh 脚本中使用 |
| tengine-2.3.2.tar.gz | 这是安装源码压缩包 |
| tengine-install.sh | 这是安装tengine的脚本，包括安装依赖，源码安装，配置，开机启动 |
| tengine-update.sh.bak | 这是最初的tengine的更新脚本，已经备份，暂停使用。|
| update-conf.sh | 这是更新配置文件的集成脚本，调用了update-current-conf，update-remote-conf 脚本 |
| update-current-conf.sh | 这是生成配置文件 current.conf ，目前nginx.conf 只引用了这个配置文件，他是多个域名的合并文件。生成这个文件前，可以指定ip和端口从upstream中过滤掉要升级的机器列表。|
| update-remote-conf.sh | 这是远程执行脚本，执行其他服务器上的本地更新脚本 update-local-conf.sh |
| update-local-conf.sh |这是本地执行脚本，远程执行就是在不同机器上执行这个脚本，这个脚本是原有nginx-conf目录打tag备份，重新copy上面的conf目录，重新reload执行 |



### 安装nginx
sh /mnt/tengine/tengine-install.sh

### 更新配置

#### 整体更新：修改配置且更新服务器
sh /mnt/tengine/update-conf.sh
```bash
[root@r92 ~]# sh /mnt/tengine/update-conf.sh
请输入要屏蔽的IP:Port[可只输入IP尾数和端口,直接回车为全量配置]:96:8081
您输入的内容：96:8081
您要屏蔽的内容如下：
27-             proxy_pass http://dmpapi;
28-        }
29-     }
30-
31-    upstream appuser{
32:	server 172.16.1.96:8081;
33-	server 172.16.1.97:8081;
34-    }
35-    server {
36-        listen       443 ssl http2;
37-        server_name  api.mobicreds.com;
确认是否正确[0正确;1错误,退出;回车默认为正确]:0
您输入的内容：0
屏蔽 96:8081 配置处理完成
请输入tag标签[建议输入年月日时分秒，不可为空]:02261940
请输入action标签[update:更新 ; rollback:回滚 ; 回车默认是更新]:
现在开始更新
[1] 19:39:55 [SUCCESS] 172.16.1.93
[2] 19:39:55 [SUCCESS] 172.16.1.94
操作已完成
```

#### 单独更新：修改配置，更新或者回滚操作
##### 远程更新：
sh /mnt/tengine/update-remote-conf.sh
```bash
[root@r92 ~]# sh /mnt/tengine/update-remote-conf.sh
请输入tag标签[建议输入年月日时分秒，不可为空]:02261944
请输入action标签[update:更新 ; rollback:回滚 ; 回车默认是更新]:
现在开始更新
[1] 19:44:44 [SUCCESS] 172.16.1.94
[2] 19:44:44 [SUCCESS] 172.16.1.93
操作已完成
[root@r92 ~]#
[root@r92 ~]#
[root@r92 ~]# sh /mnt/tengine/update-remote-conf.sh
请输入tag标签[建议输入年月日时分秒，不可为空]:02261944
请输入action标签[update:更新 ; rollback:回滚 ; 回车默认是更新]:r
现在开始回滚
[1] 19:45:03 [SUCCESS] 172.16.1.93
[2] 19:45:03 [SUCCESS] 172.16.1.94
操作已完成
```

##### 本地更新：
sh /mnt/tengine/update-local-conf.sh
```bash
[root@r94 ~]# sh /mnt/tengine/update-local-conf.sh 02261948
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
[root@r94 ~]# sh /mnt/tengine/update-local-conf.sh 02261948 rollback
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

##### 更新配置文件：
sh /mnt/tengine/update-current-conf.sh
```bash
[root@r94 ~]# sh /mnt/tengine/update-current-conf.sh
请输入要屏蔽的IP:Port[可只输入IP尾数和端口,直接回车为全量配置]:96:8081
您输入的内容：96:8081
您要屏蔽的内容如下：
27-             proxy_pass http://dmpapi;
28-        }
29-     }
30-
31-    upstream appuser{
32:	server 172.16.1.96:8081;
33-	server 172.16.1.97:8081;
34-    }
35-    server {
36-        listen       443 ssl http2;
37-        server_name  api.mobicreds.com;
确认是否正确[0正确;1错误,退出;回车默认为正确]:
您输入的内容：
屏蔽 96:8081 配置处理完成
[root@r94 ~]# sh /mnt/tengine/update-current-conf.sh
请输入要屏蔽的IP:Port[可只输入IP尾数和端口,直接回车为全量配置]:96:8082
您输入的内容：96:8082
您要屏蔽的内容如下：
211-             proxy_pass http://dmpmanage;
212-        }
213-     }
214-
215-    upstream appmanage{
216:	server 172.16.1.96:8082;
217-    }
218-    server {
219-        listen       443 ssl http2;
220-        server_name  manage.mobicreds.com;
221-
确认是否正确[0正确;1错误,退出;回车默认为正确]:
您输入的内容：
屏蔽 96:8082 配置处理完成
[root@r94 ~]# sh /mnt/tengine/update-current-conf.sh
请输入要屏蔽的IP:Port[可只输入IP尾数和端口,直接回车为全量配置]:
您输入的内容：
无屏蔽内容，全量配置
全量配置处理完成
```

### 注意事项：
1. 更新配置文件的基础是 conf/default/*.conf  ，首先要保证这里的配置正确有效。
2. 增减nginx服务器的数量，只需要更新iplist.txt的ip列表
3. 脚本中没有文件传输，核心原因 : /mnt 是所有服务器的共享挂载磁盘，否则需要跨服务器传输文件，进行解压操作。


