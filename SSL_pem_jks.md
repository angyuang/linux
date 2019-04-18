>## 什么是jks
jks是java的 keystore文件格式java提供keytool工具操作jks
keytool是随jre发布的工具所以只要你安装了jre就有这个工具
在windows上,是keytool.exe，在Lunix上是keytool
jks 类似于 pfx(p12) 文件, 有密码加密, 可以保存多可key 或者证书等等 key 或者 证书被称为一个 entry, 每个 entry 有个别名(alias) 操作时需要制定别名

>## 如何把PEM格式证书转换成JKS格式

通常一个完整的证书链包含三个文件：

    cert.cn.pem：用户证书文件
    server.key：用户私钥文件
    ca.pem：CA根证书文件(crt或pem格式)

keystore密码必须是六位，例如123456

当然，我们假设cert.pem是经过ca.pem签名的。
把PEM格式转换成JKS格式通常会生成两个JKS文件。

>## PEM转换成JSK格式
### 1、把CA证书文件转换成truststore.jks文件
说明:把CA证书做成keystore库，keystore用来存放server.key ,server.crt
```shell
keytool -import -alias server(条目名称) -noprompt -file ca.pem（ca颁发机构证书） -keystore tongpeifu.jks（keystore名称） -storepass 密码
```

### 2、把用户证书文件转换成keystore.jks文件
#### 2.1把用户证书转换成P12格式
```shell
openssl pkcs12 -export -in ctyun.cn.pem（pem格式证书） -inkey server.key（私钥） -out tongpeifu.p12（p12格式） -passout pass:密码
````


#### 2.2把p12格式文件加入到JKS格式
```shell
keytool -importkeystore -srckeystore tongpeifu.p12（p12格式） -srcstoretype PKCS12 -destkeystore tongpeifu.jks（keystore名称） -srcstorepass 密码 -deststorepass 密码
```


>## 3、证书查看

缺省情况下，-list 命令打印证书的 MD5 指纹。而如果指定了 -v 选项，将以可读格式打印证书，如果指定了 -rfc 选项，将以可打印的编码格式输出证书。
```shell
keytool -list –rfc -keystore keystore.jks -storepass 密码
```

```shell
keytool -list -v -keystore keystore.jks -storepass 密码
```


>## 4、其他说明


证书导入
keytool -importcert -keystore publickeys.jks -storepass 密码 -alias partyb -file PartyB.cer

证书删除
keytool  -delete  -keystore publickeys.jks  -storepass  mypassword  -alias partyb