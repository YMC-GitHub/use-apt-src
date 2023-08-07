#!/usr/bin/env bash


zero_app_nsh="./`basename $0`"

zero_app_msg_usage="
usage:
    {ns} [sourcename]
    {ns} [command]
source name list:
    ubuntu
    debian
    tsinghua
    aliyun
    ustc
    163
command:
    current
"
zero_app_msg_version="{ns} version 1.0.0"

sourcelist="
http://archive.ubuntu.com
http://deb.debian.org
http://mirrors.tuna.tsinghua.edu.cn
http://mirrors.aliyun.com
http://mirrors.ustc.edu.cn
http://mirrors.163.com
"




function zero_app_run_version_and_usage(){
#zero:task:s:out-cli-version
case "$1" in
    -v|--version|version)
        echo "$zero_app_msg_version";exit 0;
    ;;
esac
#zero:task:e:out-cli-version

#zero:task:s:out-usage
case "$1" in
    -h|--help|help)
        echo "$zero_app_msg_usage";exit 0;
    ;;
esac
#zero:task:e:out-usage
}

function replace_source(){
    o=$1
    n=$2
    [ $n != $o ] && sed -i "s@$o@$n@g" /etc/apt/sources.list
}
# replace_source "https://mirrors.tuna.tsinghua.edu.cn" "http://mirrors.aliyun.com"
# replace_source "http://mirrors.tuna.tsinghua.edu.cn" "http://mirrors.aliyun.com"
# replace_source "http://mirrors.ustc.edu.cn" "http://mirrors.aliyun.com"

function use_repalcing(){
# task:s:use replacing
    n=`echo "$1" | grep "$2"` # get n mirror with key
    
    # get o mirror in file
    o=$(cat /etc/apt/sources.list | sed "/^#/d" | sed "/^$/d" | tail -1 | cut -d " " -f2)
    o=$(echo "$o" | sed "s@/@ @g" | awk '{print $1,$2;}' | sed "s@ @//@g")
    
    replace_source "$o" "$n"
# task:e:use replacing
}
# use_repalcing "$sourcelist" "$name

function main(){

zero_app_run_version_and_usage "$1"

# task:s:backup offical source
file=/etc/apt/sources.list
[ ! -e $file.backup ] && cp $file $file.backup
# task:e:backup offical source


name=tsinghua
[ $1 ] && name=$1;

# task:s:use backup
# task:e:use backup

case "$name" in
    current |now)
        cat /etc/apt/sources.list | sed "/^#/d" | sed "/^$/d" ;exit 0;
    ;;
    ubuntu |"ubuntu.com")
        [ -e $file.backup ] && cp -f $file.backup $file
    ;;
    debian)
        [ -e $file.backup ] && cp -f $file.backup $file
    ;;
    *)
        use_repalcing "$sourcelist" "$name"
    ;;
esac

# update - update list of available packages
apt update
# upgrade - upgrade the system by installing/upgrading packages
apt upgrade -y
}

main "$@"