#!/bin/bash

# ========================================
# AI Agents Framework - Setup Básico
# Configuración automática para proyectos NUEVOS
# Basado en proceso manual optimizado - Linux/Mac
# ========================================

set -e

REPO_URL="https://raw.githubusercontent.com/javalenciacai/AI_Agents_Framework/main"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "  AI Agents Framework - Setup Básico"
echo "  Configuración para proyecto NUEVO"
echo "========================================"
echo ""

# Obtener nombre del proyecto
PROJECT_NAME="$1"
if [ -z "$PROJECT_NAME" ]; then
    echo -n "Nombre del proyecto: "
    read PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME="mi-proyecto-ai"
fi

echo -e "${BLUE}[INFO] Configurando proyecto: $PROJECT_NAME${NC}"

# Detectar tipo de proyecto
PROJECT_TYPE="unknown"
if [ -f "package.json" ]; then
    PROJECT_TYPE="javascript"
elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    PROJECT_TYPE="python"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    PROJECT_TYPE="java"
fi

echo -e "${BLUE}[INFO] Tipo de proyecto detectado: $PROJECT_TYPE${NC}"
echo -e "${BLUE}[INFO] Creando estructura básica...${NC}"

# Crear estructura de directorios
mkdir -p .github .vscode docs ai-config

# Función para descargar archivos
download_file() {
    local url="$1"
    local output="$2"
    local dir
    dir=$(dirname "$output")
    
    # Crear directorio si no existe
    mkdir -p "$dir"
    
    echo -e "${BLUE}[INFO] Descargando: $output${NC}"
    
    # Intentar con curl primero
    if command -v curl >/dev/null 2>&1; then
        if curl -s -L -o "$output" "$url" 2>/dev/null; then
            echo -e "${GREEN}[SUCCESS] ✅ $output${NC}"
            return 0
        fi
    fi
    
    # Fallback a wget
    if command -v wget >/dev/null 2>&1; then
        if wget -q -O "$output" "$url" 2>/dev/null; then
            echo -e "${GREEN}[SUCCESS] ✅ $output${NC}"
            return 0
        fi
    fi
    
    echo -e "${YELLOW}[WARNING] ⚠️  No se pudo descargar $output${NC}"
    return 1
}

echo -e "${BLUE}[INFO] Descargando configuraciones AI desde GitHub...${NC}"
download_file "$REPO_URL/.github/copilot-instructions.md" ".github/copilot-instructions.md"
download_file "$REPO_URL/ai-config/vscode-extensions/settings.json" ".vscode/settings.json"
download_file "$REPO_URL/ai-config/vscode-extensions/extensions.json" ".vscode/extensions.json"
download_file "$REPO_URL/docs/AI_ENGINEERING_GUIDE.md" "docs/AI_ENGINEERING_GUIDE.md"

echo -e "${BLUE}[INFO] Creando archivo .env básico...${NC}"

# Verificar si ya existen configuraciones IA
if [ -f ".github/copilot-instructions.md" ]; then
    echo -e "${YELLOW}[WARNING] Configuraciones IA ya existen, omitiendo...${NC}"
