#!/usr/bin/env bash

# zero:const:s:all
# [getopts]
zero_app_sarg=""
zero_app_larg=""

# [base]
zero_const_space_md5=`echo -n " " | md5sum | cut -b -32`
zero_const_comma_md5=`echo -n "," | md5sum | cut -b -32`



# zero:const:e:all

# zero:core:func:s
# [gen-help-msg]
function render_tpl(){
    tpl=topic/today/email
    [ -n "$1" ] && tpl=$1
    [ -n "$2" ] && key=$2
    [ -n "$3" ] && val=$3
    if [ $key ] ; then
        echo "$tpl" | sed "s/$key/$val/g"
    else
        echo "$tpl"
    fi
}

function zero_app_render_msg_tpl(){
    tpl="$1"
    key="$2"
    val="$3"
    echo "$tpl" | sed "s,{ns},$val,g"
}

# [fetch-help-msg-or-tpl]
function zero_app_check_msg_usage_loaded(){
    echo "$zero_app_msg_usage" | grep "{{HELP_MSG}}" > /dev/null 2>&1 ;
    # [ $? -ne 0 ] && zero_app_msg_usage_loaded=0
}

# [vars]
function zero_app_lst_var_name_by_prefix(){
valn="GPG"
[ "$1" ] && valn=$1
vars_code="echo \${!$valn*}"
# eval $vars_code
vars=(`eval $vars_code`)
# vars=(`echo ${!GPG*}`)
for s in ${vars[@]}
do
    echo $s
done
}
# usage:
# zero_app_lst_var_name_by_prefix "zero_"
# zero_app_lst_var_name_by_prefix "GPG_"

function zero_app_lst_var_value_by_prefix(){
valn="GPG"
[ "$1" ] && valn=$1
vars_code="echo \${!$valn*}"
# eval $vars_code
vars=(`eval $vars_code`)
# vars=(`echo ${!GPG*}`)
for s in ${vars[@]}
do
    v="echo \$$s"
    v=`eval $v`
    echo "$s=$v"
done
}
# usage:
# zero_app_lst_var_value_by_prefix "zero_"
# zero_app_lst_var_value_by_prefix "GPG_"

# [getopts]

function zero_str_join(){
    # echo "$@"

    # a b c
    c=""
    a=$1
    b=$2
    d=""
    [ -n "$3" ] && c=$3
    [ -n "$4" ] && d=$4

    [ $b ] && {
        if [ $a ] ; then
            echo ${a}${c}${b}${d}
        else
            echo ${b}${d}
        fi 
        return 0
    }
    echo $a
}

