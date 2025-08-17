#!/bin/bash

# ========================================
# AI Agents Framework - Setup Script
# Para configurar un proyecto NUEVO con IA
# ========================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Función para mostrar banner
show_banner() {
    echo ""
    echo "🤖 ========================================="
    echo "   AI Agents Framework - Setup Proyecto Nuevo"
    echo "   Configuración automática para desarrollo con IA"
    echo "========================================= 🚀"
    echo ""
}

# Función para detectar el lenguaje/stack del proyecto
detect_project_type() {
    log_info "Detectando tipo de proyecto..."
    
    # JavaScript/TypeScript
    if [[ -f "package.json" ]]; then
        echo "javascript"
        return
    fi
    
    # Python
    if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" || -f "Pipfile" ]]; then
        echo "python"
        return
    fi
    
    # Java
    if [[ -f "pom.xml" || -f "build.gradle" || -f "build.gradle.kts" ]]; then
        echo "java"
        return
    fi
    
    # C#
    if [[ -f "*.csproj" || -f "*.sln" || -f "global.json" ]]; then
        echo "csharp"
        return
    fi
    
    # Go
    if [[ -f "go.mod" || -f "go.sum" ]]; then
        echo "go"
        return
    fi
    
    # Rust
    if [[ -f "Cargo.toml" ]]; then
        echo "rust"
        return
    fi
    
    # PHP
    if [[ -f "composer.json" || -f "composer.lock" ]]; then
        echo "php"
        return
    fi
    
    # Ruby
    if [[ -f "Gemfile" || -f "Gemfile.lock" ]]; then
        echo "ruby"
        return
    fi
    
    # Si no se detecta nada, preguntar al usuario
    echo "unknown"
}

# Función para detectar y configurar base de datos
detect_and_configure_database() {
    log_info "Configurando base de datos según el propósito del proyecto..."
    
    echo ""
    echo "🗃️ Selecciona el tipo de base de datos más adecuado:"
    echo "1) PostgreSQL - Aplicaciones empresariales, ACID completo"
    echo "2) MongoDB - Documentos, escalabilidad horizontal"
    echo "3) SQLite - Desarrollo local, aplicaciones simples"
    echo "4) Redis - Cache, sesiones, tiempo real"
    echo "5) MySQL - Aplicaciones web tradicionales"
    echo "6) InfluxDB - Series temporales, IoT, métricas"
    echo "7) Elasticsearch - Búsqueda de texto, analytics"
    echo "8) Neo4j - Datos relacionales complejos, grafos"
    echo "9) Múltiples bases de datos"
    echo "0) Omitir configuración de BD"
    echo ""
    
    read -p "Selecciona una opción (1-9, 0): " db_choice
    
    case $db_choice in
        1)
            configure_postgresql
            ;;
        2)
            configure_mongodb
            ;;
        3)
            configure_sqlite
            ;;
        4)
            configure_redis
            ;;
        5)
            configure_mysql
            ;;
        6)
            configure_influxdb
            ;;
        7)
            configure_elasticsearch
            ;;
        8)
            configure_neo4j
            ;;
        9)
            configure_multiple_databases
            ;;
        0)
            log_info "Configuración de base de datos omitida"
            ;;
        *)
            log_warning "Opción no válida. Usando configuración por defecto."
            configure_default_database
            ;;
    esac
}

# Funciones de configuración por base de datos
configure_postgresql() {
    log_info "Configurando PostgreSQL..."
    
    cat >> .env << EOF
# PostgreSQL Configuration
DB_TYPE=postgresql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_app_db
DB_USER=your_user
DB_PASSWORD=your_password
DATABASE_URL=postgresql://\${DB_USER}:\${DB_PASSWORD}@\${DB_HOST}:\${DB_PORT}/\${DB_NAME}
EOF
    
    # Agregar a docker-compose si existe
    if [[ -f "../templates/docker-compose.postgresql.yml" ]]; then
        cp ../templates/docker-compose.postgresql.yml docker-compose.yml
    fi
    
    log_success "PostgreSQL configurado para aplicaciones empresariales"
}

configure_mongodb() {
    log_info "Configurando MongoDB..."
    
    cat >> .env << EOF
# MongoDB Configuration
DB_TYPE=mongodb
DB_HOST=localhost
DB_PORT=27017
DB_NAME=your_app_db
MONGODB_URI=mongodb://\${DB_HOST}:\${DB_PORT}/\${DB_NAME}
EOF
    
    log_success "MongoDB configurado para aplicaciones con documentos"
}

configure_redis() {
    log_info "Configurando Redis..."
    
    cat >> .env << EOF
# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_URL=redis://\${REDIS_HOST}:\${REDIS_PORT}
EOF
    
    log_success "Redis configurado para cache y sesiones"
}

