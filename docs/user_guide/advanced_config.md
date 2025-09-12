# ⚙️ Advanced Configuration - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Configuración de Microservicios](#configuración-de-microservicios)
- [Base de Datos Avanzada](#base-de-datos-avanzada)
- [Red y Seguridad](#red-y-seguridad)
- [Storage y Performance](#storage-y-performance)
- [Monitoreo Avanzado](#monitoreo-avanzado)
- [High Availability](#high-availability)
- [Disaster Recovery](#disaster-recovery)
- [Integrations](#integrations)

---

## 🔧 Configuración de Microservicios

### **API Gateway Configuration**

#### **📡 Advanced Routing**
```yaml
# config/api-gateway/routes.yml
routes:
  backup_service:
    path: "/api/v1/backups/*"
    target: "http://backup-service:3001"
    timeout: 300000  # 5 minutos
    retry_attempts: 3
    circuit_breaker:
      enabled: true
      failure_threshold: 5
      recovery_timeout: 30000
    rate_limiting:
      requests_per_minute: 1000
      burst_size: 50
    
  user_service:
    path: "/api/v1/users/*"
    target: "http://user-service:3002"
    timeout: 30000
    auth_required: true
    roles: ["admin", "user"]
    
  notification_service:
    path: "/api/v1/notifications/*"
    target: "http://notification-service:3003"
    timeout: 15000
    async: true  # Non-blocking calls
    
  metrics_service:
    path: "/api/v1/metrics/*"
    target: "http://metrics-service:3004"
    cache:
      enabled: true
      ttl: 300  # 5 minutos
    compression: true
```

#### **🔐 Advanced Authentication**
```yaml
# config/api-gateway/auth.yml
auth_providers:
  jwt:
    secret: "${JWT_SECRET}"
    algorithm: "HS256"
    expiration: 3600
    refresh_enabled: true
    
  oauth2:
    google:
      client_id: "${GOOGLE_CLIENT_ID}"
      client_secret: "${GOOGLE_CLIENT_SECRET}"
      redirect_uri: "https://api.backupguard.pro/auth/google/callback"
      
    microsoft:
      client_id: "${MICROSOFT_CLIENT_ID}"
      client_secret: "${MICROSOFT_CLIENT_SECRET}"
      tenant_id: "${MICROSOFT_TENANT_ID}"
      
  saml:
    enabled: true
    sp_entity_id: "https://api.backupguard.pro"
    idp_metadata_url: "${SAML_IDP_METADATA_URL}"
    certificate_path: "/certs/saml.crt"
    private_key_path: "/certs/saml.key"

middleware:
  rate_limiting:
    redis_url: "${REDIS_URL}"
    window_ms: 60000  # 1 minuto
    max_requests: 1000
    
  cors:
    origin: 
      - "https://app.backupguard.pro"
      - "https://dashboard.backupguard.pro"
    credentials: true
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    
  request_logging:
    enabled: true
    include_body: false  # Para privacidad
    exclude_paths: ["/health", "/metrics"]
```

### **Service Mesh Configuration**

#### **🕸️ Istio Service Mesh**
```yaml
# k8s/istio/virtual-service.yml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: backupguard-services
spec:
  hosts:
  - api.backupguard.pro
  gateways:
  - backupguard-gateway
  http:
  - match:
    - uri:
        prefix: /api/v1/backups
    route:
    - destination:
        host: backup-service
        port:
          number: 3001
    fault:
      delay:
        percentage:
          value: 0.1  # 0.1% de requests con delay
        fixedDelay: 5s
    retries:
      attempts: 3
      perTryTimeout: 30s
      
  - match:
    - uri:
        prefix: /api/v1/users
    route:
    - destination:
        host: user-service
        port:
          number: 3002
        subset: v2  # Canary deployment
      weight: 10
    - destination:
        host: user-service
        port:
          number: 3002
        subset: v1
      weight: 90
```

#### **📊 Traffic Policies**
```yaml
# k8s/istio/destination-rule.yml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: backup-service
spec:
  host: backup-service
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 50
        maxRequestsPerConnection: 10
    loadBalancer:
      simple: LEAST_CONN
    circuitBreaker:
      consecutiveErrors: 5
      interval: 30s
      baseEjectionTime: 30s
      maxEjectionPercent: 50
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
    trafficPolicy:
      portLevelSettings:
      - port:
          number: 3001
        circuitBreaker:
          consecutiveErrors: 3  # Más estricto para canary
```

---

## 🗄️ Base de Datos Avanzada

### **MongoDB Cluster Configuration**

#### **🔄 Replica Set Setup**
```yaml
# config/mongodb/replica-set.yml
replication:
  replSetName: "backupguard-rs"
  
members:
  - host: "mongodb-primary:27017"
    priority: 1
    votes: 1
    
  - host: "mongodb-secondary-1:27017"
    priority: 0.5
    votes: 1
    hidden: false
    
  - host: "mongodb-secondary-2:27017"
    priority: 0.5
    votes: 1
    hidden: false
    
  - host: "mongodb-arbiter:27017"
    priority: 0
    votes: 1
    arbiterOnly: true

# Configuración avanzada
storage:
  engine: "wiredTiger"
  wiredTiger:
    engineConfig:
      cacheSizeGB: 16
      journalCompressor: "zstd"
      directoryForIndexes: true
    collectionConfig:
      blockCompressor: "zstd"
    indexConfig:
      prefixCompression: true

net:
  port: 27017
  bindIp: "0.0.0.0"
  maxIncomingConnections: 1000
  
operationProfiling:
  mode: "slowOp"
  slowOpThresholdMs: 100
```

#### **📈 Sharding Configuration**
```yaml
# config/mongodb/sharding.yml
sharding:
  clusterRole: "shardsvr"
  
# Config servers
configsvr:
  hosts:
    - "config-1:27019"
    - "config-2:27019" 
    - "config-3:27019"

# Mongos routers
mongos:
  hosts:
    - "mongos-1:27017"
    - "mongos-2:27017"
    
# Shards
shards:
  shard1:
    hosts:
      - "shard1-primary:27018"
      - "shard1-secondary:27018"
      
  shard2:
    hosts:
      - "shard2-primary:27018"
      - "shard2-secondary:27018"

# Shard key strategies
collections:
  backup_jobs:
    shard_key: {"client_id": 1, "created_at": 1}
    strategy: "range"
    
  backup_files:
    shard_key: {"file_hash": "hashed"}
    strategy: "hash"
    
  metrics:
    shard_key: {"timestamp": 1}
    strategy: "range"
```

### **PostgreSQL Configuration (Métricas)**

#### **🚀 Performance Tuning**
```sql
-- config/postgresql/postgresql.conf

-- Memoria
shared_buffers = '2GB'
effective_cache_size = '6GB'
work_mem = '128MB'
maintenance_work_mem = '512MB'

-- Conexiones
max_connections = 200
superuser_reserved_connections = 3

-- WAL y Checkpoints
wal_buffers = '64MB'
checkpoint_completion_target = 0.9
checkpoint_timeout = '15min'
max_wal_size = '4GB'
min_wal_size = '1GB'

-- Query Planner
random_page_cost = 1.1  # Para SSD
effective_io_concurrency = 200

-- Logging
log_statement = 'mod'  # Solo modificaciones
log_min_duration_statement = 1000  # Queries > 1s
log_checkpoints = on
log_lock_waits = on

-- Autovacuum
autovacuum = on
autovacuum_max_workers = 6
autovacuum_vacuum_threshold = 50
autovacuum_analyze_threshold = 50
```

#### **📊 Partitioning Strategy**
```sql
-- Particionado de tabla de métricas por tiempo
CREATE TABLE metrics (
    id BIGSERIAL,
    timestamp TIMESTAMPTZ NOT NULL,
    metric_name VARCHAR(255) NOT NULL,
    metric_value NUMERIC,
    client_id UUID,
    server_id UUID,
    tags JSONB
) PARTITION BY RANGE (timestamp);

-- Particiones mensuales automatizadas
CREATE OR REPLACE FUNCTION create_monthly_partition(table_name text, start_date date)
RETURNS void AS $$
DECLARE
    partition_name text;
    end_date date;
BEGIN
    partition_name := table_name || '_' || to_char(start_date, 'YYYY_MM');
    end_date := start_date + interval '1 month';
    
    EXECUTE format('CREATE TABLE %I PARTITION OF %I 
                    FOR VALUES FROM (%L) TO (%L)',
                   partition_name, table_name, start_date, end_date);
                   
    -- Índices específicos por partición
    EXECUTE format('CREATE INDEX ON %I (client_id, timestamp)', partition_name);
    EXECUTE format('CREATE INDEX ON %I USING GIN (tags)', partition_name);
END;
$$ LANGUAGE plpgsql;

-- Automatizar creación de particiones
SELECT create_monthly_partition('metrics', date_trunc('month', CURRENT_DATE + interval '1 month'));
```

### **Redis Cluster Configuration**

#### **⚡ High Performance Setup**
```yaml
# config/redis/redis.conf
# Networking
bind 0.0.0.0
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300

# Memoria
maxmemory 4gb
maxmemory-policy allkeys-lru
maxmemory-samples 5

# Persistencia híbrida
save 900 1    # 1 cambio en 15 min
save 300 10   # 10 cambios en 5 min
save 60 10000 # 10000 cambios en 1 min

# AOF para durabilidad
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# Cluster
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 15000
cluster-require-full-coverage no

# Performance
hz 10  # Background tasks frequency
```

#### **🔄 Redis Cluster Setup**
```bash
#!/bin/bash
# Script de configuración de Redis Cluster

# Nodos del cluster
NODES=(
    "redis-1:7001"
    "redis-2:7002" 
    "redis-3:7003"
    "redis-4:7004"
    "redis-5:7005"
    "redis-6:7006"
)

# Crear cluster con 3 masters y 3 slaves
redis-cli --cluster create \
    ${NODES[@]} \
    --cluster-replicas 1 \
    --cluster-yes

# Verificar cluster
redis-cli --cluster check redis-1:7001

# Configurar cliente para aplicación
cat > config/redis-cluster.yml << EOF
redis:
  cluster:
    nodes:
      - host: redis-1
        port: 7001
      - host: redis-2  
        port: 7002
      - host: redis-3
        port: 7003
    options:
      max_redirections: 3
      retry_delay: 100
      pool_size: 20
EOF
```

---

## 🔒 Red y Seguridad

### **Network Security**

#### **🛡️ Firewall Rules (iptables)**
```bash
#!/bin/bash
# config/security/firewall-rules.sh

# Limpiar reglas existentes
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Políticas por defecto
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir conexiones establecidas
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# SSH (solo desde IPs específicas)
iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 172.16.0.0/12 -j ACCEPT

# HTTP/HTTPS (desde load balancer)
iptables -A INPUT -p tcp --dport 80 -s 10.0.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -s 10.0.1.0/24 -j ACCEPT

# Aplicación (desde service mesh)
iptables -A INPUT -p tcp --dport 8080 -s 10.0.2.0/24 -j ACCEPT

# MongoDB (solo cluster interno)
iptables -A INPUT -p tcp --dport 27017 -s 10.0.3.0/24 -j ACCEPT

# Redis (solo cluster interno)
iptables -A INPUT -p tcp --dport 6379 -s 10.0.4.0/24 -j ACCEPT

# Métricas (solo monitoring)
iptables -A INPUT -p tcp --dport 9090 -s 10.0.5.0/24 -j ACCEPT

# Anti-DDoS básico
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

# Log y drop
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPTables-Dropped: "
iptables -A INPUT -j DROP
```

#### **🔐 SSL/TLS Configuration**
```yaml
# config/nginx/ssl.conf
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384;
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;

# HSTS
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# OCSP Stapling
ssl_stapling on;
ssl_stapling_verify on;
ssl_trusted_certificate /etc/ssl/certs/ca-certs.pem;

# Certificate pinning
add_header Public-Key-Pins 'pin-sha256="base64+primary+key"; pin-sha256="base64+backup+key"; max-age=5184000; includeSubDomains';

# Security headers
add_header X-Frame-Options DENY always;
add_header X-Content-Type-Options nosniff always;
add_header Referrer-Policy strict-origin-when-cross-origin always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';" always;
```

### **Identity and Access Management**

#### **🎯 RBAC Advanced Configuration**
```yaml
# config/security/rbac.yml
roles:
  super_admin:
    description: "Acceso completo al sistema"
    permissions:
      - "system:*"
      - "client:*"
      - "backup:*"
      - "security:*"
    conditions:
      ip_whitelist: ["10.0.0.0/8", "172.16.0.0/12"]
      time_restriction: "business_hours"
      
  backup_operator:
    description: "Operador de backups"
    permissions:
      - "backup:read"
      - "backup:create"
      - "backup:restore"
      - "client:read"
      - "monitoring:read"
    conditions:
      requires_mfa: true
      session_timeout: 480  # 8 horas
      
  client_admin:
    description: "Administrador de cliente específico"
    permissions:
      - "backup:read:own"
      - "backup:restore:own"
      - "monitoring:read:own"
      - "reporting:read:own"
    conditions:
      client_scoped: true
      requires_approval_for: ["backup:restore"]

policy_engine:
  type: "opa"  # Open Policy Agent
  policies:
    backup_restore_approval:
      rule: |
        package backupguard.authz
        
        allow {
          input.action == "backup:restore"
          input.resource.size_gb < 100
          input.user.role == "backup_operator"
        }
        
        allow {
          input.action == "backup:restore"
          input.approval.status == "approved"
          input.approval.approver.role == "super_admin"
        }
        
    sensitive_data_access:
      rule: |
        package backupguard.authz
        
        allow {
          input.action == "data:read"
          input.resource.classification != "confidential"
        }
        
        allow {
          input.action == "data:read"
          input.resource.classification == "confidential"
          input.user.clearance_level >= 3
          input.justification != ""
        }
```

#### **🔑 Advanced Authentication**
```yaml
# config/security/auth.yml
authentication:
  multi_factor:
    enabled: true
    providers:
      totp:
        issuer: "BackupGuard Pro"
        algorithm: "SHA256"
        digits: 6
        period: 30
        
      webauthn:
        enabled: true
        attestation: "direct"
        user_verification: "required"
        
      sms:
        provider: "twilio"
        template: "Your BackupGuard verification code: {code}"
        
  risk_based:
    enabled: true
    factors:
      - ip_address_reputation
      - device_fingerprinting
      - behavioral_biometrics
      - geolocation
      
    thresholds:
      low_risk: 0.3
      medium_risk: 0.6
      high_risk: 0.8
      
    actions:
      medium_risk: "require_mfa"
      high_risk: "require_approval"

  session_management:
    concurrent_sessions: 3
    idle_timeout: 1800  # 30 minutos
    absolute_timeout: 28800  # 8 horas
    
    security:
      secure_cookies: true
      httponly_cookies: true
      samesite: "strict"
      csrf_protection: true
```

---

## 💾 Storage y Performance

### **Storage Optimization**

#### **🗄️ Tiered Storage Configuration**
```yaml
# config/storage/tiers.yml
storage_tiers:
  hot:
    description: "Alta performance para datos activos"
    type: "nvme_ssd"
    replication: 3
    compression: "lz4"  # Rápida
    encryption: "aes256-gcm"
    retention_days: 30
    
    performance:
      target_iops: 50000
      target_throughput_mbps: 2000
      target_latency_ms: 1
      
  warm:
    description: "Datos de acceso frecuente"
    type: "sata_ssd"
    replication: 2
    compression: "zstd"  # Balance
    encryption: "aes256-cbc"
    retention_days: 90
    
    auto_migration:
      from_tier: "hot"
      conditions:
        - "age_days > 7"
        - "access_frequency < 0.1"
        
  cold:
    description: "Archivo a largo plazo"
    type: "hdd_raid6"
    replication: 1
    compression: "zstd_max"  # Máxima compresión
    encryption: "aes256-cbc"
    retention_days: 2555  # 7 años
    
    auto_migration:
      from_tier: "warm"
      conditions:
        - "age_days > 90"
        - "access_frequency < 0.01"
        
  glacier:
    description: "Archivo ultra-económico"
    type: "tape_library"
    replication: 1
    compression: "bzip2"
    encryption: "aes256-cbc"
    retention_days: 3650  # 10 años
    
    retrieval_time_hours: 24
    auto_migration:
      from_tier: "cold"
      conditions:
        - "age_days > 365"
        - "compliance_required"
```

#### **⚡ Deduplication Engine**
```yaml
# config/storage/deduplication.yml
deduplication:
  algorithm: "variable_length_chunking"
  
  chunking:
    min_chunk_size_kb: 4
    avg_chunk_size_kb: 64
    max_chunk_size_kb: 1024
    
  hashing:
    algorithm: "blake2b"
    hash_length: 32
    
  index:
    type: "distributed_hash_table"
    bloom_filter:
      enabled: true
      false_positive_rate: 0.001
      
  scope:
    global: true  # Dedup across all clients
    client_isolation: false  # Para máxima eficiencia
    
  performance:
    parallel_threads: 16
    memory_cache_size_gb: 8
    disk_cache_size_gb: 100
    
  statistics:
    track_savings: true
    report_interval_hours: 24
```

#### **🔄 Compression Strategy**
```yaml
# config/storage/compression.yml
compression:
  algorithms:
    lz4:
      speed: "fastest"
      ratio: "low"
      cpu_usage: "low"
      use_cases: ["real_time", "hot_tier"]
      
    zstd:
      speed: "fast"
      ratio: "high"
      cpu_usage: "medium"
      use_cases: ["warm_tier", "general"]
      levels:
        fast: 1
        balanced: 6
        best: 19
        
    bzip2:
      speed: "slow"
      ratio: "highest"
      cpu_usage: "high"
      use_cases: ["cold_tier", "archive"]

  adaptive_compression:
    enabled: true
    rules:
      - file_types: ["jpg", "png", "mp4", "mp3"]
        algorithm: "none"  # Ya comprimidos
        
      - file_types: ["txt", "log", "csv", "json"]
        algorithm: "zstd"
        level: "best"
        
      - file_size_mb: "> 1000"
        algorithm: "zstd"
        level: "balanced"
        
      - cpu_load: "> 80%"
        algorithm: "lz4"  # Menos CPU intensivo
```

### **Performance Tuning**

#### **🚀 I/O Optimization**
```yaml
# config/performance/io.yml
io_scheduler:
  type: "mq-deadline"  # Para SSD
  read_ahead_kb: 128
  
storage_optimization:
  filesystem: "xfs"
  mount_options:
    - "noatime"      # No actualizar access time
    - "nodiratime"   # No actualizar directory access time
    - "largeio"      # Optimizar para I/O grandes
    - "inode64"      # Usar 64-bit inodes
    
raid_configuration:
  level: "raid10"    # Balance performance/redundancia
  stripe_size_kb: 256
  read_ahead_kb: 2048
  
kernel_parameters:
  vm.dirty_ratio: 10
  vm.dirty_background_ratio: 5
  vm.vfs_cache_pressure: 50
  vm.swappiness: 1
  
block_device_tuning:
  scheduler: "mq-deadline"
  read_ahead_kb: 128
  max_sectors_kb: 512
  nr_requests: 256
```

#### **💾 Memory Management**
```yaml
# config/performance/memory.yml
memory_allocation:
  application_heap: "8GB"
  os_cache: "16GB"
  database_buffers: "4GB"
  
  huge_pages:
    enabled: true
    size: "2MB"
    count: 4096  # 8GB en huge pages
    
garbage_collection:
  type: "G1GC"
  parameters:
    - "-XX:G1HeapRegionSize=32m"
    - "-XX:MaxGCPauseMillis=100"
    - "-XX:G1NewSizePercent=20"
    - "-XX:G1MaxNewSizePercent=30"
    - "-XX:InitiatingHeapOccupancyPercent=45"
    
buffer_pools:
  backup_read_buffer: "512MB"
  backup_write_buffer: "1GB"
  dedup_cache: "2GB"
  compression_buffer: "256MB"
```

---

## 📊 Monitoreo Avanzado

### **Prometheus Configuration**

#### **📈 Métricas Personalizadas**
```yaml
# config/monitoring/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'backupguard-prod'
    region: 'us-east-1'

rule_files:
  - "rules/*.yml"

scrape_configs:
  - job_name: 'backupguard-api'
    static_configs:
      - targets: ['api-gateway:8080']
    metrics_path: '/metrics'
    scrape_interval: 10s
    
  - job_name: 'backupguard-backup-service'
    static_configs:
      - targets: ['backup-service:3001']
    metrics_path: '/metrics'
    
  - job_name: 'mongodb-exporter'
    static_configs:
      - targets: ['mongodb-exporter:9216']
      
  - job_name: 'redis-exporter'
    static_configs:
      - targets: ['redis-exporter:9121']
      
  - job_name: 'node-exporter'
    static_configs:
      - targets:
        - 'node-1:9100'
        - 'node-2:9100' 
        - 'node-3:9100'

  # Métricas personalizadas de negocio
  - job_name: 'backup-business-metrics'
    static_configs:
      - targets: ['metrics-collector:9200']
    scrape_interval: 60s
```

#### **🚨 Alerting Rules**
```yaml
# config/monitoring/rules/backup-alerts.yml
groups:
  - name: backup.rules
    interval: 30s
    rules:
      # SLA Alerts
      - alert: BackupSLABreach
        expr: |
          (
            sum(rate(backup_jobs_failed_total[5m])) / 
            sum(rate(backup_jobs_total[5m]))
          ) > 0.05
        for: 5m
        labels:
          severity: critical
          team: operations
        annotations:
          summary: "Backup SLA breach detected"
          description: "Backup failure rate is {{ $value | humanizePercentage }} over 5 minutes"
          
      - alert: BackupRPOViolation
        expr: |
          (time() - backup_last_successful_timestamp) / 3600 > 
          on(client_id) backup_rpo_hours
        for: 0m
        labels:
          severity: critical
          team: operations
        annotations:
          summary: "RPO violation for client {{ $labels.client_id }}"
          description: "Last successful backup was {{ $value | humanizeDuration }} ago"
          
      # Performance Alerts  
      - alert: BackupPerformanceDegradation
        expr: |
          avg_over_time(backup_throughput_mbps[1h]) < 
          avg_over_time(backup_throughput_mbps[24h] offset 1w) * 0.7
        for: 30m
        labels:
          severity: warning
          team: engineering
        annotations:
          summary: "Backup performance degradation"
          description: "Backup throughput is 30% below weekly average"
          
      # Capacity Alerts
      - alert: StorageCapacityWarning
        expr: |
          (storage_used_bytes / storage_total_bytes) > 0.85
        for: 15m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Storage capacity warning"
          description: "Storage is {{ $value | humanizePercentage }} full"
          
      - alert: StorageCapacityCritical
        expr: |
          (storage_used_bytes / storage_total_bytes) > 0.95
        for: 5m
        labels:
          severity: critical
          team: infrastructure
        annotations:
          summary: "Storage capacity critical"
          description: "Storage is {{ $value | humanizePercentage }} full"
          
      # Security Alerts
      - alert: UnusualLoginActivity
        expr: |
          increase(auth_failures_total[5m]) > 10
        for: 0m
        labels:
          severity: warning
          team: security
        annotations:
          summary: "Unusual login activity detected"
          description: "{{ $value }} failed login attempts in 5 minutes"
```

### **Grafana Dashboards**

#### **📊 Executive Dashboard**
```json
{
  "dashboard": {
    "title": "BackupGuard Executive Dashboard",
    "tags": ["backupguard", "executive"],
    "time": {
      "from": "now-24h",
      "to": "now"
    },
    "panels": [
      {
        "title": "SLA Compliance",
        "type": "stat",
        "targets": [
          {
            "expr": "avg(backup_sla_compliance_percentage)",
            "legendFormat": "SLA Compliance"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "min": 0,
            "max": 100,
            "unit": "percent",
            "thresholds": {
              "steps": [
                {"color": "red", "value": 0},
                {"color": "yellow", "value": 95},
                {"color": "green", "value": 99}
              ]
            }
          }
        }
      },
      {
        "title": "Backup Success Rate (24h)",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(rate(backup_jobs_successful_total[24h])) / sum(rate(backup_jobs_total[24h])) * 100",
            "legendFormat": "Success Rate"
          }
        ]
      },
      {
        "title": "Data Protected",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(backup_data_protected_bytes)",
            "legendFormat": "Total Protected Data"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "bytes"
          }
        }
      },
      {
        "title": "Backup Jobs Timeline",
        "type": "timeseries",
        "targets": [
          {
            "expr": "sum by (status) (rate(backup_jobs_total[5m]))",
            "legendFormat": "{{status}}"
          }
        ]
      }
    ]
  }
}
```

#### **🔧 Operations Dashboard**
```json
{
  "dashboard": {
    "title": "BackupGuard Operations Dashboard",
    "tags": ["backupguard", "operations"],
    "panels": [
      {
        "title": "Active Backup Jobs",
        "type": "table",
        "targets": [
          {
            "expr": "backup_job_active_info",
            "format": "table"
          }
        ],
        "transformations": [
          {
            "id": "organize",
            "options": {
              "excludeByName": {"__name__": true, "job": true},
              "renameByName": {
                "client_name": "Client",
                "job_id": "Job ID",
                "progress": "Progress %",
                "eta_minutes": "ETA (min)"
              }
            }
          }
        ]
      },
      {
        "title": "System Resource Usage",
        "type": "timeseries",
        "targets": [
          {
            "expr": "100 - (avg(rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "CPU Usage %"
          },
          {
            "expr": "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100",
            "legendFormat": "Memory Usage %"
          }
        ]
      },
      {
        "title": "Network I/O",
        "type": "timeseries",
        "targets": [
          {
            "expr": "rate(node_network_receive_bytes_total[5m]) * 8",
            "legendFormat": "Inbound"
          },
          {
            "expr": "rate(node_network_transmit_bytes_total[5m]) * 8",
            "legendFormat": "Outbound"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "bps"
          }
        }
      }
    ]
  }
}
```

---

## 🏗️ High Availability

### **Load Balancer Configuration**

#### **⚖️ HAProxy Setup**
```haproxy
# config/haproxy/haproxy.cfg
global
    daemon
    maxconn 4096
    log stdout local0
    
    # SSL configuration
    ssl-default-bind-ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384
    ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
    
defaults
    mode http
    log global
    option httplog
    option dontlognull
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
    
# Frontend para HTTPS
frontend https_frontend
    bind *:443 ssl crt /etc/ssl/certs/backupguard.pem
    redirect scheme https if !{ ssl_fc }
    
    # Security headers
    http-response set-header Strict-Transport-Security "max-age=31536000; includeSubDomains"
    http-response set-header X-Frame-Options DENY
    http-response set-header X-Content-Type-Options nosniff
    
    # Rate limiting
    stick-table type ip size 100k expire 30s store http_req_rate(10s)
    http-request track-sc0 src
    http-request reject if { sc_http_req_rate(0) gt 20 }
    
    default_backend api_gateway_backend

# Backend para API Gateway
backend api_gateway_backend
    balance roundrobin
    option httpchk GET /health
    
    server api1 10.0.1.10:8080 check inter 5s fall 3 rise 2
    server api2 10.0.1.11:8080 check inter 5s fall 3 rise 2
    server api3 10.0.1.12:8080 check inter 5s fall 3 rise 2

# Stats page
listen stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 30s
    stats admin if TRUE
```

### **Database High Availability**

#### **🔄 MongoDB Replica Set with Automatic Failover**
```javascript
// config/mongodb/replica-init.js
rs.initiate({
  _id: "backupguard-rs",
  version: 1,
  members: [
    {
      _id: 0,
      host: "mongodb-primary:27017",
      priority: 2,
      votes: 1
    },
    {
      _id: 1,
      host: "mongodb-secondary-1:27017",
      priority: 1,
      votes: 1
    },
    {
      _id: 2,
      host: "mongodb-secondary-2:27017",
      priority: 1,
      votes: 1
    },
    {
      _id: 3,
      host: "mongodb-arbiter:27017",
      priority: 0,
      votes: 1,
      arbiterOnly: true
    }
  ],
  settings: {
    electionTimeoutMillis: 5000,
    heartbeatIntervalMillis: 2000,
    heartbeatTimeoutSecs: 10,
    catchUpTimeoutMillis: 60000
  }
});

// Configurar read preferences
db.adminCommand({
  setDefaultRWConcern: {
    defaultReadConcern: { level: "majority" },
    defaultWriteConcern: {
      w: "majority",
      wtimeout: 5000
    }
  }
});
```

### **Application Level HA**

#### **🔄 Circuit Breaker Pattern**
```yaml
# config/resilience/circuit-breaker.yml
circuit_breakers:
  mongodb:
    failure_threshold: 5
    recovery_timeout: 30000
    half_open_max_calls: 3
    
  redis:
    failure_threshold: 3
    recovery_timeout: 15000
    half_open_max_calls: 2
    
  backup_service:
    failure_threshold: 10
    recovery_timeout: 60000
    half_open_max_calls: 5
    slow_call_duration_threshold: 30000
    slow_call_rate_threshold: 0.5

retry_policies:
  database_operations:
    max_attempts: 3
    delay: 1000
    backoff_multiplier: 2
    max_delay: 10000
    
  api_calls:
    max_attempts: 2
    delay: 500
    backoff_multiplier: 1.5
    max_delay: 5000

bulkhead:
  thread_pools:
    backup_operations:
      core_size: 10
      max_size: 20
      queue_capacity: 100
      
    user_operations:
      core_size: 5
      max_size: 10
      queue_capacity: 50
      
    reporting:
      core_size: 3
      max_size: 5
      queue_capacity: 20
```

---

## 🌪️ Disaster Recovery

### **Backup Strategy for Backup System**

#### **📋 Multi-Layer Backup Strategy**
```yaml
# config/disaster-recovery/backup-strategy.yml
backup_layers:
  config_backup:
    description: "Configuraciones del sistema"
    frequency: "daily"
    retention: "90 days"
    targets:
      - "/opt/backupguard/config"
      - "/etc/nginx"
      - "/etc/ssl"
    destinations:
      - "s3://backupguard-config-backup"
      - "rsync://backup-server/config"
      
  database_backup:
    description: "Backup de bases de datos"
    frequency: "every 6 hours"
    retention: "30 days"
    
    mongodb:
      method: "mongodump"
      compression: "gzip"
      options: "--oplog"
      
    postgresql:
      method: "pg_dump"
      compression: "custom"
      options: "--verbose --no-owner"
      
  application_backup:
    description: "Código de aplicación y dependencias"
    frequency: "after_deployment"
    retention: "10 versions"
    targets:
      - "/opt/backupguard/app"
      - "/opt/backupguard/scripts"
      
  storage_backup:
    description: "Backup de datos de clientes"
    frequency: "continuous"
    method: "rsync"
    destinations:
      - remote_site: "dr-site-1"
        method: "rsync"
        bandwidth_limit: "100MB/s"
      - remote_site: "dr-site-2"
        method: "object_storage"
        storage_class: "cold"

recovery_procedures:
  rto_targets:
    database: "15 minutes"
    application: "30 minutes"
    full_system: "2 hours"
    
  automated_tests:
    frequency: "weekly"
    procedures:
      - "restore_database_to_staging"
      - "validate_data_integrity"
      - "test_application_startup"
      - "verify_client_access"
```

### **Geographic Redundancy**

#### **🌍 Multi-Region Setup**
```yaml
# config/disaster-recovery/geo-redundancy.yml
regions:
  primary:
    name: "us-east-1"
    role: "active"
    services:
      - api_gateway
      - backup_service
      - user_service
      - notification_service
    databases:
      mongodb_primary: true
      redis_master: true
      
  secondary:
    name: "us-west-2"
    role: "standby"
    replication_lag_max: "5 minutes"
    services:
      - api_gateway  # Read-only mode
      - backup_service  # Standby
    databases:
      mongodb_secondary: true
      redis_replica: true
      
  disaster_recovery:
    name: "eu-west-1"
    role: "cold_standby"
    activation_time: "2 hours"
    data_sync_frequency: "daily"

failover_automation:
  health_checks:
    - endpoint: "/health"
      interval: "30s"
      timeout: "10s"
      consecutive_failures: 3
      
  automatic_failover:
    enabled: true
    conditions:
      - "primary_region_down > 5 minutes"
      - "database_lag < 1 minute"
    
  manual_controls:
    force_failover_command: "kubectl patch deployment api-gateway -p '{\"spec\":{\"replicas\":0}}'"
    promote_secondary_command: "kubectl scale deployment api-gateway --replicas=3"
```

---

## 🔌 Integrations

### **Enterprise Systems Integration**

#### **💼 Active Directory Integration**
```yaml
# config/integrations/active-directory.yml
ldap:
  url: "ldaps://dc.empresa.com:636"
  bind_dn: "CN=BackupGuard Service,OU=Service Accounts,DC=empresa,DC=com"
  bind_password: "${LDAP_PASSWORD}"
  
  user_search:
    base_dn: "OU=Users,DC=empresa,DC=com"
    filter: "(&(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"
    attributes:
      username: "sAMAccountName"
      email: "mail"
      full_name: "displayName"
      department: "department"
      manager: "manager"
      
  group_search:
    base_dn: "OU=Groups,DC=empresa,DC=com"
    filter: "(objectClass=group)"
    member_attribute: "member"
    
  role_mapping:
    "CN=BackupGuard Admins,OU=Groups,DC=empresa,DC=com": "super_admin"
    "CN=IT Operations,OU=Groups,DC=empresa,DC=com": "backup_admin"
    "CN=Backup Users,OU=Groups,DC=empresa,DC=com": "backup_operator"

sync:
  enabled: true
  interval: "1 hour"
  full_sync_interval: "24 hours"
  
  on_user_change:
    action: "update_profile"
    notify: true
    
  on_user_disable:
    action: "disable_account"
    retain_data: true
```

#### **📊 ITSM Integration (ServiceNow)**
```yaml
# config/integrations/servicenow.yml
servicenow:
  instance_url: "https://empresa.service-now.com"
  username: "${SERVICENOW_USER}"
  password: "${SERVICENOW_PASSWORD}"
  
  incident_creation:
    enabled: true
    triggers:
      - alert_severity: "critical"
        category: "Software"
        subcategory: "Backup"
        priority: 1
        
      - alert_severity: "high"
        category: "Software" 
        subcategory: "Backup"
        priority: 2
        
  change_requests:
    auto_create: true
    triggers:
      - action: "system_update"
        lead_time_days: 3
        approval_required: true
        
  work_orders:
    auto_create: true
    triggers:
      - event: "hardware_failure"
        assignment_group: "Infrastructure Team"
        
templates:
  critical_incident: |
    BackupGuard Critical Alert
    
    Service: {{service_name}}
    Alert: {{alert_summary}}
    Impact: {{business_impact}}
    
    Automatic monitoring detected a critical issue requiring immediate attention.
    
    Dashboard: {{dashboard_url}}
    Runbook: {{runbook_url}}
```

#### **💬 Collaboration Tools Integration**
```yaml
# config/integrations/collaboration.yml
slack:
  bot_token: "${SLACK_BOT_TOKEN}"
  channels:
    alerts: "#backup-alerts"
    operations: "#backup-ops"
    executive: "#executive-summary"
    
  message_formatting:
    use_threads: true
    emoji_status: true
    mention_on_critical: "@here"
    
microsoft_teams:
  webhook_url: "${TEAMS_WEBHOOK_URL}"
  adaptive_cards: true
  
  channels:
    alerts: "Backup Alerts"
    reports: "Daily Reports"

email:
  smtp_server: "${SMTP_SERVER}"
  templates:
    daily_summary: "templates/daily-summary.html"
    incident_report: "templates/incident-report.html"
    executive_weekly: "templates/executive-weekly.html"
```

### **Cloud Provider Integration**

#### **☁️ AWS Integration**
```yaml
# config/integrations/aws.yml
aws:
  region: "us-east-1"
  credentials:
    access_key_id: "${AWS_ACCESS_KEY_ID}"
    secret_access_key: "${AWS_SECRET_ACCESS_KEY}"
    
  s3:
    backup_bucket: "backupguard-client-data"
    config_bucket: "backupguard-config"
    
    lifecycle_policies:
      - id: "transition_to_ia"
        status: "Enabled"
        transition:
          days: 30
          storage_class: "STANDARD_IA"
          
      - id: "transition_to_glacier"
        status: "Enabled"
        transition:
          days: 90
          storage_class: "GLACIER"
          
      - id: "delete_old_backups"
        status: "Enabled"
        expiration:
          days: 2555  # 7 años
          
  cloudwatch:
    custom_metrics: true
    log_groups:
      - name: "/backupguard/application"
        retention_days: 90
      - name: "/backupguard/audit"
        retention_days: 2555
        
  sns:
    topics:
      critical_alerts: "arn:aws:sns:us-east-1:account:backupguard-critical"
      daily_reports: "arn:aws:sns:us-east-1:account:backupguard-reports"
```

#### **🔐 Vault Integration (HashiCorp)**
```yaml
# config/integrations/vault.yml
vault:
  address: "https://vault.empresa.com:8200"
  auth_method: "kubernetes"
  
  secrets_engines:
    database:
      path: "database"
      type: "database"
      
    pki:
      path: "pki"
      type: "pki"
      
  policies:
    backupguard_app:
      capabilities:
        - "read"
        - "list"
      paths:
        - "secret/data/backupguard/*"
        - "database/creds/backupguard-role"
        
  dynamic_secrets:
    mongodb:
      enabled: true
      ttl: "1h"
      max_ttl: "24h"
      
    postgresql:
      enabled: true
      ttl: "2h"
      max_ttl: "24h"

auto_rotation:
  api_keys:
    enabled: true
    interval: "90 days"
    
  database_passwords:
    enabled: true
    interval: "30 days"
    
  ssl_certificates:
    enabled: true
    interval: "60 days"
    renewal_threshold: "30 days"
```

---

> **💡 Nota**: Esta configuración avanzada está diseñada para entornos de producción empresariales. Adapta los valores según tus necesidades específicas de infraestructura y seguridad.