function zero_app_use_opt(){
    o=$(echo $1 | sed -E "s/ -- +.*//g")
    o=$(echo $o | sed -E "s/^ +//g")
    o=$(echo $o | sed -E "s/-+//g")
    o=$(echo $o | sed -E "s/,+/ /g")
    # echo $o
    oa=(${o// / })
    # echo $o
    # echo ${oa[0]}
    # echo ${oa[1]}
    # echo ${oa[2]}

    # zero_app_sarg=$(zero_str_join "$zero_app_sarg" ${oa[0]} "" ":")
    # zero_app_larg=$(zero_str_join "$zero_app_larg" ${oa[1]} ", ":")


    os=${oa[0]}
    ol=${oa[1]}
    ot=${oa[2]}
    # eg. nc,<value>
    [ -z $ot ] && {
        ot=$ol
    }

    # eg. os is --eml
    [ $os ] && {
        [ ${#os} -ne 1 ] && { ol=$os; os=""; }
    }

    
    # echo $os,$ol,$ot

    if [[ $ot =~ "]" ]];then
        #  echo ${oa[0]}
        zero_app_sarg=$(zero_str_join "$zero_app_sarg" $os "" ":")
        zero_app_larg=$(zero_str_join "$zero_app_larg" $ol "," ":")
    elif [[ $ot =~ ">" ]];then
        # echo ${oa[0]}
        zero_app_sarg=$(zero_str_join "$zero_app_sarg" $os "" "::")
        zero_app_larg=$(zero_str_join "$zero_app_larg" $ol "," "::")
    else
        # echo ${oa[0]}
        zero_app_sarg=$(zero_str_join "$zero_app_sarg" $os "")
        zero_app_larg=$(zero_str_join "$zero_app_larg" $ol ",")
    fi

}
# zero_app_use_opt "-h,--help -- info help usage"
# zero_app_use_opt '-v,--version -- info version'
# zero_app_use_opt "-p,--preset [value] -- use some preset"
# zero_app_use_opt "--hubs <value> -- set hub url list. multi one will split with , char"
# zero_app_use_opt "--eml <value> -- set email list. multi one will split with , char"


function zero_app_use_opts(){

# zero_const_space_md5=$2

opts="$1"
space_md5=$2
space=$3

opts=`echo "$opts" | sed "s/$space/$space_md5/g" `
# echo "$options"
array=(`echo "$opts"` )

id=0
for line in ${array[@]}
do
if [ "$line" ]; then
    vline=`echo "$line" | sed "s/$space_md5/$space/g" `
    zero_app_use_opt "$vline"

    #  echo "$ld:$vline"
    # # echo "$ld:$line"
    # ld=$(($ld + 1))
fi
done 

# echo $ld
# echo "args:"
# echo $zero_app_sarg
# echo $zero_app_larg

}
# zero_app_use_opts "$options" "$zero_const_space_md5" " "



function zero_app_get_opts(){

# zero_const_space_md5=$2

opts="$1"
space_md5=$2
space=$3

opts=`echo "$opts" | sed "s/$space/$space_md5/g" `
opts=`echo "$opts" |sed '/^$/d' `

# echo "$options"
array=(`echo "$opts"` )

idf=`echo "$opts" | grep -n 'options' | cut -d ':' -f1`
idf=$(($idf + 0))
# echo $idf
id=0


# for line in ${array[@]}
for id in "${!array[@]}"
do
line=${array[$id]}
# echo "$id$line" | sed "s/$space_md5/$space/g"
if [ "$line" ]; then
    # echo $id
    if [ $id -ge $idf ] ; then
        # echo $id
        echo "$line" | sed "s/$space_md5/$space/g"
    fi 
    # id=$(($id + 1))
fi
done 
}
# options=`zero_app_get_opts "$zero_app_msg_usage" "$zero_const_space_md5" " "`

function zero_app_out_opts(){
    echo "args:(getopt)"
    # echo $zero_app_sarg
    # echo $zero_app_larg
    echo "-o $zero_app_sarg --long $zero_app_larg"
    # exit 0
}

function zero_app_dbg_getopts()
{
    local opt_ab
    while getopts "ab" opt_ab; do
        # funname,index,key
        echo $FUNCNAME: $OPTIND: $opt_ab
    done
}

function zero_app_fix_val(){
    if [[ $1 =~ "--" ]] ;then
        #  "--name"
        echo ${2}
    else
        # "-n"
        echo ${2:1}
    fi
}

# zero:core:func:e


zero_app_nsh="./`basename $0`"

zero_app_msg_usage="
{{HELP_MSG}}
"
zero_app_msg_version="{ns} version 1.0.0"


# zero:task:s:get-project-dir-and-other
ZERO_THIS_FILE_PATH_REL="./"
ZERO_THIS_FILE_PATH=$(cd $(dirname $0);pwd)
ZERO_THIS_FILE_NAME=$(basename $0)
[ -z "$ZERO_RUN_SCRIPT_PATH" ] && ZERO_RUN_SCRIPT_PATH=$(pwd)
ZERO_THIS_FILE_PROJECT_PATH=$(cd "$ZERO_THIS_FILE_PATH";cd "$ZERO_THIS_FILE_PATH_REL" ;pwd)
# zero:task:e:get-project-dir-and-other


#zero:task:s:load-help-msg-for-url
# ./help.md,~/help.md,thiscript/help.md,--url
# zero_app_msg_usage_loaded=1

# if you do no like loading from zero_app_msg_current_dir_url,skip it.
zero_app_msg_current_dir_url=$ZERO_THIS_FILE_PROJECT_PATH"/lang/en/help.txt"
zero_app_check_msg_usage_loaded ; [ $? -eq 0 ] && [ -e "$zero_app_msg_current_dir_url" ] && zero_app_msg_usage=`cat "$zero_app_msg_current_dir_url"`
 
# if you do no like loading from zero_app_msg_user_dir_url,skip it.
zero_app_msg_user_dir_url=~./help.txt
zero_app_check_msg_usage_loaded ; [ $? -eq 0 ] && [ -e "$zero_app_msg_user_dir_url" ] && zero_app_msg_usage=`cat "$zero_app_msg_user_dir_url"`
 
# if you do no like loading from url,skip it.
zero_app_msg_remote_url=https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/gpg-key-gen/main/lang/en/help.txt
zero_app_check_msg_usage_loaded ; [ $? -eq 0 ] && zero_app_msg_remote=`curl -sfL $zero_app_msg_remote_url` && zero_app_msg_usage=$zero_app_msg_remote
#zero:task:e:load-help-msg-for-url


# zero:task:s:render-msg-tpl
zero_app_msg_usage=`zero_app_render_msg_tpl "$zero_app_msg_usage" "{ns}" "$zero_app_nsh"`
zero_app_msg_version=`zero_app_render_msg_tpl "$zero_app_msg_version" "{ns}" "$zero_app_msg_version"`
# zero:task:e:render-msg-tpl




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


# zero_app_uas_cmd=
# zero_app_uas_res=22.04
# zero_app_uas_key=tsinghua

if [ $# -lt 3 ];then
    echo "$zero_app_msg_usage"
    exit 1
fi

zero_app_uas_cmd=$1
zero_app_uas_res=$2
zero_app_uas_key=$3

shift 3;

f=/etc/apt/sources.list
f_bk_dir=/etc/apt/


#zero:task:s:gen-getopt-option
#zero:task:s:define-cli-option
options=`zero_app_get_opts "$zero_app_msg_usage" "$zero_const_space_md5" " "`
# echo "$options"
#zero:task:e:define-cli-option
zero_app_use_opts "$options" "$zero_const_space_md5" " "
# zero_app_out_opts
# echo "-o $zero_app_sarg --long $zero_app_larg"
# echo "$@"
# exit 0
#zero:task:e:gen-getopt-option

vars=$(getopt -o $zero_app_sarg --long $zero_app_larg -- "$@")

eval set -- "$vars"
#zero:task:s:bind-scr-level-args-value
for opt; do
    case "$opt" in
      -o|--outdir)
        f_bk_dir=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
      -f|--file)
        f=`zero_app_fix_val "$opt" "$2"`
        shift 2
        ;;
    #   --dryrun)
    #     dryrun=0
    #     shift 1
    #     ;;
      --)
        shift
        ;;
      -v|--version)
        echo "$zero_app_msg_version";exit 0;
        ;;
      -h|--help)
        echo "$zero_app_msg_usage";exit 0;
        ;;
    esac
