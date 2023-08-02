# use-apt-src

using apt source on ubuntu

## features
- [x] get current file
- [x] add backup file
- [x] del backup file
- [x] use backup file
- [x] download backup file
- [x] use apt source in china with sed replacing

## components
- [x] using apt source qinghua on ubuntu 22.04
- [x] using apt source qinghua on ubuntu 20.04
- [x] using apt source qinghua on ubuntu 18.04


## using backup script

```bash
# download source code in china with git 
GC_PROXY="https://ghproxy.com/"
GC_URL="https://github.com/YMC-GitHub/use-apt-src"
GC_URL="${GC_PROXY}${GC_URL}"
git clone -b main "$GC_URL"

# get script usage
./use-apt-src/index.sh -h


```

## using replace script
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


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
