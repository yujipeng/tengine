#!/bin/bash

# 依赖安装
yum install -y gcc gcc-devel zlib zlib-devel pcre pcre-devel openssl openssl-devel

# tengine 安装
cd /mnt/tengine/tengine-2.3.2
./configure --with-http_v2_module  --with-http_realip_module   --with-http_gunzip_module --with-http_gzip_static_module --add-module=modules/ngx_http_concat_module/
make
make install

# 覆盖配置文件
cd /mnt/tengine/
/bin/cp -rf conf/* /usr/local/nginx/conf/

# 开机自启
/bin/cp nginx.service /lib/systemd/system/
chmod 745 /lib/systemd/system/nginx.service 
systemctl enable nginx.service
systemctl start nginx.service
