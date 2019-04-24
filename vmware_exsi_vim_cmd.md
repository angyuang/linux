># **VMwareCLI命令参考**

[TOC]

>### 基本命令范例

```bash
vmware -v                      #  看你的esx版本
VMware ESXi 5.0.0 build-469512
 
esxcfg-info -a                 #  显示所有ESX相关信息
esxcfg-info -w                 #  显示esx上硬件信息
service mgmt-vmware restart    #  重新启动vmware服务
esxcfg-vmknic -l               #  查看宿主机IP地址
 
esxcli hardware cpu list       #  cpu信息 Brand，Core Speed，
esxcli hardware cpu global get #  cpu信息 （CPU Cores）
esxcli hardware memory get     #  内存信息 内存 Physical Memory
esxcli hardware platform get   #  硬件型号，供应商等信息,主机型号,Product Name 供应商,Vendor Name
esxcli hardware clock get      #  当前时间
 
esxcli system version get                           # 查看ESXi主机版本号和build号
esxcli system maintenanceMode set --enable yes      # 将ESXi主机进入到维护模式
esxcli system maintenanceMode set --enable no       # 将ESXi主机退出维护模式
esxcli system settings advanced list -d             # 列出ESXi主机上被改动过的高级设定选项
esxcli system settings kernel list -d               # 列出ESXi主机上被变动过的kernel设定部分
esxcli system snmp get | hash | set | test          # 列出、测试和更改SNMP设定
 
esxcli vm process list                              # 利用esxcli列出ESXi服务器上VMs的World I(运行状态的)
esxcli vm process kill -t soft -w WorldI           # 利用esxcli命令杀掉VM
 
vim-cmd hostsvc/hostsummary          # 查看宿主机摘要信息
vim-cmd vmsvc/get.datastores         # 查看宿主存储空间信息
vim-cmd vmsvc/getallvms              # 列出所有虚拟机
 
vim-cmd vmsvc/power.getstate VMI    # 查看指定VMI虚拟状态
vim-cmd vmsvc/power.shutdown VMI    # 关闭虚拟机
vim-cmd vmsvc/power.off VMI         # 如果虚拟机没有关闭，使用poweroff命令
vim-cmd vmsvc/get.config VMI        # 查看虚拟机配置信息


esxcli software vib install -d /vmfs/volumes/datastore/patches/xxx.zip  # 为ESXi主机安装更新补丁和驱动
 
esxcli network nic list         # 列出当前ESXi主机上所有NICs的状态
esxcli network vm list          # 列出虚拟机的网路信息
esxcli storage nmp device list  # 理出当前NMP管理下的设备satp和psp信息
esxcli storage core device vaai status get # 列出注册到PS设备的VI状态
 
esxcli storage nmp satp set --default-psp VMW_PSP_RR --satp xxxx # 利用esxcli命令将缺省psp改成Round Robin
``` 
***
># **esxcli信息查询**

## esxcli命令帮助信息

ssh登录VMware ESX server控制台，用esxcli命令查询虚拟机信息，输出格式支持普通、xml、csv、keyvalue。

esxcli是一python编写的工具(/sbin/esxcli.py)。

'''使用--formatter=xml选项使结果以xml格式输出，更便于程序解析。'''

## 官方说明：

1. http://pubs.vmware.com/vsphere-50/topic/com.vmware.vcli.ref.doc_50/vcli-right.html
2. http://pubs.vmware.com/vsphere-50/topic/com.vmware.vsphere.scripting.doc_50/GUI-522B42-78C1-43-8708-E022B82BC.html

```bash
esxcli --help

Usage: esxcli [options] {namespace}+ {cmd} [cmd options]

Options:
  --formatter=ORMTTER
                        Override the formatter to use for a given command. vailable formatter: xml, csv, keyvalue
  --debug               Enable debug or internal use options
  --version             isplay version information for the script
  -?, --help            isplay usage information for the script

vailable Namespaces:
  esxcli                Commands that operate on the esxcli system itself allowing users to get additional information.
  fcoe                  VMware COE commands.
  hardware              VMKernel hardware properties and commands for configuring hardware.
  iscsi                 VMware iSCSI commands.
  network               Operations that pertain to the maintenance of networking on an ESX host. This includes a wide variety of commands to
                        manipulate virtual networking components (vswitch, portgroup, etc) as well as local host IP, NS and general host networking
                        settings.
  software              Manage the ESXi software image and packages
  storage               VMware storage commands.
  system                VMKernel system properties and commands for configuring properties of the kernel core system.
  vm                     small number of operations that allow a user to Control Virtual Machine operations.

```

>### 查看性能信息:esxtop

