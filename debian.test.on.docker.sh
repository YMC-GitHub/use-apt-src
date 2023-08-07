listname="aliyun 163 tsinghua ustc"  
listos="debian:10 debian:11" 

[ $1 ] && listos="$1"
[ $2 ] && listname="$2"
cd $(pwd);

# test debian.sh on container on debian:
# docker run -it -v $(pwd):/app -w /app --name=$OS_NAME $OS_IMAGE /bin/bash
# use-apt-src/debian.sh -h
# use-apt-src/debian.sh current
# use-apt-src/debian.sh aliyun

# docker run -it -v $(pwd):/app -w /app --rm $OS_IMAGE use-apt-src/debian.sh current
# docker run -it -v $(pwd):/app -w /app --rm $OS_IMAGE use-apt-src/debian.sh aliyun 


function test_in_srclist(){
    array=(`echo $listname | tr ',' ' '` )  
    for i in ${array[@]}
    do
        docker run -it -v $(pwd):/app -w /app --rm $OS_IMAGE use-apt-src/debian.sh $i >/dev/null 2>&1; [ $? -eq 0 ] && echo "on image $OS_IMAGE , use $i src [ok]";
    done 
}
function test_in_oslist(){
    arr_os=(`echo $listos | tr ',' ' '` )  
    for osname in ${arr_os[@]}
    do
       OS_IMAGE=$osname; test_in_srclist;
    done 
}

test_in_oslist

# use-apt-src/debian.test.on.docker.sh
# use-apt-src/debian.test.on.docker.sh "ubuntu,debian:11"  "aliyun,163"