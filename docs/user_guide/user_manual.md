# 📖 User Manual - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Dashboard Principal](#dashboard-principal)
- [Gestión de Clientes](#gestión-de-clientes)
- [Configuración de Backups](#configuración-de-backups)
- [Monitoreo y Alertas](#monitoreo-y-alertas)
- [Reportes y Análisis](#reportes-y-análisis)
- [Administración del Sistema](#administración-del-sistema)
- [API y Automatización](#api-y-automatización)
- [Mobile App](#mobile-app)

---

## 🏠 Dashboard Principal

### **Vista General**
El dashboard principal te proporciona una vista instantánea del estado de todos tus backups y sistemas monitoreados.

#### **Acceso al Dashboard**
1. Navega a `https://tu-dominio.com`
2. Inicia sesión con tus credenciales
3. Serás dirigido automáticamente al dashboard

#### **Componentes del Dashboard**

##### **🎯 Métricas Principales**
```
┌─────────────────────────────────────────┐
│ 📊 RESUMEN EJECUTIVO                    │
├─────────────────────────────────────────┤
│ ✅ Backups Exitosos (24h):      247    │
│ ⚠️  Backups con Warnings:        12    │
│ ❌ Backups Fallidos:              3    │
│ 📈 Datos Respaldados (mes):     2.4TB  │
│ 🎯 SLA Compliance:             99.2%   │
└─────────────────────────────────────────┘
```

##### **📈 Gráficos en Tiempo Real**
- **Throughput de Backup**: Velocidad de transferencia actual
- **Storage Utilization**: Uso del almacenamiento por cliente
- **Success Rate**: Tasa de éxito de backups (últimos 7 días)
- **Alert Timeline**: Línea temporal de alertas recientes

##### **🚨 Centro de Alertas**
```
🔴 CRÍTICO   │ Cliente XYZ: Backup fallido 3 veces consecutivas
🟡 WARNING   │ Storage pool A: 85% de capacidad utilizada  
🔵 INFO      │ Actualización v2.1.3 disponible
🟢 SUCCESS   │ Backup nocturno completado: 156 clientes
```

### **Navegación Rápida**
#### **Sidebar Menu**
```
🏠 Dashboard
├── 👥 Clientes
│   ├── Lista de Clientes
│   ├── Agregar Cliente
│   └── Configuraciones Masivas
├── 💾 Backups
│   ├── Estado Actual
│   ├── Programación
│   ├── Restauraciones
│   └── Historial
├── 📊 Monitoreo
│   ├── Métricas en Vivo
│   ├── Alertas
│   └── SLA Dashboard
├── 📈 Reportes
│   ├── Reportes Ejecutivos
│   ├── Análisis de Capacidad
│   └── Compliance
└── ⚙️ Administración
    ├── Usuarios
    ├── Configuración
    └── Mantenimiento
```

---

## 👥 Gestión de Clientes

### **Agregar Nuevo Cliente**

#### **Información Básica**
1. Navega a `Clientes → Agregar Cliente`
2. Completa el formulario:

```yaml
Información del Cliente:
  Nombre: "Empresa ABC S.A."
  Contacto Principal: "Juan Pérez"
  Email: "backup-admin@empresa-abc.com"
  Teléfono: "+1-555-0123"
  
Plan de Servicio:
  Tipo: "Enterprise Pro"
  Storage Límite: "5 TB"
  Retención: "90 días"
  
Configuración de SLA:
  RPO (Recovery Point Objective): "1 hora"
  RTO (Recovery Time Objective): "4 horas"
  Backup Window: "22:00 - 06:00 UTC"
```

#### **Configuración Técnica**
```yaml
Conexión:
  Método: "Agent + API"
  IP Range: "192.168.1.0/24"
  VPN Required: true
  
Encriptación:
  Algorithm: "AES-256-GCM"
  Key Management: "Customer Managed"
  
Networking:
  Bandwidth Limit: "100 Mbps"
  Compression: "LZ4 High"
  Deduplication: "Global"
```

### **Instalar Agente Cliente**

#### **Método 1: Auto-Installer**
```bash
# Linux/macOS
curl -fsSL https://tu-dominio.com/install/CLIENT_TOKEN | sudo bash

# Windows PowerShell (como Administrador)
irm https://tu-dominio.com/install/CLIENT_TOKEN.ps1 | iex
```

#### **Método 2: Manual**
1. Descarga el agente desde `Clientes → [Cliente] → Descargar Agente`
2. Extrae el archivo en el directorio de instalación
3. Edita `config/agent.yml`:

```yaml
# config/agent.yml
server:
  endpoint: "https://tu-dominio.com/api/v1/agent"
  token: "CLIENT_TOKEN_HERE"
  verify_ssl: true

backup:
  paths:
    - "/home/users"
    - "/etc"
    - "/var/www"
  exclude:
    - "*.tmp"
    - "*.log"
    - "/var/cache/*"

schedule:
  full_backup: "0 2 * * 0"    # Domingo 2:00 AM
  incremental: "0 */6 * * *"  # Cada 6 horas

retention:
  daily: 30
  weekly: 12
  monthly: 12
  yearly: 5
```

4. Inicia el servicio:
```bash
# Linux
sudo systemctl enable backupguard-agent
sudo systemctl start backupguard-agent

# Windows
sc create "BackupGuard Agent" binPath="C:\BackupGuard\agent.exe"
sc start "BackupGuard Agent"
```

### **Configuración de Políticas**

#### **Política de Backup Estándar**
```yaml
# Ejemplo: Política para servidores web
name: "Web Servers Policy"
description: "Política estándar para servidores web empresariales"

backup_config:
  type: "incremental_with_weekly_full"
  schedule:
    incremental: "0 */4 * * *"  # Cada 4 horas
    full: "0 1 * * 0"           # Domingo 1:00 AM
  
  paths:
    include:
      - "/var/www"
      - "/etc/nginx"
      - "/etc/apache2"
      - "/home/*/public_html"
    exclude:
      - "*.log"
      - "*.cache"
      - "/var/www/*/temp/*"

  pre_backup_script: |
    #!/bin/bash
    # Dump de bases de datos MySQL
    mysqldump --all-databases > /tmp/mysql_backup.sql
    
  post_backup_script: |
    #!/bin/bash
    # Limpiar archivos temporales
    rm -f /tmp/mysql_backup.sql

retention:
  hourly: 24    # 24 backups por hora
  daily: 30     # 30 días
  weekly: 12    # 12 semanas
  monthly: 12   # 12 meses
  yearly: 7     # 7 años

notifications:
  on_success: false
  on_warning: true
  on_failure: true
  channels:
    - email
    - slack
    - webhook
```

---

## 💾 Configuración de Backups

### **Tipos de Backup**

#### **🔄 Backup Incremental**
- **Descripción**: Solo respalda archivos modificados desde el último backup
- **Ventajas**: Rápido, eficiente en storage
- **Uso**: Backups frecuentes (cada hora/día)

```yaml
incremental_config:
  frequency: "hourly"
  schedule: "0 * * * *"
  retention: 168  # 7 días
  compression: "lz4"
  encryption: true
```

#### **📦 Backup Completo**
- **Descripción**: Respalda todos los archivos especificados
- **Ventajas**: Restauración simple, autocontenido
- **Uso**: Backup base semanal/mensual

```yaml
full_config:
  frequency: "weekly"
  schedule: "0 2 * * 0"  # Domingo 2:00 AM
  retention: 12  # 12 semanas
  compression: "zstd"
  encryption: true
  verification: true
```

#### **🔀 Backup Diferencial**
- **Descripción**: Respalda cambios desde el último backup completo
- **Ventajas**: Balance entre velocidad y simplicidad
- **Uso**: Backup diario

```yaml
differential_config:
  frequency: "daily"
  schedule: "0 23 * * *"  # 11:00 PM
  retention: 30  # 30 días
  base_backup: "last_full"
```

### **Configuración Avanzada**

#### **🎯 Backup Estratégico por Tiers**
```yaml
# Tier 1: Datos críticos (RTO: 1 hora)
tier1:
  schedule: "0 */2 * * *"  # Cada 2 horas
  storage_class: "hot"
  replication: 3
  encryption: "AES-256-GCM"
  verification: "always"
  
# Tier 2: Datos importantes (RTO: 4 horas)  
tier2:
  schedule: "0 */6 * * *"  # Cada 6 horas
  storage_class: "warm"
  replication: 2
  encryption: "AES-256-CBC"
  verification: "weekly"

# Tier 3: Datos archivados (RTO: 24 horas)
tier3:
  schedule: "0 2 * * *"    # Diario
  storage_class: "cold"
  replication: 1
  encryption: "AES-128-CBC"
  verification: "monthly"
```

#### **📍 Backup Geográfico**
```yaml
geographic_replication:
  primary_site:
    location: "US-East"
    storage_type: "SSD"
    
  secondary_site:
    location: "EU-West"
    storage_type: "HDD"
    sync_delay: "4 hours"
    
  disaster_recovery:
    location: "Asia-Pacific"
    storage_type: "Cloud Archive"
    sync_delay: "24 hours"
```

### **Exclusiones y Filtros**

#### **Patrones de Exclusión Comunes**
```yaml
global_exclusions:
  # Archivos temporales
  - "*.tmp"
  - "*.temp"
  - "*.log"
  - "*.cache"
  
  # Directorios del sistema
  - "/proc/*"
  - "/sys/*"
  - "/dev/*"
  - "/tmp/*"
  
  # Aplicaciones específicas
  - "node_modules/*"
  - ".git/*"
  - "*.pyc"
  - "__pycache__/*"
  
  # Archivos grandes de media
  - "*.iso"
  - "*.vdi"
  - "*.vmdk"
  
size_based_exclusions:
  max_file_size: "10GB"
  skip_zero_bytes: true
  
age_based_exclusions:
  skip_older_than: "2 years"
  skip_accessed_older_than: "1 year"
```

#### **Filtros Dinámicos**
```python
# Ejemplo de filtro personalizado (Python)
def custom_backup_filter(file_path, file_stats):
    """
    Filtro personalizado para determinar si un archivo
    debe ser incluido en el backup
    """
    
    # Skip archivos ocultos del sistema
    if file_path.name.startswith('.') and file_stats.size < 1024:
        return False
    
    # Skip logs más antiguos que 30 días
    if file_path.suffix == '.log':
        age_days = (datetime.now() - datetime.fromtimestamp(file_stats.mtime)).days
        if age_days > 30:
            return False
    
    # Skip archivos de compilación
    if 'build' in file_path.parts or 'dist' in file_path.parts:
        return False
    
    # Include everything else
    return True
```

---

## 📊 Monitoreo y Alertas

### **Dashboard de Monitoreo en Tiempo Real**

#### **Métricas Clave**
```
🎯 SLA DASHBOARD
╭─────────────────────────────────────────╮
│ RPO Compliance:     ████████░░  89.2%   │
│ RTO Compliance:     ███████░░░  78.5%   │
│ Backup Success:     █████████░  92.1%   │
│ Storage Efficiency: ██████████  98.7%   │
╰─────────────────────────────────────────╯

📈 PERFORMANCE METRICS
╭─────────────────────────────────────────╮
│ Throughput:         245 MB/s            │
│ Dedup Ratio:        4.2:1               │
│ Compression:        67%                 │
│ Network Usage:      45% of 1Gbps        │
╰─────────────────────────────────────────╯

🔍 ACTIVE JOBS
╭─────────────────────────────────────────╮
│ Running:            12 jobs              │
│ Queued:             3 jobs               │
│ Average Duration:   47 minutes          │
│ ETA Completion:     2:34 AM              │
╰─────────────────────────────────────────╯
```

### **Configuración de Alertas**

#### **Alertas por Tipo de Evento**
```yaml
alert_rules:
  backup_failure:
    condition: "backup_status == 'failed'"
    threshold: 1
    channels: ["email", "slack", "pagerduty"]
    escalation:
      - wait: "15 minutes"
        action: "notify_manager"
      - wait: "30 minutes"  
        action: "create_incident"
    
  sla_breach:
    condition: "rpo_minutes > rpo_target"
    threshold: 1
    channels: ["email", "slack", "webhook"]
    priority: "high"
    
  storage_capacity:
    condition: "storage_used_percent > 85"
    threshold: 1
    channels: ["email"]
    frequency: "daily"
    
  performance_degradation:
    condition: "avg_throughput < (baseline_throughput * 0.7)"
    threshold: 3  # 3 consecutive measurements
    channels: ["slack"]
    
  security_event:
    condition: "auth_failures > 5 OR unusual_access_pattern"
    threshold: 1
    channels: ["email", "sms", "security_webhook"]
    priority: "critical"
```

#### **Canales de Notificación**

##### **📧 Email**
```yaml
email_config:
  smtp_server: "smtp.tu-empresa.com"
  smtp_port: 587
  username: "backupguard@tu-empresa.com"
  use_tls: true
  
  templates:
    backup_failure: |
      Subject: 🚨 BACKUP FAILED: {{client_name}}
      
      Cliente: {{client_name}}
      Servidor: {{server_name}}
      Error: {{error_message}}
      Timestamp: {{timestamp}}
      
      Dashboard: {{dashboard_url}}
      
    sla_breach: |
      Subject: ⚠️ SLA BREACH: {{sla_type}}
      
      SLA Affected: {{sla_type}}
      Target: {{target_value}}
      Actual: {{actual_value}}
      
      Immediate action required.
```

##### **💬 Slack Integration**
```yaml
slack_config:
  webhook_url: "https://hooks.slack.com/your-webhook"
  channel: "#backup-alerts"
  username: "BackupGuard"
  
  message_format: |
    {{status_emoji}} *{{alert_type}}*
    
    *Cliente:* {{client_name}}
    *Severidad:* {{severity}}
    *Detalle:* {{message}}
    
    <{{dashboard_url}}|Ver Dashboard> | <{{logs_url}}|Ver Logs>
```

##### **📱 PagerDuty**
```yaml
pagerduty_config:
  integration_key: "your-pagerduty-integration-key"
  
  severity_mapping:
    critical: "critical"
    high: "error"
    medium: "warning"
    low: "info"
    
  escalation_policy: "Backup Team Escalation"
```

### **Monitoreo Proactivo**

#### **Predictive Analytics**
```python
# Ejemplo de análisis predictivo
class BackupPredictiveAnalysis:
    def analyze_storage_trends(self, client_id, days=30):
        """
        Analiza tendencias de crecimiento de datos
        y predice necesidades futuras de storage
        """
        
        # Obtener datos históricos
        data = self.get_storage_usage_history(client_id, days)
        
        # Calcular tendencia de crecimiento
        growth_rate = self.calculate_growth_rate(data)
        
        # Predicción para próximos 90 días
        prediction = {
            'current_usage': data[-1]['usage_gb'],
            'predicted_usage_90d': data[-1]['usage_gb'] * (1 + growth_rate) ** 90,
            'capacity_exhaustion_date': self.predict_capacity_exhaustion(data, growth_rate),
            'recommended_action': self.get_capacity_recommendation(growth_rate)
        }
        
        return prediction
    
    def detect_backup_anomalies(self, client_id):
        """
        Detecta patrones anómalos en backups
        """
        
        baseline = self.get_baseline_metrics(client_id)
        current = self.get_current_metrics(client_id)
        
        anomalies = []
        
        if current['duration'] > baseline['duration'] * 1.5:
            anomalies.append({
                'type': 'duration_anomaly',
                'severity': 'medium',
                'message': f"Backup duration 50% above baseline"
            })
        
        if current['file_count'] < baseline['file_count'] * 0.8:
            anomalies.append({
                'type': 'file_count_anomaly',
                'severity': 'high',
                'message': f"Significant drop in backed up files"
            })
        
        return anomalies
```

---

## 📈 Reportes y Análisis

### **Reportes Ejecutivos**

#### **📊 Reporte Mensual Ejecutivo**
```yaml
executive_monthly_report:
  period: "2024-01"
  
  summary:
    total_clients: 156
    total_data_protected: "847 TB"
    backup_success_rate: "99.2%"
    sla_compliance: "97.8%"
    cost_per_gb: "$0.12"
    
  key_metrics:
    - metric: "RPO Compliance"
      value: "98.5%"
      trend: "+2.1%"
      status: "✅ Target met"
      
    - metric: "RTO Compliance"  
      value: "96.2%"
      trend: "+1.8%"
      status: "✅ Target met"
      
    - metric: "Storage Efficiency"
      value: "4.2:1 dedup ratio"
      trend: "+0.3:1"
      status: "✅ Excellent"
      
  incidents:
    total: 7
    critical: 1
    high: 2
    medium: 4
    resolved_within_sla: "85.7%"
    
  recommendations:
    - "Increase storage capacity for Cliente XYZ (85% utilization)"
    - "Review backup window for Cliente ABC (3 consecutive timeouts)"
    - "Implement tiered storage for long-term retention cost optimization"
```

#### **📋 Reporte de Compliance**
```yaml
compliance_report:
  regulations:
    gdpr:
      status: "✅ Compliant"
      last_audit: "2024-01-15"
      requirements_met:
        - "Data encryption at rest and in transit"
        - "Right to be forgotten implementation"
        - "Data retention policy compliance"
        - "Regular security audits"
        
    sox:
      status: "✅ Compliant"
      last_audit: "2023-12-20"
      requirements_met:
        - "Financial data backup integrity"
        - "Change management controls"
        - "Access controls and logging"
        
    hipaa:
      status: "⚠️ Partial"
      issues:
        - "2 clients require BAA signing"
        - "Encryption key rotation overdue for 1 client"
      action_plan:
        - due: "2024-02-15"
          action: "Complete BAA execution"
        - due: "2024-02-10"
          action: "Execute key rotation"
```

### **Análisis de Rendimiento**

#### **🚀 Performance Dashboard**
```sql
-- Ejemplo de queries para métricas de performance
-- Top 10 clientes por velocidad de backup
SELECT 
    c.name as client_name,
    AVG(bj.data_size_gb / (bj.duration_seconds / 3600)) as avg_throughput_gbh,
    COUNT(*) as backup_count
FROM backup_jobs bj
JOIN clients c ON bj.client_id = c.id
WHERE bj.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    AND bj.status = 'completed'
GROUP BY c.id, c.name
ORDER BY avg_throughput_gbh DESC
LIMIT 10;

-- Análisis de eficiencia de deduplicación
SELECT 
    c.name,
    SUM(bj.original_size_gb) as original_size,
    SUM(bj.stored_size_gb) as stored_size,
    (SUM(bj.original_size_gb) / SUM(bj.stored_size_gb)) as dedup_ratio
FROM backup_jobs bj
JOIN clients c ON bj.client_id = c.id
WHERE bj.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY c.id, c.name
HAVING dedup_ratio > 1
ORDER BY dedup_ratio DESC;
```

#### **📊 Capacity Planning Report**
```python
# Análisis de capacidad y predicciones
def generate_capacity_report():
    report = {
        'current_status': {
            'total_capacity': '500 TB',
            'used_capacity': '342 TB',
            'utilization': '68.4%',
            'available': '158 TB'
        },
        
        'growth_trends': {
            'daily_growth': '1.2 TB',
            'weekly_growth': '8.4 TB', 
            'monthly_growth': '35.8 TB',
            'yoy_growth_rate': '47%'
        },
        
        'predictions': {
            'capacity_full_date': '2024-08-15',
            'recommended_expansion': '200 TB',
            'expansion_timeline': '2024-06-01'
        },
        
        'cost_analysis': {
            'current_monthly_cost': '$12,450',
            'cost_per_gb': '$0.036',
            'expansion_cost': '$28,000',
            'roi_months': 14
        }
    }
    
    return report
```

### **Reportes Personalizados**

#### **🎨 Report Builder**
Los usuarios pueden crear reportes personalizados usando nuestra interfaz de drag-and-drop:

```yaml
custom_report_example:
  name: "Weekly Operations Summary"
  description: "Reporte semanal para el equipo de operaciones"
  
  sections:
    - type: "metrics_grid"
      title: "KPIs Semanales"
      metrics:
        - "backup_success_rate"
        - "average_backup_duration"
        - "storage_utilization"
        - "alert_count"
        
    - type: "chart"
      title: "Tendencia de Throughput"
      chart_type: "line"
      data_source: "backup_performance"
      time_range: "7 days"
      
    - type: "table"
      title: "Top Failures"
      data_source: "failed_backups"
      columns:
        - "client_name"
        - "error_message"
        - "failure_time"
        - "retry_count"
      limit: 10
      
  schedule:
    frequency: "weekly"
    day: "monday"
    time: "08:00"
    timezone: "UTC"
    
  distribution:
    email:
      - "ops-team@empresa.com"
      - "backup-admin@empresa.com"
    slack:
      channel: "#ops-weekly"
```

---

## ⚙️ Administración del Sistema

### **Gestión de Usuarios**

#### **👤 Roles y Permisos**
```yaml
user_roles:
  super_admin:
    description: "Acceso completo al sistema"
    permissions:
      - "system.*"
      - "client.*"
      - "backup.*"
      - "reporting.*"
      - "administration.*"
      
  backup_admin:
    description: "Administrador de backups"
    permissions:
      - "client.view"
      - "client.edit"
      - "backup.*"
      - "monitoring.view"
      - "reporting.view"
      
  client_manager:
    description: "Gestor de clientes específicos"
    permissions:
      - "client.view"
      - "client.edit"  # Solo clientes asignados
      - "backup.view"
      - "backup.restore"  # Solo clientes asignados
      
  read_only:
    description: "Solo lectura"
    permissions:
      - "*.view"
      
  client_user:
    description: "Usuario final de cliente"
    permissions:
      - "backup.view"    # Solo su organización
      - "backup.restore" # Solo su organización
      - "reporting.view" # Solo su organización
```

#### **👥 Gestión de Equipos**
```yaml
team_structure:
  operations_team:
    name: "Operations Team"
    description: "Equipo de operaciones 24/7"
    members:
      - user: "ops.manager@empresa.com"
        role: "backup_admin"
      - user: "ops.tech1@empresa.com"
        role: "backup_admin"
      - user: "ops.tech2@empresa.com"
        role: "backup_admin"
    
    responsibilities:
      - "Monitor backup jobs"
      - "Respond to alerts"
      - "Perform restores"
      - "Level 1 troubleshooting"
      
  client_success:
    name: "Client Success Team"
    description: "Gestión de relaciones con clientes"
    members:
      - user: "cs.manager@empresa.com"
        role: "client_manager"
      - user: "cs.rep1@empresa.com"
        role: "client_manager"
        
    responsibilities:
      - "Client onboarding"
      - "Account management"
      - "SLA reviews"
      - "Reporting to clients"
```

### **Configuración del Sistema**

#### **🔧 Configuración Global**
```yaml
system_config:
  performance:
    max_concurrent_jobs: 50
    job_timeout_hours: 12
    retry_attempts: 3
    retry_delay_minutes: 15
    
  storage:
    default_retention_days: 90
    max_file_size_gb: 50
    compression_algorithm: "zstd"
    encryption_algorithm: "AES-256-GCM"
    
  networking:
    api_rate_limit: 1000  # requests per minute
    upload_chunk_size_mb: 100
    download_bandwidth_limit_mbps: 1000
    connection_timeout_seconds: 30
    
  monitoring:
    metrics_retention_days: 365
    log_level: "INFO"
    enable_performance_profiling: true
    
  notifications:
    max_email_per_hour: 100
    max_slack_per_hour: 200
    enable_digest_notifications: true
```

#### **🛡️ Configuración de Seguridad**
```yaml
security_config:
  authentication:
    session_timeout_minutes: 480  # 8 horas
    require_2fa: true
    password_policy:
      min_length: 12
      require_uppercase: true
      require_lowercase: true
      require_numbers: true
      require_symbols: true
      history_count: 12
      
  api_security:
    require_api_key: true
    api_key_rotation_days: 90
    rate_limiting: true
    ip_whitelist_enabled: true
    
  data_protection:
    encryption_at_rest: true
    encryption_in_transit: true
    key_rotation_days: 365
    secure_delete: true
    
  audit_logging:
    enabled: true
    retention_days: 2555  # 7 años
    log_user_actions: true
    log_api_calls: true
    log_data_access: true
```

### **Mantenimiento del Sistema**

#### **🔄 Tareas de Mantenimiento Automáticas**
```yaml
maintenance_schedule:
  daily:
    - time: "02:00"
      task: "cleanup_temp_files"
      description: "Limpiar archivos temporales"
      
    - time: "03:00"
      task: "vacuum_database"
      description: "Optimizar base de datos"
      
    - time: "04:00"
      task: "update_statistics"
      description: "Actualizar estadísticas del sistema"
      
  weekly:
    - day: "sunday"
      time: "01:00"
      task: "deep_storage_cleanup"
      description: "Limpieza profunda de storage"
      
    - day: "sunday"
      time: "05:00"
      task: "generate_weekly_reports"
      description: "Generar reportes semanales"
      
  monthly:
    - day: 1
      time: "00:00"
      task: "archive_old_logs"
      description: "Archivar logs antiguos"
      
    - day: 15
      time: "02:00"
      task: "security_scan"
      description: "Escaneo de seguridad"
```

#### **🔍 Herramientas de Diagnóstico**
```bash
# Sistema de diagnóstico integrado
backupguard-cli diagnostics

# Reportes específicos
backupguard-cli diagnostics --storage
backupguard-cli diagnostics --performance
backupguard-cli diagnostics --network
backupguard-cli diagnostics --database

# Ejemplo de salida
┌─────────────────────────────────────────┐
│ 🔍 SYSTEM DIAGNOSTICS REPORT           │
├─────────────────────────────────────────┤
│ ✅ Database: Healthy                    │
│ ✅ Storage: 68% utilization             │
│ ⚠️  Network: High latency detected      │
│ ✅ Services: All running                │
│ ⚠️  Alerts: 3 pending                   │
├─────────────────────────────────────────┤
│ 📊 Performance Metrics (24h):          │
│ • Average job duration: 47 min         │
│ • Throughput: 245 MB/s                 │
│ • Success rate: 97.2%                  │
│ • CPU usage: 45%                       │
│ • Memory usage: 62%                    │
└─────────────────────────────────────────┘
```

---

## 🔌 API y Automatización

### **REST API**

#### **🔑 Autenticación API**
```bash
# Obtener token de API
curl -X POST https://tu-dominio.com/api/v1/auth/token \
  -H "Content-Type: application/json" \
  -d '{
    "email": "api-user@empresa.com",
    "password": "secure-password",
    "scope": "api"
  }'

# Respuesta
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "api"
}
```

#### **📋 Endpoints Principales**
```yaml
api_endpoints:
  clients:
    - GET /api/v1/clients
    - POST /api/v1/clients
    - GET /api/v1/clients/{id}
    - PUT /api/v1/clients/{id}
    - DELETE /api/v1/clients/{id}
    
  backups:
    - GET /api/v1/backups
    - POST /api/v1/backups/trigger/{client_id}
    - GET /api/v1/backups/{job_id}
    - GET /api/v1/backups/{job_id}/logs
    
  restores:
    - POST /api/v1/restores
    - GET /api/v1/restores/{restore_id}
    - GET /api/v1/restores/{restore_id}/status
    
  monitoring:
    - GET /api/v1/metrics/system
    - GET /api/v1/metrics/clients
    - GET /api/v1/alerts
    - POST /api/v1/alerts/{id}/acknowledge
    
  reports:
    - GET /api/v1/reports/executive
    - POST /api/v1/reports/custom
    - GET /api/v1/reports/{report_id}/download
```

#### **💻 Ejemplos de Uso**
```python
# SDK de Python para BackupGuard API
from backupguard import BackupGuardClient

# Inicializar cliente
client = BackupGuardClient(
    base_url="https://tu-dominio.com",
    api_token="your-api-token"
)

# Listar clientes
clients = client.clients.list()
for client_info in clients:
    print(f"Cliente: {client_info['name']}, Estado: {client_info['status']}")

# Triggear backup manual
backup_job = client.backups.trigger(
    client_id="client-123",
    backup_type="incremental",
    priority="high"
)
print(f"Backup iniciado: {backup_job['job_id']}")

# Monitorear progreso
while True:
    status = client.backups.get_status(backup_job['job_id'])
    print(f"Progreso: {status['progress']}%")
    
    if status['status'] in ['completed', 'failed']:
        break
    
    time.sleep(30)

# Crear reporte personalizado
report = client.reports.create_custom({
    "name": "Weekly Client Summary",
    "type": "client_summary",
    "period": "last_7_days",
    "format": "pdf",
    "clients": ["client-123", "client-456"]
})

# Descargar reporte
client.reports.download(report['report_id'], "/tmp/report.pdf")
```

### **Webhooks y Automatización**

#### **🔔 Configuración de Webhooks**
```yaml
webhook_config:
  backup_completed:
    url: "https://tu-sistema.com/webhooks/backup-completed"
    headers:
      Authorization: "Bearer your-webhook-token"
      Content-Type: "application/json"
    payload_template: |
      {
        "event": "backup.completed",
        "client_id": "{{client_id}}",
        "client_name": "{{client_name}}",
        "job_id": "{{job_id}}",
        "status": "{{status}}",
        "data_size_gb": {{data_size_gb}},
        "duration_seconds": {{duration_seconds}},
        "timestamp": "{{timestamp}}"
      }
      
  backup_failed:
    url: "https://tu-sistema.com/webhooks/backup-failed"
    payload_template: |
      {
        "event": "backup.failed",
        "client_id": "{{client_id}}",
        "client_name": "{{client_name}}",
        "job_id": "{{job_id}}",
        "error_message": "{{error_message}}",
        "retry_count": {{retry_count}},
        "timestamp": "{{timestamp}}"
      }
```

#### **🤖 Scripts de Automatización**
```bash
#!/bin/bash
# Ejemplo: Script para backup automático con validación

CLIENT_ID="client-123"
API_TOKEN="your-api-token"
BASE_URL="https://tu-dominio.com"

# Función para llamar API
call_api() {
    curl -s -H "Authorization: Bearer $API_TOKEN" \
         -H "Content-Type: application/json" \
         "$BASE_URL$1" \
         "${@:2}"
}

# Verificar estado del cliente
echo "Verificando estado del cliente..."
client_status=$(call_api "/api/v1/clients/$CLIENT_ID" | jq -r '.status')

if [ "$client_status" != "active" ]; then
    echo "ERROR: Cliente no está activo"
    exit 1
fi

# Triggear backup
echo "Iniciando backup..."
backup_response=$(call_api "/api/v1/backups/trigger/$CLIENT_ID" -X POST)
job_id=$(echo $backup_response | jq -r '.job_id')

echo "Backup iniciado con Job ID: $job_id"

# Monitorear progreso
while true; do
    status_response=$(call_api "/api/v1/backups/$job_id")
    status=$(echo $status_response | jq -r '.status')
    progress=$(echo $status_response | jq -r '.progress')
    
    echo "Estado: $status, Progreso: $progress%"
    
    if [ "$status" = "completed" ]; then
        echo "✅ Backup completado exitosamente"
        break
    elif [ "$status" = "failed" ]; then
        error=$(echo $status_response | jq -r '.error_message')
        echo "❌ Backup falló: $error"
        exit 1
    fi
    
    sleep 30
done
```

---

## 📱 Mobile App

### **📲 Instalación de la App**

#### **Android**
1. Busca "BackupGuard Pro" en Google Play Store
2. O escanea el QR code desde el dashboard web
3. Instala y abre la aplicación

#### **iOS**
1. Busca "BackupGuard Pro" en App Store
2. O escanea el QR code desde el dashboard web
3. Instala y abre la aplicación

### **🔐 Configuración Inicial**
```yaml
mobile_setup:
  login_methods:
    - "Email/Password"
    - "SSO (SAML/OIDC)"
    - "QR Code (desde web dashboard)"
    - "Biometric (Face ID/Touch ID)"
    
  initial_sync:
    - "Descargar configuración de servidor"
    - "Sincronizar lista de clientes"
    - "Configurar notificaciones push"
    - "Verificar permisos de acceso"
```

### **📊 Características de la Mobile App**

#### **🏠 Dashboard Móvil**
```
╭─────────────────────────╮
│ 📱 BackupGuard Pro     │
├─────────────────────────┤
│ 🟢 Sistema: Operativo  │
│ 📊 Backups Hoy: 142/156│
│ ⚡ Éxito: 97.2%        │
│ 🔔 Alertas: 3          │
├─────────────────────────┤
│ [📋 Clientes]           │
│ [💾 Trabajos]           │
│ [📈 Métricas]           │
│ [🔔 Alertas]            │
│ [⚙️ Config]             │
╰─────────────────────────╯
```

#### **🚨 Notificaciones Push**
```yaml
push_notifications:
  backup_failures:
    title: "❌ Backup Failed"
    body: "{{client_name}} backup failed. Tap for details."
    priority: "high"
    sound: "alert"
    
  sla_breaches:
    title: "⚠️ SLA Breach"
    body: "{{sla_type}} exceeded for {{client_name}}"
    priority: "high"
    sound: "alert"
    
  capacity_warnings:
    title: "📊 Storage Warning"
    body: "Storage 85% full. Expansion needed soon."
    priority: "normal"
    
  daily_summary:
    title: "📈 Daily Summary"
    body: "{{success_count}} successful, {{failed_count}} failed"
    priority: "normal"
    time: "08:00"
```

#### **💾 Gestión de Backups Móvil**
- **Vista de Lista**: Todos los trabajos de backup con estado en tiempo real
- **Detalles de Job**: Progreso, logs, tiempo estimado
- **Acciones Rápidas**: 
  - Triggear backup manual
  - Pausar/Reanudar trabajos
  - Ver logs detallados
  - Iniciar restauración de emergencia

#### **📱 Restauración de Emergencia**
```yaml
emergency_restore:
  quick_actions:
    - "Restore Last Known Good"
    - "Restore Specific Point in Time"
    - "Restore Specific Files/Folders"
    
  workflow:
    1. "Seleccionar cliente"
    2. "Elegir punto de restauración"
    3. "Confirmar con Touch ID/Face ID"
    4. "Monitorear progreso"
    5. "Recibir notificación de completado"
```

---

## 🆘 Soporte y Ayuda

### **📞 Canales de Soporte**
- **🔗 Portal Web**: [support.backupguard.pro](https://support.backupguard.pro)
- **📧 Email**: support@backupguard.pro
- **💬 Chat en Vivo**: Disponible en dashboard web
- **📱 Soporte Móvil**: Desde la app móvil
- **🆘 Emergencias**: +1-800-BACKUP-1 (24/7)

### **📚 Recursos de Autoayuda**
- **📖 Knowledge Base**: Artículos y guías paso a paso
- **🎥 Video Tutorials**: Tutoriales en video
- **📋 FAQ**: Preguntas frecuentes
- **🔧 Troubleshooting**: Guías de resolución de problemas
- **💻 API Docs**: Documentación completa de API

### **🎯 Niveles de Soporte**

#### **📊 Planes de Soporte**
```yaml
support_tiers:
  basic:
    response_time: "4 business hours"
    channels: ["email", "portal"]
    coverage: "Business hours (9-5 PST)"
    
  professional:
    response_time: "2 business hours"
    channels: ["email", "portal", "chat"]
    coverage: "Extended hours (6-10 PST)"
    phone_support: true
    
  enterprise:
    response_time: "1 hour"
    channels: ["email", "portal", "chat", "phone"]
    coverage: "24/7"
    dedicated_account_manager: true
    emergency_hotline: true
    
  premium:
    response_time: "15 minutes"
    channels: ["all channels"]
    coverage: "24/7"
    dedicated_technical_team: true
    on_site_support: true
```

---

> **💡 Nota**: Este manual cubre las funcionalidades principales de BackupGuard Pro. Para características avanzadas y casos de uso específicos, consulta la documentación técnica completa o contacta a nuestro equipo de soporte.
