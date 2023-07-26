#! /bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'

_red()    { echo -e "${red}"     "$*" "${none}"; }
_green()  { echo -e "${green}"   "$*" "${none}"; }
_yellow() { echo -e "${yellow}"  "$*" "${none}"; }
_magenta(){ echo -e "${magenta}" "$*" "${none}"; }
_cyan()   { echo -e "${cyan}"    "$*" "${none}"; }
_none()   { echo -e "${none}"    "$*" "${none}"; }

# 定义日志函数
log() {
    local level="$1"
    local msg="$2"
    local color

    if [ $# -eq 1 ]; then
        msg="$1"
        level=""
    fi

    case $level in
    info)
        color=$green;;
    warn)
        color=$yellow;;
    err)
        color=$red;;
    *)
        color=$green
        level="";;
    esac

    local log_msg="$(date +'%F %H:%M:%S') $level $msg"

    if [ -n "$logfile" ]; then
        echo -e "${color}$log_msg${none}" | tee -a "$logfile"
    else
        echo -e "${color}$log_msg${none}"
    fi
}

# 备份的目录
src_dir="/tmp"
# 备份存放的目录
dst_dir="/root/bak"
name="test"


backup(){
    # 创建备份
    log 创建备份
    tar -czf $dst_dir/"$name"_$(date +'%F-%H-%M')_backup.tar.gz -C $src_dir .

    latest_bak=$(find $dst_dir -maxdepth 1 -type f -name '*_backup.tar.gz' -printf '%T@ %p\n' | sort -n | tail -1 | awk '{print $2}')
    log 最新的备份:"$latest_bak"

    # 删除本地前一天的备份
    old_bak=$(find $local_dir -maxdepth 1  -mtime +1 -name '*_backuptar.gz')
    log 删除前一天的备份:"$old_bak"
    rm -rf "$old_bak"
}

main(){
    backup
}

main "$@"
