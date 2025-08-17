#!/bin/bash

# ========================================
# AI Agents Framework - Migration Script
# Para MIGRAR proyecto existente con IA
# ========================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
TARGET_DIR=""
FRAMEWORK_DIR="$(dirname "$(dirname "$(realpath "$0")")")"
BACKUP_DIR=""

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
    echo "🔄 ========================================="
    echo "   AI Agents Framework - Migración Proyecto"
    echo "   Integra IA en proyecto existente"
    echo "========================================= 🤖"
    echo ""
}

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 /path/to/existing/project"
    echo ""
    echo "Opciones:"
    echo "  -h, --help     Mostrar esta ayuda"
    echo "  -b, --backup   Crear backup antes de migrar (recomendado)"
    echo "  -f, --force    Sobrescribir archivos existentes sin preguntar"
    echo ""
    echo "Ejemplo:"
    echo "  $0 /home/usuario/mi-proyecto-existente"
    echo "  $0 --backup /home/usuario/mi-proyecto-existente"
    exit 0
}

# Función para validar argumentos
validate_arguments() {
    if [[ -z "$TARGET_DIR" ]]; then
        log_error "Debes especificar el directorio del proyecto existente"
        show_help
    fi
    
    if [[ ! -d "$TARGET_DIR" ]]; then
        log_error "El directorio especificado no existe: $TARGET_DIR"
        exit 1
    fi
    
    if [[ ! -w "$TARGET_DIR" ]]; then
        log_error "No tienes permisos de escritura en: $TARGET_DIR"
        exit 1
    fi
}

# Función para crear backup
create_backup() {
    if [[ "$CREATE_BACKUP" == "true" ]]; then
        BACKUP_DIR="${TARGET_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
        log_info "Creando backup en: $BACKUP_DIR"
        
        cp -r "$TARGET_DIR" "$BACKUP_DIR"
        log_success "Backup creado exitosamente"
    fi
}

# Función para detectar el lenguaje/stack del proyecto
detect_project_type() {
    log_info "Analizando proyecto existente..."
    
    cd "$TARGET_DIR"
    
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
    if find . -name "*.csproj" -o -name "*.sln" -o -name "global.json" | grep -q .; then
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
    
    echo "unknown"
}

