# tool-basket-env
工具篮-环境配置项目

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
```

