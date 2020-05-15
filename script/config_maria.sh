#!/bin/bash

## Args:
#   ${1}: root dir

root_dir=${1}
tmp_dir=${root_dir}/tmp
config_dir=${root_dir}/config


# log
function log() {
    msg=${1}
    echo "${msg}"
}

function installMariaDB() {
    yum install -y python-devel gcc mariadb-server mariadb-devel
    systemctl start mariadb
    systemctl enable mariadb
    pip install mysqlclient
}

function initDB() {
    # init db
    mysql_secure_installation

    # change character encoding to utf8
    cp -f ${config_dir}/mariadb/my.cnf /etc/my.cnf
    cp -f ${config_dir}/mariadb/client.cnf /etc/my.cnf.d/client.cnf
    cp -f ${config_dir}/mariadb/mysql-clients.cnf /etc/my.cnf.d/mysql-clients.cnf
    systemctl restart mariadb
}

# create database and add user
function config_django_db() {
    # generate random password for django user
    random_password=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}`
    sed -i "s/password/${random_password}/g" script/config_db.sql

    # execute sql script
    echo "Please input MariaDB root's password"
    mysql -uroot -p < script/config_db.sql
}


# main
function main() {
    log "Install MariaDB..."
    installMariaDB

    log "Initialize MariaDB..."
    initDB

    log "Config django db..."
    config_django_db

    log "Database configuration complete!"
}

# start
main