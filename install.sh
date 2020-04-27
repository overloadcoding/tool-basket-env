#!/bin/bash

## Function: 
#   1.Environment configuration


## Deploy development environment
sh -x script/env_deploy.sh `pwd`


## Deploy web


## Deploy server
# 部署
# 切换到用户server，启用uwsgi，并添加为启动项


## Start nginx
# 切换到其他管理用户，并启动nginx，然后将nginx启动脚本添加为启动项
# nginx

# test nginx.conf syntax
# nginx -t
# reload nginx.conf
# nginx -s reload
# restart Nginx
# nginx -s reopen
# stop Nginx
# nginx -s stop
