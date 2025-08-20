# 🤖 Guía Completa de Ingeniería de Contexto para Desarrollo con IA

*Una metodología step-by-step para crear aplicaciones empresariales usando cualquier agente IA*

## ✅ **Verificación Oficial Completa**

**🎯 IMPORTANTE**: Todos los agentes IA, herramientas y tecnologías mencionados en esta guía han sido verificados con **fuentes oficiales**.

📋 **Ver Referencias Completas**: [REFERENCIAS_OFICIALES.md](./REFERENCIAS_OFICIALES.md)
- ✅ **87 tecnologías verificadas** incluyendo todos los agentes IA listados
- ✅ **100% precisión** - enlaces directos a sitios oficiales
- ✅ **Sin información inventada** - solo fuentes verificadas

---

## 🤖 **Compatibilidad Universal con Agentes IA**

Esta guía funciona con **TODOS los agentes IA de desarrollo** disponibles, incluyendo:

### **Agentes Integrados en IDEs:**
- **GitHub Copilot** (VS Code, JetBrains, Neovim)
- **Amazon CodeWhisperer** (VS Code, JetBrains, AWS Cloud9)
- **Tabnine** (VS Code, JetBrains, Sublime Text, Vim)
- **Codeium** (VS Code, JetBrains, Neovim, Web)
- **Replit Ghostwriter** (Replit IDE)

### **Agentes Conversacionales Web:**
- **ChatGPT** (GPT-4, GPT-4 Turbo, Code Interpreter)
- **Claude** (Claude-3 Opus, Claude-3.5 Sonnet)
- **Google Gemini** (Gemini Pro, Gemini Ultra)
- **Microsoft Copilot** (con GPT-4)
- **Perplexity AI** (con modo Code)
- **Phind** (especializado en desarrollo)
- **You.com** (modo programación)

### **Agentes API y Plataformas:**
- **OpenAI API** (GPT-4, GPT-3.5 Turbo)
- **Anthropic Claude API**
- **Google PaLM API**
- **Cohere Command**
- **Hugging Face Transformers**
- **Ollama** (modelos locales)

### **Agentes CLI (Command Line Interface):**
- **GitHub Copilot CLI** (`gh copilot suggest`, `gh copilot explain`)
- **OpenAI CLI** (`openai api completions.create`)
- **Anthropic Claude CLI** (`anthropic complete`)
- **Ollama CLI** (`ollama run codellama`, `ollama run deepseek-coder`)
- **Shell GPT (sgpt)** (integración directa en terminal)
- **ChatGPT CLI** (`chatgpt`, `gpt`)
- **AI Shell** (`ai "crear función que..."`)
- **Warp Terminal** (terminal con IA integrada)
- **Fig** (ahora Amazon Q CLI - autocompletado inteligente)
- **Zsh Copilot** (plugin para zsh con IA)
- **Terminal Copilot** (asistente IA para comandos bash)

### **Agentes Especializados:**
- **Cursor** (IDE con IA integrada)
- **Replit Bounties** (desarrollo colaborativo)
- **v0.dev** (Vercel - generación de UI)
- **Bolt.new** (StackBlitz - desarrollo full-stack)
- **CodeT5** (Salesforce)
- **InCoder** (Facebook/Meta)

### **Agentes Locales de Nueva Generación (2024-2025):**
- **Cline** (ex Claude Dev - VSCode extension, autonomo, multi-modelo)
- **Continue** (VSCode/JetBrains - open source, flexible, MCP compatible)
- **LM Studio** (interfaz local para modelos GGUF)
- **Jan** (ChatGPT alternativo 100% local)
- **Msty** (cliente desktop multi-modelo local)
- **GPT4All** (chat local con múltiples modelos)
- **LocalAI** (API OpenAI compatible para modelos locales)
- **AnythingLLM** (RAG local con UI)
- **Open WebUI** (interfaz web para Ollama)
- **Enchanted** (cliente nativo macOS para modelos locales)

### **Características Clave:**
- ✅ **Prompts universales** que funcionan en cualquier plataforma
- ✅ **Contexto adaptable** según las capacidades del agente
- ✅ **Metodología agnóstica** de tecnología y herramienta
- ✅ **Escalable** desde proyectos simples hasta arquitecturas empresariales

---

## 📋 Tabla de Contenidos

