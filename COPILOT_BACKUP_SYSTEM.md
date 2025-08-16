# Copilot Interaction Guidelines for "Sistema de Monitoreo y Gestión de Copias de Seguridad"

Este documento proporciona las directrices para interactuar con GitHub Copilot en el desarrollo del sistema BackupGuard Pro.

## 🎯 Proyecto: BackupGuard Pro

Sistema automatizado de monitoreo y gestión de copias de seguridad con arquitectura de microservicios, diseñado para ser viral en internet con instalación one-click.

## 🗣️ Idioma de Comunicación

**IMPORTANTE**: Todas las interacciones deben ser en **español (variante latinoamericana)**.

## 👥 Roles y Responsabilidades

Al trabajar en este proyecto, Copilot debe asumir estos roles:

### 🔧 Desarrollador Experto
- Escribir código TypeScript/Node.js de alta calidad
- Seguir principios SOLID y Clean Architecture
- Implementar patrones de microservicios
- Aplicar mejores prácticas de seguridad

### 📋 Product Owner
- Entender los objetivos de negocio del sistema viral
- Asegurar que las funcionalidades cumplan con la visión del producto
- Priorizar características que faciliten la adopción masiva

### 🧪 QA Engineer
- Identificar casos edge y problemas potenciales
- Crear tests comprehensivos (unit, integration, E2E)
- Validar la experiencia de usuario

## 🏗️ Stack Tecnológico

### Backend (Microservicios)
```typescript
// Tecnologías principales
const stack = {
  runtime: "Node.js 18+",
  language: "TypeScript",
  framework: "Express.js",
  database: "MongoDB",
  cache: "Redis",
  queue: "RabbitMQ",
  auth: "JWT + Refresh Tokens",
  validation: "Zod",
  orm: "Mongoose",
  websockets: "Socket.io"
};
```

### Frontend (Microfrontends)
```typescript
const frontendStack = {
  framework: "React 18",
  language: "TypeScript",
  bundler: "Vite",
  styling: "Tailwind CSS + Radix UI",
  state: "Zustand + React Query",
  routing: "React Router",
  realtime: "Socket.io-client"
};
```

### DevOps & Infraestructura
```yaml
infrastructure:
  containers: "Docker"
  orchestration: "Kubernetes"
  cicd: "GitHub Actions"
  monitoring: "Prometheus + Grafana"
  logging: "ELK Stack"
  cloud: "Multi-cloud (AWS/Azure/GCP)"
```

## 🏛️ Arquitectura de Microservicios

### Servicios Core
1. **API Gateway** (Puerto 8080)
   - Routing y load balancing
   - Autenticación centralizada
   - Rate limiting
   - Circuit breaker

2. **User Service** (Puerto 3001)
   - Gestión de usuarios y organizaciones
   - Autenticación JWT
   - Roles y permisos

3. **Backup Monitor Service** (Puerto 3002)
   - Monitoreo de copias de seguridad
   - Validación de integridad
   - WebSocket para tiempo real

4. **Notification Service** (Puerto 3003)
   - Email, SMS, push notifications
   - Templates personalizables
   - Queue processing

5. **Report Service** (Puerto 3004)
   - Generación de reportes
   - Exportación PDF/Excel
   - Scheduling automático

6. **Config Service** (Puerto 3005)
   - Gestión de configuraciones
   - Reglas de negocio
   - Feature flags

### Estructura de Directorios
```
/services
  /api-gateway/
  /user-service/
  /backup-monitor-service/
  /notification-service/
  /report-service/
  /config-service/
/frontends
  /admin-dashboard/
  /user-portal/
  /installer-app/
/shared
  /types/
  /utils/
  /schemas/
```

## 🔐 Seguridad y Autenticación

### JWT Strategy
```typescript
interface AuthTokens {
  accessToken: string;  // 15 minutos
  refreshToken: string; // 30 días
}

interface UserPayload {
  id: string;
  organizationId: string;
  role: 'admin' | 'operator' | 'viewer';
  permissions: string[];
}
```

### Middleware de Autenticación
```typescript
const authMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  // Validación JWT
  // Verificación de permisos
  // Rate limiting por usuario
};
```

## 📊 Modelo de Datos

### Entidades Principales
```typescript
interface Organization {
  _id: ObjectId;
  name: string;
  domain: string;
  plan: 'free' | 'premium' | 'enterprise';
  settings: OrganizationSettings;
  createdAt: Date;
}

interface Machine {
  _id: ObjectId;
  organizationId: ObjectId;
  name: string;
  hostname: string;
  osType: 'windows' | 'linux' | 'macos';
  agentVersion: string;
  status: 'online' | 'offline' | 'warning' | 'error';
  lastHeartbeat: Date;
}

interface BackupExecution {
  _id: ObjectId;
  machineId: ObjectId;
  startTime: Date;
  endTime?: Date;
  status: 'running' | 'completed' | 'failed';
  filesCount: number;
  totalSize: number;
  checksum: string;
}
```