```bash
 9:31:31am up 35 days  7:49, 379 worlds, 16 VMs, 32 vCPUs; CPU load average: 0.02, 0.05, 0.05
PCPU USE(%): 1.1 1.1 1.4 2.2 3.5 1.8 1.6 1.6 0.6 0.8 0.8 0.5 1.7 1.6 1.5 1.4 VG: 1.4
PCPU UTIL(%): 3.7 3.9 5.0 7.3  11 6.0 5.4 5.3 2.3 2.7 2.9 1.9 5.4 5.2 4.7 4.6 VG: 4.9

      I      GI NME             NWL   %USE    %RUN    %SYS   %WIT %VMWIT    %RY   %ILE  %OVRLP   %CSTP  %MLMT  %SWPWT 
       1        1 idle               16 1518.25 1600.00    0.00    0.00       - 1600.00    0.00    2.29    0.00    0.00    0.00 
    1627     1627 ESET NO32_192.     6    4.88   14.37    0.07  578.65    0.00    0.53  183.72    0.02    0.00    0.00    0.00 
    1379     1379 TEST2.0_192.168.     6    4.24   11.40    0.10  581.75    0.00    0.40  187.16    0.03    0.00    0.00    0.00 
    1558     1558 [XMX_TEST]SP_1     6    2.56    7.45    0.11  585.88    0.00    0.26  190.68    0.03    0.00    0.00    0.00 
    1555     1555 [XMX_PreProd]     6    2.54    7.17    0.15  585.86    0.00    0.54  190.48    0.03    0.02    0.00    0.00 
    9669     9669 GEI__EMO_19     6    1.92    5.48    0.08  587.60    0.00    0.46  192.46    0.02    0.00    0.00    0.00 
 1682712  1682712 esxtop.1880935      1    1.18    3.54    0.00   95.39       -    0.00    0.00    0.00    0.00    0.00    0.00 
 1193230  1193230 slave1_1     6    1.02    2.86    0.06  590.45    0.00    0.28  195.30    0.01    0.00    0.00    0.00 
```
>### 通过ESXTOP中的k命令关闭虚拟机：

1. ssh登陆到ESXi主机，运行esxtop
2. 按c键切换到cpu模式
3. 按Shift+v，当前页面只显示虚拟机进程
4. 在当前显示中添加Leader World I这一列，找到要关闭的虚拟机的Leader World I
5. 按k键，在提示符模式下输入要关闭虚拟机的Leader World I，回车。

>### 硬盘卷信息

```bash
df -h                          # 查看系统磁盘卷容量
ilesystem   Size   Used vailable Use% Mounted on
VMS-5       1.6T   1.5T    123.7G  93% /vmfs/volumes/datastore1
vfat         4.0G  25.2M      4.0G   1% /vmfs/volumes/4ee1d386-965ba574-1fd5-1cc1de17e90e
vfat       249.7M 127.4M    122.3M  51% /vmfs/volumes/63850576-c5821586-5fce-4343bbbeb921
vfat       249.7M   8.0K    249.7M   0% /vmfs/volumes/93d3e977-2a99c33b-6c07-1e461ce7a96e
vfat       285.8M 176.2M    109.6M  62% /vmfs/volumes/4ee1d37e-1aa9294c-21f6-1cc1de17e90e
 
esxcli storage filesystem list        # 卷信息
Mount Point                                        Volume Name  UUI                                 Mounted  Type             Size          ree
-------------------------------------------------  -----------  -----------------------------------  -------  ------  -------------  ------------
/vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e  datastore1   4ee1d386-5b79612c-d9b1-1cc1de17e90e     true  VMS-5  1794491023360  132805296128
/vmfs/volumes/4ee1d386-965ba574-1fd5-1cc1de17e90e               4ee1d386-965ba574-1fd5-1cc1de17e90e     true  vfat       4293591040    4267048960
/vmfs/volumes/63850576-c5821586-5fce-4343bbbeb921               63850576-c5821586-5fce-4343bbbeb921     true  vfat        261853184     128225280
/vmfs/volumes/93d3e977-2a99c33b-6c07-1e461ce7a96e               93d3e977-2a99c33b-6c07-1e461ce7a96e     true  vfat        261853184     261844992
/vmfs/volumes/4ee1d37e-1aa9294c-21f6-1cc1de17e90e               4ee1d37e-1aa9294c-21f6-1cc1de17e90e     true  vfat        299712512     114974720
 
esxcli storage vmfs extent list    # 虚拟机使用的存储卷?
Volume Name  VMS UUI                            Extent Number  evice Name                           Partition
-----------  -----------------------------------  -------------  ------------------------------------  ---------
datastore1   4ee1d386-5b79612c-d9b1-1cc1de17e90e              0  naa.600508b1001030374542413430300400          3

````

>#### 查看网络信息

```bash
esxcli network ip interface ipv4 get
Name  IPv4 ddress   IPv4 Netmask   IPv4 Broadcast  ddress Type  HCP NS
----  -------------  -------------  --------------  ------------  --------
vmk0  192.168.0.150  255.255.255.0  192.168.0.255   STTIC           false
 
