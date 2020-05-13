#!/bin/bash

## Function: 
#   1.Environment configuration


## Deploy development environment
sh -x script/env_deploy.sh `pwd`
# 初始化 MariaDB
# mysql_secure_installation


## Deploy web


## Deploy server
# 部署修改 uwsgi.ini
cp -f config/uwsgi.ini /usr/local/etc/uwsgi.ini


## Start nginx
# 启动 nginx，然后将 nginx 启动脚本添加为启动项
# nginx
