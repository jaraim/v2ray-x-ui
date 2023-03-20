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
bash <(curl -s -L https:https://raw.githubusercontent.com/jaraim/v2ray/main/install.sh)

# 安装x-ui
bash <(curl -s -L https://raw.githubusercontent.com/jaraim/xray-x-ui/main/install.sh)