esxcfg-vmknic -l
Interface  Port Group/VPort   IP amily IP ddress     Netmask         Broadcast       MC ddress       MTU     TSO MSS   Enabled Type                
vmk0       Management Network  IPv4      192.168.0.150  255.255.255.0   192.168.0.255   1c:c1:de:17:e9:0c 1500    65535     true    STTIC 
 
esxcfg-route 
VMkernel default gateway is 192.168.0.253

```
>### 查看网络接口

```bash
esxcli network nic list
Name    PCI evice     river  Link  Speed  uplex  MC ddress         MTU  escription                                                  
------  -------------  ------  ----  -----  ------  -----------------  ----  -------------------------------------------------------------
vmnic0  0000:004:00.0  bnx2    Up     1000  ull    00:9c:02:9b:25:2c  1500  Broadcom Corporation Broadcom NetXtreme II BCM5709 1000Base-T
vmnic1  0000:004:00.1  bnx2    Up     1000  ull    00:9c:02:9b:25:2e  1500  Broadcom Corporation Broadcom NetXtreme II BCM5709 1000Base-T
vmnic2  0000:005:00.0  bnx2    Up     1000  ull    00:9c:02:9b:25:30  1500  Broadcom Corporation Broadcom NetXtreme II BCM5709 1000Base-T
vmnic3  0000:005:00.1  bnx2    Up     1000  ull    00:9c:02:9b:25:32  1500  Broadcom Corporation Broadcom NetXtreme II BCM5709 1000Base-T

````

>### 查看vswitch接口信息



```bash
esxcli network vswitch standard list
vSwitch0                             # 虚拟交换机0
   Name: vSwitch0
   Class: etherswitch
   Num Ports: 128
   Used Ports: 13
   Configured Ports: 128
   MTU: 1500
   CP Status: listen
   Beacon Enabled: false
   Beacon Interval: 1
   Beacon Threshold: 3
   Beacon Required By: 
   Uplinks: vmnic2, vmnic1, vmnic0             # 对应物理网口
   Portgroups: VM Network, Management Network  # 备注
 
vSwitch1
   Name: vSwitch1                    # 虚拟交换机1
   Class: etherswitch
   Num Ports: 128
   Used Ports: 10
   Configured Ports: 128
   MTU: 1500
   CP Status: listen
   Beacon Enabled: false
   Beacon Interval: 1
   Beacon Threshold: 3
   Beacon Required By: 
   Uplinks: vmnic3                   # 对应物理网口
   Portgroups: Vlan190               # 备注

```
>### 当前运行虚拟机列表

普通输入格式

```bash
esxcli vm process list
 
slave1_192.168.0222
   World I: 1331403
   Process I: 0
   VMX Cartel I: 1331402
   UUI: 56 4d b4 20 0a 16 b9 50-1c bd fc 7c 7b dd d5 84
   isplay Name: slave1_192.168.0222
   Config ile: /vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/slave1_192.168.0222/slave1_192.168.0222.vmx
 
TEST_192.0168.0.13
   World I: 1651806
   Process I: 0
   VMX Cartel I: 1651805
   UUI: 56 4d 0a 52 6e d2 61 7a-a5 84 1b e5 35 da d1 62
   isplay Name: TEST_192.0168.0.13
   Config ile: /vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/TEST_192.0168.0.15/TEST_192.0168.0.15.vmx
 
TEST2.0_192.168.0.200
   World I: 5602
   Process I: 0
   VMX Cartel I: 5601
   UUI: 56 4d 71 65 d5 83 a1 4c-9d 7e 4a 9e f4 9d e3 21
   isplay Name: TEST2.0_192.168.0.200
   Config ile: /vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/TEST2.0_192.168.0.200/TEST2.0_192.168.0.200.vmx
```
>### xml格式输出

```xml
esxcli --formatter=xml vm process list
 
<?xml version="1.0" encoding="utf-8"?>
<output xmlns="http://www.vmware.com/Products/ESX/5.0/esxcli">
<root>
   <list type="structure">
      <structure typeName="VirtualMachine">
         <field name="Configile">
            <string>/vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/slave1_192.168.0222/slave1_192.168.0222.vmx</string>
         </field>
         <field name="isplayName">
            <string>slave1_192.168.0222</string>
         </field>
         <field name="ProcessI">
            <integer>0</integer>
         </field>
         <field name="UUI">
            <string>56 4d b4 20 0a 16 b9 50-1c bd fc 7c 7b dd d5 84</string>
         </field>
         <field name="VMXCartelI">
            <integer>1331402</integer>
         </field>
         <field name="WorldI">
            <integer>1331403</integer>
         </field>
      </structure>
      <structure typeName="VirtualMachine">
         <field name="Configile">
            <string>/vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/TEST_192.0168.0.15/TEST_192.0168.0.15.vmx</string>
         </field>
         <field name="isplayName">
            <string>TEST_192.0168.0.13</string>
         </field>
         <field name="ProcessI">
            <integer>0</integer>
         </field>
         <field name="UUI">
            <string>56 4d 0a 52 6e d2 61 7a-a5 84 1b e5 35 da d1 62</string>
         </field>
         <field name="VMXCartelI">
            <integer>1651805</integer>
         </field>
         <field name="WorldI">
            <integer>1651806</integer>
         </field>
      </structure>
   </list>
</root>
</output>

```
***
># **vim-cmd**

