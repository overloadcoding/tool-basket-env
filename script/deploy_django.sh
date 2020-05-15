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