## 🚀 Características del Sistema Viral

### Instalación One-Click
- Installer executable de < 10MB
- Auto-detección de configuraciones existentes
- Setup completo en < 2 minutos
- Zero-configuration para usuarios básicos

### Modelo Freemium
```typescript
const planLimits = {
  free: {
    maxMachines: 3,
    maxUsers: 1,
    reportFrequency: 'weekly',
    support: 'community'
  },
  premium: {
    maxMachines: 50,
    maxUsers: 10,
    reportFrequency: 'daily',
    support: 'email'
  },
  enterprise: {
    maxMachines: 'unlimited',
    maxUsers: 'unlimited',
    reportFrequency: 'real-time',
    support: 'priority'
  }
};
```

## 📝 Convenciones de Desarrollo

### Naming Conventions
```typescript
// Archivos y carpetas: kebab-case
// user-service/
// backup-monitor.controller.ts

// Variables y funciones: camelCase
const backupStatus = 'completed';
function validateBackupIntegrity() {}

// Tipos e interfaces: PascalCase
interface BackupExecution {}
type BackupStatus = 'running' | 'completed' | 'failed';

// Constantes: UPPER_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3;
```

### Error Handling
```typescript
class BackupServiceError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'BackupServiceError';
  }
}

// Uso consistente de try-catch
try {
  const result = await backupService.validateIntegrity(file);
  return result;
} catch (error) {
  logger.error('Backup validation failed', { error, fileId: file.id });
  throw new BackupServiceError(
    'Failed to validate backup integrity',
    'VALIDATION_FAILED',
    422
  );
}
```

### Testing Strategy
```typescript
// Tests unitarios: *.test.ts
describe('BackupValidator', () => {
  it('should validate backup integrity successfully', async () => {
    // Arrange
    const mockFile = createMockBackupFile();
    
    // Act
    const result = await validator.validate(mockFile);
    
    // Assert
    expect(result.isValid).toBe(true);
  });
});

// Tests de integración: *.integration.test.ts
// Tests E2E: *.e2e.test.ts
```

## 🔧 Comandos de Desarrollo

### Scripts NPM
```bash
# Desarrollo local
npm run dev                    # Todos los servicios
npm run dev:user              # Solo user service
npm run dev:backup            # Solo backup service

# Testing
npm run test                  # Tests unitarios
npm run test:integration      # Tests de integración
npm run test:e2e             # Tests end-to-end

# Build y Deploy
npm run build                 # Build todos los servicios
npm run docker:build         # Build containers
npm run docker:up            # Start stack completo
```

## 📈 Métricas y Observabilidad

### Prometheus Metrics
```typescript
const metrics = {
  backupsTotal: new Counter('backups_total'),
  backupDuration: new Histogram('backup_duration_seconds'),
  machinesOnline: new Gauge('machines_online_count'),
  apiRequestDuration: new Histogram('api_request_duration_seconds')
};
```

### Logging Structure
```typescript
const logger = winston.createLogger({
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  defaultMeta: {
    service: 'backup-monitor-service',
    version: process.env.npm_package_version
  }
});

logger.info('Backup validation completed', {
  machineId: 'machine-123',
  backupId: 'backup-456',
  duration: 1200,
  filesCount: 150
});
```

## 🎯 Criterios de Quality Gates

### Definition of Ready (DoR)
- [ ] Historia de usuario clara y bien definida
- [ ] Criterios de aceptación específicos y testeable
- [ ] Dependencias identificadas y resueltas
- [ ] Diseño de API documentado
- [ ] Casos de prueba definidos

### Definition of Done (DoD)
- [ ] Código implementado siguiendo estándares
- [ ] Tests unitarios con cobertura > 80%
- [ ] Tests de integración pasando
- [ ] Code review aprobado
- [ ] Documentación actualizada
- [ ] Métricas y logs implementados
- [ ] Funcionalidad validada en staging

## 🚨 Alertas y Monitoring

### SLA Targets
```typescript
const slaTargets = {
  uptime: '99.9%',
  apiResponseTime: '< 200ms',
  backupDetectionTime: '< 5 minutes',
  notificationDelivery: '< 2 minutes'
};
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow
```yaml
name: CI/CD Pipeline
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm run test:coverage
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## 📚 Recursos y Referencias

### Documentación Interna
- [Arquitectura del Sistema](./docs/architecture/)
- [API Reference](./docs/api/)
- [Guía de Desarrollo](./docs/development/)
- [Manual de Usuario](./docs/user_guide/)

### Metodología
- **Shape Up**: Para gestión de proyectos
- **Conventional Commits**: Para mensajes de commit
- **Semantic Versioning**: Para versionado de releases

---

**Recordatorio**: Mantener este documento actualizado con cada cambio significativo en el proyecto. Al seguir estas directrices, Copilot puede proporcionar asistencia más efectiva y contextualizada para el desarrollo de BackupGuard Pro.
