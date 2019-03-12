
[TOC]

>### 1、环境检查
关闭selinux、关闭防火墙、关闭NetworkManager、检查系统版本cat /etc/redhat-release 

>### 2、配置公网
测试能上公网

    ping www.baidu.com

配置DNS

`vim /etc/resolv.conf`

    nameserver 114.114.114.114

>### 3、配置阿里yum源（本例）或使用本地yum源

`vim /etc/yum.repos.d/CentOS-Base.repo`

```bash
     
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=osinfra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates 
[updates]
name=CentOS-$releasever - Updates
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&   infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&   infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&   infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```


>### 4、安装epel包
`yum install epel-release`

>### 5、更新或者安装nux-dextop软件

`rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm`

>### 6、搭建nux-dextop的源头为安装xrdp做准备

`vim /etc/yum.repos.d/xrdp.repo`
```shell
[xrdp]
name=xrdp
baseurl=http://li.nux.ro/download/nux/dextop/el7/x86_64/
enabled=1
gpgcheck=0
```

>### 7、安装xrdp、vnc两个软件
`yum install xrdp tigervnc-server `

>### 8、启动服务，添加开机启动项
```shell
systemctl start xrdp.service
systemctl enable xrdp.service 
systemctl status xrdp.service 
```
>### 9、查看xrdp服务是否开启

`netstat -antup | grep xrdp `

>### 10、添加防火墙本例使用firewalld，也可使用iptables
```shell
firewall-cmd --permanent --zone=public --add-port=3389/tcp
firewall-cmd --reload
```

>### 11、登录测试在win使用mstsc输入对应的ip即可
