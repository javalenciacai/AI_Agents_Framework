# 🐛 Debugging Guide - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Estrategia de Debugging](#estrategia-de-debugging)
- [Logging y Observabilidad](#logging-y-observabilidad)
- [Debugging por Servicios](#debugging-por-servicios)
- [Herramientas de Desarrollo](#herramientas-de-desarrollo)
- [Problemas Comunes](#problemas-comunes)
- [Performance Debugging](#performance-debugging)
- [Producción vs Desarrollo](#producción-vs-desarrollo)

---

## 🎯 Estrategia de Debugging

### **Niveles de Debugging**
```
🔴 ERROR    - Errores críticos que rompen funcionalidad
🟡 WARN     - Situaciones que requieren atención
🔵 INFO     - Información general del flujo
🟢 DEBUG    - Información detallada para desarrollo
🟣 TRACE    - Información muy detallada (solo desarrollo)
```

### **Principios de Debugging**
1. **Reproducibilidad**: Crear escenarios consistentes
2. **Observabilidad**: Logs estructurados y métricas
3. **Isolación**: Identificar el componente específico
4. **Instrumentación**: Herramientas de monitoreo activo

---

## 📊 Logging y Observabilidad

### **Configuración de Logger (Winston)**
```typescript
// src/utils/logger.ts
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json(),
    winston.format.printf(({ timestamp, level, message, service, correlationId, ...meta }) => {
      return JSON.stringify({
        timestamp,
        level,
        message,
        service: service || 'backupguard',
        correlationId,
        ...meta
      });
    })
  ),
  defaultMeta: { 
    service: process.env.SERVICE_NAME || 'unknown-service',
    version: process.env.APP_VERSION || '1.0.0'
  },
  transports: [
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' }),
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    })
  ]
});

export default logger;
```

### **Structured Logging Examples**
```typescript
// Logging de operaciones de backup
logger.info('Backup operation started', {
  clientId: 'client-123',
  backupType: 'incremental',
  estimatedSize: '2.4GB',
  correlationId: req.correlationId
});

// Logging de errores con contexto
logger.error('Database connection failed', {
  error: error.message,
  stack: error.stack,
  dbHost: process.env.DB_HOST,
  retryAttempt: 3,
  correlationId: req.correlationId
});

// Logging de métricas de performance
logger.info('Operation completed', {
  operation: 'backup-verification',
  duration: Date.now() - startTime,
  filesProcessed: 1547,
  bytesProcessed: 2567890123,
  correlationId: req.correlationId
});
```

### **Correlation ID Middleware**
```typescript
// src/middleware/correlation.middleware.ts
import { Request, Response, NextFunction } from 'express';
import { v4 as uuidv4 } from 'uuid';

export const correlationMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const correlationId = req.headers['x-correlation-id'] as string || uuidv4();
  
  req.correlationId = correlationId;
  res.setHeader('x-correlation-id', correlationId);
  
  // Agregar al contexto de logs
  req.logger = logger.child({ correlationId });
  
  next();
};
```

---

## 🏗️ Debugging por Servicios

### **API Gateway Debugging**
```typescript
// Debug de routing y autenticación
app.use('/api/*', (req, res, next) => {
  req.logger.debug('API Gateway routing', {
    method: req.method,
    originalUrl: req.originalUrl,
    userAgent: req.get('User-Agent'),
    clientIP: req.ip,
    authHeader: req.get('Authorization') ? 'present' : 'missing'
  });
  next();
});

// Debug de proxy a microservicios
const proxyMiddleware = createProxyMiddleware({
  target: process.env.USER_SERVICE_URL,
  changeOrigin: true,
  onProxyReq: (proxyReq, req, res) => {
    req.logger.debug('Proxying request to user-service', {
      targetUrl: proxyReq.getHeader('host'),
      path: proxyReq.path
    });
  },
  onError: (err, req, res) => {
    req.logger.error('Proxy error to user-service', {
      error: err.message,
      targetService: 'user-service'
    });
  }
});
```

### **Backup Monitor Service Debugging**
```typescript
// src/services/backup-monitor.service.ts
export class BackupMonitorService {
  async checkBackupStatus(clientId: string): Promise<BackupStatus> {
    const startTime = Date.now();
    
    try {
      logger.debug('Starting backup status check', { clientId });
      
      const client = await this.clientRepository.findById(clientId);
      if (!client) {
        logger.warn('Client not found for backup check', { clientId });
        throw new ClientNotFoundError(clientId);
      }
      
      const lastBackup = await this.backupRepository.findLatestByClient(clientId);
      logger.debug('Latest backup retrieved', { 
        clientId, 
        lastBackupId: lastBackup?.id,
        lastBackupDate: lastBackup?.timestamp 
      });
      
      const status = this.calculateStatus(lastBackup);
      
      logger.info('Backup status check completed', {
        clientId,
        status: status.health,
        duration: Date.now() - startTime
      });
      
      return status;
      
    } catch (error) {
      logger.error('Backup status check failed', {
        clientId,
        error: error.message,
        stack: error.stack,
        duration: Date.now() - startTime
      });
      throw error;
    }
  }
}
```

### **Database Debugging**
```typescript
// MongoDB query debugging
mongoose.set('debug', (collectionName: string, method: string, query: any, doc: any) => {
  logger.debug('MongoDB operation', {
    collection: collectionName,
    method,
    query: JSON.stringify(query),
    document: doc ? JSON.stringify(doc) : undefined,
    timestamp: new Date().toISOString()
  });
});

// Redis debugging
const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT || '6379'),
  lazyConnect: true,
  retryDelayOnFailover: 100,
  monitor: (error, result) => {
    if (error) {
      logger.error('Redis monitor error', { error: error.message });
    }
  }
});

redis.on('connect', () => {
  logger.info('Redis connected');
});

redis.on('error', (error) => {
  logger.error('Redis connection error', { error: error.message });
});
```

---

## 🛠️ Herramientas de Desarrollo

### **VS Code Debug Configuration**
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug API Gateway",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/services/api-gateway/src/index.ts",
      "env": {
        "NODE_ENV": "development",
        "LOG_LEVEL": "debug",
        "PORT": "8080"
      },
      "runtimeArgs": ["-r", "ts-node/register"],
      "console": "integratedTerminal",
      "restart": true,
      "protocol": "inspector"
    },
    {
      "name": "Debug Backup Monitor",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/services/backup-monitor/src/index.ts",
      "env": {
        "NODE_ENV": "development",
        "LOG_LEVEL": "trace",
        "PORT": "3002"
      },
      "runtimeArgs": ["-r", "ts-node/register"],
      "console": "integratedTerminal"
    },
    {
      "name": "Attach to Process",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "restart": true,
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app"
    }
  ]
}
```

### **Docker Debugging Setup**
```dockerfile
# Dockerfile.debug
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .

# Exponer puerto de debug
EXPOSE 9229

# Comando con debug habilitado
CMD ["node", "--inspect=0.0.0.0:9229", "-r", "ts-node/register", "src/index.ts"]
```

```yaml
# docker-compose.debug.yml
services:
  api-gateway:
    build:
      context: ./services/api-gateway
      dockerfile: Dockerfile.debug
    ports:
      - "8080:8080"
      - "9229:9229"  # Debug port
    environment:
      - NODE_ENV=development
      - LOG_LEVEL=debug
    volumes:
      - ./services/api-gateway:/app
      - /app/node_modules
```

### **HTTP Debugging con cURL**
```bash
# Debug de autenticación
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -H "x-correlation-id: debug-123" \
  -d '{"email": "admin@backupguard.pro", "password": "test123"}' \
  -v

# Debug de backup status
curl -X GET http://localhost:8080/api/v1/backups/status/client-123 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "x-correlation-id: debug-456" \
  -v

# Debug con response time
curl -w "@curl-format.txt" -s -o /dev/null \
  http://localhost:8080/api/v1/health

# curl-format.txt
     time_namelookup:  %{time_namelookup}s\n
        time_connect:  %{time_connect}s\n
     time_appconnect:  %{time_appconnect}s\n
    time_pretransfer:  %{time_pretransfer}s\n
       time_redirect:  %{time_redirect}s\n
  time_starttransfer:  %{time_starttransfer}s\n
                     ----------\n
          time_total:  %{time_total}s\n
```

---

## ⚠️ Problemas Comunes

### **1. Connection Timeouts**
```typescript
// Debugging timeouts
const httpClient = axios.create({
  timeout: 30000,
  validateStatus: (status) => status < 500
});

httpClient.interceptors.request.use((config) => {
  config.metadata = { startTime: Date.now() };
  logger.debug('HTTP request started', {
    method: config.method,
    url: config.url,
    timeout: config.timeout
  });
  return config;
});

httpClient.interceptors.response.use(
  (response) => {
    const duration = Date.now() - response.config.metadata.startTime;
    logger.debug('HTTP request completed', {
      method: response.config.method,
      url: response.config.url,
      status: response.status,
      duration
    });
    return response;
  },
  (error) => {
    if (error.code === 'ECONNABORTED') {
      logger.error('HTTP request timeout', {
        method: error.config?.method,
        url: error.config?.url,
        timeout: error.config?.timeout
      });
    }
    return Promise.reject(error);
  }
);
```

### **2. Memory Leaks**
```typescript
// Memory debugging helper
const memoryUsage = () => {
  const usage = process.memoryUsage();
  logger.debug('Memory usage', {
    rss: `${Math.round(usage.rss / 1024 / 1024)} MB`,
    heapTotal: `${Math.round(usage.heapTotal / 1024 / 1024)} MB`,
    heapUsed: `${Math.round(usage.heapUsed / 1024 / 1024)} MB`,
    external: `${Math.round(usage.external / 1024 / 1024)} MB`
  });
};

// Monitorear memoria cada 30 segundos
setInterval(memoryUsage, 30000);

// Detectar event loop lag
const startTime = process.hrtime();
setImmediate(() => {
  const delta = process.hrtime(startTime);
  const lag = delta[0] * 1000 + delta[1] * 1e-6;
  if (lag > 100) {
    logger.warn('Event loop lag detected', { lag: `${lag.toFixed(2)}ms` });
  }
});
```

### **3. Database Connection Issues**
```typescript
// MongoDB connection debugging
mongoose.connection.on('connected', () => {
  logger.info('MongoDB connected', {
    host: mongoose.connection.host,
    port: mongoose.connection.port,
    name: mongoose.connection.name
  });
});

mongoose.connection.on('error', (error) => {
  logger.error('MongoDB connection error', {
    error: error.message,
    stack: error.stack
  });
});

mongoose.connection.on('disconnected', () => {
  logger.warn('MongoDB disconnected');
});

// Health check con timeout
const healthCheck = async () => {
  const timeout = 5000;
  const start = Date.now();
  
  try {
    await Promise.race([
      mongoose.connection.db.admin().ping(),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('Health check timeout')), timeout)
      )
    ]);
    
    logger.debug('Database health check passed', {
      duration: Date.now() - start
    });
  } catch (error) {
    logger.error('Database health check failed', {
      error: error.message,
      duration: Date.now() - start
    });
  }
};
```

---

## ⚡ Performance Debugging

### **APM Integration (ejemplo con New Relic)**
```typescript
// newrelic.js
'use strict'