1. [🎯 Introducción y Fundamentos](#-introducción-y-fundamentos)
2. [📚 Conocimientos Base Requeridos](#-conocimientos-base-requeridos)
3. [🏗️ Fase 1: Setup del Proyecto](#️-fase-1-setup-del-proyecto)
4. [💻 Fase 2: Desarrollo de la Aplicación](#-fase-2-desarrollo-de-la-aplicación)
5. [🚀 Fase 3: Despliegue a Producción](#-fase-3-despliegue-a-producción)
6. [🔧 Fase 4: Mantenimiento y Soporte](#-fase-4-mantenimiento-y-soporte)
7. [⚡ Prompts Específicos por Contexto](#-prompts-específicos-por-contexto)
8. [🎓 Mejores Prácticas](#-mejores-prácticas)

---

## 🎯 Introducción y Fundamentos

### ¿Qué es la Ingeniería de Contexto?

La **Ingeniería de Contexto** es la disciplina de comunicarse efectivamente con agentes IA para obtener resultados precisos, consistentes y de alta calidad. En lugar de programar línea por línea, diseñas el contexto y las instrucciones para que la IA genere el código que necesitas.

### Principios Fundamentales

1. **Contexto es Rey**: Proporciona TODA la información relevante
2. **Especificidad sobre Generalidad**: Sé específico en lo que quieres
3. **Iteración Inteligente**: Refina el contexto basado en resultados
4. **Documentación Primera**: La IA necesita entender el "por qué"
5. **Validación Continua**: Verifica cada output antes de continuar

---

## 📚 Conocimientos Base Requeridos

### 🟢 **LO QUE SÍ NECESITAS SABER:**

#### Conceptos de Programación (Básico)
- Variables, funciones, objetos
- Qué es una API y cómo funciona
- Conceptos de base de datos (tablas, relaciones)
- Qué son los frameworks y librerías

#### Arquitectura de Software (Conceptual)
- Diferencia entre frontend y backend
- Qué son los microservicios
- Conceptos básicos de seguridad (autenticación, autorización)
- Principios de diseño (separación de responsabilidades)

#### Herramientas de Desarrollo
- **Git**: Comandos básicos (add, commit, push, pull)
- **Terminal/CMD**: Navegación básica y ejecución de comandos
- **VS Code**: Uso básico del editor
- **Docker**: Conceptos básicos (containers, images)

#### Metodologías
- **Scrum/Agile**: Conceptos básicos de gestión de proyectos
- **Clean Architecture**: Principios de código limpio
- **Testing**: Por qué son importantes los tests

### 🔴 **LO QUE NO NECESITAS PREOCUPARTE:**

#### Sintaxis Específica de Lenguajes
- ❌ Memorizar sintaxis de TypeScript/JavaScript
- ❌ Conocer todas las APIs de Node.js
- ❌ Dominar React hooks específicos
- ❌ Configuraciones complejas de Webpack/Vite

#### Configuraciones Complejas
- ❌ Setup manual de Docker
- ❌ Configuración de CI/CD desde cero
- ❌ Optimizaciones avanzadas de base de datos
- ❌ Configuraciones de seguridad a nivel de infraestructura

#### Implementaciones Específicas
- ❌ Algoritmos complejos
- ❌ Optimizaciones de performance avanzadas
- ❌ Patrones de diseño específicos
- ❌ Configuraciones de monitoreo avanzado

---

## 🏗️ Fase 1: Setup del Proyecto

### **Paso 1.1: Definición del Proyecto**

#### Prompt Inicial Recomendado:
```
Necesito crear un sistema [DESCRIPCIÓN_DEL_SISTEMA] con las siguientes características:

**Funcionalidades principales:**
- [Lista específica de funcionalidades]

**Requisitos técnicos:**
- Arquitectura de microservicios
- Frontend en React/TypeScript
- Backend en Node.js/TypeScript  
- Base de datos [TIPO_BD]
- Autenticación JWT
- API REST

**Requisitos de negocio:**
- Escalable para [NÚMERO] usuarios
- Tiempo de respuesta < [TIEMPO]
- Disponibilidad 99.9%
- Compatible con [SISTEMAS/INTEGRACIONES]

Quiero seguir mejores prácticas de Clean Architecture, SOLID, y tener documentación completa. El proyecto debe ser fácil de mantener y desarrollar en equipo.

Por favor, ayúdame a estructurar este proyecto paso a paso.
```

#### Prompts Usados en BackupGuard Pro:
```
1. "Necesito crear un sistema de monitoreo y gestión de copias de seguridad multiempresa que sea viral, fácil de instalar, con microservicios y microfrontends"

2. "El sistema debe usar TypeScript, Node.js, MongoDB, Redis, ser escalable y tener una arquitectura limpia"

3. "Quiero que sea un sistema que las empresas adopten rápidamente y compartan con otras empresas"
```

### **Paso 1.2: Estructura Inicial del Proyecto**

#### Prompt para Documentación Base:
```
Ahora necesito crear la estructura de documentación base para este proyecto. 

Por favor:
1. Crea una estructura de carpetas docs/ completa
2. Genera README.md principal explicando el proyecto
3. Crea documentación de arquitectura
4. Incluye guías de desarrollo
5. Agrega documentación de API
6. Crea guías de usuario

Usa markdown profesional y asegúrate de que todo esté en español. La documentación debe ser comprensible para desarrolladores junior y senior.
```

#### Prompt Usado en BackupGuard Pro:
```
"Crea la estructura de documentación completa en docs/ con README.md, architecture/, development/, api/, y user_guide/. Todo en español y siguiendo mejores prácticas"
```

### **Paso 1.3: Configuración de Herramientas**

#### Prompt para Git Flow:
```
Configura un flujo de trabajo Git profesional con:
- 3 ramas principales: main (producción), testing (QA), develop (desarrollo)
- Convenciones de commits (Conventional Commits)
- Protecciones de ramas
- Configuración de CI/CD básica
- Documentación del flujo de trabajo

Incluye ejemplos específicos y comandos que el equipo puede usar.
```

#### Prompt para AI Instructions:
```
Genera un archivo .github/copilot-instructions.md con instrucciones detalladas para agentes IA que trabajen en este proyecto.

Debe incluir:
- Principios de desarrollo (SOLID, Clean Architecture)
- Stack tecnológico específico
- Patrones de código requeridos
- Estructura de microservicios
- Convenciones de nomenclatura
- Mejores prácticas de testing
- Metodología de gestión de proyectos

Todo en español y específico para este proyecto.
```

### **Paso 1.4: Planificación con Shape Up**

#### Prompt para Metodología:
```
Implementa la metodología Shape Up para este proyecto:

1. Crea la estructura de carpetas plans/
2. Define el primer plan "Sistema de Monitoreo de Backups"
3. Crea user stories siguiendo formato Gherkin
4. Incluye Definition of Ready y Definition of Done
5. Agrega estimaciones y dependencias

Cada user story debe tener:
- Información funcional (Gherkin)
- Especificaciones técnicas
- **Diagramas C4 completos (4 niveles obligatorios)**
- Criterios de aceptación
- Tareas específicas

#### **Los 4 Niveles de Diagramas C4 Requeridos:**

**🏢 Level 1 - System Context**
```
Prompt: "Crea un diagrama C4 Level 1 (System Context) que muestre:
- El sistema [NOMBRE_SISTEMA] en el centro
- Usuarios principales (administradores, operadores, clientes)
- Sistemas externos (APIs, servicios third-party, legacy systems)
- Flujos principales de datos entre ellos
- Tecnologías de integración usadas

Usa formato Mermaid o PlantUML compatible con markdown."
```

**📦 Level 2 - Containers** 
```
Prompt: "Crea un diagrama C4 Level 2 (Containers) que detalle:
- Cada microservicio como container independiente
- Bases de datos y stores (MongoDB, Redis, etc.)
- API Gateway y load balancers
- Frontend applications (React apps, mobile apps)
- Message brokers (RabbitMQ, Kafka)
- Protocolos de comunicación (HTTP, WebSocket, async messaging)

Incluye puertos, tecnologías y responsabilidades de cada container."
```

**⚙️ Level 3 - Components**
```
Prompt: "Crea un diagrama C4 Level 3 (Components) para [SERVICIO_ESPECÍFICO]:
- Controllers (endpoints REST)
- Services (lógica de negocio)
- Repositories (acceso a datos)
- Models/Entities (esquemas de datos)
- Middleware (auth, validation, logging)
- External adapters (APIs externas, email, SMS)

Muestra dependencias entre componentes y flujos de datos internos."
```

**💻 Level 4 - Code**
```
Prompt: "Crea un diagrama C4 Level 4 (Code) para [COMPONENTE_CRÍTICO]:
- Clases principales con propiedades y métodos
- Interfaces y abstractions
- Design patterns implementados (Repository, Factory, Observer)
- Relaciones entre clases (herencia, composición, dependencias)
- Flujo de ejecución para casos de uso principales

Enfócate en los componentes más críticos o complejos del sistema."
```
```

---

## 💻 Fase 2: Desarrollo de la Aplicación

### **Paso 2.1: Arquitectura de Microservicios**

#### Prompt para Estructura Base:
```
Ahora vamos a crear la estructura de código para los microservicios.

Por favor:
1. Crea la estructura de carpetas services/ con cada microservicio
2. Configura package.json como monorepo con scripts
3. Crea docker-compose.yml para desarrollo local
4. Establece la estructura base de cada servicio (controllers, services, models, etc.)
5. Configura eslint, prettier, y tsconfig.json compartido

Servicios requeridos: [LISTA_DE_SERVICIOS]

Cada servicio debe seguir Clean Architecture y tener su propia base de datos.
```

#### Prompt Específico Usado:
```
"Crea la estructura de microservicios para: api-gateway (puerto 8080), user-service (3001), backup-monitor-service (3002), notification-service (3003), report-service (3004), config-service (3005), billing-service (3006)"
```

### **Paso 2.2: API Gateway y Autenticación**

#### Prompt para API Gateway:
```
Implementa el API Gateway que será el punto de entrada único:

Funcionalidades requeridas:
- Routing a microservicios internos
- Autenticación JWT con refresh tokens
- Rate limiting por usuario y endpoint
- Middleware de logging y error handling
- Circuit breaker para resilencia
- Validación de requests con Zod

Configura también:
- Middleware de CORS
- Compression
- Security headers (helmet)
- Request/response logging

Usa TypeScript strict y sigue principios SOLID.
```

### **Paso 2.3: Servicios Individuales**

#### Prompt Template para Cada Servicio:
```
Implementa el [NOMBRE_SERVICIO] con las siguientes responsabilidades:

**Funcionalidades:**
- [Lista específica de funcionalidades]

**Endpoints requeridos:**
- [Lista de endpoints con métodos HTTP]

**Modelo de datos:**
- [Esquemas de MongoDB/Mongoose requeridos]

**Integraciones:**
- [Otros servicios con los que debe comunicarse]

**Eventos:**
- [Eventos que debe publicar/escuchar via RabbitMQ]

Incluye:
- Controllers con validación Zod
- Services con lógica de negocio
- Models con Mongoose schemas
- Tests unitarios con Jest
- Documentación de API

Sigue Clean Architecture y principios SOLID.
```

### **Paso 2.4: Frontend (Microfrontends)**

#### Prompt para Frontend:
```
Crea el frontend usando microfrontends en React con TypeScript:

**Aplicaciones requeridas:**
- admin-dashboard (para administradores)
- user-portal (para usuarios finales)
- installer-app (para instalación)

**Stack técnico:**
- React 18 + TypeScript
- Vite para bundling
- Tailwind CSS + Radix UI
- Zustand para estado global
- React Query para datos remotos
- React Router para navegación

**Funcionalidades base:**
- Autenticación (login/logout)
- Dashboard principal
- Gestión de usuarios
- Monitoreo en tiempo real (WebSocket)
- Reportes y gráficos

Cada microfrontend debe ser independiente y seguir atomic design.
```

### **Paso 2.5: Testing Comprensivo**

#### Prompt para Testing:
```
Implementa una estrategia de testing completa:

**Tipos de tests requeridos:**
1. Unit tests (Jest + Supertest) para cada servicio
2. Integration tests para flujos entre servicios  
3. E2E tests (Playwright) para flujos de usuario críticos
4. Performance tests para endpoints principales

**Configuración requerida:**
- Setup de base de datos de testing
- Mocks para servicios externos
- Fixtures de datos de prueba
- Coverage mínimo del 80%
- Tests en pipeline CI/CD

**Tests específicos por servicio:**
- [Lista específica por cada microservicio]

Incluye ejemplos y documentación de cómo ejecutar tests localmente.
```

---

## 🚀 Fase 3: Despliegue a Producción

### **Paso 3.1: Containerización**

#### Prompt para Docker:
```
Containeriza la aplicación completa para despliegue:

1. Crea Dockerfile para cada microservicio optimizado para producción
2. Configura docker-compose.yml para producción
3. Setup de multi-stage builds para reducir tamaño
4. Configuración de health checks
5. Variables de entorno y secrets management
6. Optimizaciones de performance

Incluye también:
- Dockerfile para frontends con nginx
- Docker para bases de datos (MongoDB, Redis)
- Network configuration entre servicios
- Volume management para persistencia
- Logging configuration
```

### **Paso 3.2: CI/CD Pipeline**

#### Prompt para GitHub Actions:
```
Configura un pipeline CI/CD completo usando GitHub Actions:

**Pipeline stages:**
1. Linting y formateo (ESLint, Prettier)
2. Tests unitarios e integración
3. Build de aplicaciones
4. Security scanning (Snyk, npm audit)
5. Build de imágenes Docker
6. Deploy a staging (rama testing)
7. E2E tests en staging
8. Deploy a producción (rama main)

**Environments:**
- Development (auto-deploy desde develop)
- Staging (auto-deploy desde testing)
- Production (auto-deploy desde main)

**Features adicionales:**
- Rollback automático en caso de fallo
- Notificaciones a Slack/Discord
- Deployment approval para producción
- Gestión de secrets y variables
```

### **Paso 3.3: Infraestructura Cloud**

#### Prompt para Infrastructure as Code:
```
Configura la infraestructura cloud usando [PROVEEDOR_CLOUD]:

**Componentes requeridos:**
- Kubernetes cluster para microservicios
- Load balancer con SSL termination
- CDN para assets estáticos
- Base de datos administrada (MongoDB Atlas)
- Cache administrado (Redis Cloud)
- Message queue (RabbitMQ Cloud)
- Object storage para archivos
- Monitoring stack (Prometheus + Grafana)
- Log aggregation (ELK Stack)

**Configuración:**
- Auto-scaling policies
- Backup strategies
- Disaster recovery plan
- Security groups y networking
- SSL certificates management
```

### **Paso 3.4: Monitoreo y Observabilidad**

#### Prompt para Monitoring:
```
Implementa monitoreo completo de la aplicación:

**Métricas requeridas:**
- Application metrics (response time, error rate)
- Business metrics (usuarios activos, transacciones)
- Infrastructure metrics (CPU, memoria, disk)
- Custom metrics específicas del negocio

**Herramientas:**
- Prometheus para métricas
- Grafana para dashboards
- ELK Stack para logs centralizados
- APM tool (New Relic/Datadog)
- Uptime monitoring (Pingdom/StatusPage)

**Alerting:**
- Alertas críticas (downtime, errores 5xx)
- Alertas de warning (latencia alta, uso de recursos)
- Escalation policies
- Integration con PagerDuty/OpsGenie
```

---

## �️ Bases de Datos Soportadas

### **Relacionales (ACID Completo)**
- **PostgreSQL**: Aplicaciones empresariales, datos críticos, compliance
- **MySQL**: Aplicaciones web tradicionales, WordPress, ecommerce
- **SQLite**: Desarrollo local, aplicaciones móviles, prototipos
- **SQL Server**: Ecosistema Microsoft, aplicaciones enterprise

### **NoSQL (Escalabilidad)**
- **MongoDB**: Documentos, APIs REST, prototipado rápido
- **CouchDB**: Sincronización offline, aplicaciones distribuidas
- **DynamoDB**: AWS serverless, alta performance, gaming
- **Firebase**: Aplicaciones móviles, tiempo real, MVP

### **Cache y Sesiones**
- **Redis**: Cache, sesiones, pub/sub, colas de trabajo
- **Memcached**: Cache distribuido simple, alta performance
- **Hazelcast**: Cache empresarial, computación distribuida

### **Especializadas**
- **InfluxDB**: Series temporales, IoT, métricas, monitoreo
- **TimescaleDB**: PostgreSQL + series temporales
- **Neo4j**: Grafos, redes sociales, recomendaciones
- **Elasticsearch**: Búsqueda de texto, analytics, logs
- **Pinecone**: Vectores, embeddings, AI/ML

## 🔌 MCP (Model Context Protocol) Integrado

### **¿Qué es MCP?**
El Model Context Protocol permite que los agentes IA accedan a datos y servicios externos de forma segura y estandarizada.

### **Servidores MCP por Categoría**

#### **�🔧 Desarrollo y Control de Versiones**
```json
{
  "github": {
    "propósito": "Gestión de repositorios, issues, PRs",
    "casos_uso": ["Code review", "Issue tracking", "Release management"],
    "comando": "uvx mcp-server-github"
  },
  "gitlab": {
    "propósito": "CI/CD, merge requests, pipelines",
    "casos_uso": ["DevOps", "Pipeline automation", "Code collaboration"],
    "comando": "uvx mcp-server-gitlab"
  },
  "linear": {
    "propósito": "Project management, issue tracking",
    "casos_uso": ["Agile development", "Sprint planning", "Bug tracking"],
    "comando": "npx @linear/mcp-server"
  }
}
```

#### **🗃️ Bases de Datos**
```json
{
  "postgresql": {
    "propósito": "Consultas SQL, schema management",
    "casos_uso": ["Data analysis", "Schema design", "Query optimization"],
    "comando": "uvx mcp-server-postgres"
  },
  "mongodb": {
    "propósito": "Queries NoSQL, aggregation pipelines",
    "casos_uso": ["Document queries", "Data migration", "Index optimization"],
    "comando": "npx mcp-server-mongodb"
  },
  "redis": {
    "propósito": "Cache management, pub/sub",
    "casos_uso": ["Performance tuning", "Session management", "Real-time features"],
    "comando": "uvx mcp-server-redis"
  }
}
```

#### **☁️ Cloud Services**
```json
{
  "aws": {
    "propósito": "AWS resources management",
    "casos_uso": ["Infrastructure as Code", "Cost optimization", "Security audits"],
    "comando": "uvx mcp-server-aws"
  },
  "gcp": {
    "propósito": "Google Cloud Platform integration",
    "casos_uso": ["ML/AI services", "BigQuery analytics", "Kubernetes management"],
    "comando": "uvx mcp-server-gcp"
  },
  "azure": {
    "propósito": "Microsoft Azure services",
    "casos_uso": ["Enterprise integration", "Active Directory", "DevOps"],
    "comando": "uvx mcp-server-azure"
  }
}
```

#### **🔗 APIs y Servicios Web**
```json
{
  "rest-api": {
    "propósito": "Testing y documentación de APIs REST",
    "casos_uso": ["API testing", "Documentation generation", "Mock services"],
    "comando": "uvx mcp-server-rest"
  },
  "graphql": {
    "propósito": "Queries y mutations GraphQL",
    "casos_uso": ["Schema introspection", "Query optimization", "Resolver testing"],
    "comando": "npx mcp-server-graphql"
  },
  "openapi": {
    "propósito": "Especificaciones OpenAPI/Swagger",
    "casos_uso": ["API design", "Code generation", "Contract testing"],
    "comando": "uvx mcp-server-openapi"
  }
}
```

#### **📊 Productividad y Comunicación**
```json
{
  "notion": {
    "propósito": "Knowledge management, documentation",
    "casos_uso": ["Documentation", "Project wikis", "Knowledge base"],
    "comando": "npx @notion/mcp-server"
  },
  "slack": {
    "propósito": "Team communication, notifications",
    "casos_uso": ["Automated notifications", "Team updates", "Alert management"],
    "comando": "uvx mcp-server-slack"
  },
  "jira": {
    "propósito": "Issue tracking, project management",
    "casos_uso": ["Sprint planning", "Bug tracking", "Release management"],
    "comando": "uvx mcp-server-jira"
  }
}
```

### **Configuración MCP Recomendada por Proyecto**

#### **🌐 Aplicación Web Full-Stack**
```json
{
  "recomendado": ["github", "postgresql", "redis", "slack"],
  "opcional": ["aws", "notion", "rest-api"]
}
```

#### **📱 Aplicación Móvil**
```json
{
  "recomendado": ["github", "firebase", "rest-api", "linear"],
  "opcional": ["aws", "notion", "slack"]
}
```

#### **🤖 Proyecto de IA/ML**
```json
{
  "recomendado": ["github", "postgresql", "pinecone", "gcp"],
  "opcional": ["aws", "notion", "jupyter"]
}
```

#### **📊 Analytics y Big Data**
```json
{
  "recomendado": ["github", "postgresql", "influxdb", "elasticsearch"],
  "opcional": ["aws", "gcp", "notion"]
}
```

### **Prompts Optimizados para MCP**

#### **📊 Análisis de Base de Datos**
```
Conecta al servidor MCP PostgreSQL y analiza la performance de la base de datos.

Contexto:
- Base de datos: producción
- Problema: Queries lentas en tabla users
- Tiempo de respuesta actual: >2 segundos

Tareas:
1. Identifica las 10 queries más lentas
2. Analiza los índices existentes
3. Propón optimizaciones específicas
4. Genera script de migración

Usa el MCP server para ejecutar consultas de análisis y proporciona recomendaciones basadas en datos reales.
```

#### **🔧 Gestión de Issues con GitHub**
```
Usa el servidor MCP GitHub para analizar y gestionar issues del proyecto.

Contexto:
- Repositorio: [tu-repo]
- Sprint actual: Sprint 15
- Prioridad: Bugs críticos

Tareas:
1. Lista todos los bugs con label "critical"
2. Agrupa por componente afectado
3. Identifica patrones comunes
4. Crea plan de resolución con estimaciones
5. Asigna issues a milestone correcto

Proporciona análisis basado en datos reales del repositorio.
```

#### **☁️ Optimización de Infraestructura AWS**
```
Conecta al servidor MCP AWS para optimizar costos y performance.

Contexto:
- Aplicación: [tu-app]
- Región: us-east-1
- Problema: Costos elevados y latencia

Tareas:
1. Analiza recursos infrautilizados
2. Identifica oportunidades de reserved instances
3. Revisa configuración de auto-scaling
4. Propón arquitectura optimizada
5. Calcula ahorros proyectados

Usa datos reales de CloudWatch y Cost Explorer.
```

### **Paso 4.1: Documentación de Operaciones**

#### Prompt para Runbooks:
```
Crea documentación operacional completa:

**Runbooks requeridos:**
- Troubleshooting guide para cada servicio
- Deployment procedures
- Rollback procedures
- Backup and restore procedures
- Disaster recovery plan
- Performance tuning guide
- Security incident response

**Documentación para soporte:**
- FAQ para usuarios finales
- Knowledge base para soporte técnico
- Escalation procedures
- SLA definitions y monitoring
```

### **Paso 4.2: Automatización de Soporte**

#### Prompt para Support Automation:
```
Implementa automatización para soporte y mantenimiento:

**Chatbot de soporte:**
- Integration con knowledge base
- Automated ticket creation
- Basic troubleshooting flows
- Escalation to human agents

**Automated maintenance:**
- Database maintenance scripts
- Log rotation y cleanup
- Security patches automation
- Dependency updates (Dependabot)
- Performance optimization scripts

**Self-healing capabilities:**
- Auto-restart failed services
- Auto-scaling based on load
- Circuit breaker patterns
- Graceful degradation
```

### **Paso 4.3: Mejora Continua**

#### Prompt para Continuous Improvement:
```
Establece procesos de mejora continua:

**Analytics y métricas:**
- User behavior analytics
- Performance analytics
- Business KPIs tracking
- Technical debt monitoring

**Feedback loops:**
- User feedback collection
- Team retrospectives automation
- Performance review automation
- Security audit automation

**Innovation pipeline:**
- Feature flag management
- A/B testing framework
- Canary deployment strategy
- Innovation time allocation
```

---

## ⚡ Prompts Específicos por Contexto

### 🚨 **Resolución de Problemas**

#### Cuando algo no funciona:
```
Tengo un problema con [COMPONENTE_ESPECÍFICO]:

**Error observado:**
[Descripción exacta del error]

**Contexto:**
- ¿Cuándo empezó a fallar?
- ¿Qué cambios se hicieron recientemente?
- ¿En qué ambiente ocurre?
- ¿Hay logs específicos?

**Comportamiento esperado:**
[Lo que debería pasar]

Por favor ayúdame a:
1. Diagnosticar la causa raíz
2. Proponer 3 soluciones posibles
3. Implementar la mejor solución
4. Prevenir que vuelva a ocurrir
```

### 🔧 **Nuevas Funcionalidades**

#### Para agregar features:
```
Necesito implementar una nueva funcionalidad: [DESCRIPCIÓN]

**Contexto del negocio:**
- ¿Por qué es necesaria?
- ¿Qué problema resuelve?
- ¿Quién la va a usar?

**Requisitos funcionales:**
[Lista detallada de qué debe hacer]

**Requisitos técnicos:**
- ¿Qué servicios se ven afectados?
- ¿Hay integraciones con sistemas externos?
- ¿Hay consideraciones de performance?
- ¿Hay requisitos de seguridad?

Por favor:
1. Analiza el impacto en la arquitectura actual
2. Propón 3 enfoques de implementación
3. Recomienda el mejor enfoque
4. Crea una user story detallada
5. Identifica riesgos y dependencias
```

### 🧪 **Optimización y Performance**

#### Para mejorar performance:
```
Necesito optimizar [COMPONENTE/ENDPOINT] que está teniendo problemas de performance:

**Métricas actuales:**
- Tiempo de respuesta: [X]ms
- Throughput: [X] requests/segundo
- Uso de CPU: [X]%
- Uso de memoria: [X]MB
- Uso de base de datos: [consultas/segundo]

**Objetivo:**
- Tiempo de respuesta: < [X]ms
- Throughput: > [X] requests/segundo

**Constraints:**
- Presupuesto disponible
- Tiempo de implementación
- Impacto en otros servicios

Analiza y propón:
1. Bottlenecks identificados
2. Optimizaciones de código
3. Optimizaciones de base de datos
4. Optimizaciones de infraestructura
5. Plan de implementación por fases
```

### 🛡️ **Seguridad**

#### Para auditorías de seguridad:
```
Necesito realizar una auditoría de seguridad completa del sistema:

**Áreas a revisar:**
- Autenticación y autorización
- Validación de inputs
- Manejo de secrets
- Comunicación entre servicios
- Logs y auditoría
- Configuración de infraestructura

**Compliance requerido:**
- [GDPR, SOC2, ISO27001, etc.]

Por favor:
1. Identifica vulnerabilidades potenciales
2. Evalúa la implementación actual vs mejores prácticas
3. Propón un plan de remediación priorizado
4. Crea checklist para auditorías futuras
5. Recomienda herramientas de monitoring de seguridad
```

---

## 🎓 Mejores Prácticas

### **✅ DO's - Haz Esto**

#### Contexto y Comunicación:
- **Sé específico**: "Crea un endpoint POST /api/users que valide email único" vs "Crea un endpoint de usuarios"
- **Proporciona contexto completo**: Incluye stack tecnológico, patrones usados, constraints
- **Usa ejemplos**: "Como en el user-service existente" o "Similar a este pattern"
- **Especifica el output esperado**: "Incluye tests unitarios" o "Con documentación API"
- **Adapta el prompt al agente**: Claude prefiere contexto detallado, GPT-4 es mejor con ejemplos específicos, Gemini funciona bien con estructuras paso a paso

#### Compatibilidad Multi-Agente:
- **GitHub Copilot**: Funciona mejor con comentarios en código y autocomplete contextual
- **ChatGPT/GPT-4**: Excelente para arquitectura y explicaciones detalladas
- **Claude**: Superior para análisis de código complejo y refactoring
- **Gemini**: Muy bueno para documentación y casos de uso
- **Cursor**: Ideal para edición de código en tiempo real
- **v0.dev**: Especializado en componentes UI/UX

#### Gestión de Iteraciones:
- **Divide en pasos**: No pidas toda la aplicación de una vez
- **Valida cada paso**: Revisa el output antes de continuar
- **Refina el contexto**: Mejora las instrucciones basado en resultados anteriores
- **Documenta aprendizajes**: Actualiza las instrucciones AI con nuevos patterns

#### Calidad y Mantenimiento:
- **Exige tests**: Siempre pide tests junto con el código
- **Pide documentación**: README, comentarios, guías de API
- **Aplica principios**: Menciona explícitamente SOLID, Clean Architecture
- **Considera performance**: Incluye consideraciones de escalabilidad

### **❌ DON'Ts - Evita Esto**

#### Errores Comunes de Contexto:
- **No seas vago**: "Hazme una app" → Sin contexto suficiente
- **No asumas conocimiento**: La IA no sabe tu stack completo
- **No ignores errores**: Si algo no funciona, proporciona logs completos
- **No saltes pasos**: Sigue una secuencia lógica de desarrollo

#### Gestión de Complejidad:
- **No pidas todo junto**: Una aplicación completa en un prompt
- **No cambies el contexto constantemente**: Mantén consistencia
- **No ignores la arquitectura**: Siempre respeta los patterns establecidos
- **No olvides la documentación**: El código sin docs es código perdido

### **🔄 Patterns de Iteración Efectiva**

#### Pattern 1: Arquitectura → Implementación → Tests
```
1. "Diseña la arquitectura para [FEATURE]"
2. "Implementa [COMPONENTE] siguiendo la arquitectura"
3. "Crea tests completos para [COMPONENTE]"
4. "Optimiza y refactoriza basado en tests"
```

#### Pattern 2: MVP → Iterate → Scale
```
1. "Crea MVP de [FEATURE] con funcionalidades básicas"
2. "Agrega [FUNCIONALIDAD_ESPECÍFICA] al MVP"
3. "Optimiza para [MÉTRICA_ESPECÍFICA]"
4. "Escala para soportar [REQUISITO_ESPECÍFICO]"
```

#### Pattern 3: Problem → Analyze → Solutions → Implement
```
1. "Analiza el problema: [DESCRIPCIÓN_DETALLADA]"
2. "Propón 3 soluciones diferentes con pros/cons"
3. "Recomienda la mejor solución y justifica"
4. "Implementa la solución recomendada paso a paso"
```

---

## 🏆 Ejemplos de Prompts Exitosos Usados en BackupGuard Pro

### **Prompt Inicial del Proyecto (Funciona con cualquier agente IA):**
```
Necesito crear un sistema de monitoreo y gestión de copias de seguridad multiempresa, viral, fácil de instalar, con microservicios y microfrontends en TypeScript, MongoDB y Redis, siguiendo directrices de GEMINI.md.

El sistema debe:
- Ser fácil de adoptar por empresas
- Tener instalación one-click
- Modelo freemium para viralidad
- Arquitectura escalable y mantenible
- Dashboard en tiempo real
- Alertas inteligentes
- Reportes automatizados

Stack: Node.js/TypeScript, React, MongoDB, Redis, RabbitMQ, Docker, Kubernetes

📝 Nota: Este prompt funcionó exitosamente con GitHub Copilot, ChatGPT-4, y Claude-3.5
```

### **Prompt para Arquitectura (Optimizado para agentes conversacionales):**
```
Diseña la arquitectura de microservicios con:
- API Gateway (puerto 8080)
- User Service (3001) - usuarios y organizaciones
- Backup Monitor Service (3002) - monitoreo tiempo real
- Notification Service (3003) - alertas multicanal
- Report Service (3004) - reportes automatizados
- Config Service (3005) - configuraciones
- Billing Service (3006) - Stripe integration

Cada servicio debe tener su propia DB, comunicarse via events (RabbitMQ), seguir Clean Architecture y principios SOLID.

Incluye diagramas C4 para los 4 niveles: System Context, Containers, Components, y Code.

📝 Nota: Funciona especialmente bien con Claude para análisis arquitectónico
```

### **Prompt para Documentación (Ideal para Gemini y GPT-4):**
```
Crea documentación completa en docs/ con:
- README.md principal
- Architecture/ con diagramas C4 (4 niveles)
- Development/ con setup y patrones
- API/ con especificaciones OpenAPI
- User_guide/ con guías de usuario

Todo en español, markdown profesional, ejemplos prácticos.

Formato: Usa headers jerárquicos, code blocks con syntax highlighting, tablas para comparaciones, y badges para status.

📝 Nota: Gemini excele en documentación estructurada, GPT-4 en ejemplos prácticos
```

### **Prompt para Instructions AI (Multi-agente):**
```
Genera .github/copilot-instructions.md integrando TODO el contenido de GEMINI.md:
- Principios SOLID y Clean Architecture
- Stack tecnológico específico
- Patrones de microservicios
- Metodología Shape Up
- Convenciones de código
- Estrategia de testing
- Flujo Git con 3 ramas

Todo en español, específico para este proyecto.

Compatibilidad: Estas instrucciones deben funcionar con GitHub Copilot, Cursor, Tabnine, y cualquier agente IA de desarrollo.

📝 Nota: Probado exitosamente con múltiples agentes IA
```

### **Prompts Específicos por Agente:**

#### **Para GitHub Copilot (en comentarios de código):**
```typescript
// Crear endpoint POST /api/users con validación Zod
// Debe incluir: email único, password hash, role assignment
// Response: user object sin password, JWT token
// Error handling: 400 para validation, 409 para email duplicado
```

#### **Para Cursor (edición contextual):**
```
Refactoriza esta función para seguir principios SOLID:
[CÓDIGO_EXISTENTE]

Aplica:
- Single Responsibility Principle
- Dependency Injection
- Error handling robusto
- TypeScript strict types
```

#### **Para Claude (análisis profundo):**
```
Analiza este código y sugiere mejoras de arquitectura:

[CÓDIGO_COMPLETO]

Consideraciones:
- Performance y escalabilidad
- Mantenibilidad y testabilidad
- Seguridad y best practices
- Patrones de diseño aplicables

Proporciona 3 alternativas de refactoring con pros/cons.
```

#### **Para v0.dev (componentes UI):**
```
Crea un dashboard component en React con:
- Header con navegación y user menu
- Sidebar con métricas principales
- Grid de cards con estadísticas de backups
- Tabla de últimos backups con paginación
- Theme: moderno, usar Tailwind CSS + Radix UI

Responsive design, dark/light mode toggle.
```

#### **Para Agentes CLI:**

**GitHub Copilot CLI:**
```bash
# Sugerir comando para setup del proyecto
gh copilot suggest "setup node.js typescript microservices project"

# Explicar comando complejo
gh copilot explain "docker-compose up -d --build --scale api-gateway=2"
```

**Ollama CLI (modelos locales):**
```bash
# Usando CodeLlama para desarrollo
ollama run codellama "Crear función TypeScript para validar JWT tokens"

# Usando DeepSeek Coder para refactoring
ollama run deepseek-coder "Refactorizar esta función para seguir SOLID principles: [CÓDIGO]"

# Modelos más recientes disponibles (2025)
ollama run deepseek-r1 "Analizar arquitectura y sugerir mejoras"
ollama run llama3.3 "Crear documentación técnica para [COMPONENTE]"
ollama run qwq "Resolver problema complejo de lógica de negocio"
```

**Shell GPT (sgpt):**
```bash
# Generar comando bash desde descripción
sgpt "create docker-compose file for mongodb redis rabbitmq"

# Debugging de errores
sgpt "fix this error: TypeError: Cannot read property 'user' of undefined"
```

**AI Shell:**
```bash
# Generar y ejecutar comandos complejos
ai "crear estructura de microservicios con carpetas services api-gateway user-service"

# Setup de dependencias
ai "instalar dependencias typescript express mongoose redis para microservicio"
```

**Warp Terminal (IA integrada):**
```bash
# Usar # para activar IA en Warp
# crear script para backup automático de mongodb

# optimizar dockerfile para aplicación node.js
```

---

## 🚀 Conclusión

Esta guía te proporciona el framework completo para desarrollar aplicaciones empresariales usando ingeniería de contexto con **cualquier agente IA disponible**. La clave del éxito está en:

1. **Preparación**: Tener el contexto claro antes de empezar
2. **Iteración**: Desarrollar paso a paso, validando cada etapa
3. **Documentación**: Mantener todo documentado para futura referencia
4. **Mejora continua**: Refinar el proceso basado en resultados
5. **Flexibilidad**: Adaptar prompts según el agente IA utilizado

### 🎯 **Recomendaciones por Tipo de Trabajo:**

- **📋 Planificación y Arquitectura**: Claude-3.5 Sonnet, GPT-4
- **💻 Desarrollo de Código**: GitHub Copilot, Cursor, Tabnine, Cline
- **🎨 UI/UX y Componentes**: v0.dev, Claude, GPT-4 con vision
- **📚 Documentación**: Gemini Pro, GPT-4, Claude
- **🔍 Code Review y Refactoring**: Claude-3.5, GPT-4 Turbo, Continue
- **🧪 Testing y QA**: GPT-4, Phind, GitHub Copilot, Cline
- **🔧 DevOps y CI/CD**: Claude, GPT-4, Perplexity AI
- **⚡ Terminal y Scripts**: GitHub Copilot CLI, Shell GPT, AI Shell
- **🔄 Automatización**: Ollama (local), Warp Terminal, Fig/Amazon Q
- **🌐 Desarrollo Local**: CodeLlama via Ollama, DeepSeek-R1, LM Studio
- **🏠 Privacidad/Offline**: Ollama + Open WebUI, Jan, GPT4All, AnythingLLM
- **🤖 Desarrollo Autónomo**: Cline, Continue, Cursor (para tareas complejas)

### 🌟 **Ventajas de la Metodología Universal:**

✅ **No dependes de un solo agente IA**  
✅ **Puedes usar el mejor agente para cada tarea**  
✅ **Tus prompts funcionan en cualquier plataforma**  
✅ **Escalable desde proyectos simples hasta empresariales**  
✅ **Metodología probada en proyectos reales**  

**Recuerda**: La IA es tu copiloto experto, pero tú sigues siendo el arquitecto del proyecto. Usa esta guía como tu roadmap para crear aplicaciones de clase mundial con cualquier agente IA disponible.

### 🔗 **Recursos Adicionales:**

#### **Agentes Web/Cloud:**
- **ChatGPT**: [chat.openai.com](https://chat.openai.com)
- **Claude (Anthropic)**: [claude.ai](https://claude.ai)
- **Google Gemini**: [gemini.google.com](https://gemini.google.com)
- **Microsoft Copilot**: [copilot.microsoft.com](https://copilot.microsoft.com)
- **Perplexity AI**: [perplexity.ai](https://perplexity.ai)

#### **Agentes IDE Integrados:**
- **GitHub Copilot**: [copilot.github.com](https://copilot.github.com)
- **Cursor**: [cursor.sh](https://cursor.sh)
- **Tabnine**: [tabnine.com](https://tabnine.com)
- **Codeium**: [codeium.com](https://codeium.com)
- **Amazon CodeWhisperer**: [aws.amazon.com/codewhisperer](https://aws.amazon.com/codewhisperer)

#### **Agentes Locales/Privados:**
- **Ollama**: [ollama.ai](https://ollama.ai)
- **LM Studio**: [lmstudio.ai](https://lmstudio.ai)
- **Jan**: [jan.ai](https://jan.ai)
- **GPT4All**: [gpt4all.io](https://gpt4all.io)
- **AnythingLLM**: [anythingllm.com](https://anythingllm.com)
- **Open WebUI**: [openwebui.com](https://openwebui.com)

#### **Extensiones VSCode:**
- **Cline**: [marketplace.visualstudio.com](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev)
- **Continue**: [marketplace.visualstudio.com](https://marketplace.visualstudio.com/items?itemName=Continue.continue)

#### **Herramientas CLI:**
- **GitHub CLI + Copilot**: [cli.github.com](https://cli.github.com)
- **Shell GPT**: [github.com/TheR1D/shell_gpt](https://github.com/TheR1D/shell_gpt)
- **AI Shell**: [github.com/BuilderIO/ai-shell](https://github.com/BuilderIO/ai-shell)

#### **Agentes Especializados:**
- **v0.dev (UI)**: [v0.dev](https://v0.dev)
- **Bolt.new (Full-stack)**: [bolt.new](https://bolt.new)
- **Replit (Colaborativo)**: [replit.com](https://replit.com)

---

*Última actualización: 16 de agosto de 2025*  
*Proyecto: BackupGuard Pro - Sistema de Monitoreo de Copias de Seguridad*  
*Creado por: Metodología Universal de Ingeniería de Contexto*  
*Compatible con: Todos los agentes IA de desarrollo disponibles*