# Función para verificar archivos existentes
check_existing_files() {
    log_info "Verificando archivos existentes..."
    
    local conflicts=()
    
    # Verificar archivos que podrían sobrescribirse
    [[ -f "$TARGET_DIR/.github/copilot-instructions.md" ]] && conflicts+=(".github/copilot-instructions.md")
    [[ -f "$TARGET_DIR/.cursorrules" ]] && conflicts+=(".cursorrules")
    [[ -f "$TARGET_DIR/.continue/continue.json" ]] && conflicts+=(".continue/continue.json")
    [[ -f "$TARGET_DIR/docs/AI_ENGINEERING_GUIDE.md" ]] && conflicts+=("docs/AI_ENGINEERING_GUIDE.md")
    
    if [[ ${#conflicts[@]} -gt 0 && "$FORCE_OVERWRITE" != "true" ]]; then
        log_warning "Los siguientes archivos serán sobrescritos:"
        for file in "${conflicts[@]}"; do
            echo "  • $file"
        done
        echo ""
        read -p "¿Continuar? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Migración cancelada por el usuario"
            exit 0
        fi
    fi
}

# Función para instalar configuración base
install_base_config() {
    log_info "Instalando configuración base del framework..."
    
    cd "$TARGET_DIR"
    
    # Crear estructura de directorios
    mkdir -p .github
    mkdir -p docs
    mkdir -p .vscode
    
    # Copiar archivos base
    if [[ -f "$FRAMEWORK_DIR/ai-config/vscode-extensions/extensions.json" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/vscode-extensions/extensions.json" .vscode/
        log_success "Extensiones VS Code configuradas"
    fi
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/vscode-extensions/settings.json" ]]; then
        # Si existe settings.json, hacer merge inteligente
        if [[ -f ".vscode/settings.json" ]]; then
            log_info "Detectado settings.json existente, haciendo merge..."
            # Crear backup del settings actual
            cp .vscode/settings.json .vscode/settings.json.backup
        fi
        cp "$FRAMEWORK_DIR/ai-config/vscode-extensions/settings.json" .vscode/
        log_success "Settings VS Code configurados"
    fi
    
    # Copiar guía de ingeniería de contexto
    if [[ -f "$FRAMEWORK_DIR/docs/AI_ENGINEERING_GUIDE.md" ]]; then
        cp "$FRAMEWORK_DIR/docs/AI_ENGINEERING_GUIDE.md" docs/
        log_success "Guía de Ingeniería de Contexto instalada"
    fi
}

# Función para configurar según el lenguaje
configure_language() {
    local project_type=$1
    
    log_info "Configurando para proyecto tipo: $project_type"
    
    cd "$TARGET_DIR"
    
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
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/javascript-typescript.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/javascript-typescript.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para JS/TS instaladas"
    fi
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/cursor-config/.cursorrules" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/cursor-config/.cursorrules" .
        log_success "Reglas Cursor configuradas"
    fi
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/continue-config/continue.json" ]]; then
        mkdir -p .continue
        cp "$FRAMEWORK_DIR/ai-config/continue-config/continue.json" .continue/
        log_success "Configuración Continue instalada"
    fi
}

configure_python() {
    log_info "Configurando para Python..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/python-django-flask.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/python-django-flask.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Python instaladas"
    fi
}

configure_java() {
    log_info "Configurando para Java..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/java-spring.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/java-spring.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Java instaladas"
    fi
}

configure_csharp() {
    log_info "Configurando para C#..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/csharp-aspnet.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/csharp-aspnet.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para C# instaladas"
    fi
}

configure_go() {
    log_info "Configurando para Go..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/go-gin-fiber.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/go-gin-fiber.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Go instaladas"
    fi
}

configure_rust() {
    log_info "Configurando para Rust..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/rust-actix-rocket.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/rust-actix-rocket.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Rust instaladas"
    fi
}

configure_php() {
    log_info "Configurando para PHP..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/php-laravel-symfony.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/php-laravel-symfony.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para PHP instaladas"
    fi
}

configure_ruby() {
    log_info "Configurando para Ruby..."
    
    if [[ -f "$FRAMEWORK_DIR/ai-config/copilot-instructions/ruby-rails.md" ]]; then
        cp "$FRAMEWORK_DIR/ai-config/copilot-instructions/ruby-rails.md" .github/copilot-instructions.md
        log_success "Instrucciones GitHub Copilot para Ruby instaladas"
    fi
}

configure_generic() {
    log_info "Configurando configuración genérica..."
    
    if [[ -f "$FRAMEWORK_DIR/.github/copilot-instructions.md" ]]; then
        cp "$FRAMEWORK_DIR/.github/copilot-instructions.md" .github/
        log_success "Instrucciones GitHub Copilot genéricas instaladas"
    fi
}

# Función para actualizar .gitignore
update_gitignore() {
    log_info "Actualizando .gitignore..."
    
    cd "$TARGET_DIR"
    
    # Entradas específicas para IA
    local ai_entries=(
        "# AI Agents Configuration"
        ".continue/"
        ".cursor/"
        ".ai-context/"
        "*.ai-chat"
    )
    
    # Verificar si .gitignore existe
    if [[ -f ".gitignore" ]]; then
        # Verificar si ya tiene entradas de IA
        if ! grep -q ".continue/" .gitignore 2>/dev/null; then
            echo "" >> .gitignore
            for entry in "${ai_entries[@]}"; do
                echo "$entry" >> .gitignore
            done
            log_success ".gitignore actualizado con entradas de IA"
        else
            log_info ".gitignore ya contiene configuración de IA"
        fi
    else
        # Crear .gitignore completo
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

# AI Agents Configuration
.continue/
.cursor/
.ai-context/
*.ai-chat
EOF
        log_success ".gitignore creado con configuración de IA"
    fi
}

# Función para mostrar resumen de migración
show_migration_summary() {
    echo ""
    log_success "🎉 ¡Migración completada exitosamente!"
    echo ""
    echo "📋 Archivos instalados:"
    echo "   • .github/copilot-instructions.md"
    echo "   • docs/AI_ENGINEERING_GUIDE.md"
    echo "   • .vscode/extensions.json"
    echo "   • .vscode/settings.json"
    echo "   • .cursorrules (si aplica)"
    echo "   • .continue/continue.json (si aplica)"
    echo ""
    echo "📖 Próximos pasos:"
    echo "1. Abre VS Code en el directorio del proyecto"
    echo "2. Instala las extensiones recomendadas"
    echo "3. Lee la guía en docs/AI_ENGINEERING_GUIDE.md"
    echo "4. ¡Comienza a desarrollar con IA! 🚀"
    echo ""
    
    if [[ "$CREATE_BACKUP" == "true" ]]; then
        echo "💾 Backup creado en: $BACKUP_DIR"
        echo ""
    fi
    
    echo "🤖 Tu proyecto ahora está potenciado por IA"
}

# Función principal
main() {
    show_banner
    
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                ;;
            -b|--backup)
                CREATE_BACKUP=true
                shift
                ;;
            -f|--force)
                FORCE_OVERWRITE=true
                shift
                ;;
            -*)
                log_error "Opción desconocida: $1"
                show_help
                ;;
            *)
                TARGET_DIR="$(realpath "$1")"
                shift
                ;;
        esac
    done
    
    # Validar argumentos
    validate_arguments
    
    # Crear backup si se solicita
    create_backup
    
    # Detectar tipo de proyecto
    project_type=$(detect_project_type)
    log_info "Tipo de proyecto detectado: $project_type"
    
    # Verificar conflictos
    check_existing_files
    
    # Instalar configuración
    install_base_config
    configure_language "$project_type"
    update_gitignore
    
    # Mostrar resumen
    show_migration_summary
}

# Ejecutar script principal
main "$@"
