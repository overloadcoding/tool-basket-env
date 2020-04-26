#!/bin/bash

## Environment initialization
#   1.nameserver 8.8.8.8
#   2.tools
#   3.group and user
#   4.python 3.5.4
#   5.nginx 1.18.0
#
## Args:
#   ${1}: root dir


## Resource and params

url_python="https://www.python.org/ftp/python/3.5.4/Python-3.5.4.tgz"
url_pcre="https://sourceforge.net/projects/pcre/files/pcre/8.44/pcre-8.44.tar.gz"
url_nginx="http://nginx.org/download/nginx-1.18.0.tar.gz"

root_dir=${1}
tmp_dir=${root_dir}/tmp
config_dir=${root_dir}/config

nameserver="8.8.8.8"
init_passwd="E2,cEk7eDX.T6fD_"

path_py3="/usr/local/python3"
path_nginx="/usr/local/nginx"


## Functions

# log
function log() {
    msg=${1}
    echo "${msg}"
}

# create tmp dir
function createTmpDir() {
    cd ${root_dir}
    if [ ! -d "${tmp_dir}" ];then
        mkdir ${tmp_dir}
        log "Create tmp dir '${tmp_dir}'"
    else
        log "Tmp dir '${tmp_dir}' already exist, exit installation"
        exit 1
    fi
}

# install some tools
function toolsInstall() {
    # modify nameserver
    sed -i "s/nameserver.*/nameserver ${nameserver}/g" /etc/resolv.conf
    # command sz to download, rz to upload
    yum install -y lrzsz
    # netstat
    yum install -y net-tools
    # vim
    yum install -y vim
    # vim8 plugin install
    # cp -f ${config_dir}/.vimrc ~/.vimrc
    # vim +PluginInstall +qall >/dev/null
}

# add group and users
function addGroupsAndUsers() {
    # group for developers
    groupadd develop
    # group for web
    groupadd www
    # group for server
    groupadd server

    useradd -g develop lixiong
    useradd -g develop jiangwy
    # forbid remote login
    useradd -g www www -s /sbin/nologin
    # add user "server" to run service
    useradd -g server server

    # set init password
    echo "${init_passwd}" | passwd --stdin lixiong
    echo "${init_passwd}" | passwd --stdin jiangwy
    echo "${init_passwd}" | passwd --stdin server

    # add developers to web and server group
    usermod -a -G www lixiong
    usermod -a -G www jiangwy
    usermod -a -G server lixiong
    usermod -a -G server jiangwy
    # delete from group
    # gpasswd -d user group

    # let /home/* can be accessed by group
    chmod 770 /home/*
}

# install python 3.5.4
function installPython() {
    cd ${tmp_dir}
    # install dependencies
    yum groupinstall -y "Development tools"
    yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel
    yum install -y readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
    yum install -y libffi-devel

    # install python
    wget ${url_python}
    tar -xzvf Python-3.5.4.tgz
    mkdir ${path_py3}
    cd Python-3.5.4
    ./configure --prefix=${path_py3}
    make && make install
    ln -sf ${path_py3}/bin/python3 /usr/bin/python
    ln -sf ${path_py3}/bin/pip3 /usr/bin/pip

    # fix yum's python version
    sed -i "1s/python/python2.7/g" /usr/bin/yum
    sed -i "1s/python/python2.7/g" /usr/libexec/urlgrabber-ext-down
}

# install nginx 1.18.0
function installNginx() {
    cd ${tmp_dir}
    # install pcre
    yum install -y make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel
    wget ${url_pcre}
    tar -xzvf pcre-8.44.tar.gz -C /usr/local/src/
    cd /usr/local/src/pcre-8.44
    ./configure
    make && make install

    # install nginx
    cd ${tmp_dir}
    wget ${url_nginx}
    tar -xzvf nginx-1.18.0.tar.gz
    cd nginx-1.18.0
    ./configure --prefix=${path_nginx} --with-http_stub_status_module --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.44
    make && make install
    ln -sf ${path_nginx}/sbin/nginx /usr/bin/nginx

    # config nginx
    cp -f ${config_dir}/nginx_dev.conf ${path_nginx}/conf/nginx.conf
}


## Installation

# main
function main() {
    log "Create tmp dir..."
    createTmpDir >/dev/null

    log "Modify nameserver and install tools..."
    toolsInstall >/dev/null

    log "Add groups and users..."
    addGroupsAndUsers >/dev/null

    log "Install python..."
    installPython >/dev/null

    log "Install nginx..."
    installNginx >/dev/null

    log "Installation complete!"
}

# start
unalias cp
main