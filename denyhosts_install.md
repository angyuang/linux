https://meetes.top/2018/08/05/CentOS7%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%9F%BA%E6%9C%AC%E5%AE%89%E5%85%A8%E9%98%B2%E6%8A%A4%E7%AF%87/


tar zxvf DenyHosts-2.6.tar.gz                                           #解压源码包
cd DenyHosts-2.6                                                            #进入安装解压目录
python setup.py install                                                    #安装DenyHosts
cd /usr/share/denyhosts/                                                #默认安装路径
cp denyhosts.cfg-dist denyhosts.cfg                                #denyhosts.cfg为配置文件
cp daemon-control-dist daemon-control                        #daemon-control为启动程序
chown root daemon-control                                           #添加root权限
chmod 700 daemon-control                                            #修改为可执行文件
ln -s /usr/share/denyhosts/daemon-control /etc/init.d     #对daemon-control进行软连接，方便管理



/etc/init.d/daemon-control start          #启动denyhosts
chkconfig daemon-control on             #将denghosts设成开机启动
******************************************************************

vi /usr/share/denyhosts/denyhosts.cfg       #编辑配置文件，另外关于配置文件一些参数，通过grep -v "^#" denyhosts.cfg查看
SECURE_LOG = /var/log/secure                  #ssh 日志文件，redhat系列根据/var/log/secure文件来判断；Mandrake、FreeBSD根据 /var/log/auth.log来判断
                                                                  #SUSE则是用/var/log/messages来判断，这些在配置文件里面都有很详细的解释。
HOSTS_DENY = /etc/hosts.deny                 #控制用户登陆的文件
PURGE_DENY = 30m                                  #过多久后清除已经禁止的，设置为30分钟；
# ‘m’ = minutes
# ‘h’ = hours
# ‘d’ = days
# ‘w’ = weeks
# ‘y’ = years
BLOCK_SERVICE = sshd                           #禁止的服务名，当然DenyHost不仅仅用于SSH服务
DENY_THRESHOLD_INVALID = 1             #允许无效用户失败的次数
DENY_THRESHOLD_VALID = 3                 #允许普通用户登陆失败的次数
DENY_THRESHOLD_ROOT = 3                 #允许root登陆失败的次数
DAEMON_LOG = /var/log/denyhosts      #DenyHosts日志文件存放的路径，默认

更改DenyHosts的默认配置之后，重启DenyHosts服务即可生效: 
/etc/init.d/daemon-control restart         #重启denyhosts




-----------------------
denyhosts也是一个防止sshd暴力破解的开源软件，他可以有效的阻止对ssd服务器的攻击。它具有以下的特点：
1. 对/var/log/secure日志文件进行分析，查找所有的登录尝试，并且过滤出失败和成功的尝试。
2.记录下所有失败的登录尝试的用户名和主机，如果超过阀值，则记录主机。
3.保持对每一个登录失败的用户（存在系统中或不存在系统中的用户）的跟踪
4.对每一个可疑的登录进行跟踪。（虽然登录成功，但是有很多次登录失败的记录）
5.将可疑地址的主机加入到/etc/hosts.deny文件中。

具体的使用步骤
1下载
wget http://jaist.dl.sourceforge.net/project/denyhosts/denyhosts/2.6/DenyHosts-2.6.tar.gz
2解压
tar -zxvf DenyHosts-2.6.tar.gz -C /usr/local/bin
3进入解压文件夹
cd DenyHosts-2.6
4安装python环境
yum install -y python
5开始编译安装setup.py
python setup.py install
6编辑配置文件
 cd /usr/share/denyhosts/    
cp denyhosts.cfg-dist denyhosts.cfg    
cp daemon-control-dist daemon-control
vim denyhosts.cfg
7启动denyhosts并且设置为开机自启动
cd /etc/rc.d/init.d/
ln -s /usr/share/denyhosts/daemon-control denyhosts
chkconfig --add denyhosts
chkconfig denyhosts on 
chkconfig --list denyhosts
8安装完成。

