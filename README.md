# wslubt-use-host-name

changing wsl & ubuntu host name permanently.


## usage
```bash
# only download index.sh file
# curl -O https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/wslubt-use-host-name/main/index.sh

# get  index.sh script usage
./index.sh -h

# get  index.sh script version
# ./index.sh -v

# zero:task:s:swicth-user
# if you do not have the rights to edit file /etc/apt/sources.list
# you can swicth user with su.
# su [options] [-] [<user> [<argument>...]]
# su - $USER
# zero:task:e:swicth-user

# use name wsl
./index.sh wsl

# use name zero
./index.sh wsl zero

# or: ( will use default config)
# curl -sfL https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/wslubt-use-host-name/main/index.sh | sh
```


you can use as below ( including download , add-x-right , run-sh, and del-sh) :
```bash
# download -> add-x-right -> run-sh
todir=./tool/wslubt-use-host-name; tof="$todir/index.sh";uri=https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/wslubt-use-host-name/main/index.sh;  mkdir -p "$todir"; curl -o "$tof" -s $uri; chmod +x "$tof"; "$tof" wsl; 

# del-sh:
# rm -rf "$todir";
```

## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>||

## License
MIT
