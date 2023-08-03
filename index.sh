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

# function zero_app_render_msg_tpl(){
#     tpl="$1"
#     key="$2"
#     val="$3"
#     echo "$tpl" | sed "s,{ns},$val,g"
# }

zero_app_nsh="./`basename $0`"

zero_app_msg_usage="
usage:
    {ns} <newname> [oldname]

demo:
    {ns} wsl
    {ns} zero wsl
options:
    -h,--help -- info help usage
    -v,--version -- info version

"
zero_app_msg_version="{ns} version 1.0.0"

zero_app_msg_usage=`zero_app_render_msg_tpl "$zero_app_msg_usage" "{ns}" "$zero_app_nsh"`
zero_app_msg_version=`zero_app_render_msg_tpl "$zero_app_msg_version" "{ns}" "$zero_app_nsh"`


# case "$1" in
#     -v|--version|version)
#         echo "$zero_app_msg_version";exit 0;
#     ;;
# esac
# case "$1" in
#     -h|--help|help)
#         echo "$zero_app_msg_usage";exit 0;
#     ;;
# esac


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

#zero:task:s:handle-v-h
eval set -- "$vars"
for opt; do
    case "$opt" in
      -v|--version)
        echo "$zero_app_msg_version";exit 0;
        ;;
      -h|--help)
        echo "$zero_app_msg_usage";exit 0;
        ;;
      --)
        shift;
        ;;
    esac
done
# echo "$@"
#zero:task:e:handle-v-h



# zero:task:s:handle other args
# eval set -- "$vars"
# for opt; do
#     case "$opt" in
#       -v|--dryrun)
#         dryrun=1
#         shift 2
#         ;;
#     esac
# done
# zero:task:e:handle other args


newname=wsl
oldname=


[ $1 ] && newname=$1
[ $2 ] && oldname=$2

[ -z $oldname ] && oldname=`hostname`

# echo "new:$newname; old:$oldname;"
# exit 0;

function put_file_wsl_conf(){
f=/etc/wsl.conf

# echo "[task] set $f"

# add file if does not exsit.
[ ! -e $f ] && touch $f

# txt="
# [network]
# hostname=$newname
# generateHosts = false
# "
# key=network;cat $f | grep "\[$key\]" > /dev/null 2>&1 ; [ $? -eq 1 ] && echo "$txt" >>  $f

# add [network] if does not exsit.
key=network;cat $f | grep "\[$key\]" > /dev/null 2>&1 ; [ $? -eq 1 ] && echo "[$key]" >> $f


# add hostname  if does not exsit.
cat $f | grep "hostname=" > /dev/null 2>&1 ; if [ $? -eq 0 ] ; then sed -iE "s/hostname=.*/hostname=$newname/g" $f ; else sed -i "s/\[$key\]/\[$key\]\nhostname=$newname/g"  $f ; fi

# echo "generateHosts = false" >> $f
cat $f | grep "generateHosts=" > /dev/null 2>&1 ; if [ $? -eq 0 ] ; then sed -iE "s/generateHosts=.*/generateHosts=false/g" $f ; else sed -i "s/\[$key\]/\[$key\]\ngenerateHosts=false/g"  $f ; fi
}

function put_file_hosts(){
    # echo "[task] set /etc/hosts"
    # change in /etc/hosts
    # oldname=`hostname`` ; sed -i "s/$oldname/$newname/g" /etc/hosts
    # oldname=DESKTOP-H1IKCEF ; sed -i "s/$oldname/$newname/g" /etc/hosts
    [ $oldname != $newname ] && sed -i "s/$oldname/$newname/g" /etc/hosts
}

function put_file_hostname(){
    # echo "[task] set /etc/hostname"
    # change in /etc/hostname 
    [ $oldname != $newname ] &&  echo "$newname" > /etc/hostname 
}
function info_changed_result(){
echo "# hostname from hostname cli"
hostname

f=/etc/hostname;
echo "# $f"
cat $f | sed "/^#/d" | sed "/^$/d"

f=/etc/hosts;
echo "# $f"
cat $f | sed "/^#/d" | sed "/^$/d"

f=/etc/wsl.conf;
echo "# $f"
cat $f | sed "/^#/d" | sed "/^$/d"

echo "# please reboot wsl. eg: 
1. exit; 
2. wsl --shutdown 
3. wsl
4. hostname
"
}


put_file_wsl_conf
put_file_hosts
put_file_hostname
info_changed_result




# usage
# index.sh wsl DESKTOP-H1IKCEF

# wslubt-use-host-name/index.sh wsl