#!/usr/bin/env bash


zero_app_nsh="./`basename $0`"

zero_app_msg_usage="
usage:
    {ns} [sourcename]
    {ns} [command]
source name list:
    ubuntu.com
    tsinghua
    aliyun
    ustc
    163
command:
    current
"
zero_app_msg_version="{ns} version 1.0.0"

sourcelist="
http://archive.ubuntu.com/ubuntu/
https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
http://mirrors.aliyun.com/ubuntu/
https://mirrors.ustc.edu.cn/ubuntu/
http://mirrors.163.com/ubuntu/
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
    # o=http://security.ubuntu.com/ubuntu/
    # n=https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
    o=$1
    n=$2

    sed -i "s,http://archive.ubuntu.com/ubuntu/,$n,g" /etc/apt/sources.list
    sed -i "s,http://security.ubuntu.com/ubuntu/,$n,g" /etc/apt/sources.list
    [ $n != $o ] && sed -i "s,$o,$n,g" /etc/apt/sources.list
}

# sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

function use_repalcing(){
# task:s:use replacing
n=`echo "$1" | grep "$2"`
o=`cat /etc/apt/sources.list | sed "/^#/d" | tail -1 | cut -d " " -f2`
replace_source "$o" "$n"
# task:e:use replacing
}
# use_repalcing "$sourcelist" "$name"


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
    *)
        use_repalcing "$sourcelist" "$name"
    ;;
esac

# update - update list of available packages
apt update -y
# upgrade - upgrade the system by installing/upgrading packages
apt upgrade -y
}

main "$@"