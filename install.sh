#!/bin/bash  
# 安装依赖工具  
if [[ $(command -v apt-get) ]]; then # 判断是否存在apt-get命令            
    apt-get update -y && apt-get install -y curl gnupg2 ca-certificates unzip # 更新源并安装依赖工具      
elif [[ $(command -v yum) ]]; then # 判断是否存在yum命令
    yum update -y && yum install -y curl gnupg2 ca-certificates unzip # 更新源并安装依赖工具
elif [[ $(command -v dnf) ]]; then  # 判断是否存在dnf命令
    dnf update -y && dnf install -y curl gnupg2 ca-certificates unzip # 更新源并安装依赖工具
else
    echo "不支持的操作系统" && exit 1 # 不支持的操作系统
fi

# 安装v2ray
bash <(curl -s -L https://raw.githubusercontent.com/jaraim/v2ray/master/go.sh)

# 安装x-ui
bash <(curl -s -L https://raw.githubusercontent.com/jaraim/xray-x-ui/main/install.sh)

# 安装nginx并配置反向代理
if [ -d "/etc/nginx/" ]; then # 判断是否存在 Nginx 目录
    sudo apt-get install nginx -y

    # 配置 Nginx 反向代理
    echo -n "请输入反向代理服务器的域名或 IP 地址（留空将使用服务器公网 IP 地址）: "
    read domain
    if [[ -z "$domain" ]]; then
        domain=$(curl -s ipv4.icanhazip.com)
    fi
    sudo rm /etc/nginx/sites-enabled/default
    cat << EOF | sudo tee /etc/nginx/sites-available/x-ui.conf
    server {
        listen 80;
        server_name $domain;
        location / {
            proxy_pass http://127.0.0.1:65432;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
EOF
    sudo ln -s /etc/nginx/sites-available/x-ui.conf /etc/nginx/sites-enabled/
    sudo nginx -t && sudo nginx -s reload
fi

echo "安装完成！"
