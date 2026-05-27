# V免签支付系统 - 绿联NAS部署指南

## 📦 已打包文件

| 文件 | 大小 | 说明 |
|------|------|------|
| `vmqphp.tar` | 630MB | Docker镜像文件 |
| `deploy_nas.sh` | - | 自动部署脚本 |
| `vmq.sql` | - | 数据库初始化文件 |

## 🚀 部署步骤

### 方法一：使用自动部署脚本（推荐）

#### 1. 上传文件到NAS

将以下文件上传到绿联NAS的 `/volume1/docker/` 目录：
- `vmqphp.tar`
- `deploy_nas.sh`
- `vmq.sql`

#### 2. SSH登录NAS

```bash
ssh admin@<NAS_IP>
```

#### 3. 进入目录并加载镜像

```bash
cd /volume1/docker
docker load -i vmqphp.tar
```

#### 4. 运行部署脚本

```bash
chmod +x deploy_nas.sh
./deploy_nas.sh
```

### 方法二：手动部署

#### 1. 上传文件到NAS

将 `vmqphp.tar` 上传到NAS

#### 2. SSH登录NAS并加载镜像

```bash
ssh admin@<NAS_IP>
docker load -i /path/to/vmqphp.tar
```

#### 3. 创建网络

```bash
docker network create --driver bridge vmq-network
```

#### 4. 启动MySQL容器

```bash
docker run -d \
  --name vmq-mysql \
  --network vmq-network \
  -v /volume1/docker/vmq-mysql:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=vmq123456 \
  -e MYSQL_DATABASE=vmq \
  mysql:8.0
```

#### 5. 等待MySQL启动并导入数据库

```bash
# 等待15秒
sleep 15

# 导入数据库
docker exec -i vmq-mysql mysql -uroot -pvmq123456 vmq < /path/to/vmq.sql
```

#### 6. 启动VMQ容器

```bash
docker run -d \
  --name vmqphp \
  --network vmq-network \
  -p 8080:80 \
  -e DB_HOST=vmq-mysql \
  -e DB_DATABASE=vmq \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=vmq123456 \
  vmqphp:latest
```

## 🔧 配置说明

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `DB_HOST` | vmq-mysql | MySQL主机名 |
| `DB_PORT` | 3306 | MySQL端口 |
| `DB_DATABASE` | vmq | 数据库名 |
| `DB_USERNAME` | root | 数据库用户名 |
| `DB_PASSWORD` | vmq123456 | 数据库密码 |

### 端口映射

| 容器端口 | 宿主机端口 | 说明 |
|----------|------------|------|
| 80 | 8080 | Web服务端口 |

如需修改端口，修改 `-p 8080:80` 为 `-p <新端口>:80`

## 📝 访问系统

部署完成后，访问：

```
http://<NAS_IP>:8080
```

**默认登录账号**：
- 用户名：`admin`
- 密码：`admin`

## 🛠️ 常用命令

### 查看容器状态

```bash
docker ps
```

### 查看日志

```bash
# 查看VMQ日志
docker logs -f vmqphp

# 查看MySQL日志
docker logs -f vmq-mysql
```

### 停止服务

```bash
docker stop vmqphp vmq-mysql
```

### 启动服务

```bash
docker start vmqphp vmq-mysql
```

### 重启服务

```bash
docker restart vmqphp vmq-mysql
```

### 删除容器

```bash
docker rm -f vmqphp vmq-mysql
```

### 删除网络

```bash
docker network rm vmq-network
```

## 📊 数据持久化

### MySQL数据

MySQL数据已映射到 `/volume1/docker/vmq-mysql`，确保数据不会丢失。

### 备份数据

```bash
# 备份数据库
docker exec vmq-mysql mysqldump -uroot -pvmq123456 vmq > backup.sql

# 恢复数据库
docker exec -i vmq-mysql mysql -uroot -pvmq123456 vmq < backup.sql
```

## 🔍 故障排查

### 无法访问网站

1. 检查容器是否运行：`docker ps`
2. 检查日志：`docker logs vmqphp`
3. 检查端口是否被占用：`netstat -an | grep 8080`

### 数据库连接失败

1. 检查MySQL容器是否运行：`docker ps | grep vmq-mysql`
2. 检查MySQL日志：`docker logs vmq-mysql`
3. 检查网络连接：`docker network inspect vmq-network`

### 重新部署

如果需要完全重新部署：

```bash
# 停止并删除容器
docker stop vmqphp vmq-mysql
docker rm vmqphp vmq-mysql

# 删除网络
docker network rm vmq-network

# 删除数据（谨慎操作）
rm -rf /volume1/docker/vmq-mysql

# 重新运行部署脚本
./deploy_nas.sh
```

## 📞 技术支持

如遇到问题，请检查：
1. Docker版本是否为最新
2. NAS是否有足够的存储空间
3. 端口8080是否被其他服务占用

## ⚠️ 注意事项

1. **首次启动**：MySQL初始化需要约15秒，请耐心等待
2. **端口冲突**：如果8080端口被占用，请修改端口映射
3. **数据备份**：建议定期备份MySQL数据
4. **安全性**：生产环境请修改默认密码

## 📄 许可证

Apache-2.0