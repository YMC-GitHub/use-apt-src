# use-apt-src

update apt source on ubuntu in China , switching china source and other source. through sed replacing or backup script.

## features
- [x] update apt source (ubuntu/tsqinghua/aliyun/163 source) with sed replacing

## using replace script (recomended)
```bash
# only download replace.sh file
# curl -O https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/use-apt-src/main/replace.sh

# get  replace.sh script usage
./replace.sh -h

# get  replace.sh script version
# ./replace.sh -v

# zero:task:s:swicth-user
# if you do not have the rights to edit file /etc/apt/sources.list
# you can swicth user with su.
# su [options] [-] [<user> [<argument>...]]
# su - $USER
# zero:task:e:swicth-user

# use some source in china
./replace.sh tsqinghua
./replace.sh aliyun
./replace.sh 163

# use offical source
./replace.sh ubuntu

# or
# curl -sfL https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/use-apt-src/main/replace.sh | sh
```

## using backup script

```bash
# download source code in china with git 
GC_PROXY="https://ghproxy.com/"
GC_URL="https://github.com/YMC-GitHub/use-apt-src"
GC_URL="${GC_PROXY}${GC_URL}"
git clone -b main "$GC_URL"

# get script usage
./use-apt-src/index.sh -h

# get current using
use-apt-src/index.sh get 22.04 tsinghua
# download
use-apt-src/index.sh download 22.04 tsinghua
# use
use-apt-src/index.sh use 22.04 tsinghua
# del
use-apt-src/index.sh del 22.04 tsinghua
# add
use-apt-src/index.sh add 22.04 tsinghua
```

current support qinghua on ubuntu 18.04/20.04/22.04 with backup script .


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
