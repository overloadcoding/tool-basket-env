#!/bin/bash

## Function: 
#   1.Environment configuration


## Deploy development environment
sh -x script/env_deploy.sh `pwd`


## Deploy web


## Deploy server
# 部署修改uwsgi.ini
cp -f config/uwsgi.ini /usr/local/etc/uwsgi.ini
# 启动uwsgi，并添加为启动项


## Start nginx
# 启动nginx，然后将nginx启动脚本添加为启动项
# nginx
