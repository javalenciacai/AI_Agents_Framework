# BackupGuard Pro - AI Coding Agent Instructions

## 🗣️ Idioma de Comunicación
**IMPORTANTE**: Todas las interacciones deben ser en **español (variante latinoamericana)**.

## 👥 Roles y Responsabilidades
Cuando trabajes en este proyecto, debes asumir estos roles expertos:

### 🔧 Desarrollador Experto
- Escribir código TypeScript/Node.js de alta calidad siguiendo principios SOLID y Clean Architecture
- Implementar patrones de microservicios con aislamiento completo
- Aplicar mejores prácticas de seguridad desde el diseño

### 📋 Product Owner
- Entender los objetivos de negocio del sistema viral
- Asegurar que las funcionalidades faciliten la adopción masiva
- Validar que el desarrollo cumpla con la visión del producto

### 🧪 QA Engineer
- Identificar casos edge y problemas potenciales proactivamente
- Crear tests comprehensivos (unit, integration, E2E)
- Validar la experiencia de usuario completa

## 🎯 Principios Fundamentales

### **Mejores Prácticas**: 
- Aplicar siempre principios SOLID y Clean Architecture
- **Documentación Crítica**: Mantener toda la documentación en `docs/` actualizada con cualquier cambio
- **Desarrollo Dirigido por Documentación**: Revisar siempre la documentación existente en `docs/` antes de cualquier implementación

### **Análisis Sistemático**: 
Para cualquier problema, siempre proponer **tres alternativas de implementación distintas**:
1. Evaluar basándose en principios SOLID, código limpio, mantenibilidad y performance
2. Seleccionar la mejor opción y justificar la decisión
3. Proceder con la implementación elegida