exports.config = {
  app_name: ['BackupGuard Pro'],
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  logging: {
    level: 'info'
  },
  allow_all_headers: true,
  attributes: {
    exclude: [
      'request.headers.cookie',
      'request.headers.authorization',
      'request.headers.proxyAuthorization',
      'request.headers.setCookie*',
      'request.headers.x*',
      'response.headers.cookie',
      'response.headers.authorization',
      'response.headers.proxyAuthorization',
      'response.headers.setCookie*'
    ]
  }
}
```

### **Custom Performance Metrics**
```typescript
// src/utils/metrics.ts
import { performance } from 'perf_hooks';

export class PerformanceTracker {
  private static marks: Map<string, number> = new Map();

  static start(operation: string): void {
    this.marks.set(operation, performance.now());
  }

  static end(operation: string): number {
    const start = this.marks.get(operation);
    if (!start) {
      logger.warn('Performance tracking: operation not started', { operation });
      return 0;
    }

    const duration = performance.now() - start;
    this.marks.delete(operation);

    logger.info('Performance metric', {
      operation,
      duration: `${duration.toFixed(2)}ms`,
      timestamp: new Date().toISOString()
    });

    return duration;
  }

  static measure<T>(operation: string, fn: () => Promise<T>): Promise<T> {
    return new Promise(async (resolve, reject) => {
      this.start(operation);
      try {
        const result = await fn();
        this.end(operation);
        resolve(result);
      } catch (error) {
        this.end(operation);
        reject(error);
      }
    });
  }
}

