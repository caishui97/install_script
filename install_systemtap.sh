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

# test network if is up
ping -c3 baidu.com
checkok

# download debug generic for systemtap
# first install epel,wget,systemtap,kernel-devel
yum install  -y epel-release
yum install  -y wget
yum install  -y systemtap
yum install  -y kernel-devel-$release

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
