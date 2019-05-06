#!/bin/bash

#check failed_user max/min_num max/min_time
pam_key=pam_tally2
pam_file=(login sshd system-auth)
#centos_version
Centos_version=`cat /etc/redhat-release |awk -F"release" '{print $2}'|cut -d"." -f 1`
Centos=`cat /etc/redhat-release`

#function  if Centos6 or Centos7  do restart sever
#Centos_svr=(rsyslog sshd)
function svr_restart() {
	if [ ${Centos_version} -eq 7 ]
	then
	    echo "---------------------------------system7${Centos_svr-sshd}----------------------------------------------------------${Centos}"
	    systemctl restart ${Centos_svr-sshd}
	    #echo  "system${Centos_svr-rsyslog}"
	else
	    echo "---------------------------------sevice6${Centos_svr-sshd}----------------------------------------------------------${Centos}"
	    service ${Centos_svr-sshd} restart
#	    echo "sevice${Centos_svr-rsyslog}"
	fi
}


function pam_check() {

        for file in ${pam_file[*]}
        do
#               grep pam_taly2 /etc/pam.d/login
                grep ${pam_key} /etc/pam.d/$file #&> /dev/null
                #grep ${pam_key} /etc/pam.d/login
                if [ $? -eq 0 ]
                then
                        echo '------------------------------------------------------------------grep ${pam_key} /etc/pam.d/$file'
			sed -i "/${pam_key}/d" /etc/pam.d/${file}
                        sed -i '/#%PAM-1.0/aauth       required pam_tally2.so deny=6 unlock_time=300 even_deny_root root_unlock_time=30' /etc/pam.d/${file}
                else
                        echo "------------------------------------------------------------set failed_user max/min_num max/min_time"
                        sed -i '/#%PAM-1.0/aauth       required pam_tally2.so deny=6 unlock_time=300 even_deny_root root_unlock_time=30' /etc/pam.d/${file}
                fi
        done
}

#set failed_user max/min_num max/min_time
#pam_check ${pam_key} ${pam_file}
pam_check ${pam_key}

#check Login_Root wheel=user
#grep grou=wheel /etc/pam.d/su &> /dev/null
grep "grou=wheel" /etc/pam.d/su 
if [ $? -eq 0 ]
then
        echo '-----------------------------------------------------------------------grep grou=wheel /etc/pam.d/su'
	if [ ${Centos_version} -eq 7 ]
	then
	    echo "-------------------------------------------------------------------------------------------${Centos}"
	    systemctl restart sshd
	else
	    echo "-------------------------------------------------------------------------------------------${Centos}"
	    service sshd restart
	fi

else
        echo "-----------------------------------------------------------------------Login_Root wheel=user"
	sed -i 's/PermitRootLogin/#^PermitRootLogin/;/#^PermitRootLogin/a PermitRootLogin no' /etc/ssh/sshd_config
        sed -i '/#%PAM-1.0/aauth            required        pam_wheel.so group=wheel' /etc/pam.d/su
fi

#check User Password password len maxday warn 
sed -i 's/PASS_MAX_DAYS/#^PASS_MAX_DAYS/;/#^PASS_MAX_DAYS/a PASS_MAX_DAYS   90' /etc/login.defs
sed -i 's/PASS_MIN_DAYS/#^PASS_MIN_DAYS/;/#^PASS_MIN_DAYS/a PASS_MIN_DAYS   1' /etc/login.defs
sed -i 's/PASS_MIN_LEN /#^PASS_MIN_LEN /;/#^PASS_MIN_LEN /a PASS_MIN_LEN    8' /etc/login.defs
sed -i 's/PASS_WARN_AGE/#^PASS_WARN_AGE/;/#^PASS_WARN_AGE/a PASS_WARN_AGE   7' /etc/login.defs

#wget install
cd /root
wget http://jaist.dl.sourceforge.net/project/denyhosts/denyhosts/2.6/DenyHosts-2.6.tar.gz
#tar 
echo "------------------------------------------------------------------------------------------/opt/DenyHosts-2.6/" 
tar -zxf /root/DenyHosts-2.6.tar.gz -C /opt
python -V
#install
echo "------------------------------------------------------------------------------------------INSTALLL"
cd /opt/DenyHosts-2.6/
python setup.py install

#configure
echo "--------------------------------------------------------------------------Configure-----------------/usr/share/denyhosts/"
cd /usr/share/denyhosts/
echo "--------------------------------------------------------------------------Configure-----------------/usr/share/denyhosts/denyhosts.cfg"

cp denyhosts.cfg-dist denyhosts.cfg

echo "--------------------------------------------------------------------------Configure-----------------Sed1H"
sed -i 's/PURGE_DENY = /PURGE_DENY = 1h/g' denyhosts.cfg
echo "--------------------------------------------------------------------------Configure-----------------Sed USER_3"
sed -i 's/DENY_THRESHOLD_VALID = 10/DENY_THRESHOLD_VALID = 3/g' denyhosts.cfg
echo "--------------------------------------------------------------------------Configure-----------------Sed ROOT_3"
sed -i 's/DENY_THRESHOLD_ROOT = 1/DENY_THRESHOLD_ROOT = 3/g' denyhosts.cfg

#wget https://github.com/angyuang/linux/blob/master/denyhosts.cfg
echo "--------------------------------------------------------------------------Configure-----------------/usr/share/denyhosts/daemon-control"
cp daemon-control-dist daemon-control

#chown
echo "-------------------------------------------------------------------------------------------chown-chmod"
chown root.root daemon-control
chmod 700 daemon-control

#service softLink
echo "-------------------------------------------------------------------------------------------SoftLink"
ln -s /usr/share/denyhosts/daemon-control /etc/rc.d/init.d/denyhosts

echo "-------------------------------------------------------------------------------------------Chkconfig"
chkconfig denyhosts on
chkconfig --list denyhosts

#allow ip
echo "-------------------------------------------------------------------------------------------Allow"
echo -e "sshd:36.111.88.33\nsshd:10.0.0.0/8" >> /etc/hosts.allow

#restart other server
echo "-------------------------------------------------------------------------------------------Other server"
#default sshd restart
svr_restart

#set rsyslog restart
Centos_svr=rsyslog
svr_restart ${Centos_svr}

#start server

echo "-------------------------------------------------------------------------------------------Start server"
/etc/init.d/denyhosts start
/etc/init.d/denyhosts status
