#!/bin/bash

# 安装依赖工具
if [[ $(command -v apt-get) ]]; then
    apt-get update -y && apt-get install -y curl gnupg2 ca-certificates unzip
elif [[ $(command -v yum) ]]; then
    yum update -y && yum install -y curl gnupg2 ca-certificates unzip
elif [[ $(command -v dnf) ]]; then
    dnf update -y && dnf install -y curl gnupg2 ca-certificates unzip
else
    echo "不支持的操作系统" && exit 1
fi

# 显示安装选项
echo -e "请选择要安装的软件：\n"
echo -e "    1. 全部安装"
echo -e "    2. 安装 v2ray"
echo -e "    3. 安装 x-ui"
echo -e "    4. 安装 Nginx 反向代理"
echo -n "请输入数字 [1-4]："
read option

# 根据用户输入的选项进行安装
case ${option} in
    1)
        # 安装 V2RAY
        bash <(curl -s -L https://raw.githubusercontent.com/jaraim/v2ray/master/go.sh)

        # 安装 x-ui
        bash <(curl -s -L https://raw.githubusercontent.com/jaraim/xray-x-ui/main/install.sh)

        # 安装 Nginx 并配置反向代理
        if [ -d "/etc/nginx/" ]; then
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
        echo "全部安装完成！"
        ;;
    2)
        # 安装 V2RAY
        bash <(curl -s -L https://raw.githubusercontent.com/jaraim/v2ray/master/go.sh)
        echo "V2RAY 安装完成！"
        ;;
    3)
        # 安装 x-ui
        bash <(curl -s -L https://raw.githubusercontent.com/jaraim/xray-x-ui/main/install.sh)
        echo "x-ui 安装完成！"
        ;;
    4)
        # 安装 Nginx 并配置反向代理
        if [ -d "/etc/nginx/" ]; then
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
            echo "Nginx 反向代理安装完成！"
        else
            echo "Nginx 未安装！"
        fi
        ;;
    *)
        echo "无效的选项！"
        exit 1
        ;;
esac

exit 0