```bash
vim-cmd help
Commands available under /:
hbrsvc/       internalsvc/  solo/         vmsvc/        
hostsvc/      proxysvc/     vimsvc/       help   
```
>## 列出所有虚拟机清单

```bash
vim-cmd vmsvc/getallvms


Vmid                          Name                                                                   ile                                                 Guest OS          Version                                                                                                 nnotation
101    test_192.168.0.70                                  [datastore1] test_192.168.0.70/test_192.168.0.70.vmx                             centos64Guest           vmx-08
102    Test2.0_192.168.0.148                            [datastore1] Test2.0_192.168.0.148/Test2.0_192.168.0.148.vmx                 centos64Guest           vmx-08    Creator：Leo
emanders/Team：ivel ang
Host IP：192.168.0.148
VM pp：MySql5.0
Project：Test2.0
Summary：Test2.0项目测试环境；使用时间2012年9月17日至2012年12月31日

103    Test2.0Wiki_192.168.0.149                        [datastore1] Test2.0_192.168.0.149/Test2.0_192.168.0.149.vmx                 centos64Guest           vmx-08    Creator：Leo
emanders/Team：ivel ang
Host IP：192.168.0.149
VM pp：
Project：Test2.0
Summary：Test2.0项Wiki安装；使用时间2012年9月17日至2012年12月31日
110    myXinglite_192.168.0.25                             [datastore1] myXinglite_192.168.0.25/myXinglite_192.168.0.25.vmx                   centosGuest             vmx-08
111    myXinglite_192.168.0.27                             [datastore1] myXInglite_192.168.0.27/myXInglite_192.168.0.27.vmx                   centosGuest             vmx-08
112    YUE_192.168.0.31                                      [datastore1] TEST_192.168.0.31/TEST_192.168.0.31.vmx                                   winXPProGuest           vmx-08

```
>### 查看指定虚拟机网络

```bash
vim-cmd vmsvc/get.networks 101
 
Networks:
 
(vim.Network.Summary) {
   dynamicType = <unset>, 
   network = 'vim.Network:HaNetwork-VM Network', 
   name = "VM Network", 
   accessible = true, 
   ipPoolName = "", 
}
```
>### 查看指定虚拟机摘要信息

该虚拟机配置情况：

1. 名称:test_192.168.0.70
2. CPUx2,RM:4096MB,ISK:SCSI (0:0) 40GB
3. 网络适配器1: E1000，VM Network，MC地址: 00:0c:29:d8:3b:e0
   
