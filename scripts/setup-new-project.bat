@echo off
setlocal enabledelayedexpansion

REM ========================================
REM AI Agents Framework - Setup Script (Windows)
REM Para configurar un proyecto NUEVO con IA
REM ========================================

REM Colores para output (usando echo con códigos ANSI si está soportado)
set "RED=[31m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "NC=[0m"

REM Función para logging
:log_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:log_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:log_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Función para mostrar banner
:show_banner
echo.
echo ========================================
echo   AI Agents Framework - Setup Proyecto Nuevo
echo   Configuracion automatica para desarrollo con IA
echo ========================================
echo.
goto :eof

REM Función para detectar el tipo de proyecto
:detect_project_type
call :log_info "Detectando tipo de proyecto..."

if exist "package.json" (
    set "PROJECT_TYPE=javascript"
    goto :detect_done
)

if exist "requirements.txt" (
    set "PROJECT_TYPE=python"
    goto :detect_done
)

if exist "pyproject.toml" (
    set "PROJECT_TYPE=python"
    goto :detect_done
)

if exist "setup.py" (
    set "PROJECT_TYPE=python"
    goto :detect_done
)

if exist "pom.xml" (
    set "PROJECT_TYPE=java"
    goto :detect_done
)

if exist "build.gradle" (
    set "PROJECT_TYPE=java"
    goto :detect_done
)

for %%f in (*.csproj) do (
    set "PROJECT_TYPE=csharp"
    goto :detect_done
)

for %%f in (*.sln) do (
    set "PROJECT_TYPE=csharp"
    goto :detect_done
)

if exist "go.mod" (
    set "PROJECT_TYPE=go"
    goto :detect_done
)

if exist "Cargo.toml" (
    set "PROJECT_TYPE=rust"
    goto :detect_done
)

if exist "composer.json" (
    set "PROJECT_TYPE=php"
    goto :detect_done
)

if exist "Gemfile" (
    set "PROJECT_TYPE=ruby"
    goto :detect_done
)

set "PROJECT_TYPE=unknown"

:detect_done
goto :eof

REM Función para configurar base de datos
:configure_database
call :log_info "Configurando base de datos segun el proposito del proyecto..."

echo.
echo Selecciona el tipo de base de datos mas adecuado:
echo 1) PostgreSQL - Aplicaciones empresariales, ACID completo
echo 2) MongoDB - Documentos, escalabilidad horizontal  
echo 3) SQLite - Desarrollo local, aplicaciones simples
echo 4) Redis - Cache, sesiones, tiempo real
echo 5) MySQL - Aplicaciones web tradicionales
echo 6) Multiple bases de datos
echo 0) Omitir configuracion de BD
echo.

set /p "db_choice=Selecciona una opcion (1-6, 0): "

if "%db_choice%"=="1" goto :configure_postgresql
if "%db_choice%"=="2" goto :configure_mongodb
if "%db_choice%"=="3" goto :configure_sqlite
if "%db_choice%"=="4" goto :configure_redis
if "%db_choice%"=="5" goto :configure_mysql
if "%db_choice%"=="6" goto :configure_multiple_databases
if "%db_choice%"=="0" (
    call :log_info "Configuracion de base de datos omitida"
    goto :eof
)

call :log_warning "Opcion no valida. Usando configuracion por defecto."
goto :configure_postgresql

:configure_postgresql
call :log_info "Configurando PostgreSQL..."

(
    echo # PostgreSQL Configuration
    echo DB_TYPE=postgresql
    echo DB_HOST=localhost
    echo DB_PORT=5432
    echo DB_NAME=your_app_db
    echo DB_USER=your_user
    echo DB_PASSWORD=your_password
    echo DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
) >> .env

call :log_success "PostgreSQL configurado para aplicaciones empresariales"
goto :eof

:configure_mongodb
call :log_info "Configurando MongoDB..."

(
    echo # MongoDB Configuration
    echo DB_TYPE=mongodb
    echo DB_HOST=localhost
    echo DB_PORT=27017
    echo DB_NAME=your_app_db
    echo MONGODB_URI=mongodb://${DB_HOST}:${DB_PORT}/${DB_NAME}
) >> .env

