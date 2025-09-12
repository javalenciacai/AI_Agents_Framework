# 📦 Installation Guide - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Requisitos del Sistema](#requisitos-del-sistema)
- [Instalación Rápida](#instalación-rápida)
- [Instalación Personalizada](#instalación-personalizada)
- [Configuración Inicial](#configuración-inicial)
- [Verificación de Instalación](#verificación-de-instalación)
- [Actualización](#actualización)
- [Desinstalación](#desinstalación)

---

## ⚙️ Requisitos del Sistema

### **Servidor BackupGuard Pro**
```yaml
Sistema Operativo:
  - Ubuntu 20.04+ / CentOS 8+ / RHEL 8+
  - Windows Server 2019+ (en roadmap)
  - macOS 12+ (desarrollo únicamente)

Hardware Mínimo:
  - CPU: 2 cores / 2.4 GHz
  - RAM: 4 GB
  - Disco: 50 GB SSD (sistema)
  - Disco: 500 GB+ (almacenamiento backups)
  - Red: 1 Gbps

Hardware Recomendado:
  - CPU: 4+ cores / 3.0 GHz
  - RAM: 8+ GB
  - Disco: 100 GB SSD (sistema)
  - Disco: 2+ TB SSD/NVMe (almacenamiento)
  - Red: 10 Gbps
```

### **Agente Cliente**
```yaml
Sistema Operativo:
  - Linux: Ubuntu 18.04+, CentOS 7+, Debian 10+
  - Windows: Windows 10+, Server 2016+
  - macOS: 10.15+

Hardware Mínimo:
  - CPU: 1 core
  - RAM: 512 MB
  - Disco: 1 GB
  - Red: 100 Mbps

Software:
  - Python 3.8+ (incluido en instalador)
  - OpenSSL 1.1.1+
```

### **Navegadores Soportados**
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

---

## 🚀 Instalación Rápida

### **Opción 1: One-Click Installer (Recomendado)**
```bash
# Descargar e instalar en un comando
curl -fsSL https://install.backupguard.pro | sudo bash

# Con configuración personalizada
curl -fsSL https://install.backupguard.pro | sudo bash -s -- \
  --domain your-domain.com \
  --email admin@your-domain.com \
  --ssl-auto
```

### **Opción 2: Docker Compose (Más rápido para testing)**
```bash
# Clonar repositorio
git clone https://github.com/backupguard/backupguard-pro.git
cd backupguard-pro

# Configurar variables de entorno
cp .env.example .env
nano .env

# Iniciar todos los servicios
docker-compose up -d

# Verificar estado
docker-compose ps
```

### **Opción 3: Kubernetes Helm Chart**
```bash
# Agregar repositorio Helm
helm repo add backupguard https://charts.backupguard.pro
helm repo update

# Instalar con valores por defecto
helm install backupguard backupguard/backupguard-pro

# O con configuración personalizada
helm install backupguard backupguard/backupguard-pro \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=backupguard.your-domain.com \
  --set postgresql.enabled=true
```

---

## 🛠️ Instalación Personalizada

### **Paso 1: Preparar el Sistema**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget gnupg2 software-properties-common

# CentOS/RHEL
sudo yum update -y
sudo yum install -y curl wget gnupg2

# Crear usuario del sistema
sudo useradd -r -s /bin/false backupguard
sudo mkdir -p /opt/backupguard
sudo chown backupguard:backupguard /opt/backupguard
```

### **Paso 2: Instalar Dependencias**

#### **Docker & Docker Compose**
```bash
# Instalar Docker
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker --version
docker-compose --version
```

#### **Base de Datos (Opcional - Si no usas Docker)**
```bash
# MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org

# Redis
sudo apt install -y redis-server

# PostgreSQL (para métricas)
sudo apt install -y postgresql postgresql-contrib
```

### **Paso 3: Descargar BackupGuard Pro**
```bash
# Crear directorio de instalación
sudo mkdir -p /opt/backupguard
cd /opt/backupguard

# Descargar la última versión
LATEST_VERSION=$(curl -s https://api.github.com/repos/backupguard/backupguard-pro/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo wget https://github.com/backupguard/backupguard-pro/releases/download/$LATEST_VERSION/backupguard-pro-$LATEST_VERSION.tar.gz

# Extraer archivos
sudo tar -xzf backupguard-pro-$LATEST_VERSION.tar.gz
sudo chown -R backupguard:backupguard /opt/backupguard
```

### **Paso 4: Configurar Variables de Entorno**
```bash
# Copiar template de configuración
sudo cp /opt/backupguard/.env.example /opt/backupguard/.env

# Editar configuración
sudo nano /opt/backupguard/.env
```

```env
# /opt/backupguard/.env
# Configuración Principal
APP_NAME=BackupGuard Pro
APP_ENV=production
APP_DEBUG=false
APP_URL=https://backupguard.your-domain.com

# Base de Datos
MONGODB_URI=mongodb://localhost:27017/backupguard
REDIS_URL=redis://localhost:6379
POSTGRES_URI=postgresql://postgres:password@localhost:5432/backupguard_metrics

# Servicios
API_GATEWAY_PORT=8080
USER_SERVICE_PORT=3001
BACKUP_MONITOR_PORT=3002
NOTIFICATION_SERVICE_PORT=3003

# Seguridad
JWT_SECRET=your-super-secret-jwt-key-here
ENCRYPTION_KEY=your-32-char-encryption-key-here
API_RATE_LIMIT=1000

# Email
SMTP_HOST=smtp.your-provider.com
SMTP_PORT=587
SMTP_USER=noreply@your-domain.com
SMTP_PASS=your-smtp-password

# Almacenamiento
BACKUP_STORAGE_PATH=/var/backupguard/storage
MAX_BACKUP_SIZE=10737418240  # 10GB
RETENTION_DAYS=90

# SSL/TLS
SSL_ENABLED=true
SSL_CERT_PATH=/etc/ssl/certs/backupguard.crt
SSL_KEY_PATH=/etc/ssl/private/backupguard.key

# Monitoring
ENABLE_METRICS=true
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
```

### **Paso 5: Configurar SSL (Recomendado)**
```bash
# Opción 1: Let's Encrypt (Automático)
sudo apt install -y certbot
sudo certbot certonly --standalone -d backupguard.your-domain.com

# Copiar certificados
sudo cp /etc/letsencrypt/live/backupguard.your-domain.com/fullchain.pem /etc/ssl/certs/backupguard.crt
sudo cp /etc/letsencrypt/live/backupguard.your-domain.com/privkey.pem /etc/ssl/private/backupguard.key

# Opción 2: Certificado auto-firmado (Solo testing)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/backupguard.key \
  -out /etc/ssl/certs/backupguard.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=backupguard.your-domain.com"
```

---

## 🔧 Configuración Inicial

### **Paso 1: Inicializar Base de Datos**
```bash
cd /opt/backupguard

# Inicializar MongoDB
sudo docker-compose exec mongodb mongosh --eval "
  use backupguard;
  db.createUser({
    user: 'backupguard',
    pwd: 'secure-password',
    roles: ['readWrite']
  });
"

# Aplicar migraciones
sudo docker-compose exec api-gateway npm run migrate
```

### **Paso 2: Crear Usuario Administrador**
```bash
# Ejecutar script de setup inicial
sudo docker-compose exec api-gateway npm run setup:admin

# O crear manualmente
curl -X POST http://localhost:8080/api/v1/setup/admin \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Administrator",
    "email": "admin@your-domain.com",
    "password": "YourSecurePassword123!",
    "company": "Your Company"
  }'
```

### **Paso 3: Configurar Networking**
```bash
# Configurar firewall
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable

# Configurar reverse proxy (Nginx)
sudo apt install -y nginx

# Configuración Nginx
cat << 'EOF' | sudo tee /etc/nginx/sites-available/backupguard
server {
    listen 80;
    server_name backupguard.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name backupguard.your-domain.com;

    ssl_certificate /etc/ssl/certs/backupguard.crt;
    ssl_certificate_key /etc/ssl/private/backupguard.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api/v1/backups/upload {
        client_max_body_size 10G;
        proxy_pass http://127.0.0.1:8080;
        proxy_request_buffering off;
    }
}
EOF

# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/backupguard /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## ✅ Verificación de Instalación

### **Health Check Automático**
```bash
# Script de verificación
curl -fsSL https://install.backupguard.pro/verify | bash

# O verificación manual
./scripts/health-check.sh
```

### **Verificación Manual**
```bash
# 1. Verificar servicios Docker
docker-compose ps

# 2. Verificar conectividad de servicios
curl -s http://localhost:8080/health | jq .

# 3. Verificar base de datos
curl -s http://localhost:8080/health/database | jq .

# 4. Verificar acceso web
curl -k https://backupguard.your-domain.com/health

# 5. Verificar logs
docker-compose logs --tail=50 api-gateway
```

### **Dashboard de Verificación**
Accede a: `https://backupguard.your-domain.com/setup`

✅ **Lista de Verificación:**
- [ ] Servicios principales ejecutándose
- [ ] Base de datos conectada
- [ ] SSL configurado correctamente
- [ ] Usuario administrador creado
- [ ] Envío de emails funcionando
- [ ] Almacenamiento accesible
- [ ] Backup de prueba exitoso

---

## 🔄 Actualización

### **Actualización Automática**
```bash
# Habilitar actualizaciones automáticas
echo "0 2 * * 0 /opt/backupguard/scripts/auto-update.sh" | sudo crontab -

# Actualización manual
cd /opt/backupguard
sudo ./scripts/update.sh

# O usando Docker
docker-compose pull
docker-compose up -d
```

### **Actualización Manual**
```bash
# Backup de configuración
sudo cp -r /opt/backupguard/config /tmp/backupguard-config-backup

# Descargar nueva versión
LATEST_VERSION=$(curl -s https://api.github.com/repos/backupguard/backupguard-pro/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/backupguard/backupguard-pro/releases/download/$LATEST_VERSION/backupguard-pro-$LATEST_VERSION.tar.gz

# Detener servicios
sudo docker-compose down

# Actualizar archivos
sudo tar -xzf backupguard-pro-$LATEST_VERSION.tar.gz
sudo chown -R backupguard:backupguard /opt/backupguard

# Restaurar configuración
sudo cp -r /tmp/backupguard-config-backup/* /opt/backupguard/config/

# Reiniciar servicios
sudo docker-compose up -d

# Verificar actualización
curl -s http://localhost:8080/api/v1/version
```

---

## 🗑️ Desinstalación

### **Desinstalación Completa**
```bash
# Detener servicios
cd /opt/backupguard
sudo docker-compose down -v

# Remover contenedores e imágenes
sudo docker system prune -a

# Remover archivos del sistema
sudo rm -rf /opt/backupguard
sudo rm -rf /var/backupguard
sudo rm -f /etc/nginx/sites-enabled/backupguard
sudo rm -f /etc/nginx/sites-available/backupguard

# Remover usuario del sistema
sudo userdel backupguard

# Limpiar crontab
sudo crontab -r

# Remover SSL certificates (si fueron auto-generados)
sudo rm -f /etc/ssl/certs/backupguard.crt
sudo rm -f /etc/ssl/private/backupguard.key
```

### **Preservar Datos**
```bash
# Backup antes de desinstalar
sudo tar -czf /tmp/backupguard-data-backup.tar.gz \
  /opt/backupguard/config \
  /var/backupguard/storage \
  /opt/backupguard/.env

# Para restaurar después
sudo tar -xzf /tmp/backupguard-data-backup.tar.gz -C /
```

---

## 🆘 Troubleshooting de Instalación

### **Problemas Comunes**

#### **Error: Puerto en uso**
```bash
# Verificar qué está usando el puerto
sudo netstat -tulpn | grep :8080

# Cambiar puerto en .env
APP_PORT=8081
```

#### **Error: Permisos de Docker**
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER
newgrp docker
```

#### **Error: SSL Certificate**
```bash
# Verificar certificado
openssl x509 -in /etc/ssl/certs/backupguard.crt -text -noout

# Regenerar si es necesario
sudo certbot renew --force-renewal
```

#### **Error: Base de datos no conecta**
```bash
# Verificar conectividad MongoDB
docker-compose exec mongodb mongosh --eval "db.adminCommand('ismaster')"

# Verificar logs
docker-compose logs mongodb
```

---

## 📞 Soporte

### **Canales de Soporte**
- **📧 Email**: support@backupguard.pro
- **💬 Discord**: [BackupGuard Community](https://discord.gg/backupguard)
- **📚 Docs**: [docs.backupguard.pro](https://docs.backupguard.pro)
- **🐛 Issues**: [GitHub Issues](https://github.com/backupguard/backupguard-pro/issues)

### **Información para Soporte**
```bash
# Generar reporte de diagnóstico
sudo /opt/backupguard/scripts/generate-support-report.sh

# El reporte incluye:
# - Versión del sistema
# - Logs de errores (sin datos sensibles)
# - Configuración de red
# - Estado de servicios
# - Métricas de performance
```

---

> **💡 Nota**: Esta guía es parte del ejemplo BackupGuard Pro y demuestra un proceso de instalación completo para una aplicación empresarial con microservicios.