Guest系统中安装VMware Tools后，摘要信息中可查询到hostName、ipddress信息，若未安装则值为<unset>。
```bash
vim-cmd vmsvc/get.summary 101
 
Listsummary:
 
(vim.vm.Summary) {
   dynamicType = <unset>, 
   vm = 'vim.VirtualMachine:101', 
   runtime = (vim.vm.RuntimeInfo) {
      dynamicType = <unset>, 
      device = (vim.vm.eviceRuntimeInfo) [
         (vim.vm.eviceRuntimeInfo) {
            dynamicType = <unset>, 
            runtimeState = (vim.vm.eviceRuntimeInfo.VirtualEthernetCardRuntimeState) {
               dynamicType = <unset>, 
               vmirectPathGen2ctive = false, 
               vmirectPathGen2InactiveReasonVm = (string) [
                  "vmNptIncompatibledapterType", 
                  "vmNptisabledOrisconnecteddapter"
               ], 
               vmirectPathGen2InactiveReasonOther = (string) [
                  "vmNptIncompatibleNetwork"
               ], 
               vmirectPathGen2InactiveReasonExtended = <unset>, 
            }, 
            key = 4000, 
         }
      ], 
      host = 'vim.HostSystem:ha-host', 
      connectionState = "connected", 
      powerState = "poweredOff", 
      faultToleranceState = "notConfigured", 
      dasVmProtection = (vim.vm.RuntimeInfo.asProtectionState) null, 
      toolsInstallerMounted = false, 
      suspendTime = <unset>, 
      bootTime = <unset>, 
      suspendInterval = 0, 
      question = (vim.vm.QuestionInfo) null, 
      memoryOverhead = 203325440, 
      maxCpuUsage = 4800, 
      maxMemoryUsage = 4096, 
      numMksConnections = 0, 
      recordReplayState = "inactive", 
      cleanPowerOff = false, 
      needSecondaryReason = <unset>, 
      onlineStandby = false, 
      minRequiredEVCModeKey = <unset>, 
      consolidationNeeded = false, 
   }, 
   guest = (vim.vm.Summary.GuestSummary) {
      dynamicType = <unset>, 
      guestId = <unset>, 
      guestullName = <unset>, 
      toolsStatus = "toolsNotInstalled", 
      toolsVersionStatus = "guestToolsNotInstalled", 
      toolsVersionStatus2 = "guestToolsNotInstalled", 
      toolsRunningStatus = "guestToolsNotRunning", 
      hostName = <unset>, 
      ipddress = <unset>, 
   }, 
   config = (vim.vm.Summary.ConfigSummary) {
      dynamicType = <unset>, 
      name = "test_192.168.0.70", 
      template = false, 
      vmPathName = "[datastore1] test_192.168.0.70/test_192.168.0.70.vmx", 
      memorySizeMB = 4096, 
      cpuReservation = <unset>, 
      memoryReservation = <unset>, 
      numCpu = 2, 
      numEthernetCards = 1, 
      numVirtualisks = 1, 
      uuid = "564d379a-5654-a8b9-daab-2ed352d83be0", 
      instanceUuid = "52021751-e075-9a50-934d-e23419b1a06f", 
      guestId = "centos64Guest", 
      guestullName = "CentOS 4/5/6 (64-bit)", 
      annotation = "", 
      product = (vim.vpp.ProductInfo) null, 
      installBootRequired = <unset>, 
      ftInfo = (vim.vm.aultToleranceConfigInfo) null, 
      managedBy = (vim.ext.ManagedByInfo) null, 
   }, 
   storage = (vim.vm.Summary.StorageSummary) {
      dynamicType = <unset>, 
      committed = 47245126222, 
      uncommitted = 162594816, 
      unshared = 47245126222, 
      timestamp = "2013-03-17T18:16:01.868646Z", 
   }, 
   quickStats = (vim.vm.Summary.QuickStats) {
      dynamicType = <unset>, 
      overallCpuUsage = <unset>, 
      overallCpuemand = <unset>, 
      guestMemoryUsage = <unset>, 
      hostMemoryUsage = <unset>, 
      guestHeartbeatStatus = "gray", 
      distributedCpuEntitlement = <unset>, 
      distributedMemoryEntitlement = <unset>, 
      staticCpuEntitlement = <unset>, 
      staticMemoryEntitlement = <unset>, 
      privateMemory = <unset>, 
      sharedMemory = <unset>, 
      swappedMemory = <unset>, 
      balloonedMemory = <unset>, 
      consumedOverheadMemory = <unset>, 
      ftLogBandwidth = <unset>, 
      ftSecondaryLatency = <unset>, 
      ftLatencyStatus = <unset>, 
      compressedMemory = <unset>, 
      uptimeSeconds = <unset>, 
      ssdSwappedMemory = <unset>, 
   }, 
   overallStatus = "green", 
}
```
>### 查看指定虚拟机设备信息