call :log_success "MongoDB configurado para aplicaciones con documentos"
goto :eof

:configure_multiple_databases
call :log_info "Configurando arquitectura multi-base de datos..."

(
    echo # Multi-Database Configuration
    echo # Primary Database (PostgreSQL^)
    echo PRIMARY_DB_TYPE=postgresql
    echo PRIMARY_DB_HOST=localhost
    echo PRIMARY_DB_PORT=5432
    echo PRIMARY_DB_NAME=your_app_db
    echo PRIMARY_DATABASE_URL=postgresql://user:pass@localhost:5432/your_app_db
    echo.
    echo # Cache Layer (Redis^)
    echo CACHE_HOST=localhost
    echo CACHE_PORT=6379
    echo REDIS_URL=redis://localhost:6379
    echo.
    echo # Analytics/Logs (MongoDB^)
    echo ANALYTICS_DB_HOST=localhost
    echo ANALYTICS_DB_PORT=27017
    echo ANALYTICS_DB_NAME=analytics_db
    echo MONGODB_URI=mongodb://localhost:27017/analytics_db
) >> .env

call :log_success "Configuracion multi-base de datos lista"
goto :eof

REM Función para configurar MCP
:configure_mcp
call :log_info "Configurando servidores MCP segun el proposito del proyecto..."

if not exist ".mcp" mkdir .mcp

echo.
echo Selecciona los servidores MCP que necesitas:
echo 1) Desarrollo completo (GitHub + Linear + Slack^)
echo 2) Base de datos (PostgreSQL + MongoDB + Redis^)
echo 3) Cloud services (AWS + Google Cloud + Azure^)
echo 4) APIs (REST + GraphQL + OpenAPI^)
echo 5) Productividad (Notion + Jira^)
echo 6) Configuracion personalizada
echo 0) Omitir configuracion MCP
echo.

set /p "mcp_choice=Selecciona una opcion (1-6, 0): "

if "%mcp_choice%"=="1" goto :configure_development_mcp
if "%mcp_choice%"=="2" goto :configure_database_mcp
if "%mcp_choice%"=="3" goto :configure_cloud_mcp
if "%mcp_choice%"=="4" goto :configure_api_mcp
if "%mcp_choice%"=="5" goto :configure_productivity_mcp
if "%mcp_choice%"=="0" (
    call :log_info "Configuracion MCP omitida"
    goto :eof
)

call :log_warning "Opcion no valida. Configurando MCP basico."
goto :configure_development_mcp

:configure_development_mcp
call :log_info "Configurando MCP para desarrollo completo..."

if exist "..\templates\mcp-configs\development.json" (
    copy "..\templates\mcp-configs\development.json" ".mcp\config.json" >nul
    call :log_success "MCP configurado para desarrollo con GitHub, Linear y Slack"
) else (
    call :log_warning "Template MCP no encontrado, configurando manualmente"
)

(
    echo.
    echo # MCP Development Configuration
    echo GITHUB_TOKEN=your_github_token_here
    echo LINEAR_API_KEY=your_linear_api_key_here
    echo SLACK_BOT_TOKEN=your_slack_bot_token_here
) >> .env

goto :eof

:configure_database_mcp
call :log_info "Configurando MCP para bases de datos..."

if exist "..\templates\mcp-configs\database.json" (
    copy "..\templates\mcp-configs\database.json" ".mcp\config.json" >nul
    call :log_success "MCP configurado para PostgreSQL, MongoDB y Redis"
)

goto :eof

REM Función para instalar configuración base
:install_base_config
call :log_info "Instalando configuracion base del framework..."

REM Crear estructura de directorios
if not exist ".github" mkdir .github
if not exist "docs" mkdir docs
if not exist "ai-config" mkdir ai-config
if not exist ".vscode" mkdir .vscode

REM Copiar archivos base
if exist "..\ai-config\vscode-extensions\extensions.json" (
    copy "..\ai-config\vscode-extensions\extensions.json" ".vscode\" >nul
    call :log_success "Extensiones VS Code configuradas"
)