done



# exit 0

ubuntu_release=$zero_app_uas_res
key=$zero_app_uas_key
f_bk="$f_bk_dir/sources.list.$key.$ubuntu_release.backup"


# exit 0


# [download]
f_remote_url_public=https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/use-apt-src/main/
f_remote_url=${f_remote_url_public}data/$key.$ubuntu_release.backup


function log_cnf_backup(){
echo "cmd-name: $zero_app_uas_cmd"
echo "res-name: $zero_app_uas_res"
echo "key-name: $zero_app_uas_key"
echo "backup-dir: $f_bk_dir"
echo "cnf-file: $f"

echo "bak-file: $f_bk"
echo "remote-file: $f_remote_url"
}

# zero:task:s:backup-apt-source
# add: add backup
function add_backup(){
    # ubuntu_codename=`lsb_release -a | grep Codename | sed "s/Codename:\t*//g"`
    # ubuntu_release=`lsb_release -a | grep Release | sed "s/Release:\t*//g"`

    # key=tsinghua;
    cat $f | grep "$key" /dev/null 2>&1 ; [ $? -eq 1 ] && {
        mkdir -p $f_bk_dir ;
        sudo cp -f $f $f_bk ;
    }
}


# del: del backup
function del_backup(){
    rm -rf $f_bk
}


# use: use backup
function use_backup(){
    [ -e $f_bk ] && cp -f $f_bk $f
}

# get: get backup
function get_backup(){
    if [ -e $f_bk ] ; then
        cat $f_bk
    else 
        echo "no such file $f_bk"
    fi
}


# download: download backup
function download_backup(){
    if [ -e $f_bk ] ; then
        return 0
    fi

    curl -s -o $f_bk $f_remote_url
    [ $? -eq 0 ] && echo "dwonload done!"
}


# zero:task:e:backup-apy-source

function todo(){
    echo "todo: $1"
}

case "$zero_app_uas_cmd" in
    cnf)
        log_cnf_backup ;exit 0;
    ;;
    get)
        get_backup ;exit 0;
    ;;
    add)
        add_backup ;exit 0;
    ;;
    del)
        del_backup ;exit 0;
    ;;
    use)
        todo use_backup ;exit 0;
    ;;
    download)
        todo download_backup;exit 0;
    ;;
esac


# usage:
# ./index.sh -h

# ./index.sh add 22.04 tsinghua
# ./index.sh get 22.04 tsinghua > use-apt-src/data/

# use-apt-src/index.sh add 22.04 tsinghua -o=./use-apt-src/data/