配置文件的重要说明
PURGE_DENY：当一个IP被阻止以后，过多长时间被自动解禁。可选如3m（三分钟）、5h（5小时）、2d（两天）、8w（8周）、1y（一年）；
PURGE_THRESHOLD：定义了某一IP最多被解封多少次。即某一IP由于暴力破解SSH密码被阻止/解封达到了PURGE_THRESHOLD次，则会被永久禁止；
BLOCK_SERVICE：需要阻止的服务名；
DENY_THRESHOLD_INVALID：某一无效用户名（不存在的用户）尝试多少次登录后被阻止；
DENY_THRESHOLD_VALID：某一有效用户名尝试多少次登陆后被阻止（比如账号正确但密码错误），root除外；
DENY_THRESHOLD_ROOT：root用户尝试登录多少次后被阻止；
HOSTNAME_LOOKUP：是否尝试解析源IP的域名；
--------------------- 
作者：_ady 
来源：CSDN 
原文：https://blog.csdn.net/qq_41729148/article/details/88750014 
版权声明：本文为博主原创文章，转载请附上博文链接！

-------------------------------
https://my.oschina.net/itlzm/blog/1610812
# 查看系统登陆日志
vim /var/log/secure

修改ssh默认端口
开放新的端口
# 开放端口
firewall-cmd --zone=public --add-port=20000/tcp --permanent
# 重启防火墙
firewall-cmd --reload
修改/etc/ssh/sshd_config
vi /etc/ssh/sshd_config
#Port 22         //这行去掉#号
Port 20000      //下面添加这一行
重启ssh
systemctl restart sshd.service
安装和配置DenyHosts
DenyHosts是Python语言写的一个程序，它会分析sshd的日志文件（/var/log/secure），当发现重 复的攻击时就会记录IP到/etc/hosts.deny文件，从而达到自动屏IP的功能。

安装denyhosts
# 更新系统（建议所有系统都先更新）
yum update

# 安装denyhosts
sudo yum install denyhosts

# 加入开机启动
$ chkconfig --add denyhosts


# 配置完后重启denyhosts
$ /etc/init.d/denyhosts restart

# 加入开机启动（第二种方式）
$ systemctl enable denyhosts

# 配置完后重启denyhosts（第二种方式）
$ systemctl restart denyhosts

# 查看denyhosts收集到的恶意ip
$ cat /etc/hosts.deny

# 统计该文件的行数
$ cat /etc/hosts.deny | wc -l
 注：是hosts.deny和hosts.allow。不是host.deny！不是host.deny！不是host.deny！

denyhosts配置详解
默认配置就能很好的工作，如要个性化设置可以修改 /etc/denyhosts.conf

############ THESE SETTINGS ARE REQUIRED ############
#sshd的日志文件
SECURE_LOG = /var/log/secure 
#将阻止IP写入到hosts.deny,所以这个工具只支持 支持tcp wrapper的协议     
HOSTS_DENY = /etc/hosts.deny 
#过多久后清除已阻止的IP,即阻断恶意IP的时长  （4周）   
PURGE_DENY = 4w 
#阻止服务名   
BLOCK_SERVICE  = sshd
#允许无效用户登录失败的次数     
DENY_THRESHOLD_INVALID = 5
#允许普通有效用户登录失败的次数   
DENY_THRESHOLD_VALID = 10  
#允许root登录失败的次数  
DENY_THRESHOLD_ROOT = 1   
#设定 deny host 写入到该资料夹   
DENY_THRESHOLD_RESTRICTED = 1
#将deny的host或ip记录到work_dir中      
WORK_DIR = /var/lib/denyhosts      
SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS=YES
#是否做域名反解   
HOSTNAME_LOOKUP=YES  
#将DenyHost启动的pid记录到LOCK_FILE中，已确保服务正确启动，防止同时启动多个服务  
LOCK_FILE = /var/lock/subsys/denyhosts    

############ THESE SETTINGS ARE OPTIONAL ############
#设置管理员邮件地址 例如****@163.com
ADMIN_EMAIL = root  
SMTP_HOST = localhost  
SMTP_PORT = 25  
SMTP_FROM = DenyHosts &lt;nobody@localhost&gt;  
SMTP_SUBJECT = DenyHosts Report from $[HOSTNAME]  
AGE_RESET_VALID=5d  
AGE_RESET_ROOT=25d  
AGE_RESET_RESTRICTED=25d  
AGE_RESET_INVALID=10d

######### THESE SETTINGS ARE SPECIFIC TO DAEMON MODE  ##########
#denyhost服务日志文件
DAEMON_LOG = /var/log/denyhosts  

DAEMON_SLEEP = 30s 
#该项与PURGE_DENY 设置成一样，也是清除hosts.deniedssh 用户的时间 
DAEMON_PURGE = 1h      
启动命令
service denyhosts start 或 systemctl start denyhosts
service denyhosts stop 或 systemctl stop denyhosts
service denyhosts status 或 systemctl status denyhosts

# 加入自启动
chkconfig denyhosts on 或 systemctl enable denyhosts