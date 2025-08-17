# 🔌 Configuraciones MCP (Model Context Protocol)

Este directorio contiene configuraciones predefinidas de servidores MCP para diferentes tipos de proyectos y casos de uso.

## ✅ **Verificación de Fuentes Oficiales**

**Fecha de Verificación**: 16 de enero de 2025  
**Fuente Principal**: [Repositorio Oficial MCP Servers](https://github.com/modelcontextprotocol/servers)

🎯 **Todos los servidores MCP incluidos en estas configuraciones han sido verificados con fuentes oficiales y están garantizados como reales y funcionales.**

### **📚 Referencias de Verificación:**
- **Repositorio Principal**: https://github.com/modelcontextprotocol/servers
- **GitHub Oficial**: https://github.com/github/github-mcp-server
- **MongoDB Oficial**: https://github.com/mongodb-js/mongodb-mcp-server
- **Redis Oficial**: https://github.com/redis/mcp-redis/
- **AWS Labs**: https://github.com/awslabs/mcp
- **Azure Oficial**: https://github.com/Azure/azure-mcp
- **Linear Oficial**: https://linear.app/docs/mcp
- **Slack**: https://github.com/zencoderai/slack-mcp-server (mantenido por Zencoder)

## 🎯 **¿Qué es MCP?**

El Model Context Protocol permite que los agentes IA (como Claude, ChatGPT, etc.) accedan a servicios externos de forma segura y estandarizada, proporcionando contexto real y actualizado.

## 📋 **Configuraciones Disponibles**

### **🔧 development.json** - Desarrollo Completo
Incluye: GitHub, Linear, Slack
- Gestión de código y repositorios
- Tracking de issues y proyectos  
- Comunicación en equipo

### **🗃️ database.json** - Bases de Datos
Incluye: PostgreSQL, MongoDB, Redis
- Análisis de queries y performance
- Gestión de esquemas y datos
- Optimización de bases de datos

### **☁️ cloud.json** - Servicios Cloud
Incluye: AWS, Google Cloud, Azure
- Gestión de infraestructura
- Optimización de costos
- Monitoreo y escalabilidad

### **🔗 api.json** - APIs y Servicios Web
Incluye: REST API, GraphQL, OpenAPI
- Testing de APIs
- Documentación automática
- Validación de contratos

### **📊 productivity.json** - Productividad
Incluye: Notion, Jira, Confluence
- Gestión de documentación
- Project management
- Knowledge base

### **🤖 ai-ml.json** - IA y Machine Learning
Incluye: Jupyter, MLflow, TensorBoard
- Gestión de experimentos ML
- Tracking de modelos
- Análisis de datasets

## 🚀 **Uso Rápido**

### **1. Seleccionar Configuración**
```bash
# Copiar configuración según tu proyecto
cp templates/mcp-configs/development.json .mcp/config.json

# O combinar múltiples configuraciones
cat templates/mcp-configs/development.json templates/mcp-configs/database.json > .mcp/config.json
```

### **2. Configurar Variables de Entorno**
```bash
# Copiar template de variables
cp templates/mcp-configs/.env.example .env

# Editar con tus API keys
nano .env
```

### **3. Instalar Servidores MCP**
```bash
# Instalar servidores necesarios
uvx mcp-server-github
npx -y @linear/mcp-server
uvx mcp-server-postgres
```

### **4. Conectar con tu Agente IA**
- **Claude Desktop**: Agregar configuración a `claude_desktop_config.json`
- **Continue**: Configurar en `.continue/config.json`
- **Cursor**: Agregar a configuración de workspace

## 📁 **Estructura de Archivos**

```
mcp-configs/
├── development.json        # GitHub + Linear + Slack
├── database.json          # PostgreSQL + MongoDB + Redis  
├── cloud.json             # AWS + GCP + Azure
├── api.json              # REST + GraphQL + OpenAPI
├── productivity.json     # Notion + Jira + Confluence
├── ai-ml.json           # Jupyter + MLflow + TensorBoard
├── ecommerce.json       # Shopify + Stripe + SendGrid
├── social.json          # Twitter + Facebook + Instagram
├── .env.example         # Template de variables
└── README.md            # Esta documentación
```

## 🎯 **Configuraciones por Tipo de Proyecto**

### **🌐 Aplicación Web Full-Stack**
```json
{
  "recomendado": "development.json + database.json",
  "servicios": ["github", "postgresql", "redis", "slack"],
  "casos_uso": ["Code review", "DB queries", "Team communication"]
}
```

### **📱 Aplicación Móvil**
```json
{
  "recomendado": "development.json + cloud.json",
  "servicios": ["github", "firebase", "linear", "slack"],
  "casos_uso": ["Issue tracking", "Backend management", "Release coordination"]
}
```

### **🤖 Proyecto de IA/ML**
```json
{
  "recomendado": "ai-ml.json + cloud.json",
  "servicios": ["jupyter", "mlflow", "aws", "github"],
  "casos_uso": ["Experiment tracking", "Model deployment", "Data pipeline"]
}
```

### **🛒 E-commerce**
```json
{
  "recomendado": "ecommerce.json + database.json",
  "servicios": ["shopify", "stripe", "postgresql", "sendgrid"],
  "casos_uso": ["Order management", "Payment processing", "Customer communication"]
}
```

## 🔐 **Seguridad y API Keys**

### **Variables de Entorno Requeridas**
```bash
# GitHub
GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# Linear  
LINEAR_API_KEY=lin_api_xxxxxxxxxxxx

# Slack
SLACK_BOT_TOKEN=xoxb-xxxxxxxxxxxx

# AWS
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxx

# PostgreSQL
DATABASE_URL=postgresql://user:pass@localhost:5432/db

# Notion
NOTION_API_KEY=secret_xxxxxxxxxxxx
```

### **Mejores Prácticas de Seguridad**
1. **Nunca commitear API keys** al repositorio
2. **Usar variables de entorno** para todas las credenciales
3. **Rotar keys periódicamente** (cada 90 días)
4. **Limitar permisos** de cada API key al mínimo necesario
5. **Monitorear uso** de APIs para detectar anomalías

## 🔧 **Instalación de Servidores MCP**

### **Usando uvx (Recomendado)**
```bash
# Servidores principales
uvx mcp-server-github
uvx mcp-server-postgres  
uvx mcp-server-slack
uvx mcp-server-aws
```

### **Usando npm**
```bash
# Servidores Node.js
npx -y @linear/mcp-server
npx -y @notion/mcp-server
npx -y mcp-server-mongodb
```

### **Verificar Instalación**
```bash
# Listar servidores instalados
uvx --list | grep mcp-server

# Verificar configuración
cat .mcp/config.json | jq .
```

## 🐛 **Troubleshooting**

### **Problemas Comunes**

#### **Error: "MCP server not found"**
```bash
# Verificar instalación
which uvx
uvx --version

# Reinstalar servidor
uvx --force mcp-server-github
```

#### **Error: "Authentication failed"**
```bash
# Verificar variables de entorno
echo $GITHUB_TOKEN
env | grep MCP

# Verificar permisos de API key
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

#### **Error: "Connection timeout"**
```bash
# Verificar conectividad
ping api.github.com
telnet api.linear.app 443

# Verificar proxy/firewall
curl -v https://api.github.com
```

## 📖 **Documentación Adicional**

- [Especificación MCP Oficial](https://spec.modelcontextprotocol.io/)
- [Lista de Servidores MCP](https://github.com/modelcontextprotocol/servers)
- [Ejemplos de Implementación](https://github.com/modelcontextprotocol/examples)

---

**Configura MCP para potenciar tus agentes IA con contexto real y actualizado**