configure_multiple_databases() {
    log_info "Configurando arquitectura multi-base de datos..."
    
    cat >> .env << EOF
# Multi-Database Configuration
# Primary Database (PostgreSQL)
PRIMARY_DB_TYPE=postgresql
PRIMARY_DB_HOST=localhost
PRIMARY_DB_PORT=5432
PRIMARY_DB_NAME=your_app_db
PRIMARY_DATABASE_URL=postgresql://user:pass@localhost:5432/your_app_db

# Cache Layer (Redis)
CACHE_HOST=localhost
CACHE_PORT=6379
REDIS_URL=redis://localhost:6379

# Search Engine (Elasticsearch)
SEARCH_HOST=localhost
SEARCH_PORT=9200
ELASTICSEARCH_URL=http://localhost:9200

# Analytics/Logs (MongoDB)
ANALYTICS_DB_HOST=localhost
ANALYTICS_DB_PORT=27017
ANALYTICS_DB_NAME=analytics_db
MONGODB_URI=mongodb://localhost:27017/analytics_db
EOF
    
    log_success "Configuración multi-base de datos lista para arquitecturas complejas"
}

# Función para configurar MCP (Model Context Protocol)
configure_mcp_servers() {
    log_info "Configurando servidores MCP según el propósito del proyecto..."
    
    mkdir -p .mcp
    
    echo ""
    echo "🔌 Selecciona los servidores MCP que necesitas:"
    echo "1) Desarrollo completo (GitHub + Linear + Slack)"
    echo "2) Base de datos (PostgreSQL + MongoDB + Redis)"
    echo "3) Cloud services (AWS + Google Cloud + Azure)"
    echo "4) APIs (REST + GraphQL + OpenAPI)"
    echo "5) Productividad (Notion + Jira + Confluence)"
    echo "6) Configuración personalizada"
    echo "0) Omitir configuración MCP"
    echo ""
    
    read -p "Selecciona una opción (1-6, 0): " mcp_choice
    
    case $mcp_choice in
        1)
            configure_development_mcp
            ;;
        2)
            configure_database_mcp
            ;;
        3)
            configure_cloud_mcp
            ;;
        4)
            configure_api_mcp
            ;;
        5)
            configure_productivity_mcp
            ;;
        6)
            configure_custom_mcp
            ;;
        0)
            log_info "Configuración MCP omitida"
            ;;
        *)
            log_warning "Opción no válida. Configurando MCP básico."
            configure_basic_mcp
            ;;
    esac
}

