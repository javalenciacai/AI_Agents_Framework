@echo off
setlocal enabledelayedexpansion

REM ========================================
REM AI Agents Framework - Setup Script Avanzado (Windows)
REM Para configurar un proyecto NUEVO con IA
REM Con descarga automática + configuración interactiva
REM ========================================

set "REPO_URL=https://raw.githubusercontent.com/javalenciacai/AI_Agents_Framework/main"
set "API_URL=https://api.github.com/repos/javalenciacai/AI_Agents_Framework"

REM Función para logging simple (sin códigos ANSI problemáticos)
:log_info
echo [INFO] %~1
goto :eof

:log_success
echo [SUCCESS] %~1
goto :eof

:log_warning
echo [WARNING] %~1
goto :eof

:log_error
echo [ERROR] %~1
goto :eof

REM ========================================
REM FUNCIONES DE DESCARGA AUTOMÁTICA
REM ========================================

:verify_tools
echo [INFO] Verificando herramientas necesarias...

where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] curl no encontrado. Intentando instalar...
    powershell -Command "try { Invoke-WebRequest -Uri 'https://curl.se/windows/dl-7.88.1_1/curl-7.88.1_1-win64-mingw.zip' -OutFile 'curl.zip'; Expand-Archive 'curl.zip' -DestinationPath '.'; Remove-Item 'curl.zip' } catch { Write-Host 'Error descargando curl' }"
    set "PATH=%PATH%;%CD%\curl-7.88.1_1-win64-mingw\bin"
)

echo [SUCCESS] Herramientas verificadas
goto :eof

:download_or_copy_file
set "source_url=%~1"
set "dest_path=%~2"

echo [INFO] Descargando/copiando: %dest_path%

rem Crear directorio si no existe
for %%i in ("%dest_path%") do (
    if not exist "%%~pi" mkdir "%%~pi" 2>nul
)

rem Intentar copiar archivo local primero (si existe)
if exist "..\%dest_path%" (
    copy "..\%dest_path%" "%dest_path%" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] Copiado localmente: %dest_path%
        goto :eof
    )
)

rem Si no existe localmente, descargar
curl -L -s -f -o "%dest_path%" "%source_url%" 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Descargado: %dest_path%
) else (
    echo [WARNING] Fallo descarga: %dest_path% - creando fallback
    call :create_fallback_file "%dest_path%"
)

goto :eof

:create_fallback_file
set "file_path=%~1"
echo [INFO] Creando archivo fallback para: %file_path%

if "%file_path%"==".github\copilot-instructions.md" call :create_basic_copilot_instructions
if "%file_path%"==".vscode\settings.json" call :create_basic_vscode_settings
if "%file_path%"==".vscode\extensions.json" call :create_basic_vscode_extensions
if "%file_path%"=="docs\AI_ENGINEERING_GUIDE.md" call :create_basic_ai_guide

goto :eof

:create_basic_copilot_instructions
(
    echo # GitHub Copilot Instructions - %PROJECT_TYPE% Project
    echo.
    echo ## Project Context
    echo This is a %PROJECT_TYPE% project configured with AI Agents Framework.
    echo.
    echo ## Development Guidelines
    echo - Follow clean code principles and best practices
    echo - Use meaningful variable names and clear function signatures
    echo - Add comprehensive comments for complex business logic
    echo - Maintain consistent code formatting and style
    echo.
    echo ## AI Assistant Guidelines
    echo - Provide code suggestions that align with project architecture
    echo - Consider performance, security, and scalability implications
    echo - Suggest appropriate testing strategies and test cases
    echo - Help with documentation and code comments when needed
) > ".github\copilot-instructions.md"
goto :eof

:create_basic_vscode_settings
(
    echo {
    echo   "editor.formatOnSave": true,
    echo   "editor.codeActionsOnSave": {
    echo     "source.fixAll": true
    echo   },
    echo   "github.copilot.enable": {
    echo     "*": true
    echo   }
    echo }
) > ".vscode\settings.json"
goto :eof

:create_basic_vscode_extensions
(
    echo {
    echo   "recommendations": [
    echo     "github.copilot",
    echo     "github.copilot-chat",
    echo     "ms-vscode.vscode-typescript-next",
    echo     "bradlc.vscode-tailwindcss",
    echo     "esbenp.prettier-vscode"
    echo   ]
    echo }
) > ".vscode\extensions.json"
goto :eof

:create_basic_ai_guide
(
    echo # AI Engineering Guide
    echo.
    echo ## Quick Start
    echo This project is configured with AI Agents Framework.
    echo.
    echo ## AI Tools Available
    echo - GitHub Copilot for code completion
    echo - VS Code extensions for AI assistance
    echo - MCP servers for external integrations
    echo.
    echo ## Next Steps
    echo 1. Configure your AI API keys in .env
    echo 2. Start coding with AI assistance
    echo 3. Explore the documentation for advanced features
) > "docs\AI_ENGINEERING_GUIDE.md"
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

