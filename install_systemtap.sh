#!/usr/bin/bash

release=`uname -a | cut -d' '  -f3`

printf  $release

printf "\n"

function checkok() {
    if [ $? -eq 0 ]
    then
        printf "run complete\n"
    else
        printf "something error happen\n "
        exit
    fi
}

function checkifinstall() {
# check 
com=`command -v $1`

    if [ $? -eq 0  ]
    then
        printf "$1 has be installed\n"
    else
        printf "begin install $1\n"
        yum install -y $1
        checkok
    fi
}


printf "test network if is up\n"
ping -c3 baidu.com
checkok
printf  "begin install epel repo \n"
yum install -y epel-release
checkok

printf "download debug generic for systemtap\n"
# first install epel,wget,systemtap,kernel-devel
checkifinstall wget
checkifinstall 


checkifinstall kernel-devel-$release

wget http://debuginfo.centos.org/7/x86_64/kernel-debuginfo-common-x86_64-$release.rpm
checkok
wget http://debuginfo.centos.org/7/x86_64/kernel-debuginfo-$release.rpm
checkok

# Installing Required Kernel Information Packages Manually
rpm -ivh kernel-debuginfo-common-x86_64-$release.rpm
checkok
rpm -ivh kernel-debuginfo-$release.rpm
checkok

printf "Initial Testing \n"
stap -c df -e 'probe syscall.* { if (target()==pid()) log(name." ".argstr) }'
