#!/bin/bash

# V免签支付系统 - 绿联NAS部署脚本
# 使用方法: ./deploy_nas.sh

set -e

echo "========================================="
echo "  V免签支付系统 - 绿联NAS部署脚本"
echo "========================================="
echo ""

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: Docker未安装，请先安装Docker"
    exit 1
fi

echo "✅ Docker已安装"

# 创建网络
echo ""
echo "📡 创建Docker网络..."
docker network create --driver bridge vmq-network 2>/dev/null || echo "网络已存在"

# 启动MySQL容器
echo ""
echo "🗄️  启动MySQL容器..."
docker run -d \
  --name vmq-mysql \
  --network vmq-network \
  -v /volume1/docker/vmq-mysql:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=vmq123456 \
  -e MYSQL_DATABASE=vmq \
  mysql:8.0

# 等待MySQL启动
echo ""
echo "⏳ 等待MySQL启动..."
sleep 15

# 导入数据库
echo ""
echo "📥 导入数据库..."
docker exec -i vmq-mysql mysql -uroot -pvmq123456 vmq < vmq.sql

# 启动VMQ容器
echo ""
echo "🚀 启动VMQ容器..."
docker run -d \
  --name vmqphp \
  --network vmq-network \
  -p 8080:80 \
  -e DB_HOST=vmq-mysql \
  -e DB_DATABASE=vmq \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=vmq123456 \
  vmqphp:latest

echo ""
echo "========================================="
echo "  ✅ 部署完成！"
echo "========================================="
echo ""
echo "访问地址: http://<NAS_IP>:8080"
echo "默认账号: admin"
echo "默认密码: admin"
echo ""
echo "常用命令:"
echo "  查看日志: docker logs -f vmqphp"
echo "  停止服务: docker stop vmqphp vmq-mysql"
echo "  启动服务: docker start vmqphp vmq-mysql"
echo "  删除容器: docker rm -f vmqphp vmq-mysql"
echo ""