rem Descargar template si existe
call :download_or_copy_file "%REPO_URL%/templates/database-configs/postgresql.json" "templates\database-configs\postgresql.json"

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

rem Descargar template si existe
call :download_or_copy_file "%REPO_URL%/templates/database-configs/mongodb.json" "templates\database-configs\mongodb.json"

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

:configure_sqlite
call :log_info "Configurando SQLite..."

rem Descargar template si existe
call :download_or_copy_file "%REPO_URL%/templates/database-configs/sqlite.json" "templates\database-configs\sqlite.json"

(
    echo # SQLite Configuration
    echo DB_TYPE=sqlite
    echo DB_PATH=./database.sqlite
    echo DATABASE_URL=sqlite:./database.sqlite
) >> .env

call :log_success "SQLite configurado para desarrollo local"
goto :eof

:configure_redis
call :log_info "Configurando Redis..."

rem Descargar template si existe
call :download_or_copy_file "%REPO_URL%/templates/database-configs/redis.json" "templates\database-configs\redis.json"

(
    echo # Redis Configuration
    echo CACHE_TYPE=redis
    echo REDIS_HOST=localhost
    echo REDIS_PORT=6379
    echo REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}
) >> .env

call :log_success "Redis configurado para cache y sesiones"
goto :eof

:configure_mysql
call :log_info "Configurando MySQL..."

rem Descargar template si existe
call :download_or_copy_file "%REPO_URL%/templates/database-configs/mysql.json" "templates\database-configs\mysql.json"

(
    echo # MySQL Configuration
    echo DB_TYPE=mysql
    echo DB_HOST=localhost
    echo DB_PORT=3306
    echo DB_NAME=your_app_db
    echo DB_USER=your_user
    echo DB_PASSWORD=your_password
    echo DATABASE_URL=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
) >> .env

call :log_success "MySQL configurado para aplicaciones web tradicionales"
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

rem Descargar template de desarrollo
call :download_or_copy_file "%REPO_URL%/templates/mcp-configs/development.json" ".mcp\config.json"

(
    echo.
    echo # MCP Development Configuration
    echo GITHUB_TOKEN=your_github_token_here
    echo LINEAR_API_KEY=your_linear_api_key_here
    echo SLACK_BOT_TOKEN=your_slack_bot_token_here
) >> .env

call :log_success "MCP configurado para desarrollo con GitHub, Linear y Slack"
goto :eof

:configure_database_mcp
call :log_info "Configurando MCP para bases de datos..."

rem Descargar template de base de datos
call :download_or_copy_file "%REPO_URL%/templates/mcp-configs/database.json" ".mcp\config.json"

(
    echo.
    echo # MCP Database Configuration
    echo DB_MCP_ENABLED=true
    echo POSTGRES_MCP_ENABLED=true
    echo MONGODB_MCP_ENABLED=true
    echo REDIS_MCP_ENABLED=true
) >> .env

call :log_success "MCP configurado para PostgreSQL, MongoDB y Redis"
goto :eof

:configure_cloud_mcp
call :log_info "Configurando MCP para servicios cloud..."

rem Descargar template de cloud
call :download_or_copy_file "%REPO_URL%/templates/mcp-configs/cloud.json" ".mcp\config.json"

(
    echo.
    echo # MCP Cloud Configuration
    echo AWS_MCP_ENABLED=true
    echo GOOGLE_CLOUD_MCP_ENABLED=true
    echo AZURE_MCP_ENABLED=true
    echo AWS_ACCESS_KEY_ID=your_aws_access_key
    echo AWS_SECRET_ACCESS_KEY=your_aws_secret_key
    echo GOOGLE_APPLICATION_CREDENTIALS=path_to_google_credentials.json
    echo AZURE_CLIENT_ID=your_azure_client_id
) >> .env

call :log_success "MCP configurado para AWS, Google Cloud y Azure"
goto :eof

:configure_api_mcp
call :log_info "Configurando MCP para APIs..."

rem Crear configuración personalizada para APIs
if not exist ".mcp" mkdir ".mcp"
(
    echo {
    echo   "mcpServers": {
    echo     "rest-api": {
    echo       "command": "npx",
    echo       "args": ["@modelcontextprotocol/server-rest"]
    echo     },
    echo     "graphql": {
    echo       "command": "npx", 
    echo       "args": ["@modelcontextprotocol/server-graphql"]
    echo     },
    echo     "openapi": {
    echo       "command": "npx",
    echo       "args": ["@modelcontextprotocol/server-openapi"]
    echo     }
    echo   }
    echo }
) > ".mcp\config.json"

