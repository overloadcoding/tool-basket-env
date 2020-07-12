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

nginx 必须以 root 权限运行，否则 `nginx.conf` 中的 user 设置不生效，且因为缺少权限运行不起来

```shell
# start nginx
sudo nginx

# test nginx.conf syntax
sudo nginx -t

# reload nginx.conf
sudo nginx -s reload

# restart Nginx
sudo nginx -s reopen

# stop Nginx
sudo nginx -s stop
```

### uwsgi管理维护

```shell
# uwsgi 启动：
uwsgi --ini xxx.ini

# uwsgi 重启：
uwsgi --reload /var/run/uwsgi.pid

# uwsgi 停止：
uwsgi --stop /var/run/uwsgi.pid

# uwsgi 日志
cat /var/log/uwsgi.log
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

#### 审计

```shell
# 查看登陆日志
last
# 查看登陆失败日志
lastb
```

#### 防火墙

```shell
# 查看当前规则
iptables --line-numbers -L INPUT
# 添加 IP 黑名单
iptables -I INPUT -s 195.54.160.180 -j DROP
# 保存配置
iptables-save > /etc/sysconfig/iptables
# 恢复配置
iptables-restore < /etc/sysconfig/iptables
```

#### SELinux

```shell
# SELinux 管理
```

## 待完成

- nginx 禁止 accesslog 产生
- nginx 访问量监控
- nginx 并发数配置
- nginx 其他性能优化项配置
- nginx代理到uwsgi的请求404的情况