configure_development_mcp() {
    log_info "Configurando MCP para desarrollo completo..."
    
    cat > .mcp/config.json << 'EOF'
{
  "mcpServers": {
    "github": {
      "command": "uvx",
      "args": ["mcp-server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "linear": {
      "command": "npx",
      "args": ["-y", "@linear/mcp-server"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    },
    "slack": {
      "command": "uvx", 
      "args": ["mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    }
  }
}
EOF
    
    cat >> .env << EOF

# MCP Development Configuration
GITHUB_TOKEN=your_github_token_here
LINEAR_API_KEY=your_linear_api_key_here
SLACK_BOT_TOKEN=your_slack_bot_token_here
EOF
    
    log_success "MCP configurado para desarrollo con GitHub, Linear y Slack"
}

configure_database_mcp() {
    log_info "Configurando MCP para bases de datos..."
    
    cat > .mcp/config.json << 'EOF'
{
  "mcpServers": {
    "postgresql": {
      "command": "uvx",
      "args": ["mcp-server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"
      }
    },
    "mongodb": {
      "command": "npx",
      "args": ["-y", "mcp-server-mongodb"],
      "env": {
        "MONGODB_URI": "${MONGODB_URI}"
      }
    },
    "redis": {
      "command": "uvx",
      "args": ["mcp-server-redis"],
      "env": {
        "REDIS_URL": "${REDIS_URL}"
      }
    }
  }
}
EOF
    
    log_success "MCP configurado para PostgreSQL, MongoDB y Redis"
}

configure_cloud_mcp() {
    log_info "Configurando MCP para servicios cloud..."
    
    cat > .mcp/config.json << 'EOF'
{
  "mcpServers": {
    "aws": {
      "command": "uvx",
      "args": ["mcp-server-aws"],
      "env": {
        "AWS_ACCESS_KEY_ID": "${AWS_ACCESS_KEY_ID}",
        "AWS_SECRET_ACCESS_KEY": "${AWS_SECRET_ACCESS_KEY}",
        "AWS_REGION": "${AWS_REGION}"
      }
    },
    "gcp": {
      "command": "uvx",
      "args": ["mcp-server-gcp"],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "${GOOGLE_APPLICATION_CREDENTIALS}"
      }
    },
    "azure": {
      "command": "uvx",
      "args": ["mcp-server-azure"],
      "env": {
        "AZURE_CLIENT_ID": "${AZURE_CLIENT_ID}",
        "AZURE_CLIENT_SECRET": "${AZURE_CLIENT_SECRET}",
        "AZURE_TENANT_ID": "${AZURE_TENANT_ID}"
      }
    }
  }
}
EOF
    
    cat >> .env << EOF

# MCP Cloud Configuration
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=us-east-1
GOOGLE_APPLICATION_CREDENTIALS=path/to/service-account.json
AZURE_CLIENT_ID=your_azure_client_id
AZURE_CLIENT_SECRET=your_azure_client_secret
AZURE_TENANT_ID=your_azure_tenant_id
EOF
    
    log_success "MCP configurado para AWS, Google Cloud y Azure"
}

configure_productivity_mcp() {
    log_info "Configurando MCP para herramientas de productividad..."
    
    cat > .mcp/config.json << 'EOF'
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@notion/mcp-server"],
      "env": {
        "NOTION_API_KEY": "${NOTION_API_KEY}"
      }
    },
    "jira": {
      "command": "uvx",
      "args": ["mcp-server-jira"],
      "env": {
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_USERNAME": "${JIRA_USERNAME}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    }
  }
}
EOF
    
    cat >> .env << EOF

# MCP Productivity Configuration
NOTION_API_KEY=your_notion_api_key
JIRA_URL=https://your-domain.atlassian.net
JIRA_USERNAME=your_email@company.com
JIRA_API_TOKEN=your_jira_api_token
EOF
    
    log_success "MCP configurado para Notion y Jira"
}

# Función para instalar configuración base
install_base_config() {
    log_info "Instalando configuración base del framework..."
    
    # Crear estructura de directorios
    mkdir -p .github
    mkdir -p docs
    mkdir -p ai-config
    mkdir -p .vscode
    
    # Copiar archivos base
    if [[ -f "../ai-config/vscode-extensions/extensions.json" ]]; then
        cp ../ai-config/vscode-extensions/extensions.json .vscode/
        log_success "Extensiones VS Code configuradas"
    fi
    
    if [[ -f "../ai-config/vscode-extensions/settings.json" ]]; then
        cp ../ai-config/vscode-extensions/settings.json .vscode/
        log_success "Settings VS Code configurados"
    fi
    
    # Copiar guía de ingeniería de contexto
    if [[ -f "../docs/AI_ENGINEERING_GUIDE.md" ]]; then
        cp ../docs/AI_ENGINEERING_GUIDE.md docs/
        log_success "Guía de Ingeniería de Contexto instalada"
    fi
}

# Función para configurar según el lenguaje
configure_language() {
    local project_type=$1
    
    log_info "Configurando para proyecto tipo: $project_type"
    
    case $project_type in
        "javascript")
            configure_javascript
            ;;
        "python")
            configure_python
            ;;
        "java")
            configure_java
            ;;
        "csharp")
            configure_csharp
            ;;
        "go")
            configure_go
            ;;
        "rust")
            configure_rust
            ;;
        "php")
            configure_php
            ;;
        "ruby")
            configure_ruby
            ;;
        *)
            log_warning "Tipo de proyecto no reconocido. Instalando configuración genérica."
            configure_generic
            ;;
    esac
}

# Configuraciones específicas por lenguaje
configure_javascript() {
    log_info "Configurando para JavaScript/TypeScript..."
    
    # Copiar instrucciones específicas
    if [[ -f "../ai-config/copilot-instructions/javascript-typescript.md" ]]; then
        cp ../ai-config/copilot-instructions/javascript-typescript.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para JS/TS instaladas"
    fi
    
    # Configuración para Cursor
    if [[ -f "../ai-config/cursor-config/.cursorrules" ]]; then
        cp ../ai-config/cursor-config/.cursorrules .
        log_success "Reglas Cursor configuradas"
    fi
    
    # Configuración para Continue
    if [[ -f "../ai-config/continue-config/continue.json" ]]; then
        mkdir -p .continue
        cp ../ai-config/continue-config/continue.json .continue/
        log_success "Configuración Continue instalada"
    fi
}

configure_python() {
    log_info "Configurando para Python..."
    
    if [[ -f "../ai-config/copilot-instructions/python-django-flask.md" ]]; then
        cp ../ai-config/copilot-instructions/python-django-flask.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Python instaladas"
    fi
}

configure_java() {
    log_info "Configurando para Java..."
    
    if [[ -f "../ai-config/copilot-instructions/java-spring.md" ]]; then
        cp ../ai-config/copilot-instructions/java-spring.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Java instaladas"
    fi
}

