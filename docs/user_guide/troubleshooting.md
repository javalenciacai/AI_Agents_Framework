# 🔧 Troubleshooting Guide - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Diagnóstico Rápido](#diagnóstico-rápido)
- [Problemas de Backup](#problemas-de-backup)
- [Problemas de Red](#problemas-de-red)
- [Problemas de Base de Datos](#problemas-de-base-de-datos)
- [Problemas de Performance](#problemas-de-performance)
- [Problemas de Autenticación](#problemas-de-autenticación)
- [Problemas de Storage](#problemas-de-storage)
- [Herramientas de Diagnóstico](#herramientas-de-diagnóstico)

---

## 🚀 Diagnóstico Rápido

### **🔍 Health Check Automático**
```bash
#!/bin/bash
# Script de diagnóstico rápido
echo "🔍 BackupGuard Pro - Diagnóstico Rápido"
echo "======================================="

# Verificar servicios principales
echo "📊 Estado de Servicios:"
docker-compose ps --format "table {{.Name}}\t{{.State}}\t{{.Status}}"

# Verificar conectividad de bases de datos
echo -e "\n🗄️ Conectividad de Bases de Datos:"
timeout 5 mongo --quiet --eval "db.adminCommand('ismaster')" && echo "✅ MongoDB: OK" || echo "❌ MongoDB: FAIL"
timeout 5 redis-cli ping > /dev/null 2>&1 && echo "✅ Redis: OK" || echo "❌ Redis: FAIL"
timeout 5 pg_isready -h localhost -p 5432 > /dev/null 2>&1 && echo "✅ PostgreSQL: OK" || echo "❌ PostgreSQL: FAIL"

# Verificar API endpoints
echo -e "\n🌐 API Endpoints:"
curl -s -o /dev/null -w "✅ API Gateway: %{http_code}\n" http://localhost:8080/health || echo "❌ API Gateway: FAIL"
curl -s -o /dev/null -w "✅ User Service: %{http_code}\n" http://localhost:3001/health || echo "❌ User Service: FAIL"
curl -s -o /dev/null -w "✅ Backup Service: %{http_code}\n" http://localhost:3002/health || echo "❌ Backup Service: FAIL"

# Verificar storage
echo -e "\n💾 Storage:"
df -h /var/backupguard/storage | tail -1 | awk '{print "📊 Storage Usage: " $5 " (" $3 "/" $2 ")"}'

# Verificar logs de errores recientes
echo -e "\n📋 Errores Recientes (últimos 10 minutos):"
docker-compose logs --since=10m 2>&1 | grep -i error | tail -5 || echo "✅ No hay errores recientes"

echo -e "\n🎯 Diagnóstico completado. Para análisis detallado, ejecuta: ./scripts/detailed-diagnostics.sh"
```

### **📊 Dashboard de Estado del Sistema**
```bash
# Comando para ver estado en tiempo real
watch -n 5 '
echo "🖥️  SISTEMA - $(date)"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk "{print \$2}" | cut -d"%" -f1)%"
echo "RAM: $(free | grep Mem | awk "{printf \"%.1f%%\", \$3/\$2 * 100.0}")"
echo "DISCO: $(df -h /var/backupguard | tail -1 | awk "{print \$5}")"
echo ""
echo "🔄 JOBS ACTIVOS:"
docker-compose exec api-gateway curl -s localhost:8080/api/v1/jobs/active | jq -r ".[] | \"\(.client_name): \(.progress)%\""
echo ""
echo "🚨 ALERTAS:"
docker-compose exec api-gateway curl -s localhost:8080/api/v1/alerts/current | jq -r ".[] | \"\(.severity): \(.message)\""
'
```

---

## 💾 Problemas de Backup

### **❌ Backup Jobs Fallando**

#### **Síntoma**: Jobs de backup terminan con error
```bash
# Verificar logs del servicio de backup
docker-compose logs backup-service | grep ERROR | tail -20

# Verificar jobs fallidos específicos
curl -s http://localhost:8080/api/v1/backups?status=failed | jq '.data[] | {client: .client_name, error: .error_message, time: .failed_at}'
```

#### **Causas Comunes y Soluciones**:

##### **🔒 Problemas de Permisos**
```bash
# Síntoma: "Permission denied" en logs
# Verificar permisos del agente
ls -la /opt/backupguard-agent/
sudo chown -R backupguard:backupguard /opt/backupguard-agent/
sudo chmod +x /opt/backupguard-agent/bin/agent

# Verificar permisos de directorios de backup
sudo -u backupguard ls -la /path/to/backup/source/
```

##### **🌐 Problemas de Conectividad**
```bash
# Verificar conectividad del agente al servidor
telnet backup-server.com 8080

# Verificar certificados SSL
openssl s_client -connect backup-server.com:443 -servername backup-server.com

# Test de latencia
ping -c 10 backup-server.com
```

##### **💾 Espacio Insuficiente**
```bash
# Verificar espacio en disco
df -h

# Verificar inodes
df -i

# Limpiar archivos temporales
find /tmp -name "backup-*" -mtime +1 -delete
docker system prune -f
```

### **⏱️ Backup Jobs Lentos**

#### **Diagnóstico de Performance**
```bash
# Script de análisis de performance
#!/bin/bash
echo "📈 Análisis de Performance de Backup"

# Verificar throughput actual
curl -s http://localhost:8080/api/v1/metrics/backup-throughput | jq '.current_mbps'

# Verificar I/O del sistema
iostat -x 1 3

# Verificar procesos con más I/O
iotop -ao

# Verificar network utilization
iftop -t -s 10

# Verificar compresión/deduplicación stats
curl -s http://localhost:8080/api/v1/metrics/compression | jq '{compression_ratio: .ratio, dedup_ratio: .dedup_ratio}'
```

#### **Optimizaciones Comunes**:
```yaml
# config/performance-tuning.yml
backup_optimization:
  parallel_streams: 4  # Aumentar para más throughput
  chunk_size_mb: 64   # Optimizar según red
  compression_level: 1 # Reducir para más velocidad
  
network_optimization:
  tcp_window_size: "64KB"
  buffer_size: "1MB"
  
storage_optimization:
  use_direct_io: true
  read_ahead_kb: 2048
```

### **🔄 Backup Jobs Colgados**

#### **Identificar Jobs Colgados**
```bash
# Jobs que llevan más de 4 horas ejecutándose
curl -s http://localhost:8080/api/v1/backups?status=running | jq '.data[] | select((.duration_minutes // 0) > 240) | {client: .client_name, duration: .duration_minutes, started: .started_at}'

# Verificar procesos del sistema
ps aux | grep backup | grep -v grep

# Verificar locks de base de datos
docker-compose exec mongodb mongo --eval "db.currentOp()"
```

#### **Resolver Jobs Colgados**
```bash
# Terminar job específico
curl -X DELETE http://localhost:8080/api/v1/backups/JOB_ID

# Reiniciar servicio de backup si es necesario
docker-compose restart backup-service

# Verificar y limpiar procesos zombie
sudo kill -9 $(ps aux | grep '[b]ackup' | awk '{print $2}')
```

---

## 🌐 Problemas de Red

### **🔌 Conectividad entre Servicios**

#### **Diagnóstico de Red Interna**
```bash
# Verificar conectividad entre contenedores
docker network ls
docker network inspect backupguard_default

# Test de conectividad entre servicios
docker-compose exec api-gateway nc -zv backup-service 3001
docker-compose exec backup-service nc -zv mongodb 27017
docker-compose exec backup-service nc -zv redis 6379

# Verificar DNS interno
docker-compose exec api-gateway nslookup backup-service
```

#### **Problemas de Firewall**
```bash
# Verificar reglas de iptables
sudo iptables -L -n --line-numbers

# Verificar puertos abiertos
sudo netstat -tulpn | grep -E ':(8080|3001|3002|27017|6379)'

# Test desde externa
nmap -p 8080,443 your-server.com
```

### **📡 Problemas de SSL/TLS**

#### **Verificar Certificados**
```bash
# Verificar validez del certificado
openssl x509 -in /etc/ssl/certs/backupguard.crt -text -noout

# Verificar cadena de certificados
openssl s_client -connect your-domain.com:443 -servername your-domain.com

# Verificar fecha de expiración
openssl x509 -in /etc/ssl/certs/backupguard.crt -noout -dates
```

#### **Renovar Certificados**
```bash
# Let's Encrypt
sudo certbot renew --dry-run
sudo certbot renew --force-renewal

# Recargar nginx
sudo nginx -t && sudo systemctl reload nginx
```

### **🚦 Rate Limiting Issues**

#### **Identificar Rate Limiting**
```bash
# Verificar logs de rate limiting
grep "rate limit" /var/log/nginx/error.log
docker-compose logs api-gateway | grep "rate limit"

# Verificar configuración actual
curl -s http://localhost:8080/api/v1/system/rate-limits | jq
```

#### **Ajustar Rate Limits**
```yaml
# config/rate-limits.yml
rate_limits:
  global:
    requests_per_minute: 2000  # Aumentar si es necesario
    burst_size: 100
    
  per_client:
    backup_requests_per_hour: 1000
    api_requests_per_minute: 100
```

---

## 🗄️ Problemas de Base de Datos

### **MongoDB Issues**

#### **🔍 Diagnóstico de MongoDB**
```bash
# Verificar estado del replica set
docker-compose exec mongodb mongo --eval "rs.status()"

# Verificar operaciones lentas
docker-compose exec mongodb mongo --eval "db.currentOp({'secs_running': {\$gte: 5}})"

# Verificar tamaño de base de datos
docker-compose exec mongodb mongo --eval "db.stats()"

# Verificar logs de MongoDB
docker-compose logs mongodb | grep -E "(ERROR|WARNING)" | tail -20
```

#### **Problemas Comunes**:

##### **💾 Espacio Insuficiente**
```bash
# Verificar espacio
docker-compose exec mongodb df -h /data/db

# Compactar base de datos
docker-compose exec mongodb mongo --eval "db.runCommand({compact: 'backup_jobs'})"

# Limpiar oplog si es muy grande
docker-compose exec mongodb mongo --eval "db.oplog.rs.find().limit(1).sort({\$natural: -1})"
```

##### **🐌 Performance Lenta**
```bash
# Verificar índices faltantes
docker-compose exec mongodb mongo --eval "db.backup_jobs.getIndexes()"

# Crear índices necesarios
docker-compose exec mongodb mongo --eval "db.backup_jobs.createIndex({client_id: 1, created_at: -1})"

# Verificar query performance
docker-compose exec mongodb mongo --eval "db.setProfilingLevel(2, {slowms: 100})"
```

### **Redis Issues**

#### **🔍 Diagnóstico de Redis**
```bash
# Verificar estado de Redis
docker-compose exec redis redis-cli info

# Verificar memoria utilizada
docker-compose exec redis redis-cli info memory

# Verificar comandos lentos
docker-compose exec redis redis-cli slowlog get 10

# Verificar conectividad
docker-compose exec redis redis-cli ping
```

#### **Problemas Comunes**:

##### **💾 Memoria Llena**
```bash
# Verificar uso de memoria
docker-compose exec redis redis-cli info memory | grep used_memory_human

# Limpiar claves expiradas
docker-compose exec redis redis-cli --scan | xargs docker-compose exec redis redis-cli del

# Configurar maxmemory policy
docker-compose exec redis redis-cli config set maxmemory-policy allkeys-lru
```

### **PostgreSQL Issues (Métricas)**

#### **🔍 Diagnóstico de PostgreSQL**
```bash
# Verificar conexiones activas
docker-compose exec postgres psql -U postgres -c "SELECT count(*) FROM pg_stat_activity;"

# Verificar queries lentas
docker-compose exec postgres psql -U postgres -c "SELECT query, query_start, state FROM pg_stat_activity WHERE state = 'active';"

# Verificar locks
docker-compose exec postgres psql -U postgres -c "SELECT * FROM pg_locks WHERE NOT granted;"

# Verificar tamaño de base de datos
docker-compose exec postgres psql -U postgres -c "SELECT pg_size_pretty(pg_database_size('backupguard_metrics'));"
```

---

## ⚡ Problemas de Performance

### **🖥️ CPU y Memoria**

#### **Diagnóstico de Recursos**
```bash
# Monitoreo en tiempo real
htop

# Procesos que más CPU consumen
ps aux --sort=-%cpu | head -10

# Procesos que más memoria consumen  
ps aux --sort=-%mem | head -10

# Verificar swap usage
free -h
swapon -s
```

#### **Optimización de Memoria**
```bash
# Limpiar cache del sistema
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches

# Verificar memory leaks en aplicación
docker stats --no-stream

# Configurar swap si es necesario
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### **💾 I/O Performance**

#### **Diagnóstico de I/O**
```bash
# Monitorear I/O en tiempo real
iotop -ao

# Estadísticas de I/O por dispositivo
iostat -x 1 5

# Verificar I/O wait
vmstat 1 10

# Verificar procesos con más I/O
pidstat -d 1 5
```

#### **Optimización de I/O**
```bash
# Verificar scheduler de I/O
cat /sys/block/sda/queue/scheduler

# Cambiar scheduler (para SSD)
echo mq-deadline | sudo tee /sys/block/sda/queue/scheduler

# Ajustar read-ahead
sudo blockdev --setra 2048 /dev/sda

# Verificar montaje con noatime
mount | grep noatime
```

### **🌐 Network Performance**

#### **Diagnóstico de Red**
```bash
# Verificar throughput de red
iperf3 -c target-server -t 30

# Monitorear tráfico de red
iftop -i eth0

# Verificar latencia
mtr --report --report-cycles 100 target-server

# Verificar buffers de red
ss -m
```

---

## 🔐 Problemas de Autenticación

### **🚫 Login Failures**

#### **Diagnóstico de Autenticación**
```bash
# Verificar intentos de login fallidos
docker-compose logs api-gateway | grep "auth.*failed" | tail -20

# Verificar bloqueos por IP
curl -s http://localhost:8080/api/v1/security/blocked-ips | jq

# Verificar sesiones activas
curl -s http://localhost:8080/api/v1/auth/sessions | jq '.count'
```

#### **Soluciones Comunes**:

##### **🔓 Desbloquear Usuario**
```bash
# Desbloquear usuario específico
curl -X POST http://localhost:8080/api/v1/auth/unlock \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}'

# Desbloquear IP
curl -X DELETE http://localhost:8080/api/v1/security/blocked-ips/192.168.1.100
```

##### **🔑 Reset de Password**
```bash
# Generar token de reset
curl -X POST http://localhost:8080/api/v1/auth/password-reset \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}'
```

### **🎫 Token Issues**

#### **JWT Token Problems**
```bash
# Verificar configuración JWT
curl -s http://localhost:8080/api/v1/auth/jwt-config | jq

# Verificar token específico
curl -X POST http://localhost:8080/api/v1/auth/verify-token \
  -H "Authorization: Bearer YOUR_TOKEN"

# Revocar token
curl -X POST http://localhost:8080/api/v1/auth/revoke-token \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### **🔗 SSO Issues**

#### **SAML/OIDC Problems**
```bash
# Verificar configuración SSO
curl -s http://localhost:8080/api/v1/auth/sso-config | jq

# Test SAML metadata
curl -s https://your-domain.com/auth/saml/metadata

# Verificar logs de SSO
docker-compose logs api-gateway | grep -i saml | tail -10
```

---

## 💾 Problemas de Storage

### **📊 Espacio Insuficiente**

#### **Análisis de Uso de Espacio**
```bash
# Verificar uso por directorio
du -sh /var/backupguard/* | sort -hr

# Encontrar archivos grandes
find /var/backupguard -type f -size +1G -exec ls -lh {} \; | sort -k5 -hr

# Verificar archivos temporales
find /tmp -name "*backup*" -mtime +1 -ls

# Análisis de crecimiento
df -h && echo "---" && df -h | awk 'NR>1 {print $5 " " $6}' | sort -nr
```

#### **Limpieza de Storage**
```bash
# Limpiar backups antiguos según política de retención
curl -X POST http://localhost:8080/api/v1/maintenance/cleanup-old-backups

# Limpiar archivos temporales
find /var/backupguard/temp -mtime +1 -delete

# Compactar logs
find /var/log -name "*.log" -mtime +7 -exec gzip {} \;

# Limpiar Docker
docker system prune -a -f
```

### **🔄 Deduplicación Issues**

#### **Verificar Deduplicación**
```bash
# Estadísticas de deduplicación
curl -s http://localhost:8080/api/v1/metrics/deduplication | jq

# Verificar índice de deduplicación
curl -s http://localhost:8080/api/v1/storage/dedup-index-health | jq

# Reconstruir índice si es necesario
curl -X POST http://localhost:8080/api/v1/maintenance/rebuild-dedup-index
```

### **🗜️ Compresión Problems**

#### **Verificar Compresión**
```bash
# Estadísticas de compresión
curl -s http://localhost:8080/api/v1/metrics/compression | jq

# Test de algoritmos de compresión
echo "test data" | gzip | wc -c
echo "test data" | zstd | wc -c
echo "test data" | lz4 | wc -c
```

---

## 🛠️ Herramientas de Diagnóstico

### **📊 Script de Diagnóstico Completo**

```bash
#!/bin/bash
# comprehensive-diagnostics.sh

REPORT_FILE="/tmp/backupguard-diagnostics-$(date +%Y%m%d-%H%M%S).txt"
echo "🔍 BackupGuard Pro - Diagnóstico Completo" | tee $REPORT_FILE
echo "Generado: $(date)" | tee -a $REPORT_FILE
echo "=======================================" | tee -a $REPORT_FILE

# Información del sistema
echo -e "\n🖥️ INFORMACIÓN DEL SISTEMA:" | tee -a $REPORT_FILE
uname -a | tee -a $REPORT_FILE
cat /etc/os-release | tee -a $REPORT_FILE
uptime | tee -a $REPORT_FILE

# Recursos del sistema
echo -e "\n📊 RECURSOS DEL SISTEMA:" | tee -a $REPORT_FILE
echo "CPU:" | tee -a $REPORT_FILE
lscpu | grep -E "(Model name|CPU\(s\)|Thread|Core)" | tee -a $REPORT_FILE
echo -e "\nMemoria:" | tee -a $REPORT_FILE
free -h | tee -a $REPORT_FILE
echo -e "\nDisco:" | tee -a $REPORT_FILE
df -h | tee -a $REPORT_FILE

# Estado de servicios
echo -e "\n🔄 ESTADO DE SERVICIOS:" | tee -a $REPORT_FILE
docker-compose ps | tee -a $REPORT_FILE

# Logs de errores
echo -e "\n📋 ERRORES RECIENTES:" | tee -a $REPORT_FILE
docker-compose logs --since=1h 2>&1 | grep -i error | tail -20 | tee -a $REPORT_FILE

# Conectividad
echo -e "\n🌐 CONECTIVIDAD:" | tee -a $REPORT_FILE
curl -s -o /dev/null -w "API Gateway: %{http_code} - %{time_total}s\n" http://localhost:8080/health | tee -a $REPORT_FILE

# Métricas de performance
echo -e "\n⚡ PERFORMANCE:" | tee -a $REPORT_FILE
curl -s http://localhost:8080/api/v1/metrics/system | jq | tee -a $REPORT_FILE

echo -e "\n✅ Diagnóstico completo guardado en: $REPORT_FILE"
echo "📧 Envía este archivo al soporte técnico si necesitas ayuda."
```

### **🔧 Herramientas de Reparación Automática**

```bash
#!/bin/bash
# auto-repair.sh

echo "🔧 BackupGuard Pro - Reparación Automática"

# Función para verificar y reparar servicios
repair_services() {
    echo "🔄 Verificando servicios..."
    
    # Reiniciar servicios que no están healthy
    for service in $(docker-compose ps --services); do
        status=$(docker-compose ps $service --format "{{.State}}")
        if [[ "$status" != "Up" ]]; then
            echo "⚠️ Reiniciando $service..."
            docker-compose restart $service
            sleep 10
        fi
    done
}

# Función para limpiar espacio
cleanup_storage() {
    echo "🧹 Limpiando storage..."
    
    # Limpiar archivos temporales
    find /tmp -name "*backup*" -mtime +1 -delete
    
    # Limpiar logs antiguos
    find /var/log -name "*.log" -mtime +7 -exec gzip {} \;
    
    # Limpiar Docker
    docker system prune -f
    
    echo "✅ Limpieza completada"
}

# Función para verificar y reparar base de datos
repair_database() {
    echo "🗄️ Verificando base de datos..."
    
    # Verificar MongoDB
    if ! docker-compose exec -T mongodb mongo --quiet --eval "db.adminCommand('ismaster')" > /dev/null 2>&1; then
        echo "⚠️ Problema con MongoDB, intentando reparación..."
        docker-compose restart mongodb
        sleep 30
    fi
    
    # Verificar Redis
    if ! docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
        echo "⚠️ Problema con Redis, intentando reparación..."
        docker-compose restart redis
        sleep 10
    fi
}

# Ejecutar reparaciones
repair_services
cleanup_storage
repair_database

echo "✅ Reparación automática completada"
echo "🔍 Ejecuta el diagnóstico para verificar el estado del sistema"
```

### **📈 Monitoreo Continuo**

```bash
#!/bin/bash
# continuous-monitoring.sh

ALERT_EMAIL="admin@example.com"
THRESHOLD_CPU=80
THRESHOLD_MEMORY=85
THRESHOLD_DISK=90

while true; do
    # Verificar CPU
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d'u' -f1)
    if (( $(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc -l) )); then
        echo "🚨 ALERTA: CPU usage: ${CPU_USAGE}%" | mail -s "BackupGuard CPU Alert" $ALERT_EMAIL
    fi
    
    # Verificar Memoria
    MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    if (( $(echo "$MEMORY_USAGE > $THRESHOLD_MEMORY" | bc -l) )); then
        echo "🚨 ALERTA: Memory usage: ${MEMORY_USAGE}%" | mail -s "BackupGuard Memory Alert" $ALERT_EMAIL
    fi
    
    # Verificar Disco
    DISK_USAGE=$(df -h /var/backupguard | tail -1 | awk '{print $5}' | cut -d'%' -f1)
    if [[ $DISK_USAGE -gt $THRESHOLD_DISK ]]; then
        echo "🚨 ALERTA: Disk usage: ${DISK_USAGE}%" | mail -s "BackupGuard Disk Alert" $ALERT_EMAIL
    fi
    
    # Verificar servicios críticos
    if ! curl -s http://localhost:8080/health > /dev/null; then
        echo "🚨 ALERTA: API Gateway no responde" | mail -s "BackupGuard Service Alert" $ALERT_EMAIL
    fi
    
    sleep 300  # Verificar cada 5 minutos
done
```

---

## 📞 Escalación de Soporte

### **🎯 Niveles de Escalación**

#### **Nivel 1 - Self-Service**
- ✅ Ejecutar scripts de diagnóstico
- ✅ Consultar este troubleshooting guide
- ✅ Revisar logs y métricas
- ✅ Intentar reparaciones básicas

#### **Nivel 2 - Soporte Técnico**
- 📧 Email: support@backupguard.pro
- 💬 Chat: Portal web durante horario laboral
- 📋 Incluir: Reporte de diagnóstico completo

#### **Nivel 3 - Soporte Crítico**
- ☎️ Teléfono: +1-800-BACKUP-1 (24/7)
- 🚨 Para: Outages completos, pérdida de datos
- ⏱️ SLA: Respuesta en 1 hora

### **📋 Información para Soporte**

Antes de contactar soporte, ten lista esta información:

```bash
# Generar reporte completo para soporte
cat > /tmp/support-info.txt << EOF
BackupGuard Pro - Información para Soporte
==========================================
Timestamp: $(date)
Version: $(curl -s http://localhost:8080/api/v1/version | jq -r .version)
Environment: $(cat /opt/backupguard/.env | grep APP_ENV)

Sistema:
$(uname -a)

Servicios:
$(docker-compose ps)

Logs recientes:
$(docker-compose logs --since=1h --tail=50)

Métricas:
$(curl -s http://localhost:8080/api/v1/metrics/system | jq)
EOF

echo "📋 Información preparada en /tmp/support-info.txt"
```

---

> **💡 Tip**: Para problemas complejos, siempre incluye el reporte de diagnóstico completo y sé específico sobre los síntomas observados y los pasos ya intentados.