(
    echo.
    echo # MCP API Configuration
    echo REST_API_ENABLED=true
    echo GRAPHQL_ENABLED=true
    echo OPENAPI_ENABLED=true
) >> .env

call :log_success "MCP configurado para REST, GraphQL y OpenAPI"
goto :eof

:configure_productivity_mcp
call :log_info "Configurando MCP para productividad..."

rem Crear configuración para herramientas de productividad
if not exist ".mcp" mkdir ".mcp"
(
    echo {
    echo   "mcpServers": {
    echo     "notion": {
    echo       "command": "npx",
    echo       "args": ["@notion/mcp-server"]
    echo     },
    echo     "jira": {
    echo       "command": "npx",
    echo       "args": ["@atlassian/mcp-jira"]
    echo     },
    echo     "trello": {
    echo       "command": "npx",
    echo       "args": ["@trello/mcp-server"]
    echo     }
    echo   }
    echo }
) > ".mcp\config.json"

(
    echo.
    echo # MCP Productivity Configuration
    echo NOTION_API_KEY=your_notion_api_key
    echo JIRA_API_TOKEN=your_jira_api_token
    echo TRELLO_API_KEY=your_trello_api_key
) >> .env

call :log_success "MCP configurado para Notion, Jira y Trello"
goto :eof

REM Función para instalar configuración base
:install_base_config
call :log_info "Instalando configuracion base del framework..."

call :verify_tools

REM Crear estructura de directorios
if not exist ".github" mkdir .github
if not exist "docs" mkdir docs
if not exist "ai-config" mkdir ai-config
if not exist ".vscode" mkdir .vscode
if not exist "templates" mkdir templates
if not exist "templates\database-configs" mkdir "templates\database-configs"
if not exist "templates\mcp-configs" mkdir "templates\mcp-configs"

REM Descargar/copiar archivos críticos
call :download_or_copy_file "%REPO_URL%/ai-config/vscode-extensions/extensions.json" ".vscode\extensions.json"
call :download_or_copy_file "%REPO_URL%/ai-config/vscode-extensions/settings.json" ".vscode\settings.json"
call :download_or_copy_file "%REPO_URL%/docs/AI_ENGINEERING_GUIDE.md" "docs\AI_ENGINEERING_GUIDE.md"

call :log_success "Configuracion base instalada con descarga automatica"
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

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/javascript-typescript.md" ".github\copilot-instructions.md"
call :download_or_copy_file "%REPO_URL%/ai-config/cursor-config/.cursorrules" ".cursorrules"

if not exist ".continue" mkdir ".continue"
call :download_or_copy_file "%REPO_URL%/ai-config/continue-config/continue.json" ".continue\continue.json"

call :log_success "Configuracion para JavaScript/TypeScript instalada"
goto :configure_done

:configure_python
call :log_info "Configurando para Python..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/python-django-flask.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para Python instalada"
goto :configure_done

:configure_java
call :log_info "Configurando para Java..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/java-spring.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para Java instalada"
goto :configure_done

:configure_csharp
call :log_info "Configurando para C#..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/csharp-aspnet.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para C# instalada"
goto :configure_done

:configure_go
call :log_info "Configurando para Go..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/go-gin-fiber.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para Go instalada"
goto :configure_done

:configure_rust
call :log_info "Configurando para Rust..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/rust-actix-rocket.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para Rust instalada"
goto :configure_done

:configure_php
call :log_info "Configurando para PHP..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/php-laravel-symfony.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para PHP instalada"
goto :configure_done

:configure_ruby
call :log_info "Configurando para Ruby..."

call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/ruby-rails.md" ".github\copilot-instructions.md"

call :log_success "Configuracion para Ruby instalada"
goto :configure_done

:configure_generic
call :log_info "Configurando configuracion generica..."

call :download_or_copy_file "%REPO_URL%/.github/copilot-instructions.md" ".github\copilot-instructions.md"

