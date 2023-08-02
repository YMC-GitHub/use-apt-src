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

### download
```bash
# speed up git clone in china
GC_PROXY="https://ghproxy.com/"
GC_URL="https://github.com/YMC-GitHub/use-apt-src"
GC_URL="${GC_PROXY}${GC_URL}"
git clone -b main "$GC_URL"
```
### Usage

- [x] get help (ps:`./index.sh -h`)

## using replace script
```bash
# ./replace.sh -h

# su [options] [-] [<user> [<argument>...]]
# su - $USER
./replace.sh tsqinghua
./replace.sh aliyun
```


## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
