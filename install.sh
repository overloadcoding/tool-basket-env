#!/bin/bash

## Function: 
#   1.Environment configuration


## Deploy development environment
sh -x script/env_deploy.sh `pwd`

# Install and config MariaDB
sh -x script/config_maria.sh `pwd`


## Deploy web


## Deploy server
# 部署修改 uwsgi.ini
cp -f config/uwsgi.ini /usr/local/etc/uwsgi.ini


## Start nginx
# 启动 nginx，然后将 nginx 启动脚本添加为启动项
# nginx
