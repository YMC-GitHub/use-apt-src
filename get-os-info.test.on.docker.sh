listos="debian:10 debian:11" 

[ $1 ] && listos="$1"

cd $(pwd);

# docker run -it -v $(pwd):/app -w /app --rm $OS_IMAGE wslubt-docker/get-os-info.sh

function test_in_oslist(){
    arr_os=(`echo $listos | tr ',' ' '` )  
    for osname in ${arr_os[@]}
    do
       OS_IMAGE=$osname;
    #    docker run -it -v $(pwd):/app -w /app --rm $OS_IMAGE wslubt-docker/get-os-info.test.on.docker.sh;
       docker run -it -v $(pwd):/app -w /app --rm $OS_IMAGE cat /etc/os-release ;
    done 
}

test_in_oslist

# wslubt-docker/get-os-info.test.on.docker.sh
# wslubt-docker/get-os-info.test.on.docker.sh "ubuntu,debian:11" 