// Uso:
await PerformanceTracker.measure('backup-verification', async () => {
  return await this.verifyBackupIntegrity(backupId);
});
```

---

## 🌍 Producción vs Desarrollo

### **Environment-specific Debugging**
```typescript
// src/config/debug.config.ts
export const debugConfig = {
  development: {
    logLevel: 'debug',
    enableVerboseErrors: true,
    enableCORS: true,
    enableMockData: true
  },
  staging: {
    logLevel: 'info',
    enableVerboseErrors: true,
    enableCORS: false,
    enableMockData: false
  },
  production: {
    logLevel: 'warn',
    enableVerboseErrors: false,
    enableCORS: false,
    enableMockData: false
  }
}[process.env.NODE_ENV || 'development'];
```

### **Error Handling Differences**
```typescript
// Error handler para diferentes entornos
export const errorHandler = (error: Error, req: Request, res: Response, next: NextFunction) => {
  const correlationId = req.correlationId;
  
  logger.error('Unhandled error', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    correlationId
  });

  if (debugConfig.enableVerboseErrors) {
    // Desarrollo/Staging: Retornar detalles completos
    res.status(500).json({
      error: error.message,
      stack: error.stack,
      correlationId,
      timestamp: new Date().toISOString()
    });
  } else {
    // Producción: Retornar error genérico
    res.status(500).json({
      error: 'Internal server error',
      correlationId,
      timestamp: new Date().toISOString()
    });
  }
};
```

---

## 🔧 Scripts de Debugging

### **Package.json Scripts**
```json
{
  "scripts": {
    "debug": "NODE_ENV=development LOG_LEVEL=debug nodemon --inspect=0.0.0.0:9229 src/index.ts",
    "debug:break": "NODE_ENV=development LOG_LEVEL=trace nodemon --inspect-brk=0.0.0.0:9229 src/index.ts",
    "logs:follow": "tail -f logs/combined.log | jq .",
    "logs:errors": "tail -f logs/error.log | jq .",
    "health:check": "curl -s http://localhost:8080/health | jq .",
    "memory:dump": "kill -USR2 $(pgrep -f 'node.*index.ts')"
  }
}
```

---

## 📚 Herramientas Recomendadas

### **Debugging Tools**
- **Node.js Inspector**: Debug nativo de Node.js
- **Chrome DevTools**: Para debugging visual
- **Winston**: Logging estructurado
- **Morgan**: HTTP request logging
- **clinic.js**: Performance profiling
- **0x**: Flame graphs para Node.js

### **Monitoring Tools**
- **Grafana**: Dashboards de métricas
- **Prometheus**: Métricas y alertas
- **Jaeger**: Distributed tracing
- **ELK Stack**: Logs centralizados
- **New Relic/DataDog**: APM completo

---

> **💡 Nota**: Esta guía es parte del ejemplo BackupGuard Pro y demuestra una estrategia completa de debugging para aplicaciones de microservicios en producción.