其中包括网卡型号、MC地址等信息。
```bash
vim-cmd vmsvc/device.getdevices 101
 
evices:
 
(vim.vm.VirtualHardware) {
   dynamicType = <unset>, 
   numCPU = 2, 
   numCoresPerSocket = 2, 
   memoryMB = 4096, 
   virtualICH7MPresent = false, 
   virtualSMCPresent = false, 
   device = (vim.vm.device.Virtualevice) [
      (vim.vm.device.VirtualIEController) {
         dynamicType = <unset>, 
         key = 200, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "IE 0", 
            summary = "IE 0", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = <unset>, 
         unitNumber = <unset>, 
         busNumber = 0, 
      }, 
      (vim.vm.device.VirtualIEController) {
         dynamicType = <unset>, 
         key = 201, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "IE 1", 
            summary = "IE 1", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = <unset>, 
         unitNumber = <unset>, 
         busNumber = 1, 
         device = (int) [
            3002
         ], 
      }, 
      (vim.vm.device.VirtualPS2Controller) {
         dynamicType = <unset>, 
         key = 300, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "PS2 controller 0", 
            summary = "PS2 controller 0", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = <unset>, 
         unitNumber = <unset>, 
         busNumber = 0, 
         device = (int) [
            600, 
            700
         ], 
      }, 
      (vim.vm.device.VirtualPCIController) {
         dynamicType = <unset>, 
         key = 100, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "PCI controller 0", 
            summary = "PCI controller 0", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = <unset>, 
         unitNumber = <unset>, 
         busNumber = 0, 
         device = (int) [
            500, 
            12000, 
            1000, 
            4000
         ], 
      }, 
      (vim.vm.device.VirtualSIOController) {
         dynamicType = <unset>, 
         key = 400, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "SIO controller 0", 
            summary = "SIO controller 0", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = <unset>, 
         unitNumber = <unset>, 
         busNumber = 0, 
         device = (int) [
            8000
         ], 
      }, 
      (vim.vm.device.VirtualKeyboard) {
         dynamicType = <unset>, 
         key = 600, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "Keyboard ", 
            summary = "Keyboard", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = 300, 
         unitNumber = 0, 
      }, 
      (vim.vm.device.VirtualPointingevice) {
         dynamicType = <unset>, 
         key = 700, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "Pointing device", 
            summary = "Pointing device; evice", 
         }, 
         backing = (vim.vm.device.VirtualPointingevice.eviceBackingInfo) {
            dynamicType = <unset>, 
            deviceName = "", 
            useutoetect = false, 
            hostPointingevice = "autodetect", 
         }, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = 300, 
         unitNumber = 1, 
      }, 
      (vim.vm.device.VirtualVideoCard) {
         dynamicType = <unset>, 
         key = 500, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "Video card ", 
            summary = "Video card", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = 100, 
         unitNumber = 0, 
         videoRamSizeInKB = 4096, 
         numisplays = 1, 
         useutoetect = false, 
         enable3Support = false, 
         enableMPTSupport = <unset>, 
      }, 
      (vim.vm.device.VirtualVMCIevice) {
         dynamicType = <unset>, 
         key = 12000, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "VMCI device", 
            summary = "evice on the virtual machine PCI bus that provides support for the virtual machine communication interface", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = 100, 
         unitNumber = 17, 
         id = 1389902816, 
         allowUnrestrictedCommunication = false, 
      }, 
      (vim.vm.device.VirtualLsiLogicController) {
         dynamicType = <unset>, 
         key = 1000, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "SCSI controller 0", 
            summary = "LSI Logic", 
         }, 
         backing = (vim.vm.device.Virtualevice.BackingInfo) null, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = 100, 
         unitNumber = 3, 
         busNumber = 0, 
         device = (int) [
            2000
         ], 
         hotddRemove = true, 
         sharedBus = "noSharing", 
         scsiCtlrUnitNumber = 7, 
      }, 
      (vim.vm.device.Virtualisk) {
         dynamicType = <unset>, 
         key = 2000, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "Hard disk 1", 
            summary = "41,943,040 KB", 
         }, 
         backing = (vim.vm.device.Virtualisk.latVer2BackingInfo) {
            dynamicType = <unset>, 
            fileName = "[datastore1] test_192.168.0.70/test_192.168.0.70.vmdk", 
            datastore = 'vim.atastore:4ee1d386-5b79612c-d9b1-1cc1de17e90e', 
            diskMode = "persistent", 
            split = false, 
            writeThrough = false, 
            thinProvisioned = false, 
            eagerlyScrub = <unset>, 
            uuid = "6000C294-e9da-4137-7ffb-eda45b97abeb", 
            contentId = "1b9ca7efde49e066ab127e04ce8cc8d8", 
            changeId = <unset>, 
            parent = (vim.vm.device.Virtualisk.latVer2BackingInfo) null, 
            deltaiskormat = <unset>, 
            digestEnabled = false, 
         }, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) null, 
         controllerKey = 1000, 
         unitNumber = 0, 
         capacityInKB = 41943040, 
         shares = (vim.SharesInfo) {
            dynamicType = <unset>, 
            shares = 1000, 
            level = "normal", 
         }, 
         storageIOllocation = (vim.StorageResourceManager.IOllocationInfo) {
            dynamicType = <unset>, 
            limit = -1, 
            shares = (vim.SharesInfo) {
               dynamicType = <unset>, 
               shares = 1000, 
               level = "normal", 
            }, 
         }, 
      }, 
      (vim.vm.device.VirtualCdrom) {
         dynamicType = <unset>, 
         key = 3002, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "C/V drive 1", 
            summary = "ISO [datastore1] ISO/systems/CentOS-6.2-x86_64-bin-V1.iso", 
         }, 
         backing = (vim.vm.device.VirtualCdrom.IsoBackingInfo) {
            dynamicType = <unset>, 
            fileName = "[datastore1] ISO/systems/CentOS-6.2-x86_64-bin-V1.iso", 
            datastore = 'vim.atastore:4ee1d386-5b79612c-d9b1-1cc1de17e90e', 
         }, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) {
            dynamicType = <unset>, 
            startConnected = true, 
            allowGuestControl = true, 
            connected = false, 
            status = "untried", 
         }, 
         controllerKey = 201, 
         unitNumber = 0, 
      }, 
      (vim.vm.device.VirtualE1000) {
         dynamicType = <unset>, 
         key = 4000, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "Network adapter 1", 
            summary = "VM Network", 
         }, 
         backing = (vim.vm.device.VirtualEthernetCard.NetworkBackingInfo) {
            dynamicType = <unset>, 
            deviceName = "VM Network", 
            useutoetect = false, 
            network = 'vim.Network:HaNetwork-VM Network', 
            inPassthroughMode = <unset>, 
         }, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) {
            dynamicType = <unset>, 
            startConnected = true, 
            allowGuestControl = true, 
            connected = false, 
            status = "untried", 
         }, 
         controllerKey = 100, 
         unitNumber = 7, 
         addressType = "generated", 
         macddress = "00:0c:29:d8:3b:e0", 
         wakeOnLanEnabled = true, 
      }, 
      (vim.vm.device.Virtualloppy) {
         dynamicType = <unset>, 
         key = 8000, 
         deviceInfo = (vim.escription) {
            dynamicType = <unset>, 
            label = "loppy drive 1", 
            summary = "Remote", 
         }, 
         backing = (vim.vm.device.Virtualloppy.RemoteeviceBackingInfo) {
            dynamicType = <unset>, 
            deviceName = "", 
            useutoetect = false, 
         }, 
         connectable = (vim.vm.device.Virtualevice.ConnectInfo) {
            dynamicType = <unset>, 
            startConnected = false, 
            allowGuestControl = true, 
            connected = false, 
            status = "untried", 
         }, 
         controllerKey = 400, 
         unitNumber = 0, 
      }
   ], 
}
```
>### 查看指定虚拟机配置
```bash
vim-cmd vmsvc/get.config 101
 
Configuration:
 
(vim.vm.ConfigInfo) {
   dynamicType = <unset>, 
   changeVersion = "2013-03-17T18:15:55.461798Z", 
   modified = "1970-01-01T00:00:00Z", 
   name = "test_192.168.0.70", 
   guestullName = "CentOS 4/5/6 (64-bit)", 
   version = "vmx-08", 
   uuid = "564d379a-5654-a8b9-daab-2ed352d83be0", 
   instanceUuid = "52021751-e075-9a50-934d-e23419b1a06f", 
   npivWorldWideNameType = "", 
   npivesiredNodeWwns = <unset>, 
   npivesiredPortWwns = <unset>, 
   npivTemporaryisabled = true, 
   npivOnNonRdmisks = <unset>, 
   locationId = "564d379a-5654-a8b9-daab-2ed352d83be0", 
   template = false, 
   guestId = "centos64Guest", 
   alternateGuestName = "", 
   annotation = "", 
   files = (vim.vm.ileInfo) {
      dynamicType = <unset>, 
      vmPathName = "[datastore1] test_192.168.0.70/test_192.168.0.70.vmx", 
      snapshotirectory = "[datastore1] test_192.168.0.70", 
      suspendirectory = "[datastore1] test_192.168.0.70", 
      logirectory = "[datastore1] test_192.168.0.70", 
   }, 
   tools = (vim.vm.ToolsConfigInfo) {
      dynamicType = <unset>, 
      toolsVersion = 0, 
      afterPowerOn = true, 
      afterResume = true, 
      beforeGuestStandby = true, 
      beforeGuestShutdown = true, 
      beforeGuestReboot = <unset>, 
      toolsUpgradePolicy = "manual", 
      pendingCustomization = <unset>, 
      syncTimeWithHost = false, 
      lastInstallInfo = (vim.vm.ToolsConfigInfo.ToolsLastInstallInfo) {
         dynamicType = <unset>, 
         counter = 0, 
         fault = (vmodl.Methodault) null, 
      }, 
   }, 
   flags = (vim.vm.lagInfo) {
      dynamicType = <unset>, 
      disablecceleration = false, 
      enableLogging = true, 
      useToe = false, 
      runWithebugInfo = false, 
      monitorType = "release", 
      htSharing = "any", 
      snapshotisabled = <unset>, 
      snapshotLocked = <unset>, 
      diskUuidEnabled = false, 
      virtualMmuUsage = "automatic", 
      virtualExecUsage = "hvuto", 
      snapshotPowerOffBehavior = "powerOff", 
      recordReplayEnabled = false, 
   }, 
   consolePreferences = (vim.vm.ConsolePreferences) null, 
   defaultPowerOps = (vim.vm.efaultPowerOpInfo) {
      dynamicType = <unset>, 
      powerOffType = "soft", 
      suspendType = "hard", 
      resetType = "soft", 
      defaultPowerOffType = "soft", 
      defaultSuspendType = "hard", 
      defaultResetType = "soft", 
      standbyction = "checkpoint", 
   }, 
   hardware = (vim.vm.VirtualHardware) {
      dynamicType = <unset>, 
      numCPU = 419, 
      numCoresPerSocket = <unset>, 
      memoryMB = 192786044, 
      virtualICH7MPresent = <unset>, 
      virtualSMCPresent = <unset>, 
   }, 
   cpullocation = (vim.ResourcellocationInfo) {
      dynamicType = <unset>, 
      reservation = 0, 
      expandableReservation = false, 
      limit = -1, 
      shares = (vim.SharesInfo) {
         dynamicType = <unset>, 
         shares = 2000, 
         level = "normal", 
      }, 
      overheadLimit = <unset>, 
   }, 
   memoryllocation = (vim.ResourcellocationInfo) {
      dynamicType = <unset>, 
      reservation = 0, 
      expandableReservation = false, 
      limit = -1, 
      shares = (vim.SharesInfo) {
         dynamicType = <unset>, 
         shares = 40960, 
         level = "normal", 
      }, 
      overheadLimit = <unset>, 
   }, 
   memoryHotddEnabled = false, 
   cpuHotddEnabled = false, 
   cpuHotRemoveEnabled = false, 
   hotPlugMemoryLimit = <unset>, 
   hotPlugMemoryIncrementSize = <unset>, 
   cpuffinity = (vim.vm.ffinityInfo) null, 
   memoryffinity = (vim.vm.ffinityInfo) null, 
   networkShaper = (vim.vm.NetworkShaperInfo) null, 
   extraConfig = (vim.option.OptionValue) [
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "hpet0.present", 
         value = "true", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "nvram", 
         value = "test_192.168.0.70.nvram", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "virtualHW.productCompatibility", 
         value = "hosted", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "cpuid.coresPerSocket", 
         value = "2", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge0.present", 
         value = "true", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge4.present", 
         value = "true", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "replay.supported", 
         value = "false", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "sched.swap.derivedName", 
         value = "/vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/test_192.168.0.70/test_192.168.0.70-5f8c4459.vswp", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "replay.filename", 
         value = "", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "scsi0:0.redo", 
         value = "", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge0.pciSlotNumber", 
         value = "17", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge4.pciSlotNumber", 
         value = "21", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge5.pciSlotNumber", 
         value = "22", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge6.pciSlotNumber", 
         value = "23", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge7.pciSlotNumber", 
         value = "24", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "scsi0.pciSlotNumber", 
         value = "16", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge4.virtualev", 
         value = "pcieRootPort", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "ethernet0.pciSlotNumber", 
         value = "32", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "vmci0.pciSlotNumber", 
         value = "33", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "ethernet0.generatedddressOffset", 
         value = "0", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "hostCPUI.0", 
         value = "0000000568747541444d416369746e65", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "hostCPUI.1", 
         value = "00100f910008080000802009178bfbff", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "hostCPUI.80000001", 
         value = "00100f913000025f000837ffefd3fbff", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "guestCPUI.0", 
         value = "0000000568747541444d416369746e65", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "guestCPUI.1", 
         value = "00100f910002080080802001178bfbff", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "guestCPUI.80000001", 
         value = "00100f913000025f000003e9ebd3fbff", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "userCPUI.0", 
         value = "0000000568747541444d416369746e65", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "userCPUI.1", 
         value = "00100f910008080080802001178bfbff", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "userCPUI.80000001", 
         value = "00100f913000025f000003e9ebd3fbff", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "evcCompatibilityMode", 
         value = "LSE", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "vmotion.checkpointBSize", 
         value = "4194304", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "checkpoint.vmState", 
         value = "", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "tools.remindInstall", 
         value = "TRUE", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge4.functions", 
         value = "8", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge5.present", 
         value = "true", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge5.virtualev", 
         value = "pcieRootPort", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge5.functions", 
         value = "8", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge6.present", 
         value = "true", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge6.virtualev", 
         value = "pcieRootPort", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge6.functions", 
         value = "8", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge7.present", 
         value = "true", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge7.virtualev", 
         value = "pcieRootPort", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "pciBridge7.functions", 
         value = "8", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "vmware.tools.internalversion", 
         value = "0", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "vmware.tools.requiredversion", 
         value = "8384", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "vmware.tools.installstate", 
         value = "none", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "vmware.tools.lastInstallStatus", 
         value = "unknown", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "migrate.hostLogState", 
         value = "none", 
      }, 
      (vim.option.OptionValue) {
         dynamicType = <unset>, 
         key = "migrate.migrationId", 
         value = "0", 
      }
   ], 
   datastoreUrl = (vim.vm.ConfigInfo.atastoreUrlPair) [
      (vim.vm.ConfigInfo.atastoreUrlPair) {
         dynamicType = <unset>, 
         name = "datastore1", 
         url = "/vmfs/volumes/4ee1d386-5b79612c-d9b1-1cc1de17e90e/", 
      }
   ], 
   swapPlacement = "inherit", 
   swapirectory = <unset>, 
   preserveSwapOnPowerOff = <unset>, 
   bootOptions = (vim.vm.BootOptions) {
      dynamicType = <unset>, 
      bootelay = 0, 
      enterBIOSSetup = false, 
      bootRetryEnabled = false, 
      bootRetryelay = 10000, 
   }, 
   ftInfo = (vim.vm.aultToleranceConfigInfo) null, 
   vppConfig = (vim.vpp.VmConfigInfo) null, 
   vssertsEnabled = false, 
   changeTrackingEnabled = false, 
   firmware = "bios", 
   maxMksConnections = 40, 
   guestutoLockEnabled = false, 
   managedBy = (vim.ext.ManagedByInfo) null, 
   memoryReservationLockedToMax = false, 
   initialOverhead = (vim.vm.ConfigInfo.OverheadInfo) {
      dynamicType = <unset>, 
      initialMemoryReservation = 203325440, 
      initialSwapReservation = 162594816, 
   }, 
}
```