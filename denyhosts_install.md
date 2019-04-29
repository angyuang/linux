># **介绍**
DenyHosts是Python语言写的一个程序，它会分析sshd的日志文件（`/var/log/secure`），当发现重复的攻击时就会记录IP到`/etc/hosts.deny`文件，从而达到自动屏IP的功能。

DenyHosts（项目主页：[http://denyhosts.sourceforge.net/]）是运行于Linux上的一款预防SSH暴力破解的软件，可以从[http://sourceforge.net/projects/denyhosts/files/]进行下载，然后将下载回来的DenyHosts-2.6.tar.gz源码包上传到Linux系统中

># **功能**

## 限制多个服务
DenyHost也可以使用其他程序服务，不仅仅用于SSH服务，例如：在配置文件`/usr/share/denyhosts/denyhosts.cfg`中限制sshd服务（`BLOCK_SERVICE = sshd`）

## 限制sshd服务原理
1. 对/var/log/secure日志文件进行分析，查找所有的登录尝试，并且过滤出失败和成功的尝试。
2. 记录下所有失败的登录尝试的用户名和主机，如果超过阀值，则记录主机。
3. 保持对每一个登录失败的用户（存在系统中或不存在系统中的用户）的跟踪
4. 对每一个可疑的登录进行跟踪。（虽然登录成功，但是有很多次登录失败的记录）
5. 将可疑地址的主机加入到`/etc/hosts.deny`文件中。
6. 被禁IP时间超过被禁阈值，IP从`/etc/hosts.deny`中删除

># **安装**

>## 1、下载镜像
`wget http://jaist.dl.sourceforge.net/project/denyhosts/denyhosts/2.6/DenyHosts-2.6.tar.gz`
>## 2、解压
tar -zxvf DenyHosts-2.6.tar.gz -C /opt/
>## 3、python安装及检查

- 安装python
 
    `yum install python -y`
- 查看版本
  
    `python -V`
>## 4、安装
- 安装denyhosts

    `cd /opt/DenyHosts-2.6/`

    `python setup.py install`

- 生成配置文件

    `cd /usr/share/denyhosts/`

   生成denyhosts配置文件

    `cp denyhosts.cfg-dist denyhosts.cfg`  

    daemon-control为启动程序

    `cp daemon-control-dist daemon-control`
- 配置权限
  
    添加root权限

    `chown root daemon-control`
    
    修改为可执行文件                                           
    
    `chmod 700 daemon-control                                            `

- 建立软链

    `ln -s /usr/share/denyhosts/daemon-control /etc/rc.d/init.d/denyhosts`

- 将denghosts设成开机启动
    `chkconfig denyhosts on`

    `chkconfig --list denyhosts`
- 启动程序
    `/etc/init.d/denyhosts start`

    `/etc/init.d/denyhosts status`
># **配置信息说明**
`vim /usr/share/denyhosts/denyhosts.cfg`

>## 配置信息
```bash
SECURE_LOG = /var/log/secure 
##ssh 日志文件，redhat系列根据/var/log/secure文件来判断；Mandrake、FreeBSD根据 /var/log/auth.log来判断
#SUSE则是用/var/log/messages来判断，这些在配置文件里面都有很详细的解释。

HOSTS_DENY = /etc/hosts.deny 
#将阻止IP写入到hosts.deny

PURGE_DENY = 5m 
#过多久后清除已经禁止的，其中w代表周，d代表天，h代表小时，s代表秒，m代表分钟
# ‘m’ = minutes
# ‘h’ = hours
# ‘d’ = days
# ‘w’ = weeks
# ‘y’ = years

BLOCK_SERVICE = sshd 
#禁止的服务名，当然DenyHost不仅仅用于SSH服务

DENY_THRESHOLD_INVALID = 5 
#允许无效用户（在/etc/passwd未列出）登录失败次数,允许无效用户登录失败的次数.

DENY_THRESHOLD_VALID = 5 
#允许普通用户登录失败的次数

DENY_THRESHOLD_ROOT = 5 
#允许root登录失败的次数

DENY_THRESHOLD_RESTRICTED = 1 
#设定 deny host 写入到该资料夹

WORK_DIR = /usr/share/denyhosts/data 
#将deny的host或ip纪录到Work_dir中 

SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS = YES

HOSTNAME_LOOKUP=YES 
#是否做域名反解

LOCK_FILE = /var/lock/subsys/denyhosts 
#将DenyHOts启动的pid纪录到LOCK_FILE中，已确保服务正确启动，防止同时启动多个服务。

ADMIN_EMAIL = denyhosts@163.com 
#设置管理员邮件地址 
SMTP_HOST = localhost 
SMTP_PORT = 25 
SMTP_FROM = DenyHosts <nobody@localhost> 
SMTP_SUBJECT = DenyHosts Report

AGE_RESET_VALID=1d 
#有效用户登录失败计数归零的时间

AGE_RESET_ROOT=1d 
#root用户登录失败计数归零的时间

AGE_RESET_RESTRICTED=5d 
#用户的失败登录计数重置为0的时间(/usr/share/denyhosts/data/restricted-usernames)

AGE_RESET_INVALID=10d 
#无效用户登录失败计数归零的时间

DAEMON_LOG = /var/log/denyhosts 
# #DenyHosts日志文件存放的路径，默认

DAEMON_SLEEP = 30s

DAEMON_PURGE = 5m 
#该项与PURGE_DENY 设置成一样，也是清除hosts.deniedssh 用户的时间
```

># **其他**
[https://www.server-memo.net/server-setting/ssh/ssh-denyhosts.html]

[http://www.cnblogs.com/suihui/p/3899381.html]

[https://meetes.top/2018/08/05/CentOS7%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%9F%BA%E6%9C%AC%E5%AE%89%E5%85%A8%E9%98%B2%E6%8A%A4%E7%AF%87]

[https://blog.csdn.net/qq_41729148/article/details/88750014]

