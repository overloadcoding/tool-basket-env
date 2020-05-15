#!/bin/bash

## Setup base environment
#   1.tools
#   2.group and user
#   3.python 3.5.4
#   4.nginx 1.18.0
#   5.uwsgi
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

# init_passwd='E2,cEk7eDX.T6fD_'
developers=(lixiong jiangwy)
ssh_port=1022

path_py3="/usr/local"
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
    yum update -y
    # command sz to download, rz to upload
    yum install -y lrzsz
    # network tools
    yum install -y net-tools
    yum install -y tcpdump
    # system tools
    yum install -y sysstat
    # vim
    yum install -y vim
    # vim8 plugin install
    # cp -f ${config_dir}/.vimrc ~/.vimrc
    # vim +PluginInstall +qall >/dev/null
}

# add group and users
function addGroupsAndUsers() {
    # group for web(nginx)
    groupadd www
    # user for nginx (forbid remote login)
    useradd -g www www -s /sbin/nologin

    # group for server
    groupadd server
    # user for uwsgi (forbid remote login)
    useradd -g server server -s /sbin/nologin

    # group for developers
    groupadd develop
    for user in ${developers[*]}; do
        useradd -g develop ${user}
        # echo "${init_passwd}" | passwd --stdin ${user}
        # add developers to web and server group
        usermod -a -G www ${user}
        usermod -a -G server ${user}
    done

    # let /home/* can be accessed by all developers
    chmod 770 /home/*

    # add developers to to sudoers
    chmod u+w /etc/sudoers
    line_num=`grep -nP "root\s+ALL=\(ALL\)\s+ALL" /etc/sudoers |cut -d: -f1`
    for user in ${developers[*]}; do
        sed -in "${line_num} a ${user}    ALL=\(ALL\)       ALL" /etc/sudoers
    done
    chmod u-w /etc/sudoers
}

# security configurations
function securityConfig() {
    # change ssh port to 1022
    sed -i "s/#Port 22/Port ${ssh_port}/g" /etc/ssh/sshd_config 
    # SELinux config
    semanage port -a -t ssh_port_t -p tcp ${ssh_port}
    systemctl restart sshd

    # firewall config
    iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport ${ssh_port} -j ACCEPT
    # open port 80
    iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
    iptables-save
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
    cd Python-3.5.4
    ./configure
    make && make install
    ln -sf ${path_py3}/bin/python3 /usr/bin/python
    ln -sf ${path_py3}/bin/pip3 /usr/bin/pip

    pip install --upgrade pip

    # install opencv-python shared lib
    yum install -y libSM-1.2.2-2.el7.x86_64 libXext-1.3.3-3.el7.x86_64 --setopt=protected_multilib=false
}

# fix yum's python version
function fixPythonVersion() {
    # yum
    sed -i "1s/python/python2.7/g" /usr/bin/yum
    sed -i "1s/python/python2.7/g" /usr/libexec/urlgrabber-ext-down
    # selinux
    sed -i "1s/python/python2.7/g" /usr/sbin/semanage
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

    # create log and pid dir
    mkdir /var/run/nginx/
    mkdir /var/log/nginx/
    chown www:www /var/run/nginx/
    chown www:www /var/log/nginx/
    # allow developers run nginx
    chmod g+w /var/run/nginx/
    chmod g+w /var/log/nginx/

    # allow developers modify nginx configurations
    chgrp -R develop ${path_nginx}/conf/
    chmod g+w -R ${path_nginx}/conf/
}

# install uwsgi
function installUwsgi() {
    pip install uwsgi
    # create log and pid dir
    mkdir /var/run/uwsgi/
    mkdir /var/log/uwsgi/
    chown server:server /var/run/uwsgi/
    chown server:server /var/log/uwsgi/
    # allow developers run uwsgi
    chmod g+w /var/run/uwsgi/
    chmod g+w /var/log/uwsgi/
}


## Installation

# main
function main() {
    log "Create tmp dir..."
    createTmpDir

    log "Install tools..."
    toolsInstall

    log "Add groups and users..."
    addGroupsAndUsers

    log "Security Configurations..."
    securityConfig

    log "Install python..."
    installPython

    log "Fix python version"
    fixPythonVersion

    log "Install nginx..."
    installNginx

    log "Install uwsgi..."
    installUwsgi

    log "Installation complete!"
}

# start
main