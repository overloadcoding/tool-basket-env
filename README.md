# tool-basket-env
工具篮-环境配置及管理项目

## 环境配置步骤

```shell
# 修改 DNS
sed -i "s/nameserver.*/nameserver 8.8.8.8/g" /etc/resolv.conf

# 安装 git
yum install -y git

# Clone 项目
git clone https://github.com/overloadcoding/tool-basket-env.git

# 执行环境配置脚本
cd tool-basket-env/
sh install.sh

# 环境配置脚本默认不给 server、和各 developer 设置初始密码
# 需要登录 root 账户手动设置
# 如：passwd server
```

## WEB服务器管理

### Nginx 管理维护

```shell
# nginx

# test nginx.conf syntax
# nginx -t
# reload nginx.conf
# nginx -s reload
# restart Nginx
# nginx -s reopen
# stop Nginx
# nginx -s stop
```

## 系统管理维护

### 网络相关

```shell
# 查看 ipv4 下的 tcp 连接情况
netstat -anpt4
```

### 用户相关

```shell
# 踢用户
pkill -kill -t pts/0
# 或者 netstat -anpt4，然后kill -9 [pid]
```

### 安全相关

```shell
# firewall
# 添加 IP 黑名单

# SELinux 管理

```