if exist "..\ai-config\vscode-extensions\settings.json" (
    copy "..\ai-config\vscode-extensions\settings.json" ".vscode\" >nul
    call :log_success "Settings VS Code configurados"
)

if exist "..\docs\AI_ENGINEERING_GUIDE.md" (
    copy "..\docs\AI_ENGINEERING_GUIDE.md" "docs\" >nul
    call :log_success "Guia de Ingenieria de Contexto instalada"
)

goto :eof

REM Función para configurar según el lenguaje
:configure_language
call :log_info "Configurando para proyecto tipo: %PROJECT_TYPE%"

if "%PROJECT_TYPE%"=="javascript" goto :configure_javascript
if "%PROJECT_TYPE%"=="python" goto :configure_python
if "%PROJECT_TYPE%"=="java" goto :configure_java
if "%PROJECT_TYPE%"=="csharp" goto :configure_csharp
if "%PROJECT_TYPE%"=="go" goto :configure_go
if "%PROJECT_TYPE%"=="rust" goto :configure_rust
if "%PROJECT_TYPE%"=="php" goto :configure_php
if "%PROJECT_TYPE%"=="ruby" goto :configure_ruby

call :log_warning "Tipo de proyecto no reconocido. Instalando configuracion generica."
goto :configure_generic

:configure_javascript
call :log_info "Configurando para JavaScript/TypeScript..."

if exist "..\ai-config\copilot-instructions\javascript-typescript.md" (
    copy "..\ai-config\copilot-instructions\javascript-typescript.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para JS/TS instaladas"
)

if exist "..\ai-config\cursor-config\.cursorrules" (
    copy "..\ai-config\cursor-config\.cursorrules" "." >nul
    call :log_success "Reglas Cursor configuradas"
)

if exist "..\ai-config\continue-config\continue.json" (
    if not exist ".continue" mkdir .continue
    copy "..\ai-config\continue-config\continue.json" ".continue\" >nul
    call :log_success "Configuracion Continue instalada"
)
goto :configure_done

:configure_python
call :log_info "Configurando para Python..."

if exist "..\ai-config\copilot-instructions\python-django-flask.md" (
    copy "..\ai-config\copilot-instructions\python-django-flask.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para Python instaladas"
)
goto :configure_done

:configure_java
call :log_info "Configurando para Java..."

if exist "..\ai-config\copilot-instructions\java-spring.md" (
    copy "..\ai-config\copilot-instructions\java-spring.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para Java instaladas"
)
goto :configure_done

:configure_csharp
call :log_info "Configurando para C#..."

if exist "..\ai-config\copilot-instructions\csharp-aspnet.md" (
    copy "..\ai-config\copilot-instructions\csharp-aspnet.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para C# instaladas"
)
goto :configure_done

:configure_go
call :log_info "Configurando para Go..."

if exist "..\ai-config\copilot-instructions\go-gin-fiber.md" (
    copy "..\ai-config\copilot-instructions\go-gin-fiber.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para Go instaladas"
)
goto :configure_done

:configure_rust
call :log_info "Configurando para Rust..."

if exist "..\ai-config\copilot-instructions\rust-actix-rocket.md" (
    copy "..\ai-config\copilot-instructions\rust-actix-rocket.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para Rust instaladas"
)
goto :configure_done

:configure_php
call :log_info "Configurando para PHP..."

if exist "..\ai-config\copilot-instructions\php-laravel-symfony.md" (
    copy "..\ai-config\copilot-instructions\php-laravel-symfony.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para PHP instaladas"
)
goto :configure_done

:configure_ruby
call :log_info "Configurando para Ruby..."

if exist "..\ai-config\copilot-instructions\ruby-rails.md" (
    copy "..\ai-config\copilot-instructions\ruby-rails.md" ".github\copilot-instructions.md" >nul
    call :log_success "Instrucciones GitHub Copilot para Ruby instaladas"
)
goto :configure_done