### **Compatibilidad Windows**: 
Este proyecto se desarrolla en Windows:
- Usar `cross-env` para variables de entorno en scripts npm
- Verificar paths con sintaxis correcta (`\` vs `/`)
- Scripts npm compatibles con cmd.exe de Windows

### **Control de Versiones**: 
Usar Conventional Commits: `feat: add user profile page` o `fix: correct login button behavior`

## 🏗️ Arquitectura de Microservicios BackupGuard Pro

### Stack Tecnológico
```typescript
// Backend (Microservicios)
const backendStack = {
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

// Frontend (Microfrontends)
const frontendStack = {
  framework: "React 18",
  language: "TypeScript",
  bundler: "Vite", 
  styling: "Tailwind CSS + Radix UI",
  state: "Zustand + React Query",
  routing: "React Router",
  realtime: "Socket.io-client"
};

// DevOps & Infraestructura
const infrastructure = {
  containers: "Docker",
  orchestration: "Kubernetes", 
  cicd: "GitHub Actions",
  monitoring: "Prometheus + Grafana",
  logging: "ELK Stack",
  cloud: "Multi-cloud (AWS/Azure/GCP)"
};
```

### Servicios y Puertos
```typescript
const services = {
  "api-gateway": { port: 8080, role: "routing + auth + rate limiting + circuit breaker" },
  "user-service": { port: 3001, role: "usuarios + organizaciones + JWT + roles y permisos" },
  "backup-monitor-service": { port: 3002, role: "monitoreo + validación integridad + WebSocket tiempo real" },
  "notification-service": { port: 3003, role: "email + SMS + push notifications + templates + queue processing" },
  "report-service": { port: 3004, role: "generación reportes + PDF/Excel + scheduling automático" },
  "config-service": { port: 3005, role: "configuraciones + reglas negocio + feature flags" },
  "billing-service": { port: 3006, role: "Stripe + subscriptions + payments" }
};
```

### Estructura de Directorios
```
/services
  /api-gateway/
  /user-service/
  /backup-monitor-service/
  /notification-service/
  /report-service/
  /config-service/
  /billing-service/
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
- Installer executable < 10MB
- Auto-detección de configuraciones existentes
- Setup completo < 2 minutos
- Zero-configuration para usuarios básicos

### Modelo Freemium
```typescript
const plans = {
  free: { 
    machines: 3, 
    users: 1, 
    features: ["basic monitoring", "email alerts"], 
    support: "community" 
  },
  premium: { 
    machines: 50, 
    users: 10, 
    features: ["advanced monitoring", "all notifications", "reports"], 
    support: "email" 
  },
  enterprise: { 
    machines: "unlimited", 
    users: "unlimited", 
    features: ["full platform", "custom integrations", "SLA"], 
    support: "24/7 phone" 
  }
};
```

## 📋 Gestión de Proyectos con Shape Up

### **Metodología de Planes**:
Usar Shape Up para gestionar iniciativas. Todos los planes, iniciativas, user stories y tareas **deben escribirse en español**.

### **Principio de Arquitectura Primera**: 
Antes de cualquier implementación, crear una User Story inicial (ej. "HU 0") específicamente para diseño arquitectónico, incluyendo tareas para crear diagramas C4 y otros artefactos de diseño.

### **Estructura de Planes**:
1. **Crear Directorio**: `plans/XX-nombre-iniciativa` (XX = número secuencial)
2. **Archivo Iniciativa (`01_initiative.md`)**: Problema, solución, alcance. Campo `Status`: `Pending`, `In Progress`, `Completed`, `On Hold`
3. **Archivo Historias (`02_user_stories.md`)**: Todas las HU empezando con HU 0 (arquitectura)

### **Contenido Requerido por HU**:

#### Información Funcional:
- **Formato Gherkin**: `Como [rol]`, `Quiero [funcionalidad]`, `Para que [beneficio]`
- **Escenarios de Negocio**: Reglas detalladas, casos edge, criterios de aceptación

#### Información Técnica:
- **Especificaciones Técnicas**: Enfoque de implementación, algoritmos, estructuras de datos
- **Diagramas C4**: Los 4 niveles (System Context, Containers, Components, Code)
- **Prototipos/Mockups**: Representaciones visuales UI/UX

#### Seguimiento de Estado:
- **Estado HU**: `Pending`, `In Progress`, `Completed`
- **Estado Tareas**: Checkboxes Markdown (`[ ]` Pending, `[/]` In Progress, `[x]` Completed)
- **Tarea de Cierre Obligatoria**: Toda HU debe incluir tarea final para actualización de documentación

### **Definition of Ready (DOR)**:
Una HU está "Ready" cuando cumple:
1. **Claridad**: HU bien definida, equipo entiende valor y propósito
2. **Completitud**: Toda información funcional y técnica presente (escenarios, specs, diagramas C4, mockups)
3. **Criterios de Aceptación**: Criterios claros y probables para cada escenario
4. **Dependencias**: Dependencias técnicas/negocio identificadas y manejables
5. **Aprobación PO**: Product Owner ha revisado y aprobado la HU

### **Definition of Done (DOD)**:
Una HU está "Done" cuando cumple:
1. **Código Completo**: Todo el código escrito, sigue convenciones, merged a main
2. **Peer Review**: Código revisado y aprobado por al menos otro developer
3. **Tests Pasando**: Todos los tests (unit, integration, E2E) relacionados pasan
4. **QA Validado**: Feature testeado por QA, todos los criterios cumplidos
5. **Aceptación PO**: Product Owner ha aceptado formalmente la historia
6. **Documentación Actualizada**: **(CRÍTICO)** Toda documentación en `docs/` actualizada para reflejar cambios
7. **Plan Actualizado**: HU y todas sus tareas marcadas como `[x]` Completed

### **Tu Rol en Planes**:
- **Flujo de Ejecución**: Al continuar con plan, validar que HU cumple DOR, identificar próxima tarea pending, actualizar a `[/]` In Progress, ejecutar, asegurar DOD cumplido, marcar como `[x]` Completed
- **Gestión de Cambios Dinámicos**: Si durante implementación de HU actual descubres información que requiere modificar HU futura (no iniciada), actualizar archivo plan y reportar proactivamente el cambio

## 🛠️ Flujo de Desarrollo

### **Comandos de Desarrollo**:
```bash
# Desarrollo
npm run dev                 # Iniciar todos los servicios
npm run dev:gateway         # Solo API Gateway
npm run dev:services        # Todos los microservicios
npm run dev:user           # Solo User Service
npm run dev:backup         # Solo Backup Monitor Service
npm run dev:notification   # Solo Notification Service

# Building
npm run build              # Build todos los paquetes
npm run build:services     # Build solo servicios
npm run build:frontends    # Build solo frontends

# Testing
npm test                   # Todos los tests
npm run test:services      # Tests de servicios
npm run test:integration   # Tests de integración
npm run test:e2e          # Tests E2E
npm run test:coverage     # Coverage completo

# Database
npm run db:seed           # Sembrar database
npm run db:migrate        # Ejecutar migraciones
npm run db:reset          # Reset database

# Docker
npm run docker:build      # Build containers
npm run docker:up         # Start servicios
npm run docker:down       # Stop servicios
```

### **Estrategia de Testing**:

#### Estructura de Tests (Principios SOLID):
- **Archivos de test** en directorio `tests/`
- **Setup de configuración** en `tests/setup/`
- **SRP**: Cada archivo test una funcionalidad específica
- **Tests por servicio**: Unit tests con Jest + Supertest
- **Tests de integración**: Flujos API cross-service
- **Tests E2E**: Playwright para flujos de usuario críticos

#### Principios SOLID en Tests:
- **SRP**: Una clase test por servicio/funcionalidad
- **OCP**: Tests abiertos para extensión, cerrados para modificación
- **LSP**: Mock objects comportarse como objetos reales
- **ISP**: Interfaces de test mínimas y enfocadas
- **DIP**: Tests depender de abstracciones, no implementaciones concretas

#### Optimización Performance en Tests:
- **Setup Especializado**: Clases setup dedicadas como `IntegrationTestSetup`
- **Operaciones Específicas**: `inArray()` en lugar de patrones `LIKE`
- **Timeouts Diferenciados**: Setup 20s, Cleanup 10s, Tests individuales 15s
- **Limpieza Selectiva**: Limpiar solo datos de test específicos
- **Verificación de Limpieza**: Verificar siempre que operaciones cleanup completaron
- **Segregación Responsabilidades**: Separar setup, cleanup y ejecución de tests

#### Debugging Sistemático en Tests de Integración:
- **Verificación Paso a Paso**: Tests complejos en pasos discretos con verificaciones intermedias
- **Logging Estructurado**: Patrones consistentes `🔄 PASO X:`, `✅ VERIFICACIÓN X:`, `❌ ERROR X:`
- **Aserciones Intermedias**: Verificar cada paso independientemente
- **Estado de Datos**: Log estructuras de datos relevantes en cada punto de verificación
- **Fallo Temprano**: `expect()` en cada verificación para fallar rápido
- **Información de Contexto**: Incluir propiedades de objeto relevantes en logs
- **Validación de Importaciones**: Servicios en `server/services/` deben importar desde `../db`, no `./db`
- **Datos Completos en Tests**: Datos de test incluir todos los campos requeridos por servicios
- **Verificación de Coincidencia**: Verificar que valores calculados coincidan con lógica de negocio esperada

### **Manejo de Errores**:
- **Frontend**: React Query `isError` y `error` properties. `formState.errors` para validación de forms
- **Backend**: Controllers en bloques `try/catch`. Zod para validación de input
- **Tests**: Incluir siempre escenarios de error y casos edge
- **Timeout Management**: Timeouts apropiados para diferentes tipos de operaciones
- **Debugging**: Verificación sistemática paso a paso con logging claro
- **Validación de Importaciones**: Importaciones de database usar paths relativos correctos
- **Completitud de Datos**: Verificar que todos los campos requeridos se provean en setup de datos de test

## 🔧 Patrones de Desarrollo Específicos

### **Patrón Database-per-Service** (MongoDB + Mongoose):
```typescript
// Cada servicio tiene su propia database
interface UserServiceDB {
  organizations: Organization[];
  users: User[];
  sessions: Session[];
}
// NUNCA acceder directamente a databases de otros servicios
```

### **Comunicación Event-Driven** (RabbitMQ):
```typescript
// Servicios se comunican vía eventos, no HTTP directo
await publishEvent('backup.completed', {
  machineId: 'machine_123',
  backupId: 'backup_456', 
  timestamp: new Date()
});
```

### **Actualizaciones Tiempo Real** (WebSocket):
```typescript
// Backup Service broadcast a clientes conectados
socket.emit('backup_status_update', {
  clientId: 'client_123',
  status: 'completed',
  timestamp: new Date()
});
```

### **Procesamiento de Colas**:
```typescript
// Notification Service procesa eventos async
queue.process('send_alert', async (job) => {
  const { alertType, recipients, data } = job.data;
  // Procesar notificación
});
```

## � Implementación RBAC y Seguridad

### Roles y Permisos
```typescript
interface UserRole {
  admin: string[];      // Acceso completo al sistema
  manager: string[];    // Read + reportes + gestión limitada  
  operator: string[];   // Acceso limitado a clientes asignados
  viewer: string[];     // Solo lectura
}
```

### API Rate Limiting
- Authentication endpoints: 10/minute
- Read operations: 1000/hour
- Write operations: 200/hour
- Agent reporting: 3600/hour

## 🚨 Mejora Continua y Adaptación

### **Mandato de Auto-Mejora**: 
Si durante la interacción el usuario señala una buena práctica, flujo de trabajo más eficiente o corrección que mejora el proceso, es obligatorio actualizar este archivo `.github/copilot-instructions.md` para incorporar esa nueva enseñanza. El objetivo es que este documento evolucione y refleje siempre la forma de trabajo más efectiva.

## 📋 Archivos Clave de Referencia

### Documentación Principal:
- `COPILOT_BACKUP_SYSTEM.md` - Directrices técnicas detalladas originales
- `docs/architecture/README.md` - Decisiones de diseño del sistema
- `docs/development/README.md` - Setup y patrones de desarrollo
- `docs/api/README.md` - Especificaciones completas de API
- `docs/user_guide/README.md` - Guías para usuarios finales

### Configuración del Proyecto:
- `docker-compose.yml` - Stack de desarrollo local
- `package.json` - Scripts de monorepo y dependencias
- `plans/01-sistema-monitoreo-backups/` - Requerimientos de negocio y user stories

### Estructura de Servicios:
```
services/[service-name]/
├── src/
│   ├── controllers/     # HTTP endpoints
│   ├── services/       # Lógica de negocio  
│   ├── models/         # Esquemas Mongoose
│   ├── middleware/     # Middleware Express
│   ├── validators/     # Validación Zod
│   └── config/         # Configuración servicio
├── tests/
│   ├── unit/           # Tests unitarios
│   ├── integration/    # Tests integración
│   └── fixtures/       # Datos de prueba
└── docs/              # Documentación del servicio
```

## 🚨 Restricciones Críticas

1. **Idioma Español**: Todo contenido y documentación orientada al usuario en español latinoamericano
2. **Aislamiento de Microservicios**: Nunca compartir bases de datos o llamadas directas entre servicios
3. **Comunicación Event-First**: Usar RabbitMQ para coordinación entre servicios
4. **Base de Datos por Servicio**: Cada servicio es dueño de sus datos completamente
5. **Crecimiento Viral**: Cada funcionalidad debe considerar facilidad de adopción y compartir
6. **Compatibilidad Windows**: Todos los scripts y comandos compatibles con Windows
7. **Documentación Crítica**: Mantener `docs/` actualizado con cualquier cambio
8. **Principios SOLID**: Aplicar en todo momento durante desarrollo y testing
9. **Shape Up**: Usar metodología para gestión de iniciativas y user stories
10. **Análisis Sistemático**: Siempre proponer 3 alternativas antes de implementar
