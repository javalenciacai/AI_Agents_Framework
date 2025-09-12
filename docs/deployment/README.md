# 🚀 Deployment Guide - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Overview de Deployment](#overview-de-deployment)
- [Ambientes](#ambientes)
- [Estrategias de Deployment](#estrategias-de-deployment)
- [Docker Deployment](#docker-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Rollback Procedures](#rollback-procedures)
- [Health Checks](#health-checks)

---

## 🎯 Overview de Deployment

### **Arquitectura de Deployment**
```
┌─────────────────────────────────────────────┐
│                PRODUCTION                   │
├─────────────────────────────────────────────┤
│ Load Balancer (HAProxy/Nginx)              │
├─────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│ │ API Gateway │ │ Backup Svc  │ │ User Svc│ │
│ │   (3 pods)  │ │   (5 pods)  │ │ (2 pods)│ │
│ └─────────────┘ └─────────────┘ └─────────┘ │
├─────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│ │  Notify Svc │ │ Report Svc  │ │Config Sv│ │
│ │   (2 pods)  │ │   (2 pods)  │ │ (1 pod) │ │
│ └─────────────┘ └─────────────┘ └─────────┘ │
├─────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│ │  MongoDB    │ │    Redis    │ │Postgres │ │
│ │  (3 replicas)│ │ (6 cluster) │ │(2 nodes)│ │
│ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────┘
```

### **Principios de Deployment**
- **Immutable Infrastructure**: Nunca modificar servidores en ejecución
- **Blue-Green Deployment**: Zero-downtime deployments
- **Rolling Updates**: Actualizaciones graduales para microservicios
- **Automated Rollback**: Rollback automático en caso de fallas
- **Health-First**: Health checks antes de routing traffic

---

## 🌍 Ambientes

### **Development Environment**
```yaml
# config/environments/development.yml
environment: development
replicas:
  api_gateway: 1
  backup_service: 1
  user_service: 1
  notification_service: 1
  
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
    
storage:
  type: "local"
  size: "10Gi"
  
monitoring:
  enabled: true
  debug_mode: true
  
security:
  ssl_enabled: false
  auth_level: "basic"
```

### **Staging Environment**
```yaml
# config/environments/staging.yml
environment: staging
replicas:
  api_gateway: 2
  backup_service: 2
  user_service: 1
  notification_service: 1
  
resources:
  requests:
    cpu: "200m"
    memory: "256Mi"
  limits:
    cpu: "1000m"
    memory: "1Gi"
    
storage:
  type: "ssd"
  size: "50Gi"
  
monitoring:
  enabled: true
  performance_testing: true
  
security:
  ssl_enabled: true
  auth_level: "standard"
  
data_sync:
  from_production: true
  anonymized: true
  schedule: "daily"
```

### **Production Environment**
```yaml
# config/environments/production.yml
environment: production
replicas:
  api_gateway: 3
  backup_service: 5
  user_service: 2
  notification_service: 2
  report_service: 2
  config_service: 1
  
resources:
  requests:
    cpu: "500m"
    memory: "1Gi"
  limits:
    cpu: "2000m"
    memory: "4Gi"
    
storage:
  type: "nvme_ssd"
  size: "500Gi"
  replicas: 3
  
monitoring:
  enabled: true
  alerting: true
  sla_monitoring: true
  
security:
  ssl_enabled: true
  auth_level: "enterprise"
  compliance: ["SOX", "GDPR", "HIPAA"]
  
backup:
  enabled: true
  frequency: "4h"
  retention: "90d"
  geo_replication: true
```

---

## 📈 Estrategias de Deployment

### **Blue-Green Deployment**

#### **Configuración Blue-Green**
```yaml
# k8s/blue-green/blue-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backupguard-blue
  labels:
    app: backupguard
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backupguard
      version: blue
  template:
    metadata:
      labels:
        app: backupguard
        version: blue
    spec:
      containers:
      - name: api-gateway
        image: backupguard/api-gateway:v2.1.0
        ports:
        - containerPort: 8080
        env:
        - name: ENVIRONMENT
          value: "production"
        - name: VERSION_SLOT
          value: "blue"
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 20
```

#### **Script de Blue-Green Deployment**
```bash
#!/bin/bash
# scripts/blue-green-deploy.sh

set -euo pipefail

NAMESPACE="backupguard-prod"
NEW_VERSION="$1"
CURRENT_SLOT=$(kubectl get service backupguard-service -n $NAMESPACE -o jsonpath='{.spec.selector.version}')
NEW_SLOT=$([ "$CURRENT_SLOT" = "blue" ] && echo "green" || echo "blue")

echo "🚀 Iniciando Blue-Green Deployment"
echo "📋 Versión actual: $CURRENT_SLOT"
echo "📋 Nueva versión: $NEW_SLOT ($NEW_VERSION)"

# Paso 1: Deploy nueva versión en slot inactivo
echo "📦 Desplegando en slot $NEW_SLOT..."
sed "s/{{VERSION}}/$NEW_VERSION/g; s/{{SLOT}}/$NEW_SLOT/g" k8s/blue-green/deployment-template.yml | kubectl apply -n $NAMESPACE -f -

# Paso 2: Esperar que pods estén ready
echo "⏳ Esperando que pods estén ready..."
kubectl wait --for=condition=available --timeout=600s deployment/backupguard-$NEW_SLOT -n $NAMESPACE

# Paso 3: Health check del nuevo slot
echo "🔍 Verificando health del nuevo slot..."
NEW_POD=$(kubectl get pods -n $NAMESPACE -l version=$NEW_SLOT -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $NEW_POD 9090:8080 -n $NAMESPACE &
PORT_FORWARD_PID=$!

sleep 5
if curl -f http://localhost:9090/health > /dev/null 2>&1; then
    echo "✅ Health check exitoso"
else
    echo "❌ Health check falló, abortando deployment"
    kill $PORT_FORWARD_PID
    exit 1
fi
kill $PORT_FORWARD_PID

# Paso 4: Smoke tests
echo "🧪 Ejecutando smoke tests..."
if ! ./scripts/smoke-tests.sh $NEW_SLOT; then
    echo "❌ Smoke tests fallaron, abortando deployment"
    exit 1
fi

# Paso 5: Switch traffic
echo "🔄 Switcheando tráfico a $NEW_SLOT..."
kubectl patch service backupguard-service -n $NAMESPACE -p '{"spec":{"selector":{"version":"'$NEW_SLOT'"}}}'

# Paso 6: Verificar que traffic switch fue exitoso
echo "⏳ Verificando traffic switch..."
sleep 30
if curl -f https://api.backupguard.pro/health > /dev/null 2>&1; then
    echo "✅ Traffic switch exitoso"
else
    echo "❌ Traffic switch falló, haciendo rollback..."
    kubectl patch service backupguard-service -n $NAMESPACE -p '{"spec":{"selector":{"version":"'$CURRENT_SLOT'"}}}'
    exit 1
fi

# Paso 7: Cleanup slot anterior después de validación
echo "⏳ Esperando 5 minutos antes de cleanup..."
sleep 300

echo "🧹 Limpiando slot anterior $CURRENT_SLOT..."
kubectl delete deployment backupguard-$CURRENT_SLOT -n $NAMESPACE

echo "🎉 Blue-Green deployment completado exitosamente!"
echo "📊 Nueva versión $NEW_VERSION activa en slot $NEW_SLOT"
```

### **Rolling Updates**

#### **Configuración Rolling Update**
```yaml
# k8s/rolling-update/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backup-service
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1      # Máximo 1 pod down
      maxSurge: 1           # Máximo 1 pod extra
  template:
    spec:
      containers:
      - name: backup-service
        image: backupguard/backup-service:latest
        readinessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 30
          periodSeconds: 5
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 60
          periodSeconds: 10
          failureThreshold: 3
        lifecycle:
          preStop:
            exec:
              command: ["/bin/sh", "-c", "sleep 15"]  # Graceful shutdown
```

---

## 🐳 Docker Deployment

### **Docker Compose Production**
```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  api-gateway:
    image: backupguard/api-gateway:${VERSION:-latest}
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '0.5'
          memory: 1G
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=info
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    networks:
      - backupguard-network
    ports:
      - "8080:8080"
      
  backup-service:
    image: backupguard/backup-service:${VERSION:-latest}
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: '3.0'
          memory: 8G
        reservations:
          cpus: '1.0'
          memory: 2G
    environment:
      - NODE_ENV=production
      - WORKER_THREADS=4
    volumes:
      - backup-storage:/var/backupguard/storage
    networks:
      - backupguard-network
    depends_on:
      - mongodb
      - redis
      
  mongodb:
    image: mongo:6.0
    deploy:
      replicas: 1
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
    environment:
      - MONGO_INITDB_ROOT_USERNAME=${MONGO_ROOT_USER}
      - MONGO_INITDB_ROOT_PASSWORD=${MONGO_ROOT_PASSWORD}
    volumes:
      - mongodb-data:/data/db
      - ./config/mongodb/mongod.conf:/etc/mongod.conf
    command: mongod --config /etc/mongod.conf
    networks:
      - backupguard-network

networks:
  backupguard-network:
    driver: bridge
    
volumes:
  mongodb-data:
    driver: local
  backup-storage:
    driver: local
```

### **Docker Build Optimization**
```dockerfile
# Dockerfile.api-gateway
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS runtime

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S backupguard -u 1001

# Instalar herramientas necesarias
RUN apk add --no-cache curl dumb-init

WORKDIR /app

# Copiar aplicación
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=backupguard:nodejs . .

# Configurar usuario
USER backupguard

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080

# Usar dumb-init para manejo correcto de señales
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "src/index.js"]
```

---

## ☸️ Kubernetes Deployment

### **Namespace y RBAC**
```yaml
# k8s/namespace.yml
apiVersion: v1
kind: Namespace
metadata:
  name: backupguard-prod
  labels:
    name: backupguard-prod
    tier: production

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: backupguard-sa
  namespace: backupguard-prod

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: backupguard-role
  namespace: backupguard-prod
rules:
- apiGroups: [""]
  resources: ["pods", "services", "endpoints"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: backupguard-rolebinding
  namespace: backupguard-prod
subjects:
- kind: ServiceAccount
  name: backupguard-sa
  namespace: backupguard-prod
roleRef:
  kind: Role
  name: backupguard-role
  apiGroup: rbac.authorization.k8s.io
```

### **ConfigMaps y Secrets**
```yaml
# k8s/configmap.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backupguard-config
  namespace: backupguard-prod
data:
  NODE_ENV: "production"
  LOG_LEVEL: "info"
  API_TIMEOUT: "30000"
  WORKER_THREADS: "4"
  
---
apiVersion: v1
kind: Secret
metadata:
  name: backupguard-secrets
  namespace: backupguard-prod
type: Opaque
data:
  MONGODB_URI: # base64 encoded
  REDIS_URL: # base64 encoded
  JWT_SECRET: # base64 encoded
  ENCRYPTION_KEY: # base64 encoded
```

### **Production Deployments**
```yaml
# k8s/api-gateway-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
  namespace: backupguard-prod
  labels:
    app: api-gateway
    tier: backend
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: api-gateway
  template:
    metadata:
      labels:
        app: api-gateway
        tier: backend
    spec:
      serviceAccountName: backupguard-sa
      securityContext:
        runAsNonRoot: true
        runAsUser: 1001
        fsGroup: 1001
      containers:
      - name: api-gateway
        image: backupguard/api-gateway:v2.1.0
        ports:
        - containerPort: 8080
          name: http
        envFrom:
        - configMapRef:
            name: backupguard-config
        - secretRef:
            name: backupguard-secrets
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
          limits:
            cpu: 2000m
            memory: 4Gi
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 20
          timeoutSeconds: 10
          failureThreshold: 3
        lifecycle:
          preStop:
            exec:
              command: ["/bin/sh", "-c", "sleep 15"]
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - api-gateway
              topologyKey: kubernetes.io/hostname

---
apiVersion: v1
kind: Service
metadata:
  name: api-gateway-service
  namespace: backupguard-prod
spec:
  selector:
    app: api-gateway
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: ClusterIP
```

### **Ingress Configuration**
```yaml
# k8s/ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backupguard-ingress
  namespace: backupguard-prod
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10g"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
spec:
  tls:
  - hosts:
    - api.backupguard.pro
    - app.backupguard.pro
    secretName: backupguard-tls
  rules:
  - host: api.backupguard.pro
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-gateway-service
            port:
              number: 80
```

---

## 🔄 CI/CD Pipeline

### **GitHub Actions Workflow**
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    tags:
      - 'v*'

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: backupguard

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Run tests
      run: npm run test:ci
      
    - name: Run security audit
      run: npm audit --audit-level moderate

  build:
    needs: test
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [api-gateway, backup-service, user-service, notification-service]
    steps:
    - uses: actions/checkout@v3
    
    - name: Log in to Container Registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
        
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}/${{ matrix.service }}
        tags: |
          type=ref,event=tag
          type=sha
          
    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: ./services/${{ matrix.service }}
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'v1.25.0'
        
    - name: Configure kubectl
      run: |
        echo "${{ secrets.KUBE_CONFIG_STAGING }}" | base64 -d > kubeconfig
        export KUBECONFIG=kubeconfig
        
    - name: Deploy to staging
      run: |
        export VERSION=${{ github.ref_name }}
        envsubst < k8s/staging/kustomization.yml | kubectl apply -k -
        
    - name: Wait for deployment
      run: |
        kubectl wait --for=condition=available --timeout=600s deployment/api-gateway -n backupguard-staging
        
    - name: Run smoke tests
      run: |
        ./scripts/smoke-tests.sh staging

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
      
    - name: Configure kubectl
      run: |
        echo "${{ secrets.KUBE_CONFIG_PROD }}" | base64 -d > kubeconfig
        export KUBECONFIG=kubeconfig
        
    - name: Blue-Green Deploy
      run: |
        export VERSION=${{ github.ref_name }}
        ./scripts/blue-green-deploy.sh $VERSION
        
    - name: Post-deployment tests
      run: |
        ./scripts/integration-tests.sh production
        
    - name: Notify success
      uses: 8398a7/action-slack@v3
      with:
        status: success
        channel: '#deployments'
        text: '🚀 BackupGuard Pro ${{ github.ref_name }} deployed successfully!'
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 🔙 Rollback Procedures

### **Automated Rollback**
```bash
#!/bin/bash
# scripts/rollback.sh

set -euo pipefail

NAMESPACE="backupguard-prod"
ROLLBACK_TO_VERSION="$1"

echo "🔄 Iniciando rollback a versión $ROLLBACK_TO_VERSION"

# Verificar que la versión objetivo existe
if ! kubectl get deployment backupguard-blue -n $NAMESPACE > /dev/null 2>&1 && \
   ! kubectl get deployment backupguard-green -n $NAMESPACE > /dev/null 2>&1; then
    echo "❌ No se encontraron deployments para rollback"
    exit 1
fi

# Determinar slot activo y slot de rollback
CURRENT_SLOT=$(kubectl get service backupguard-service -n $NAMESPACE -o jsonpath='{.spec.selector.version}')
ROLLBACK_SLOT=$([ "$CURRENT_SLOT" = "blue" ] && echo "green" || echo "blue")

echo "📋 Slot actual: $CURRENT_SLOT"
echo "📋 Rollback a slot: $ROLLBACK_SLOT"

# Verificar que el slot de rollback está disponible
if ! kubectl get deployment backupguard-$ROLLBACK_SLOT -n $NAMESPACE > /dev/null 2>&1; then
    echo "❌ Slot de rollback $ROLLBACK_SLOT no disponible"
    exit 1
fi

# Switch inmediato de tráfico
echo "🔄 Switcheando tráfico a $ROLLBACK_SLOT..."
kubectl patch service backupguard-service -n $NAMESPACE -p '{"spec":{"selector":{"version":"'$ROLLBACK_SLOT'"}}}'

# Verificar que el rollback fue exitoso
echo "⏳ Verificando rollback..."
sleep 30
if curl -f https://api.backupguard.pro/health > /dev/null 2>&1; then
    echo "✅ Rollback exitoso"
    
    # Cleanup del slot problemático
    echo "🧹 Limpiando slot problemático $CURRENT_SLOT..."
    kubectl delete deployment backupguard-$CURRENT_SLOT -n $NAMESPACE
    
    echo "🎉 Rollback completado exitosamente!"
else
    echo "❌ Rollback falló, requiere intervención manual"
    exit 1
fi
```

### **Database Rollback**
```bash
#!/bin/bash
# scripts/database-rollback.sh

BACKUP_DATE="$1"
CONFIRM="$2"

if [ "$CONFIRM" != "YES" ]; then
    echo "❌ Este script requiere confirmación explícita"
    echo "Usage: $0 <BACKUP_DATE> YES"
    exit 1
fi

echo "🗄️ Iniciando database rollback a $BACKUP_DATE"

# Backup actual antes del rollback
echo "📦 Creando backup de seguridad..."
kubectl exec -n backupguard-prod mongodb-0 -- mongodump --out /tmp/pre-rollback-backup

# Restaurar desde backup
echo "🔄 Restaurando database desde $BACKUP_DATE..."
kubectl exec -n backupguard-prod mongodb-0 -- mongorestore --drop /backups/$BACKUP_DATE

echo "✅ Database rollback completado"
```

---

## 🔍 Health Checks

### **Application Health Checks**
```javascript
// src/health/health-check.js
const express = require('express');
const mongoose = require('mongoose');
const redis = require('redis');

class HealthChecker {
    constructor() {
        this.checks = {
            database: this.checkDatabase.bind(this),
            redis: this.checkRedis.bind(this),
            storage: this.checkStorage.bind(this),
            external_apis: this.checkExternalAPIs.bind(this)
        };
    }

    async runHealthCheck() {
        const results = {};
        const overall = { status: 'healthy', timestamp: new Date() };

        for (const [name, check] of Object.entries(this.checks)) {
            try {
                const result = await Promise.race([
                    check(),
                    new Promise((_, reject) => 
                        setTimeout(() => reject(new Error('Timeout')), 5000)
                    )
                ]);
                
                results[name] = {
                    status: 'healthy',
                    ...result
                };
            } catch (error) {
                results[name] = {
                    status: 'unhealthy',
                    error: error.message
                };
                overall.status = 'unhealthy';
            }
        }

        return {
            ...overall,
            checks: results
        };
    }

    async checkDatabase() {
        const start = Date.now();
        await mongoose.connection.db.admin().ping();
        return {
            response_time_ms: Date.now() - start,
            connection_state: mongoose.connection.readyState
        };
    }

    async checkRedis() {
        const start = Date.now();
        await redis.ping();
        return {
            response_time_ms: Date.now() - start,
            memory_usage: await redis.memory('usage')
        };
    }

    async checkStorage() {
        const fs = require('fs').promises;
        const stats = await fs.stat('/var/backupguard/storage');
        return {
            accessible: true,
            last_modified: stats.mtime
        };
    }

    async checkExternalAPIs() {
        // Check external dependencies
        const checks = await Promise.allSettled([
            fetch('https://smtp.provider.com/health'),
            fetch('https://notification.service.com/health')
        ]);

        return {
            smtp_service: checks[0].status === 'fulfilled',
            notification_service: checks[1].status === 'fulfilled'
        };
    }
}

module.exports = { HealthChecker };
```

### **Kubernetes Liveness/Readiness Probes**
```yaml
# k8s/probes.yml
readinessProbe:
  httpGet:
    path: /health/ready
    port: 8080
    httpHeaders:
    - name: X-Health-Check
      value: readiness
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 3

livenessProbe:
  httpGet:
    path: /health/live
    port: 8080
    httpHeaders:
    - name: X-Health-Check
      value: liveness
  initialDelaySeconds: 60
  periodSeconds: 20
  timeoutSeconds: 10
  successThreshold: 1
  failureThreshold: 3

startupProbe:
  httpGet:
    path: /health/startup
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
  timeoutSeconds: 3
  successThreshold: 1
  failureThreshold: 30  # 2.5 minutos para startup
```

---

## 📊 Deployment Metrics

### **Key Deployment Metrics**
```yaml
# config/metrics/deployment.yml
deployment_metrics:
  deployment_frequency:
    target: "daily"
    current: "2.3 per day"
    
  lead_time:
    target: "< 4 hours"
    current: "2.1 hours"
    
  mttr:  # Mean Time To Recovery
    target: "< 1 hour"
    current: "23 minutes"
    
  change_failure_rate:
    target: "< 5%"
    current: "2.1%"
    
success_criteria:
  zero_downtime: true
  automated_rollback: true
  health_check_pass: true
  performance_baseline: true
```

---

> **💡 Nota**: Esta guía de deployment está diseñada para entornos de producción empresariales. Adapta las configuraciones según tus necesidades específicas de infraestructura y requisitos de SLA.
