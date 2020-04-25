#!/bin/bash

## Environment initialization
#   0.group and user
#   1.nameserver 8.8.8.8
#   2.vim
#   3.python 3.5.4
#   4.nginx 1.18.0
# 
# Development environment
#
# Production environment
#


## Resource urls

path_python="https://www.python.org/ftp/python/3.5.4/Python-3.5.4.tgz"
path_pcre="https://sourceforge.net/projects/pcre/files/pcre/8.44/pcre-8.44.tar.gz"
path_nginx="http://nginx.org/download/nginx-1.18.0.tar.gz"


## Installation

# create tmp dir
tmp_dir="env_install_tmp"
if [ ! -d "${tmp_dir}" ];then
    echo "Create tmp_dir"
    mkdir ${tmp_dir}
    cd ${tmp_dir}
    tmp_dir=`pwd`
else
    echo "tmp_dir '${tmp_dir}' already exist, exit installation"
    exit 0
fi

# add group and users
init_passwd="E2,cEk7eDX.T6fD_"
groupadd develop
useradd -g develop lixiong
echo "${init_passwd}" | passwd --stdin lixiong
useradd -g develop jiangwy
echo "${init_passwd}" | passwd --stdin jiangwy

# nameserver 8.8.8.8
sed -i "s/nameserver.*/nameserver 8.8.8.8/g" /etc/resolv.conf

# install vim
yum install -y vim

# python 3.5.4
yum groupinstall -y "Development tools"
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel
yum install -y readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install -y libffi-devel

# install python
wget ${path_python}
tar -xzvf Python-3.5.4.tgz
mkdir /usr/local/python3
cd Python-3.5.4
./configure --prefix=/usr/local/python3
make && make install
ln -sf /usr/local/python3/bin/python3 /usr/bin/python
ln -sf /usr/local/python3/bin/pip3 /usr/bin/pip

# fix yum's python version
sed -i "1s/python/python2.7/g" /usr/bin/yum

# nginx 1.18.0
# install pcre
cd ${tmp_dir}
yum install -y make zlib gcc-c++ libtool  openssl
wget ${path_pcre}
tar -xzvf pcre-8.44.tar.gz -C /usr/local/src/
cd /usr/local/src/pcre-8.44
./configure
make && make install

# install nginx
cd ${tmp_dir}
wget ${path_nginx}
tar -xzvf nginx-1.18.0.tar.gz
cd nginx-1.18.0
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.44
make && make install
ln -sf /usr/local/nginx/sbin/nginx /usr/bin/nginx

# add web group and user
groupadd www
useradd -g www www -s /sbin/nologin

# config nginx
# /usr/local/webserver/nginx/conf/nginx.conf