else
    if [ -d "ai-config/copilot-instructions" ]; then
        cp -r ai-config/copilot-instructions/* .github/ 2>/dev/null || true
        echo -e "${GREEN}[SUCCESS] Configuraciones Copilot copiadas${NC}"
    else
        echo -e "${BLUE}[INFO] Creando configuración básica de Copilot...${NC}"
        cat > .github/copilot-instructions.md << EOF
# GitHub Copilot Instructions - $PROJECT_TYPE Project

## Project Context
This is a $PROJECT_TYPE project using AI Agents Framework.

## Coding Standards
- Follow clean code principles
- Use meaningful variable names
- Add comments for complex logic
- Maintain consistent formatting

## AI Assistant Guidelines
- Provide code suggestions that follow project patterns
- Consider performance and security best practices
- Suggest relevant testing approaches
- Help with documentation when needed
EOF
        echo -e "${GREEN}[SUCCESS] Configuración básica de Copilot creada${NC}"
    fi
fi

# Crear .env.example si no existe
if [ ! -f ".env.example" ]; then
    echo -e "${BLUE}[INFO] Creando archivo .env.example...${NC}"
    cat > .env.example << EOF
# AI Agents Framework - Environment Variables

# Database Configuration
DATABASE_URL=

# AI API Keys
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GOOGLE_AI_API_KEY=

# Development
NODE_ENV=development
DEBUG=true
EOF
    echo -e "${GREEN}[SUCCESS] Archivo .env.example creado${NC}"
fi

# Crear README básico si no existe
if [ ! -f "README.md" ]; then
    echo -e "${BLUE}[INFO] Creando README.md base...${NC}"
    cat > README.md << EOF
# Mi Proyecto con AI Agents Framework

Este proyecto utiliza el AI Agents Framework para desarrollo acelerado con IA.

## 🚀 Setup Rápido

1. **Configurar variables de entorno:**
   \`\`\`bash
   cp .env.example .env
   # Editar .env con tus API keys
   \`\`\`

2. **Verificar agentes IA:**
   - GitHub Copilot activo en VS Code
   - Revisar \`.github/copilot-instructions.md\`

3. **¡Empezar a desarrollar con superpoderes!**

## 📚 Documentación

- [AI Engineering Guide](./docs/AI_ENGINEERING_GUIDE.md)
- [Configuraciones IA](./ai-config/)
- [Framework Completo](https://github.com/javalenciacai/AI_Agents_Framework)

## 🔧 Stack Detectado

- **Tipo de proyecto:** $PROJECT_TYPE
- **Framework base:** AI Agents Framework

---

**⚡ Powered by [AI Agents Framework](https://github.com/javalenciacai/AI_Agents_Framework)**
EOF
    echo -e "${GREEN}[SUCCESS] README.md base creado${NC}"
fi

# Configurar .gitignore básico
if [ ! -f ".gitignore" ]; then
    echo -e "${BLUE}[INFO] Creando .gitignore...${NC}"
    cat > .gitignore << EOF
# Environment variables
.env
.env.local
.env.*.local

# Dependencies
node_modules/
__pycache__/
*.pyc
.Python
venv/
env/

# Build outputs
dist/
build/
target/
*.class
*.jar

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo

# Logs
*.log
logs/
npm-debug.log*

# OS
.DS_Store
Thumbs.db

# AI Configs (keep instructions, ignore local settings)
.copilot-settings.json
.continue/
EOF
    echo -e "${GREEN}[SUCCESS] .gitignore creado${NC}"
fi

# Configuración específica por lenguaje
if [ "$PROJECT_TYPE" = "javascript" ]; then
    echo -e "${BLUE}[INFO] Configurando optimizaciones para JavaScript/Node.js...${NC}"
    
    if [ ! -f "package.json" ]; then
        echo -e "${BLUE}[INFO] Creando package.json básico...${NC}"
        cat > package.json << EOF
{
  "name": "mi-proyecto-ai",
  "version": "1.0.0",
  "description": "Proyecto con AI Agents Framework",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "jest"
  },
  "keywords": ["ai", "framework"],
  "author": "",
  "license": "MIT"
}
EOF
        echo -e "${GREEN}[SUCCESS] package.json básico creado${NC}"
    fi
fi

if [ "$PROJECT_TYPE" = "python" ]; then
    echo -e "${BLUE}[INFO] Configurando optimizaciones para Python...${NC}"
    
    if [ ! -f "requirements.txt" ]; then
        echo -e "${BLUE}[INFO] Creando requirements.txt básico...${NC}"
        cat > requirements.txt << EOF
# AI Framework Dependencies
python-dotenv
requests

# Development Dependencies  
pytest
black
flake8
EOF
        echo -e "${GREEN}[SUCCESS] requirements.txt básico creado${NC}"
    fi
fi

# Mostrar siguientes pasos
echo ""
echo "========================================"
echo "  CONFIGURACION BASICA COMPLETADA"
echo "========================================"
echo ""
echo -e "${GREEN}✅ Tu proyecto ya tiene configuración básica de IA${NC}"
echo ""
echo -e "${BLUE}📋 Siguientes pasos:${NC}"
echo ""
echo "1. **Configurar API Keys:**"
echo "   - Copiar: cp .env.example .env"
echo "   - Editar .env con tus claves de OpenAI, Anthropic, etc."
echo ""
echo "2. **Verificar Agentes IA:**"
echo "   - Abrir VS Code: code ."
echo "   - Verificar GitHub Copilot activo"
echo "   - Revisar .github/copilot-instructions.md"
echo ""
echo "3. **Para configuración avanzada:**"
echo "   - Ejecutar: ./scripts/setup-new-project-advanced.sh"
echo "   - Configurar bases de datos, MCP, etc."
echo ""
echo "4. **¡Comenzar desarrollo!**"
echo "   - Tu proyecto ya tiene superpoderes IA"
echo ""
echo -e "${BLUE}📚 Más información:${NC}"
echo "- Documentación: https://github.com/javalenciacai/AI_Agents_Framework"
echo "- Guías IA: ./docs/AI_ENGINEERING_GUIDE.md"
echo ""

echo "Presiona Enter para continuar..."
read -r