call :log_success "Configuracion generica instalada"

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
    call :log_info "Creando .gitignore optimizado para %PROJECT_TYPE%..."
    
    (
        echo # ==========================================
        echo # AI Agents Framework - Gitignore
        echo # Proyecto tipo: %PROJECT_TYPE%
        echo # ==========================================
        echo.
        echo # Environment variables ^(CRITICAL - Never commit API keys^)
        echo .env
        echo .env.local
        echo .env.*.local
        echo .env.production
        echo .env.staging
        echo secrets.json
        echo.
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
        echo # IDE ^(keep AI configurations^)
        echo .vscode/
        echo !.vscode/settings.json
        echo !.vscode/tasks.json
        echo !.vscode/launch.json
        echo !.vscode/extensions.json
        echo .idea/
        echo *.swp
        echo *.swo
        echo *~
        echo.
        echo # OS Files
        echo .DS_Store
        echo Thumbs.db
        echo *.log
        echo Desktop.ini
        echo $RECYCLE.BIN/
        echo.
        echo # Build outputs
        echo dist/
        echo build/
        echo *.exe
        echo *.dll
        echo *.so
        echo *.dylib
        echo target/
        echo out/
        echo.
        echo # Package managers
        echo package-lock.json
        echo yarn.lock
        echo composer.lock
        echo Gemfile.lock
        echo.
        echo # AI specific ^(Keep framework configs^)
        echo .continue/
        echo !.continue/continue.json
        echo .cursor/
        echo .ai-context/
        echo .copilot-settings.json
        echo.
        echo # Keep important AI files
        echo !.github/copilot-instructions.md
        echo !.cursorrules
        echo !docs/AI_ENGINEERING_GUIDE.md
        echo !templates/
        
        if "%PROJECT_TYPE%"=="javascript" (
            echo.
            echo # JavaScript/Node.js specific
            echo .next/
            echo .nuxt/
            echo .cache/
            echo .parcel-cache/
            echo coverage/
            echo .nyc_output/
        )
        
        if "%PROJECT_TYPE%"=="python" (
            echo.
            echo # Python specific
            echo venv/
            echo env/
            echo ENV/
            echo .venv/
            echo *.egg-info/
            echo .pytest_cache/
            echo .coverage
            echo htmlcov/
        )
        
        if "%PROJECT_TYPE%"=="java" (
            echo.
            echo # Java specific
            echo *.class
            echo .gradle/
            echo gradle-app.setting
            echo !gradle-wrapper.jar
        )
    ) > .gitignore
    
    call :log_success ".gitignore optimizado creado para %PROJECT_TYPE%"
)
goto :eof

REM Función para mostrar siguiente pasos
:show_next_steps
echo.
call :log_success "Configuracion avanzada completada con descarga automatica!"
echo.
echo ========================================
echo   PROXIMOS PASOS PARA SUPERPODERES IA
echo ========================================
echo.
echo 🔧 **CONFIGURACION:**
echo   1. Edita el archivo .env con tus API keys
echo   2. Configura las credenciales de servicios externos
echo   3. Abre VS Code: code .
echo.
echo 🤖 **AGENTES IA LISTOS:**
echo   • GitHub Copilot ^(configurado para %PROJECT_TYPE%^)
echo   • VS Code Extensions ^(descargadas automaticamente^)
echo   • MCP Servers ^(configurados segun seleccion^)
echo   • Continue/Cursor ^(si estan instalados^)
echo.
echo 📚 **DOCUMENTACION DESCARGADA:**
echo   • docs\AI_ENGINEERING_GUIDE.md - Metodologia completa
echo   • .github\copilot-instructions.md - Instrucciones especificas
echo   • templates\ - Configuraciones listas para usar
echo.
echo 🗄️ **BASE DE DATOS CONFIGURADA:**
echo   • Tipo seleccionado: Segun tu eleccion interactiva
echo   • Variables de entorno: Agregadas a .env
echo   • Templates: Descargados automaticamente
echo.
echo 🔗 **INTEGRACIONES MCP:**
echo   • Servidores configurados segun proposito del proyecto
echo   • Configuraciones descargadas desde GitHub
echo   • Variables de entorno preparadas
echo.
echo 🎯 **COMIENZA A DESARROLLAR:**
echo   • El proyecto esta listo para desarrollo con IA
echo   • Todos los archivos descargados automaticamente
echo   • Configuracion interactiva completada
echo   • Git inicializado con ramas recomendadas
echo.
echo 🌐 **RECURSOS ADICIONALES:**
echo   • Framework: https://github.com/javalenciacai/AI_Agents_Framework
echo   • Issues: https://github.com/javalenciacai/AI_Agents_Framework/issues
echo   • Docs: ./docs/AI_ENGINEERING_GUIDE.md
echo.
echo ⚡ **VENTAJAS DE ESTA CONFIGURACION:**
echo   ✅ Descarga automatica desde GitHub
echo   ✅ Configuracion interactiva personalizada
echo   ✅ Optimizado para tu tipo de proyecto: %PROJECT_TYPE%
echo   ✅ Todas las mejores practicas incluidas
echo   ✅ Listo para escalabilidad empresarial
echo.
goto :eof

REM Función principal
:main
call :show_banner

REM Detectar tipo de proyecto
call :detect_project_type
call :log_info "Tipo de proyecto detectado: !PROJECT_TYPE!"

REM Configurar base de datos
call :configure_database

REM Configurar MCP servers
call :configure_mcp

REM Instalar configuración base
call :install_base_config

REM Configurar según lenguaje detectado
call :configure_language

REM Configurar Git y .gitignore
call :setup_git
call :create_gitignore

REM Mostrar próximos pasos
call :show_next_steps

pause
exit /b 0

REM ========================================
REM EJECUTAR FUNCIÓN PRINCIPAL
REM ========================================
call :main
