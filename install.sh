#!/bin/bash

## Function: 
#   1.Environment configuration


## Deploy development environment
# setup base environment
sh -x script/env_deploy.sh `pwd`
# Install and config MariaDB
sh -x script/config_maria.sh `pwd`


## Deploy web


## Deploy server
# uwsgi configuration backup
cp -f config/uwsgi.ini /usr/local/etc/uwsgi.ini
# deploy django project
sh -x script/deploy_django.sh `pwd`


## Start nginx
# 启动 nginx，然后将 nginx 启动脚本添加为启动项
# nginx