configure_csharp() {
    log_info "Configurando para C#..."
    
    if [[ -f "../ai-config/copilot-instructions/csharp-aspnet.md" ]]; then
        cp ../ai-config/copilot-instructions/csharp-aspnet.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para C# instaladas"
    fi
}

configure_go() {
    log_info "Configurando para Go..."
    
    if [[ -f "../ai-config/copilot-instructions/go-gin-fiber.md" ]]; then
        cp ../ai-config/copilot-instructions/go-gin-fiber.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Go instaladas"
    fi
}

configure_rust() {
    log_info "Configurando para Rust..."
    
    if [[ -f "../ai-config/copilot-instructions/rust-actix-rocket.md" ]]; then
        cp ../ai-config/copilot-instructions/rust-actix-rocket.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Rust instaladas"
    fi
}

configure_php() {
    log_info "Configurando para PHP..."
    
    if [[ -f "../ai-config/copilot-instructions/php-laravel-symfony.md" ]]; then
        cp ../ai-config/copilot-instructions/php-laravel-symfony.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para PHP instaladas"
    fi
}

configure_ruby() {
    log_info "Configurando para Ruby..."
    
    if [[ -f "../ai-config/copilot-instructions/ruby-rails.md" ]]; then
        cp ../ai-config/copilot-instructions/ruby-rails.md .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Ruby instaladas"
    fi
}

configure_generic() {
    log_info "Configurando configuración genérica..."
    
    # Copiar instrucciones base si existen
    if [[ -f "../.github/copilot-instructions.md" ]]; then
        cp ../.github/copilot-instructions.md .github/
        log_success "Instrucciones GitHub Copilot genéricas instaladas"
    fi
}

# Función para configurar Git
setup_git() {
    log_info "Configurando Git con ramas recomendadas..."
    
    # Inicializar Git si no existe
    if [[ ! -d ".git" ]]; then
        git init
        log_success "Repositorio Git inicializado"
    fi
    
    # Crear ramas recomendadas
    git checkout -b main 2>/dev/null || git checkout main
    git checkout -b develop 2>/dev/null || git checkout develop
    git checkout -b testing 2>/dev/null || git checkout testing
    git checkout main
    
    log_success "Ramas Git configuradas (main, develop, testing)"
}

# Función para crear .gitignore si no existe
create_gitignore() {
    if [[ ! -f ".gitignore" ]]; then
        log_info "Creando .gitignore..."
        
        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
vendor/
*.egg-info/
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
pip-log.txt
pip-delete-this-directory.txt

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
*.log

# Environment variables
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
*.exe
*.dll
*.so
*.dylib

# Package managers
package-lock.json
yarn.lock
composer.lock
Gemfile.lock

# AI specific
.continue/
.cursor/
.ai-context/
EOF
        
        log_success ".gitignore creado"
    fi
}

# Función para mostrar siguiente pasos
show_next_steps() {
    echo ""
    log_success "🎉 ¡Configuración completada!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Abre VS Code en este directorio"
    echo "2. Instala las extensiones recomendadas"
    echo "3. Lee la guía en docs/AI_ENGINEERING_GUIDE.md"
    echo "4. Comienza a desarrollar con IA 🚀"
    echo ""
    echo "📖 Documentación disponible en:"
    echo "   • docs/AI_ENGINEERING_GUIDE.md"
    echo "   • .github/copilot-instructions.md"
    echo ""
    echo "🤖 Agentes IA configurados:"
    echo "   • GitHub Copilot (VS Code)"
    echo "   • Cursor (si está instalado)"
    echo "   • Continue (si está instalado)"
    echo ""
    echo "🗃️ Base de datos configurada según selección"
    echo "🔌 Servidores MCP configurados según propósito"
    echo ""
    echo "📖 Para configurar las API keys:"
    echo "   • Edita el archivo .env con tus credenciales"
    echo "   • Consulta docs/AI_ENGINEERING_GUIDE.md para detalles"
    echo ""
}

# Función principal
main() {
    show_banner
    
    # Verificar que estamos en el directorio correcto
    if [[ ! -f "../scripts/setup-new-project.sh" ]]; then
        log_error "Este script debe ejecutarse desde el directorio de tu proyecto"
        log_error "El framework debe estar en el directorio padre"
        exit 1
    fi
    
    # Detectar tipo de proyecto
    project_type=$(detect_project_type)
    log_info "Tipo de proyecto detectado: $project_type"
    
    # Configurar base de datos
    detect_and_configure_database
    
    # Configurar MCP servers
    configure_mcp_servers
    
    # Instalar configuración
    install_base_config
    configure_language "$project_type"
    setup_git
    create_gitignore
    
    # Mostrar siguiente pasos
    show_next_steps
}

# Ejecutar script principal
main "$@"
