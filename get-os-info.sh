# get os version
function get_os_version(){

    [ "$OS_VERSION"_ == "_" ] &&  OS_VERSION=`cat /etc/os-release | grep VERSION_ID | cut -d "=" -f2 | sed "s@\"@@g"` ;
    [ "$OS_VERSION"_ == "_" ] &&  OS_VERSION=`cat /etc/issue | cut -d " " -f2`; # debian f3 ,ubuntu f2
    [ "$OS_VERSION"_ == "_" ] &&  OS_VERSION=`lsb_release -a | grep Release: | cut -d ":" -f2`;
    echo $OS_VERSION
}


# get os name
function get_os_name(){
    [ "$OS_NAME"_ == "_" ] &&  OS_NAME=`cat /etc/os-release | grep ^ID= | cut -d "=" -f2`
    [ "$OS_NAME"_ == "_" ] &&  OS_NAME=`cat /etc/issue | cut -d " " -f1`;
    [ "$OS_NAME"_ == "_" ] &&  OS_NAME=`lsb_release -a | grep "Distributor ID" | cut -d ":" -f2`;
    echo $OS_NAME
}


# get os codename
function get_os_codename(){
    [ "$OS_CODENAME"_ == "_" ] &&  OS_CODENAME=`cat /etc/os-release | grep VERSION_CODENAME | cut -d "=" -f2`;
    [ "$OS_CODENAME"_ == "_" ] &&  OS_CODENAME=`lsb_release -a | grep "codename" | cut -d ":" -f2`;
    echo $OS_CODENAME
}

version=`get_os_version`;
name=`get_os_name`;
codename=`get_os_codename`;

echo "$name $version $codename"

# ./get-os-info.sh