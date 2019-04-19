>## 1、配置好yum源
`wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo`

`yum clean all`

`yum repolist`

>## 2、卸载java-openjdk
查看安装那些java

`rpm -qa|grep java`

卸载java-openjdk
```bash
yum remove java-1.7.0-openjdk -y
yum remove java-1.8.0-openjdk -y
yum remove java-1.7.0-openjdk-headless -y
yum remove java-1.8.0-openjdk-headless -y
```

>## 3、确认firefox版本
`firefox -version`

**注意：
从 Firefox 版本 52 开始，停止支持除 Adobe Flash 之外的所有 NPAPI 插件**

[firefox52.9版本下载](https://ftp.mozilla.org/pub/firefox/releases/52.9.0esr/)

[mozilla官网解释](https://support.mozilla.org/zh-CN/kb/Firefox%20%E4%B8%AD%E4%BD%BF%E7%94%A8%20Java%20%E6%8F%92%E4%BB%B6）

[java官网解释](https://java.com/zh_CN/download/help/firefox_java.xml)


>## 4、安装jdk以及配置环境变量

创建java目录，并解压到对应目录

`mkdir -pv /opt/java`

`tar -zxvf /opt/java/jdk-7u65-linux-x64.tar.gz -C /opt/java/`

配置环境变量

`vim /root/.bashrc`

```bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/java/jdk1.7.0_65/jre/bin:/opt/java/jdk1.7.0_65/bin
```

>## 5、firefox如何调用java plugin程序介绍

        在安装 Java 平台时，Java 插件文件将作为该安装的一部分包含在内。要在 Firefox 中使用 Java，您需要从该发行版中的插件文件手动创建符号链接指向 Firefox 预期的其中一个位置。对于 Firefox 版本 21 和更高版本，您必  须在主目录 ~/.mozilla/plugins 中创建符号链接。从 Firefox 版本 21 开始，不支持在 Firefox 应用程序目录的plugins 子目录中创建符号链接。现在firefox最新的firefox quantum浏览器已经不再自持java插件，需要下载以前的版本推荐下载：firefox-52.9.0esr.tar.bz2 这个本版 下载网址：https://ftp.mozilla.org/pub/firefox/releases/52.9.0esr/  找到自己对应软件的位数和语言。
        要配置 Java Plugin，请按照以下步骤执行：
### 配置Java Plugin

* 创建目录
  
`mkdir -pv /root/.mozilla/plugins/`

* 创建软链

`ln -s /opt/java/jdk1.7.0_65/jre/lib/amd64/libnpjp2.so /root/.mozilla/plugins/java`

* firefox 查看插件是否开启

打开firefox---->Add-on---->plugins---->Java(TM)

* 为java控制面板添加可信命令：ControlPanel

`/opt/java/jdk1.7.0_65/jre/bin/ControlPanel`

* 启动带外文件命令：javaws

`/opt/java/jdk1.7.0_65/jre/bin/javaws kvm.jnlp`

* 创建javaws程序桌面快捷方式

创建文件名sun_javaws.desktop的文件内容如下：

```bash
[Desktop Entry]
Name=Oracle jre javaws
Comment=Oracle jre javaws
Exec=/opt/java/jdk1.7.0_65/jre/bin/javaws 
Icon=/opt/java/jdk1.7.0_65/jre/plugin/desktop/sun_java.png
Terminal=false
Type=Application
Categories=Application
Encoding=UTF-8
StartupNotify=true
```

* 将快捷方式拷贝到/usr/share/applications目录下

`cp /root/Desktop/sum_javaws.desktop /usr/share/applications`

>## 6、带外验证

1. 通过firefox打开链接时候在弹出的标签选择你想要firefox如何处理此文件打，通过选择新加的javaws就可以

2. javaws kvm.jnlp  #这种方式跟通过浏览器打开是一样的，只是麻烦点，通过浏览器插件也是调用javaws这个程序

3. 如果系统里同时存在两个版本的java程序，可以通过选择各自的插件，或者通过绝对路径程序来运行（环境变量只能指定一个，另外的就要用程序绝对路径

>## 7、原理介绍firefox调用java插件
```bash
    原文连接：https://www.cnblogs.com/pipci/p/8609846.html

在安装 Java 平台时，Java 插件文件将作为该安装的一部分包含在内。要在 Firefox 中使用Java，您需要从该发       行版中的插件文件手动创建符号链接指向 Firefox 预期的其中一位置。对于 Firefox 版本 21 和更高版本，您必  须在主目录 ~/.mozilla/plugins 中创建号链接。从 Firefox 版本 21 开始，不支持在 Firefox 应用程序目录     的 plugins 子目中创建符号链接。现在firefox最新的firefox quantum浏览器已经不再自持java插件，需要下    载以前的版本推荐下载：firefox-52.9.0esr.tar.bz2 这个本版 下载网址：https:/ftp.mozilla.org/pub/    firefox/releases/52.9.0esr/  找到自己对应软件的位数和言。
要配置 Java Plugin，请按照以下步骤执行：
1、退出 Firefox 浏览器（如果它已在运行）。
2、卸载以前安装的所有 Java 插件。
3、一次只能使用一个 Java 插件。如果希望使用其他插件或插件的不同版本，请删除指向任何其版本的符号链接，     并创建指向新版本的全新符号链接。
4、删除指向 Firefox plugins 目录中的 javaplugin-oji.so 和 libnpjp2.so 的符号链（或者将这些链接移      至其他目录）。
5、创建指向 Firefox plugins 目录中的 Java 插件的符号链接
        转至 Firefox plugins 目录
        cd ~/.mozilla/plugins
        如果 plugins 目录不存在，则创建该目录。
        创建符号链接
        32 位插件：
        ln -s Java 安装目录/lib/i386/libnpjp2.so。
        64 位插件：
        ln -s Java 安装目录/lib/amd64/libnpjp2.so。
    示例
        我的 Java 安装在以下目录中：
        usr/local/java/  #安装目录
        则在终端窗口上键入以下命令，转至浏览器的插件目录：
        cd ~/.mozilla/plugins/
        输入以下命令，创建指向用于 Firefox 的 Java 插件的符号链接：
        pipci@ubuntu:~/.mozilla/plugins$ ln -s /usr/local/java/jre1.8.0_161/lib/amd64/      libnpjp2.so 
    启动 Firefox 浏览器，如果该浏览器已启动，则重新启动。
    在 Firefox 的位置栏中，键入 about:plugins 以确认 Java 插件已加载。还可以单击 "Tools"（工具）菜单        以确认其中存在 Java 控制台。
```


>## 8、其他引用
```bash
openjdk
如果是安装的OpenJDK，很遗憾它是没有libnpjp2.so的。
　　此时按照网上各种奇怪的方法都挣扎无效，但可以用icedtea插件来解决这个问题。
　　icedtea的版本与本机安装的OpenJDK版本有关，一般default-java-plugin会自动选中：
1 sudo apt-get install default-java-plugin
　　显示如下信息（截取部分）：
The following NEW packages will be installed:
  default-java-plugin icedtea-8-plugin icedtea-netx icedtea-netx-common
　　如果icedtea未被选中，则需要手动选择安装，或apt-get update一下。
　　确定安装完成后，再用Firefox等打开带有Java插件调用的网页，会调用icedtea插件。如http://     www.java.com/en/download/installed8.jsp，点击“Verify Java version”后Firefox会提示允许加       载icedtea插件，允许后显示icedtea的界面，再次允许操作后即在网上显示出已安装的Java（OpenJRE）      的版本。
二、Oracle java
1、首先要安装Oracle java（jre）安装方法前面的文章已经写了，这里就不讲述了。
链接 http://www.cnblogs.com/pipci/p/8609820.html
先创建javaws程序桌面快捷方式，
创建文件名sun_javaws.desktop的文件内容如下：
[Desktop Entry]
Name=Oracle jre javaws
Comment=Oracle jre javaws
Exec=/opt/java/jdk1.7.0_65/jre/bin/javaws 
Icon=/opt/java/jdk1.7.0_65/jre/plugin/desktop/sun_java.png
Terminal=false
Type=Application
Categories=Application
Encoding=UTF-8
StartupNotify=true
cp /root/Desktop/sum_javaws.desktop /usr/share/applications
将上面的sun_java.desktop 文件复制到/usr/share/applications/ 目录 命令：
pipci@ubuntu:~$ sudo cp -v sun_java.desktop sun_java.desktop
通过firefox打开链接时候在弹出的标签 你想要firefox如何处理此文件？打开 通过 处选择新加javaws       就可以。
2、Opera Chromium浏览器可能不会关联这个插件，没有关系打开这个链接后会自动下载一个jnlp的件，       把他保存到指定的目录,通过javaws命令运行就可以。
例：指定目录是/home/pipci/Downloads/   jnlp文件为kvm.jnlp  命令如下：
root@ubuntu:/home/pipci/Downloads# javaws kvm.jnlp       #这种方式跟通过浏览器打开是样        的，只是麻烦点，通过浏览器插件也是调用javaws这个程序。
三、如果系统里同时存在两个版本的java程序，可以通过选择各自的插件，或者通过绝对路径程序来行（环        境变量只能指定一个，另外的就要用程序绝对路径）。
```
Firefox 浏览器添加Linux jre插件
https://www.cnblogs.com/pipci/p/8609846.html

Ubuntu下通过Firefox Opera Chromium浏览器直接执行java应用程序（打开java jnlp文件）实现在服务器远程虚拟控制台完成远程管理的方法
https://www.cnblogs.com/pipci/p/8616223.html

解决Ubuntu下Firefox+OpenJDK没有Java插件的问题
http://www.cnblogs.com/BlackStorm/p/5480761.html

Ubuntu下Firefox安装jre插件
http://www.micmiu.com/os/linux/ubuntu-firefox-jre/