:configure_generic
call :log_info "Configurando configuracion generica..."

if exist "..\.github\copilot-instructions.md" (
    copy "..\.github\copilot-instructions.md" ".github\" >nul
    call :log_success "Instrucciones GitHub Copilot genericas instaladas"
)

:configure_done
goto :eof

REM Función para configurar Git
:setup_git
call :log_info "Configurando Git con ramas recomendadas..."

REM Verificar si Git está instalado
git --version >nul 2>&1
if errorlevel 1 (
    call :log_warning "Git no está instalado. Saltando configuracion de Git."
    goto :eof
)

REM Inicializar Git si no existe
if not exist ".git" (
    git init >nul 2>&1
    call :log_success "Repositorio Git inicializado"
)

REM Crear ramas recomendadas
git checkout -b main >nul 2>&1
git checkout -b develop >nul 2>&1
git checkout -b testing >nul 2>&1
git checkout main >nul 2>&1

call :log_success "Ramas Git configuradas (main, develop, testing)"
goto :eof

REM Función para crear .gitignore si no existe
:create_gitignore
if not exist ".gitignore" (
    call :log_info "Creando .gitignore..."
    
    (
        echo # Dependencies
        echo node_modules/
        echo vendor/
        echo *.egg-info/
        echo __pycache__/
        echo *.pyc
        echo *.pyo
        echo *.pyd
        echo .Python
        echo pip-log.txt
        echo pip-delete-this-directory.txt
        echo.
        echo # IDE
        echo .vscode/settings.json
        echo .idea/
        echo *.swp
        echo *.swo
        echo *~
        echo.
        echo # OS
        echo .DS_Store
        echo Thumbs.db
        echo *.log
        echo.
        echo # Environment variables
        echo .env
        echo .env.local
        echo .env.*.local
        echo.
        echo # Build outputs
        echo dist/
        echo build/
        echo *.exe
        echo *.dll
        echo *.so
        echo *.dylib
        echo.
        echo # Package managers
        echo package-lock.json
        echo yarn.lock
        echo composer.lock
        echo Gemfile.lock
        echo.
        echo # AI specific
        echo .continue/
        echo .cursor/
        echo .ai-context/
    ) > .gitignore
    
    call :log_success ".gitignore creado"
)
goto :eof

REM Función para mostrar siguiente pasos
:show_next_steps
echo.
call :log_success "Configuracion completada!"
echo.
echo Proximos pasos:
echo 1. Abre VS Code en este directorio
echo 2. Instala las extensiones recomendadas
echo 3. Lee la guia en docs\AI_ENGINEERING_GUIDE.md
echo 4. Comienza a desarrollar con IA
echo.
echo Documentacion disponible en:
echo   • docs\AI_ENGINEERING_GUIDE.md
echo   • .github\copilot-instructions.md
echo.
echo Agentes IA configurados:
echo   • GitHub Copilot (VS Code)
echo   • Cursor (si esta instalado)
echo   • Continue (si esta instalado)
echo.
echo Base de datos configurada segun seleccion
echo Servidores MCP configurados segun proposito
echo.
echo Para configurar las API keys:
echo   • Edita el archivo .env con tus credenciales
echo   • Consulta docs\AI_ENGINEERING_GUIDE.md para detalles
echo.
goto :eof

REM Función principal
:main
call :show_banner

REM Verificar que estamos en el directorio correcto
if not exist "..\scripts\setup-new-project.bat" (
    call :log_error "Este script debe ejecutarse desde el directorio de tu proyecto"
    call :log_error "El framework debe estar en el directorio padre"
    pause
    exit /b 1
)

REM Detectar tipo de proyecto
call :detect_project_type
call :log_info "Tipo de proyecto detectado: !PROJECT_TYPE!"

REM Configurar base de datos
call :configure_database

REM Configurar MCP servers
call :configure_mcp

REM Instalar configuración
call :install_base_config
call :configure_language
call :setup_git
call :create_gitignore

REM Mostrar siguiente pasos
call :show_next_steps

pause
goto :eof

REM Ejecutar función principal
call :main
