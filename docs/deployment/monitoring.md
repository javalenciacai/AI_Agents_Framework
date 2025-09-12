# 📊 Monitoring Documentation - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Arquitectura de Monitoreo](#arquitectura-de-monitoreo)
- [Métricas y KPIs](#métricas-y-kpis)
- [Prometheus Configuration](#prometheus-configuration)
- [Grafana Dashboards](#grafana-dashboards)
- [Alerting Strategy](#alerting-strategy)
- [Logging Architecture](#logging-architecture)
- [Observabilidad](#observabilidad)
- [SRE y SLA Monitoring](#sre-y-sla-monitoring)

---

## 🏗️ Arquitectura de Monitoreo

### **Stack de Observabilidad**
```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                   │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │   Grafana   │ │  Kibana     │ │    Custom           │ │
│ │ Dashboards  │ │  Analytics  │ │    Dashboards       │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
├─────────────────────────────────────────────────────────┤
│                    ALERTING LAYER                       │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │ AlertManager│ │ PagerDuty   │ │ Slack/Teams/Email   │ │
│ │ Routing     │ │ Escalation  │ │ Notifications       │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
├─────────────────────────────────────────────────────────┤
│                    PROCESSING LAYER                     │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │ Prometheus  │ │    ELK      │ │      Jaeger         │ │
│ │  Metrics    │ │   Stack     │ │     Tracing         │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
├─────────────────────────────────────────────────────────┤
│                    COLLECTION LAYER                     │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │Node Exporter│ │  Filebeat   │ │  OpenTelemetry      │ │
│ │cAdvisor     │ │  Logstash   │ │  Agents             │ │
│ │Custom       │ │  Fluentd    │ │  Instrumenttion     │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
├─────────────────────────────────────────────────────────┤
│                    APPLICATION LAYER                    │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐ │
│ │ API Gateway │ │ Backup Svc  │ │  User Service       │ │
│ │ Metrics     │ │ Metrics     │ │  Metrics            │ │
│ └─────────────┘ └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### **Componentes del Stack**
```yaml
monitoring_stack:
  metrics:
    prometheus:
      version: "2.40.0"
      retention: "90d"
      scrape_interval: "15s"
      
    node_exporter:
      version: "1.5.0"
      collectors: ["cpu", "memory", "disk", "network", "filesystem"]
      
    cadvisor:
      version: "0.46.0"
      purpose: "Container metrics"
      
  logging:
    elasticsearch:
      version: "8.5.0"
      nodes: 3
      retention: "30d"
      
    logstash:
      version: "8.5.0"
      pipeline_workers: 4
      
    kibana:
      version: "8.5.0"
      features: ["discover", "visualize", "dashboard"]
      
  tracing:
    jaeger:
      version: "1.40.0"
      strategy: "all-in-one"
      sampling_rate: "0.1"
      
  visualization:
    grafana:
      version: "9.3.0"
      plugins: ["prometheus", "elasticsearch", "jaeger"]
      
  alerting:
    alertmanager:
      version: "0.25.0"
      clustering: true
      high_availability: true
```

---

## 📈 Métricas y KPIs

### **Business Metrics**

#### **🎯 SLA Metrics**
```yaml
sla_metrics:
  backup_success_rate:
    target: "99.5%"
    measurement: "successful_backups / total_backup_attempts"
    window: "rolling_30d"
    alert_threshold: "< 99%"
    
  backup_rpo_compliance:
    target: "99.9%"
    measurement: "(current_time - last_successful_backup) <= rpo_target"
    window: "point_in_time"
    alert_threshold: "< 99%"
    
  backup_rto_compliance:
    target: "99%"
    measurement: "restore_completion_time <= rto_target"
    window: "per_restore_operation"
    alert_threshold: "< 95%"
    
  data_integrity:
    target: "100%"
    measurement: "verified_checksums / total_checksums"
    window: "daily"
    alert_threshold: "< 99.9%"
    
  system_availability:
    target: "99.9%"
    measurement: "uptime / total_time"
    window: "rolling_30d"
    alert_threshold: "< 99.5%"
```

#### **💼 Business KPIs**
```yaml
business_kpis:
  data_protected:
    metric: "backup_data_protected_bytes"
    aggregation: "sum"
    labels: ["client_id", "data_type"]
    
  backup_frequency:
    metric: "backup_jobs_completed_total"
    aggregation: "rate"
    labels: ["client_id", "backup_type"]
    
  storage_efficiency:
    metric: "(raw_data_size - stored_data_size) / raw_data_size"
    components: ["deduplication_ratio", "compression_ratio"]
    
  client_growth:
    metric: "active_clients_total"
    aggregation: "count"
    labels: ["plan_type", "region"]
    
  revenue_metrics:
    metric: "monthly_recurring_revenue"
    aggregation: "sum"
    labels: ["plan_type", "client_tier"]
```

### **Technical Metrics**

#### **🖥️ Infrastructure Metrics**
```yaml
infrastructure_metrics:
  compute:
    cpu_utilization:
      metric: "node_cpu_seconds_total"
      aggregation: "rate"
      threshold_warning: 80
      threshold_critical: 90
      
    memory_utilization:
      metric: "node_memory_MemAvailable_bytes"
      calculation: "(total - available) / total * 100"
      threshold_warning: 85
      threshold_critical: 95
      
    disk_utilization:
      metric: "node_filesystem_avail_bytes"
      calculation: "(total - available) / total * 100"
      threshold_warning: 80
      threshold_critical: 90
      
  network:
    bandwidth_utilization:
      metric: "node_network_transmit_bytes_total"
      aggregation: "rate"
      threshold_warning: "70% of capacity"
      threshold_critical: "90% of capacity"
      
    packet_loss:
      metric: "node_network_transmit_drop_total"
      aggregation: "rate"
      threshold_warning: "> 0.01%"
      threshold_critical: "> 0.1%"
      
  storage:
    iops_utilization:
      metric: "node_disk_io_time_seconds_total"
      aggregation: "rate"
      threshold_warning: "80% of capacity"
      threshold_critical: "95% of capacity"
      
    throughput:
      metric: "node_disk_read_bytes_total + node_disk_written_bytes_total"
      aggregation: "rate"
      unit: "bytes/second"
```

#### **🐳 Container Metrics**
```yaml
container_metrics:
  resource_usage:
    cpu:
      metric: "container_cpu_usage_seconds_total"
      aggregation: "rate"
      labels: ["pod", "container", "namespace"]
      
    memory:
      metric: "container_memory_working_set_bytes"
      labels: ["pod", "container", "namespace"]
      
    network:
      metric: "container_network_transmit_bytes_total"
      aggregation: "rate"
      labels: ["pod", "interface"]
      
  container_health:
    restart_count:
      metric: "kube_pod_container_status_restarts_total"
      threshold_warning: "> 5 in 1h"
      threshold_critical: "> 10 in 1h"
      
    ready_replicas:
      metric: "kube_deployment_status_replicas_available"
      threshold_warning: "< desired * 0.8"
      threshold_critical: "< desired * 0.5"
```

### **Application Metrics**

#### **🔧 Service-Level Metrics**
```yaml
application_metrics:
  api_gateway:
    request_rate:
      metric: "http_requests_total"
      aggregation: "rate"
      labels: ["method", "endpoint", "status"]
      
    response_time:
      metric: "http_request_duration_seconds"
      aggregation: "histogram"
      percentiles: [50, 95, 99]
      
    error_rate:
      metric: "http_requests_total{status=~'5..'}"
      calculation: "rate / total_rate"
      threshold_warning: "> 1%"
      threshold_critical: "> 5%"
      
  backup_service:
    job_queue_length:
      metric: "backup_job_queue_length"
      threshold_warning: "> 100"
      threshold_critical: "> 500"
      
    job_duration:
      metric: "backup_job_duration_seconds"
      aggregation: "histogram"
      percentiles: [50, 95, 99]
      
    throughput:
      metric: "backup_throughput_bytes_per_second"
      aggregation: "gauge"
      
    success_rate:
      metric: "backup_jobs_completed_total{status='success'}"
      calculation: "rate / total_job_rate"
      threshold_warning: "< 95%"
      threshold_critical: "< 90%"
      
  database:
    connection_pool:
      metric: "mongodb_connections_current"
      threshold_warning: "> 80% of max"
      threshold_critical: "> 95% of max"
      
    query_performance:
      metric: "mongodb_op_latencies_reads_ops_total"
      aggregation: "histogram"
      threshold_warning: "p95 > 100ms"
      threshold_critical: "p95 > 500ms"
      
    replication_lag:
      metric: "mongodb_replica_set_member_replication_lag"
      threshold_warning: "> 10s"
      threshold_critical: "> 60s"
```

---

## 🔧 Prometheus Configuration

### **Prometheus Setup**

#### **📊 Prometheus Configuration**
```yaml
# config/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'backupguard-prod'
    region: 'us-east-1'

rule_files:
  - "/etc/prometheus/rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager-1:9093
          - alertmanager-2:9093
          - alertmanager-3:9093

scrape_configs:
  # Infrastructure monitoring
  - job_name: 'node-exporter'
    static_configs:
      - targets:
        - 'node-1:9100'
        - 'node-2:9100'
        - 'node-3:9100'
    scrape_interval: 10s
    metrics_path: /metrics
    
  - job_name: 'cadvisor'
    static_configs:
      - targets:
        - 'cadvisor-1:8080'
        - 'cadvisor-2:8080'
    scrape_interval: 15s
    
  # Kubernetes monitoring
  - job_name: 'kubernetes-apiservers'
    kubernetes_sd_configs:
      - role: endpoints
        namespaces:
          names:
            - default
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      insecure_skip_verify: true
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
        action: keep
        regex: default;kubernetes;https
        
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      insecure_skip_verify: true
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    
  # Application monitoring
  - job_name: 'api-gateway'
    static_configs:
      - targets:
        - 'api-gateway-1:8080'
        - 'api-gateway-2:8080'
        - 'api-gateway-3:8080'
    metrics_path: '/metrics'
    scrape_interval: 10s
    
  - job_name: 'backup-service'
    static_configs:
      - targets:
        - 'backup-service-1:3001'
        - 'backup-service-2:3001'
        - 'backup-service-3:3001'
    metrics_path: '/metrics'
    scrape_interval: 15s
    
  - job_name: 'user-service'
    static_configs:
      - targets:
        - 'user-service-1:3002'
        - 'user-service-2:3002'
    metrics_path: '/metrics'
    
  # Database monitoring
  - job_name: 'mongodb-exporter'
    static_configs:
      - targets:
        - 'mongodb-exporter:9216'
    scrape_interval: 30s
    
  - job_name: 'redis-exporter'
    static_configs:
      - targets:
        - 'redis-exporter:9121'
    scrape_interval: 30s
    
  - job_name: 'postgres-exporter'
    static_configs:
      - targets:
        - 'postgres-exporter:9187'
    scrape_interval: 30s

# Remote write for long-term storage
remote_write:
  - url: "https://cortex.backupguard.internal/api/v1/push"
    queue_config:
      max_samples_per_send: 1000
      max_shards: 200
      capacity: 2500
```

### **Custom Metrics Implementation**

#### **🎯 Application Metrics**
```javascript
// src/metrics/prometheus-metrics.js
const promClient = require('prom-client');

class BackupGuardMetrics {
    constructor() {
        this.register = new promClient.Registry();
        this.initializeMetrics();
    }

    initializeMetrics() {
        // Business metrics
        this.backupJobsTotal = new promClient.Counter({
            name: 'backup_jobs_total',
            help: 'Total number of backup jobs',
            labelNames: ['client_id', 'job_type', 'status'],
            registers: [this.register]
        });

        this.backupDuration = new promClient.Histogram({
            name: 'backup_job_duration_seconds',
            help: 'Duration of backup jobs in seconds',
            labelNames: ['client_id', 'job_type'],
            buckets: [60, 300, 900, 1800, 3600, 7200, 14400],
            registers: [this.register]
        });

        this.backupThroughput = new promClient.Gauge({
            name: 'backup_throughput_bytes_per_second',
            help: 'Current backup throughput in bytes per second',
            labelNames: ['client_id', 'worker_id'],
            registers: [this.register]
        });

        this.dataProtected = new promClient.Gauge({
            name: 'backup_data_protected_bytes',
            help: 'Total amount of data protected in bytes',
            labelNames: ['client_id', 'data_type'],
            registers: [this.register]
        });

        this.queueLength = new promClient.Gauge({
            name: 'backup_job_queue_length',
            help: 'Number of jobs in backup queue',
            labelNames: ['priority'],
            registers: [this.register]
        });

        // Technical metrics
        this.httpRequests = new promClient.Counter({
            name: 'http_requests_total',
            help: 'Total HTTP requests',
            labelNames: ['method', 'endpoint', 'status_code'],
            registers: [this.register]
        });

        this.httpDuration = new promClient.Histogram({
            name: 'http_request_duration_seconds',
            help: 'HTTP request duration in seconds',
            labelNames: ['method', 'endpoint'],
            buckets: [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5],
            registers: [this.register]
        });

        this.databaseConnections = new promClient.Gauge({
            name: 'database_connections_active',
            help: 'Active database connections',
            labelNames: ['database', 'pool'],
            registers: [this.register]
        });

        // Resource metrics
        this.memoryUsage = new promClient.Gauge({
            name: 'nodejs_memory_usage_bytes',
            help: 'Node.js memory usage in bytes',
            labelNames: ['type'],
            registers: [this.register]
        });

        this.cpuUsage = new promClient.Gauge({
            name: 'nodejs_cpu_usage_percent',
            help: 'Node.js CPU usage percentage',
            registers: [this.register]
        });

        // Start collecting default metrics
        promClient.collectDefaultMetrics({
            register: this.register,
            prefix: 'nodejs_'
        });
    }

    // Metric recording methods
    recordBackupJob(clientId, jobType, status, duration, throughput) {
        this.backupJobsTotal.inc({
            client_id: clientId,
            job_type: jobType,
            status: status
        });

        if (duration) {
            this.backupDuration.observe({
                client_id: clientId,
                job_type: jobType
            }, duration);
        }

        if (throughput) {
            this.backupThroughput.set({
                client_id: clientId,
                worker_id: process.env.WORKER_ID || 'unknown'
            }, throughput);
        }
    }

    recordHttpRequest(method, endpoint, statusCode, duration) {
        this.httpRequests.inc({
            method: method,
            endpoint: endpoint,
            status_code: statusCode
        });

        this.httpDuration.observe({
            method: method,
            endpoint: endpoint
        }, duration);
    }

    updateQueueLength(priority, length) {
        this.queueLength.set({ priority: priority }, length);
    }

    updateDataProtected(clientId, dataType, bytes) {
        this.dataProtected.set({
            client_id: clientId,
            data_type: dataType
        }, bytes);
    }

    // Express middleware
    getMetricsMiddleware() {
        return (req, res, next) => {
            const start = Date.now();
            
            res.on('finish', () => {
                const duration = (Date.now() - start) / 1000;
                this.recordHttpRequest(
                    req.method,
                    req.route?.path || req.path,
                    res.statusCode,
                    duration
                );
            });
            
            next();
        };
    }

    // Metrics endpoint
    async getMetrics() {
        return await this.register.metrics();
    }
}

module.exports = { BackupGuardMetrics };
```

### **Alert Rules Configuration**

#### **🚨 Prometheus Alert Rules**
```yaml
# config/prometheus/rules/backup-alerts.yml
groups:
  - name: backup.rules
    interval: 30s
    rules:
      # SLA Alerts
      - alert: BackupSLABreach
        expr: |
          (
            sum(rate(backup_jobs_total{status="failed"}[5m])) / 
            sum(rate(backup_jobs_total[5m]))
          ) > 0.05
        for: 5m
        labels:
          severity: critical
          team: operations
          service: backup
        annotations:
          summary: "Backup SLA breach detected"
          description: "Backup failure rate is {{ $value | humanizePercentage }} over 5 minutes"
          playbook: "https://wiki.backupguard.com/runbooks/backup-sla-breach"

      - alert: BackupRPOViolation
        expr: |
          (time() - backup_last_successful_timestamp) / 3600 > 
          on(client_id) backup_rpo_hours
        for: 0m
        labels:
          severity: critical
          team: operations
          client: "{{ $labels.client_id }}"
        annotations:
          summary: "RPO violation for client {{ $labels.client_id }}"
          description: "Last successful backup was {{ $value | humanizeDuration }} ago"
          
      # Performance Alerts
      - alert: BackupThroughputDegraded
        expr: |
          avg_over_time(backup_throughput_bytes_per_second[1h]) < 
          avg_over_time(backup_throughput_bytes_per_second[24h] offset 1w) * 0.7
        for: 30m
        labels:
          severity: warning
          team: engineering
        annotations:
          summary: "Backup throughput degraded"
          description: "Backup throughput is 30% below weekly average"

      - alert: BackupQueueBacklog
        expr: backup_job_queue_length > 500
        for: 15m
        labels:
          severity: warning
          team: operations
        annotations:
          summary: "Large backup queue backlog"
          description: "{{ $value }} jobs in backup queue"

  - name: infrastructure.rules
    interval: 30s
    rules:
      # Resource Alerts
      - alert: HighCPUUsage
        expr: |
          100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 85
        for: 10m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is {{ $value }}%"

      - alert: HighMemoryUsage
        expr: |
          (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: critical
          team: infrastructure
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is {{ $value }}%"

      - alert: DiskSpaceLow
        expr: |
          (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: critical
          team: infrastructure
        annotations:
          summary: "Low disk space on {{ $labels.instance }}"
          description: "Disk usage is {{ $value }}% on {{ $labels.mountpoint }}"

  - name: application.rules
    interval: 30s
    rules:
      # Application Health
      - alert: ServiceDown
        expr: up == 0
        for: 5m
        labels:
          severity: critical
          team: operations
        annotations:
          summary: "Service {{ $labels.job }} is down"
          description: "{{ $labels.instance }} has been down for more than 5 minutes"

      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status_code=~"5.."}[5m])) /
          sum(rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: warning
          team: engineering
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }}"

      - alert: SlowResponseTime
        expr: |
          histogram_quantile(0.95, 
            sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
          ) > 2
        for: 10m
        labels:
          severity: warning
          team: engineering
        annotations:
          summary: "Slow response times detected"
          description: "95th percentile response time is {{ $value }}s"
```

---

## 📊 Grafana Dashboards

### **Executive Dashboard**

#### **🎯 C-Level Dashboard**
```json
{
  "dashboard": {
    "title": "BackupGuard Executive Dashboard",
    "tags": ["executive", "business"],
    "time": {
      "from": "now-30d",
      "to": "now"
    },
    "refresh": "5m",
    "panels": [
      {
        "title": "SLA Compliance Overview",
        "type": "stat",
        "gridPos": {"h": 8, "w": 24, "x": 0, "y": 0},
        "targets": [
          {
            "expr": "avg(backup_sla_compliance_percentage)",
            "legendFormat": "Overall SLA Compliance"
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
        "title": "Key Business Metrics",
        "type": "stat",
        "gridPos": {"h": 8, "w": 6, "x": 0, "y": 8},
        "targets": [
          {
            "expr": "sum(backup_data_protected_bytes) / 1e12",
            "legendFormat": "Data Protected (TB)"
          },
          {
            "expr": "count(count by (client_id) (backup_jobs_total))",
            "legendFormat": "Active Clients"
          },
          {
            "expr": "sum(rate(backup_jobs_total{status=\"success\"}[24h])) * 86400",
            "legendFormat": "Daily Successful Backups"
          },
          {
            "expr": "avg(backup_success_rate_percentage)",
            "legendFormat": "Success Rate %"
          }
        ]
      },
      {
        "title": "Monthly Revenue Trend",
        "type": "timeseries",
        "gridPos": {"h": 8, "w": 12, "x": 6, "y": 8},
        "targets": [
          {
            "expr": "sum by (month) (monthly_recurring_revenue)",
            "legendFormat": "MRR"
          }
        ]
      },
      {
        "title": "Client Growth",
        "type": "timeseries",
        "gridPos": {"h": 8, "w": 6, "x": 18, "y": 8},
        "targets": [
          {
            "expr": "count(count by (client_id) (backup_jobs_total))",
            "legendFormat": "Total Clients"
          }
        ]
      }
    ]
  }
}
```

### **Operations Dashboard**

#### **🔧 Technical Operations Dashboard**
```json
{
  "dashboard": {
    "title": "BackupGuard Operations Dashboard",
    "tags": ["operations", "technical"],
    "refresh": "30s",
    "panels": [
      {
        "title": "System Health Overview",
        "type": "stat",
        "targets": [
          {
            "expr": "up",
            "legendFormat": "{{ $labels.job }} - {{ $labels.instance }}"
          }
        ]
      },
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
              "excludeByName": {"__name__": true},
              "renameByName": {
                "client_id": "Client",
                "job_type": "Type",
                "progress": "Progress %",
                "eta_seconds": "ETA"
              }
            }
          }
        ]
      },
      {
        "title": "Backup Queue Status",
        "type": "timeseries",
        "targets": [
          {
            "expr": "backup_job_queue_length",
            "legendFormat": "{{ $labels.priority }} Priority"
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
            "expr": "(1 - (avg(node_memory_MemAvailable_bytes) / avg(node_memory_MemTotal_bytes))) * 100",
            "legendFormat": "Memory Usage %"
          }
        ]
      },
      {
        "title": "Network I/O",
        "type": "timeseries",
        "targets": [
          {
            "expr": "sum(rate(node_network_receive_bytes_total[5m])) * 8",
            "legendFormat": "Inbound"
          },
          {
            "expr": "sum(rate(node_network_transmit_bytes_total[5m])) * 8",
            "legendFormat": "Outbound"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "bps"
          }
        }
      },
      {
        "title": "Error Rate by Service",
        "type": "timeseries",
        "targets": [
          {
            "expr": "sum by (job) (rate(http_requests_total{status_code=~\"5..\"}[5m])) / sum by (job) (rate(http_requests_total[5m]))",
            "legendFormat": "{{ $labels.job }}"
          }
        ]
      }
    ]
  }
}
```

### **Performance Dashboard**

#### **⚡ Performance Monitoring Dashboard**
```json
{
  "dashboard": {
    "title": "BackupGuard Performance Dashboard",
    "tags": ["performance", "optimization"],
    "panels": [
      {
        "title": "Backup Throughput",
        "type": "timeseries",
        "targets": [
          {
            "expr": "sum by (client_id) (backup_throughput_bytes_per_second) / 1e6",
            "legendFormat": "Client {{ $labels.client_id }}"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "MBps"
          }
        }
      },
      {
        "title": "Response Time Percentiles",
        "type": "timeseries",
        "targets": [
          {
            "expr": "histogram_quantile(0.50, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))",
            "legendFormat": "50th percentile"
          },
          {
            "expr": "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))",
            "legendFormat": "95th percentile"
          },
          {
            "expr": "histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))",
            "legendFormat": "99th percentile"
          }
        ]
      },
      {
        "title": "Database Performance",
        "type": "timeseries",
        "targets": [
          {
            "expr": "mongodb_op_latencies_reads_ops_total",
            "legendFormat": "MongoDB Read Latency"
          },
          {
            "expr": "mongodb_op_latencies_writes_ops_total",
            "legendFormat": "MongoDB Write Latency"
          }
        ]
      },
      {
        "title": "Storage I/O Performance",
        "type": "timeseries",
        "targets": [
          {
            "expr": "sum(rate(node_disk_reads_completed_total[5m]))",
            "legendFormat": "Read IOPS"
          },
          {
            "expr": "sum(rate(node_disk_writes_completed_total[5m]))",
            "legendFormat": "Write IOPS"
          }
        ]
      }
    ]
  }
}
```

---

## 🚨 Alerting Strategy

### **AlertManager Configuration**

#### **📢 AlertManager Setup**
```yaml
# config/alertmanager/alertmanager.yml
global:
  smtp_smarthost: 'smtp.company.com:587'
  smtp_from: 'alerts@backupguard.com'
  smtp_auth_username: 'alerts@backupguard.com'
  smtp_auth_password: 'smtp_password'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'default'
  routes:
    # Critical alerts go to PagerDuty
    - match:
        severity: critical
      receiver: 'pagerduty-critical'
      group_wait: 0s
      repeat_interval: 5m
      
    # Business hours warnings
    - match:
        severity: warning
      receiver: 'slack-warnings'
      active_time_intervals:
        - business_hours
        
    # SLA violations always alert
    - match:
        team: sla
      receiver: 'executive-alerts'
      group_wait: 0s
      
    # Client-specific alerts
    - match_re:
        client: '.+'
      receiver: 'client-specific'

time_intervals:
  - name: business_hours
    time_intervals:
      - times:
          - start_time: '09:00'
            end_time: '17:00'
        weekdays: ['monday:friday']
        location: 'America/New_York'

receivers:
  - name: 'default'
    email_configs:
      - to: 'oncall@backupguard.com'
        subject: '{{ .GroupLabels.alertname }} - {{ .Status }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          {{ end }}

  - name: 'pagerduty-critical'
    pagerduty_configs:
      - service_key: 'pagerduty_service_key'
        description: '{{ .GroupLabels.alertname }}: {{ .GroupLabels.instance }}'
        details:
          severity: '{{ .GroupLabels.severity }}'
          cluster: '{{ .GroupLabels.cluster }}'
          
  - name: 'slack-warnings'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/...'
        channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: |
          {{ range .Alerts }}
          {{ .Annotations.summary }}
          {{ .Annotations.description }}
          {{ end }}
        color: 'warning'
        
  - name: 'executive-alerts'
    email_configs:
      - to: 'executives@backupguard.com'
        subject: '🚨 SLA Alert: {{ .GroupLabels.alertname }}'
        body: |
          URGENT: SLA violation detected
          
          {{ range .Alerts }}
          Summary: {{ .Annotations.summary }}
          Impact: {{ .Annotations.description }}
          Playbook: {{ .Annotations.playbook }}
          {{ end }}
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/...'
        channel: '#executive-alerts'
        
  - name: 'client-specific'
    webhook_configs:
      - url: 'https://api.backupguard.com/webhooks/client-alerts'
        send_resolved: true
        http_config:
          bearer_token: 'webhook_token'

inhibit_rules:
  # Inhibit warning if critical is firing
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'instance']
    
  # Inhibit service down if host is down
  - source_match:
      alertname: 'HostDown'
    target_match_re:
      alertname: '.*'
    equal: ['instance']
```

### **Escalation Procedures**

#### **📈 Alert Escalation Matrix**
```yaml
escalation_matrix:
  level_1:
    severity: warning
    response_time: "15 minutes"
    responders:
      - "On-call engineer"
    actions:
      - "Acknowledge alert"
      - "Initial investigation"
      - "Apply quick fixes if possible"
      
  level_2:
    severity: critical
    response_time: "5 minutes"
    responders:
      - "On-call engineer"
      - "Team lead (if no response in 10 min)"
    actions:
      - "Immediate response"
      - "Status page update"
      - "Customer notification (if needed)"
      
  level_3:
    severity: sla_breach
    response_time: "2 minutes"
    responders:
      - "On-call engineer"
      - "Team lead"
      - "Manager (if no response in 5 min)"
      - "Executive team (for major breaches)"
    actions:
      - "Emergency response"
      - "Immediate escalation"
      - "External vendor engagement"
      - "Customer communication"

communication_procedures:
  internal:
    immediate: "Slack + PagerDuty"
    updates: "Every 30 minutes during active incident"
    resolution: "Post-mortem within 24 hours"
    
  external:
    status_page: "Update within 5 minutes"
    customer_email: "Within 15 minutes for SLA breaches"
    social_media: "For major outages affecting many customers"
```

---

## 📋 Logging Architecture

### **ELK Stack Configuration**

#### **📊 Elasticsearch Configuration**
```yaml
# config/elasticsearch/elasticsearch.yml
cluster.name: backupguard-logs
node.name: ${HOSTNAME}
node.roles: [master, data, ingest]

network.host: 0.0.0.0
http.port: 9200
transport.port: 9300

discovery.seed_hosts:
  - elasticsearch-1
  - elasticsearch-2
  - elasticsearch-3
  
cluster.initial_master_nodes:
  - elasticsearch-1
  - elasticsearch-2
  - elasticsearch-3

# Performance settings
bootstrap.memory_lock: true
indices.memory.index_buffer_size: 20%
indices.queries.cache.size: 10%

# Index management
action.auto_create_index: true
index.number_of_shards: 3
index.number_of_replicas: 1

# Retention settings
indices.lifecycle.poll_interval: 10m

# Security
xpack.security.enabled: true
xpack.security.authc.api_key.enabled: true
```

#### **📝 Logstash Configuration**
```ruby
# config/logstash/logstash.conf
input {
  beats {
    port => 5044
    host => "0.0.0.0"
  }
  
  syslog {
    port => 5514
    host => "0.0.0.0"
  }
  
  http {
    port => 8080
    host => "0.0.0.0"
  }
}

filter {
  # Parse application logs
  if [fields][service] == "api-gateway" {
    grok {
      match => { 
        "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{DATA:logger} - %{GREEDYDATA:message}"
      }
    }
    
    date {
      match => [ "timestamp", "ISO8601" ]
    }
    
    if [level] == "ERROR" {
      mutate {
        add_tag => ["error"]
        add_field => { "alert_required" => "true" }
      }
    }
  }
  
  # Parse access logs
  if [fields][service] == "nginx" {
    grok {
      match => {
        "message" => '%{IPORHOST:remote_addr} - %{DATA:remote_user} \[%{HTTPDATE:time_local}\] "%{WORD:method} %{DATA:request} HTTP/%{NUMBER:http_version}" %{NUMBER:status} %{NUMBER:body_bytes_sent} "%{DATA:http_referer}" "%{DATA:http_user_agent}" "%{DATA:http_x_forwarded_for}"'
      }
    }
    
    date {
      match => [ "time_local", "dd/MMM/yyyy:HH:mm:ss Z" ]
    }
    
    mutate {
      convert => {
        "status" => "integer"
        "body_bytes_sent" => "integer"
      }
    }
    
    if [status] >= 400 {
      mutate {
        add_tag => ["http_error"]
      }
    }
  }
  
  # Parse database logs
  if [fields][service] == "mongodb" {
    grok {
      match => {
        "message" => "%{TIMESTAMP_ISO8601:timestamp} %{WORD:severity} %{WORD:component} %{GREEDYDATA:message}"
      }
    }
    
    if [severity] in ["F", "E"] {
      mutate {
        add_tag => ["database_error"]
        add_field => { "alert_required" => "true" }
      }
    }
  }
  
  # Add common fields
  mutate {
    add_field => {
      "environment" => "${ENVIRONMENT:production}"
      "cluster" => "${CLUSTER_NAME:backupguard-prod}"
    }
  }
  
  # Remove sensitive data
  mutate {
    remove_field => ["password", "token", "api_key"]
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch-1:9200", "elasticsearch-2:9200", "elasticsearch-3:9200"]
    index => "backupguard-logs-%{[fields][service]}-%{+YYYY.MM.dd}"
    template_name => "backupguard"
    template_pattern => "backupguard-*"
    template => "/etc/logstash/templates/backupguard.json"
    
    user => "${ELASTICSEARCH_USER}"
    password => "${ELASTICSEARCH_PASSWORD}"
  }
  
  # Send alerts for critical errors
  if "alert_required" in [tags] {
    http {
      url => "https://api.backupguard.com/webhooks/log-alerts"
      http_method => "post"
      format => "json"
      headers => {
        "Authorization" => "Bearer ${WEBHOOK_TOKEN}"
      }
    }
  }
}
```

### **Log Aggregation Strategy**

#### **📚 Log Classification**
```yaml
log_categories:
  application_logs:
    sources: ["api-gateway", "backup-service", "user-service"]
    format: "JSON structured"
    retention: "30 days"
    indexing: "Daily indices"
    
  access_logs:
    sources: ["nginx", "haproxy"]
    format: "Common Log Format"
    retention: "90 days"
    indexing: "Weekly indices"
    
  security_logs:
    sources: ["auth-service", "firewall", "waf"]
    format: "CEF (Common Event Format)"
    retention: "1 year"
    indexing: "Monthly indices"
    
  audit_logs:
    sources: ["database", "admin-actions"]
    format: "JSON structured"
    retention: "7 years"
    indexing: "Quarterly indices"
    
  system_logs:
    sources: ["syslog", "kernel", "docker"]
    format: "Syslog"
    retention: "60 days"
    indexing: "Daily indices"

log_levels:
  TRACE: "Development debugging only"
  DEBUG: "Detailed debugging information"
  INFO: "General operational messages"
  WARN: "Warning conditions"
  ERROR: "Error conditions requiring attention"
  FATAL: "Critical errors causing service failure"
```

---

## 🔍 Observabilidad

### **Distributed Tracing**

#### **🕸️ Jaeger Configuration**
```yaml
# config/jaeger/jaeger.yml
jaeger:
  collector:
    port: 14268
    grpc_port: 14250
    
  query:
    port: 16686
    base_path: /jaeger
    
  agent:
    port: 6831
    
  storage:
    type: elasticsearch
    elasticsearch:
      server_urls: 
        - http://elasticsearch-1:9200
        - http://elasticsearch-2:9200
      index_prefix: jaeger
      
sampling:
  default_strategy:
    type: probabilistic
    param: 0.1  # 10% sampling rate
    
  per_service_strategies:
    - service: api-gateway
      type: probabilistic
      param: 0.5  # 50% for critical service
      
    - service: backup-service
      type: probabilistic
      param: 0.2  # 20% for high-volume service
      
    - service: user-service
      type: adaptive
      max_traces_per_second: 100
```

#### **📊 Trace Instrumentation**
```javascript
// src/tracing/jaeger-tracer.js
const { initTracer } = require('jaeger-client');
const opentracing = require('opentracing');

class TracingService {
    constructor() {
        this.tracer = this.initializeTracer();
    }

    initializeTracer() {
        const config = {
            serviceName: process.env.SERVICE_NAME || 'backupguard-service',
            
            sampler: {
                type: 'probabilistic',
                param: parseFloat(process.env.JAEGER_SAMPLING_RATE || '0.1')
            },
            
            reporter: {
                logSpans: true,
                agentHost: process.env.JAEGER_AGENT_HOST || 'localhost',
                agentPort: parseInt(process.env.JAEGER_AGENT_PORT || '6832')
            }
        };

        return initTracer(config);
    }

    // Express middleware for automatic tracing
    getTracingMiddleware() {
        return (req, res, next) => {
            const parentSpanContext = this.tracer.extract(
                opentracing.FORMAT_HTTP_HEADERS,
                req.headers
            );

            const span = this.tracer.startSpan(
                `${req.method} ${req.path}`,
                { childOf: parentSpanContext }
            );

            // Add request metadata
            span.setTag('http.method', req.method);
            span.setTag('http.url', req.url);
            span.setTag('http.user_agent', req.get('User-Agent'));
            span.setTag('user.id', req.user?.id);

            // Store span in request for downstream use
            req.span = span;

            res.on('finish', () => {
                span.setTag('http.status_code', res.statusCode);
                
                if (res.statusCode >= 400) {
                    span.setTag('error', true);
                    span.log({
                        event: 'error',
                        message: `HTTP ${res.statusCode}`
                    });
                }
                
                span.finish();
            });

            next();
        };
    }

    // Manual span creation for business logic
    createSpan(operationName, parentSpan, tags = {}) {
        const span = this.tracer.startSpan(operationName, {
            childOf: parentSpan
        });

        Object.entries(tags).forEach(([key, value]) => {
            span.setTag(key, value);
        });

        return span;
    }

    // Database operation tracing
    traceDatabase(operation, collection, parentSpan) {
        const span = this.createSpan(`db.${operation}`, parentSpan, {
            'db.type': 'mongodb',
            'db.collection': collection,
            'db.operation': operation
        });

        return {
            span,
            finish: (error = null) => {
                if (error) {
                    span.setTag('error', true);
                    span.log({
                        event: 'error',
                        'error.object': error
                    });
                }
                span.finish();
            }
        };
    }

    // External service call tracing
    traceExternalCall(serviceName, operation, parentSpan) {
        const span = this.createSpan(`external.${serviceName}`, parentSpan, {
            'service.name': serviceName,
            'operation.name': operation,
            'span.kind': 'client'
        });

        return {
            span,
            injectHeaders: (headers = {}) => {
                this.tracer.inject(span, opentracing.FORMAT_HTTP_HEADERS, headers);
                return headers;
            },
            finish: (statusCode = null, error = null) => {
                if (statusCode) {
                    span.setTag('http.status_code', statusCode);
                }
                if (error) {
                    span.setTag('error', true);
                    span.log({
                        event: 'error',
                        'error.object': error
                    });
                }
                span.finish();
            }
        };
    }
}

module.exports = { TracingService };
```

### **Custom Metrics and Business Intelligence**

#### **📈 Business Metrics Dashboard**
```yaml
business_intelligence:
  data_sources:
    prometheus: "Real-time metrics"
    elasticsearch: "Log analysis"
    database: "Business data"
    
  kpi_calculations:
    customer_satisfaction:
      formula: "successful_restores / total_restore_requests"
      target: "> 99%"
      
    cost_per_gb:
      formula: "total_infrastructure_cost / total_gb_stored"
      target: "< $0.05/GB"
      
    backup_efficiency:
      formula: "deduplicated_size / original_size"
      target: "> 4:1 ratio"
      
    mean_time_to_recovery:
      formula: "avg(recovery_completion_time - recovery_start_time)"
      target: "< 15 minutes"
```

---

## 🎯 SRE y SLA Monitoring

### **SLI/SLO/SLA Framework**

#### **📊 Service Level Indicators (SLIs)**
```yaml
slis:
  availability:
    measurement: "uptime / total_time"
    data_source: "prometheus"
    query: "avg_over_time(up[5m])"
    
  backup_success_rate:
    measurement: "successful_backups / total_backup_attempts"
    data_source: "prometheus"
    query: "rate(backup_jobs_total{status='success'}[1h]) / rate(backup_jobs_total[1h])"
    
  restore_success_rate:
    measurement: "successful_restores / total_restore_attempts"
    data_source: "prometheus"
    query: "rate(restore_jobs_total{status='success'}[1h]) / rate(restore_jobs_total[1h])"
    
  response_time:
    measurement: "p95 response time"
    data_source: "prometheus"
    query: "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))"
    
  data_integrity:
    measurement: "verified_checksums / total_checksums"
    data_source: "prometheus"
    query: "rate(backup_checksum_verified_total[1h]) / rate(backup_checksum_total[1h])"
```

#### **🎯 Service Level Objectives (SLOs)**
```yaml
slos:
  system_availability:
    target: "99.9%"
    measurement_window: "30d"
    sli: "availability"
    error_budget: "43.2 minutes/month"
    
  backup_reliability:
    target: "99.5%"
    measurement_window: "7d"
    sli: "backup_success_rate"
    error_budget: "0.5% of backup attempts"
    
  restore_performance:
    target: "95% of restores complete in < 15 minutes"
    measurement_window: "24h"
    sli: "restore_success_rate"
    
  api_performance:
    target: "95% of requests respond in < 200ms"
    measurement_window: "1h"
    sli: "response_time"
    
  data_durability:
    target: "99.999%"
    measurement_window: "365d"
    sli: "data_integrity"
    error_budget: "0.001% data loss acceptable"
```

#### **📋 Service Level Agreements (SLAs)**
```yaml
slas:
  enterprise_tier:
    availability: "99.9% uptime"
    backup_rpo: "1 hour maximum data loss"
    backup_rto: "4 hours maximum recovery time"
    support: "24/7 phone support"
    credits: "10% monthly credit per 0.1% below SLA"
    
  professional_tier:
    availability: "99.5% uptime"
    backup_rpo: "4 hours maximum data loss"
    backup_rto: "8 hours maximum recovery time"
    support: "Business hours support"
    credits: "5% monthly credit per 0.5% below SLA"
    
  standard_tier:
    availability: "99% uptime"
    backup_rpo: "24 hours maximum data loss"
    backup_rto: "24 hours maximum recovery time"
    support: "Email support"
    credits: "No credits"

sla_monitoring:
  automated_reporting:
    frequency: "monthly"
    recipients: ["customers", "account_managers", "executives"]
    
  breach_detection:
    real_time: true
    escalation: "immediate"
    
  remediation:
    automatic_credits: true
    customer_notification: "within 24 hours"
```

### **Error Budget Management**

#### **📊 Error Budget Tracking**
```yaml
error_budget_policies:
  budget_calculation:
    formula: "(1 - SLO_target) * measurement_window"
    recalculation: "daily"
    
  budget_consumption:
    tracking: "real_time"
    alerts:
      - threshold: "50% consumed"
        action: "inform_team"
      - threshold: "75% consumed"
        action: "reduce_deployment_frequency"
      - threshold: "90% consumed"
        action: "freeze_deployments"
      - threshold: "100% consumed"
        action: "incident_response"
        
  budget_recovery:
    method: "rolling_window"
    recovery_rate: "automatic_with_good_performance"
```

---

> **💡 Nota**: Esta documentación de monitoreo proporciona un framework completo de observabilidad para sistemas empresariales complejos. Adapta las métricas y alertas según tus necesidades específicas de negocio y operaciones.
