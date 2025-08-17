@echo off
setlocal enabledelayedexpansion

REM ========================================
REM AI Agents Framework - Setup Script Avanzado (Windows)
REM Para configurar un proyecto NUEVO con IA
REM Con descarga automática + configuración interactiva
REM ========================================

set "REPO_URL=https://raw.githubusercontent.com/javalenciacai/AI_Agents_Framework/main"

REM ========================================
REM BLOQUE DE EJECUCIÓN PRINCIPAL
REM ========================================

call :show_banner
call :verify_tools

REM --- Obtener nombre del proyecto ---
set "PROJECT_NAME="
set /p "PROJECT_NAME=Introduce el nombre del proyecto: "
if not defined PROJECT_NAME set "PROJECT_NAME=mi-proyecto-ai"
call :log_info "Creando y configurando el directorio del proyecto: !PROJECT_NAME!"

if not exist "!PROJECT_NAME!" mkdir "!PROJECT_NAME!"
cd "!PROJECT_NAME!"

REM --- Lógica Principal ---
call :detect_project_type
call :log_info "Tipo de proyecto detectado: !PROJECT_TYPE!"

REM --- Creación de archivos de configuración ---
echo # Environment variables for !PROJECT_NAME! > .env
echo. >> .env

call :configure_database
call :configure_mcp
call :install_base_config
call :configure_language
call :setup_git
call :create_gitignore
call :create_readme

call :show_next_steps

echo.
call :log_success "Script finalizado."
pause
goto :eof


REM ========================================
REM DEFINICIONES DE FUNCIONES
REM ========================================

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

:show_banner
echo.
echo ========================================
echo   AI Agents Framework - Setup Avanzado
echo   Configuracion interactiva para desarrollo con IA
echo ========================================
echo.
goto :eof

:verify_tools
echo [INFO] Verificando herramientas necesarias...
where curl >nul 2>&1
if %errorlevel% neq 0 (
    call :log_error "curl no está instalado. Por favor, instálalo y asegúrate de que esté en el PATH."
    call :log_error "Puedes descargarlo desde: https://curl.se/windows/"
    pause
    exit /b 1
)
where git >nul 2>&1
if %errorlevel% neq 0 (
    call :log_warning "Git no está instalado. Se omitirá la configuración del repositorio."
)
echo [SUCCESS] Herramientas verificadas.
goto :eof

:download_or_copy_file
set "source_url=%~1"
set "dest_path=%~2"

echo [INFO] Procesando archivo: %dest_path%

rem Crear directorio si no existe
for %%i in ("%dest_path%") do (
    if not exist "%%~pi" mkdir "%%~pi" 2>nul
)

rem Intentar copiar archivo local primero (si existe en el directorio padre)
if exist "..\..\%dest_path%" (
    copy "..\..\%dest_path%" "%dest_path%" >nul 2>&1
    if %errorlevel% equ 0 (
        call :log_success "Copiado localmente: %dest_path%"
        goto :eof
    )
)

rem Si no existe localmente, descargar
curl -L -s -f -o "%dest_path%" "%source_url%" 2>nul
if %errorlevel% equ 0 (
    call :log_success "Descargado: %dest_path%"
) else (
    call :log_warning "Fallo descarga: %dest_path% - creando fallback."
    call :create_fallback_file "%dest_path%"
)
goto :eof

:create_fallback_file
set "file_path=%~1"
call :log_info "Creando archivo fallback para: %file_path%"

if /i "%file_path%"==".github\copilot-instructions.md" call :create_basic_copilot_instructions
if /i "%file_path%"==".vscode\settings.json" call :create_basic_vscode_settings
if /i "%file_path%"==".vscode\extensions.json" call :create_basic_vscode_extensions
if /i "%file_path%"=="docs\AI_ENGINEERING_GUIDE.md" call :create_basic_ai_guide
goto :eof

:create_basic_copilot_instructions
(
    echo # GitHub Copilot Instructions - !PROJECT_TYPE! Project
    echo.
    echo ## Project Context
    echo This is a !PROJECT_TYPE! project configured with AI Agents Framework.
) > ".github\copilot-instructions.md"
goto :eof

:create_basic_vscode_settings
(
    echo {
    echo   "editor.formatOnSave": true,
    echo   "github.copilot.enable": { "*": true }
    echo }
) > ".vscode\settings.json"
goto :eof

:create_basic_vscode_extensions
(
    echo {
    echo   "recommendations": [ "github.copilot", "github.copilot-chat" ]
    echo }
) > ".vscode\extensions.json"
goto :eof

:create_basic_ai_guide
(
    echo # AI Engineering Guide
    echo.
    echo This project is configured with AI Agents Framework.
) > "docs\AI_ENGINEERING_GUIDE.md"
goto :eof

:detect_project_type
call :log_info "Detectando tipo de proyecto en el directorio actual..."
if exist "package.json" (set "PROJECT_TYPE=javascript" & goto :detect_done)
if exist "requirements.txt" (set "PROJECT_TYPE=python" & goto :detect_done)
if exist "pyproject.toml" (set "PROJECT_TYPE=python" & goto :detect_done)
if exist "pom.xml" (set "PROJECT_TYPE=java" & goto :detect_done)
if exist "build.gradle" (set "PROJECT_TYPE=java" & goto :detect_done)
if exist "go.mod" (set "PROJECT_TYPE=go" & goto :detect_done)
if exist "Cargo.toml" (set "PROJECT_TYPE=rust" & goto :detect_done)
set "PROJECT_TYPE=unknown"
:detect_done
goto :eof

:configure_database
call :log_info "Configurando base de datos..."
echo.
echo Selecciona el tipo de base de datos:
echo 1) PostgreSQL    5) MySQL
echo 2) MongoDB       6) Múltiples bases de datos
echo 3) SQLite        0) Omitir
echo 4) Redis
echo.
set /p "db_choice=Selecciona una opcion: "
if "%db_choice%"=="1" (call :configure_postgresql & goto :eof)
if "%db_choice%"=="2" (call :configure_mongodb & goto :eof)
if "%db_choice%"=="3" (call :configure_sqlite & goto :eof)
if "%db_choice%"=="4" (call :configure_redis & goto :eof)
if "%db_choice%"=="5" (call :configure_mysql & goto :eof)
if "%db_choice%"=="6" (call :configure_multiple_databases & goto :eof)
call :log_info "Configuracion de base de datos omitida."
goto :eof

:configure_postgresql
call :log_info "Configurando PostgreSQL..."
call :download_or_copy_file "%REPO_URL%/templates/database-configs/postgresql.json" "templates\database-configs\postgresql.json"
(
    echo # PostgreSQL Configuration
    echo DB_TYPE=postgresql
    echo DATABASE_URL=postgresql://user:pass@localhost:5432/app_db
) >> .env
call :log_success "PostgreSQL configurado."
goto :eof

:configure_mongodb
call :log_info "Configurando MongoDB..."
call :download_or_copy_file "%REPO_URL%/templates/database-configs/mongodb.json" "templates\database-configs\mongodb.json"
(
    echo # MongoDB Configuration
    echo DB_TYPE=mongodb
    echo MONGODB_URI=mongodb://localhost:27017/app_db
) >> .env
call :log_success "MongoDB configurado."
goto :eof

:configure_sqlite
call :log_info "Configurando SQLite..."
(
    echo # SQLite Configuration
    echo DB_TYPE=sqlite
    echo DATABASE_URL=sqlite:./database.sqlite
) >> .env
call :log_success "SQLite configurado."
goto :eof

:configure_redis
call :log_info "Configurando Redis..."
(
    echo # Redis Configuration
    echo CACHE_TYPE=redis
    echo REDIS_URL=redis://localhost:6379
) >> .env
call :log_success "Redis configurado."
goto :eof

:configure_mysql
call :log_info "Configurando MySQL..."
call :download_or_copy_file "%REPO_URL%/templates/database-configs/mysql.json" "templates\database-configs\mysql.json"
(
    echo # MySQL Configuration
    echo DB_TYPE=mysql
    echo DATABASE_URL=mysql://user:pass@localhost:3306/app_db
) >> .env
call :log_success "MySQL configurado."
goto :eof

:configure_multiple_databases
call :log_info "Configurando arquitectura multi-base de datos..."
(
    echo # Multi-Database Configuration
    echo PRIMARY_DATABASE_URL=postgresql://user:pass@localhost:5432/main_db
    echo CACHE_URL=redis://localhost:6379
    echo ANALYTICS_DB_URI=mongodb://localhost:27017/analytics_db
) >> .env
call :log_success "Configuracion multi-base de datos lista."
goto :eof

:configure_mcp
call :log_info "Configurando servidores MCP..."
if not exist ".mcp" mkdir .mcp
echo.
echo Selecciona los servidores MCP que necesitas:
echo 1) Desarrollo (GitHub, Linear)      4) APIs (REST, GraphQL)
echo 2) Base de datos (Postgres, Mongo)   5) Productividad (Notion, Jira)
echo 3) Cloud (AWS, Azure, GCP)           0) Omitir
echo.
set /p "mcp_choice=Selecciona una opcion: "
if "%mcp_choice%"=="1" (call :configure_development_mcp & goto :eof)
if "%mcp_choice%"=="2" (call :configure_database_mcp & goto :eof)
if "%mcp_choice%"=="3" (call :configure_cloud_mcp & goto :eof)
if "%mcp_choice%"=="4" (call :configure_api_mcp & goto :eof)
if "%mcp_choice%"=="5" (call :configure_productivity_mcp & goto :eof)
call :log_info "Configuracion MCP omitida."
goto :eof

:configure_development_mcp
call :log_info "Configurando MCP para desarrollo..."
call :download_or_copy_file "%REPO_URL%/templates/mcp-configs/development.json" ".mcp\config.json"
(
    echo.
    echo # MCP Development Configuration
    echo GITHUB_TOKEN=your_github_token_here
    echo LINEAR_API_KEY=your_linear_api_key_here
) >> .env
call :log_success "MCP para desarrollo configurado."
goto :eof

:configure_database_mcp
call :log_info "Configurando MCP para bases de datos..."
call :download_or_copy_file "%REPO_URL%/templates/mcp-configs/database.json" ".mcp\config.json"
(
    echo.
    echo # MCP Database Configuration
    echo DB_MCP_ENABLED=true
) >> .env
call :log_success "MCP para bases de datos configurado."
goto :eof

:configure_cloud_mcp
call :log_info "Configurando MCP para servicios cloud..."
call :download_or_copy_file "%REPO_URL%/templates/mcp-configs/cloud.json" ".mcp\config.json"
(
    echo.
    echo # MCP Cloud Configuration
    echo AWS_ACCESS_KEY_ID=your_aws_access_key
    echo AWS_SECRET_ACCESS_KEY=your_aws_secret_key
) >> .env
call :log_success "MCP para cloud configurado."
goto :eof

:configure_api_mcp
call :log_info "Configurando MCP para APIs..."
(
    echo { "mcpServers": { "rest-api": {}, "graphql": {} } }
) > ".mcp\config.json"
(
    echo.
    echo # MCP API Configuration
    echo REST_API_ENABLED=true
) >> .env
call :log_success "MCP para APIs configurado."
goto :eof

:configure_productivity_mcp
call :log_info "Configurando MCP para productividad..."
(
    echo { "mcpServers": { "notion": {}, "jira": {} } }
) > ".mcp\config.json"
(
    echo.
    echo # MCP Productivity Configuration
    echo NOTION_API_KEY=your_notion_api_key
    echo JIRA_API_TOKEN=your_jira_api_token
) >> .env
call :log_success "MCP para productividad configurado."
goto :eof

:install_base_config
call :log_info "Instalando configuracion base del framework..."
if not exist ".github" mkdir .github
if not exist "docs" mkdir docs
if not exist ".vscode" mkdir .vscode
if not exist "templates" mkdir templates
call :download_or_copy_file "%REPO_URL%/ai-config/vscode-extensions/extensions.json" ".vscode\extensions.json"
call :download_or_copy_file "%REPO_URL%/ai-config/vscode-extensions/settings.json" ".vscode\settings.json"
call :download_or_copy_file "%REPO_URL%/docs/AI_ENGINEERING_GUIDE.md" "docs\AI_ENGINEERING_GUIDE.md"
call :log_success "Configuracion base instalada."
goto :eof

:configure_language
call :log_info "Configurando para proyecto tipo: !PROJECT_TYPE!"
if "!PROJECT_TYPE!"=="unknown" (
    call :download_or_copy_file "%REPO_URL%/.github/copilot-instructions.md" ".github\copilot-instructions.md"
) else (
    call :download_or_copy_file "%REPO_URL%/ai-config/copilot-instructions/!PROJECT_TYPE!.md" ".github\copilot-instructions.md"
)
call :log_success "Instrucciones de Copilot para !PROJECT_TYPE! instaladas."
goto :eof

:setup_git
where git >nul 2>&1
if %errorlevel% neq 0 goto :eof
call :log_info "Configurando Git con ramas recomendadas..."
if not exist ".git" (
    git init >nul 2>&1
    call :log_success "Repositorio Git inicializado."
)
git checkout -b main >nul 2>&1 || git checkout main >nul 2>&1
git checkout -b develop >nul 2>&1 || git checkout develop >nul 2>&1
git checkout -b testing >nul 2>&1 || git checkout testing >nul 2>&1
git checkout develop >nul 2>&1
call :log_success "Ramas Git configuradas (main, develop, testing). Rama actual: develop"
goto :eof

:create_gitignore
if exist ".gitignore" goto :eof
call :log_info "Creando .gitignore optimizado para !PROJECT_TYPE!..."
(
    echo # Environment variables
    echo .env
    echo .env.local
    echo .env.*
    echo.
    echo # Dependencies
    echo node_modules/
    echo vendor/
    echo __pycache__/
    echo.
    echo # IDE
    echo .vscode/
    echo !.vscode/settings.json
    echo !.vscode/extensions.json
    echo .idea/
    echo.
    echo # OS Files
    echo .DS_Store
    echo Thumbs.db
) > .gitignore

if "!PROJECT_TYPE!"=="javascript" (
    (echo # JavaScript specific & echo .next/ & echo .nuxt/) >> .gitignore
)
if "!PROJECT_TPE!"=="python" (
    (echo # Python specific & echo venv/ & echo env/ & echo .venv/) >> .gitignore
)
call :log_success ".gitignore optimizado creado."
goto :eof

:create_readme
if exist "README.md" goto :eof
call :log_info "Creando README.md..."
echo # !PROJECT_NAME! > README.md
echo. >> README.md
echo Este proyecto está configurado con el AI Agents Framework. >> README.md
echo. >> README.md
echo ## 🚀 Quick Start >> README.md
echo 1. Copia .env.example a .env y añade tus API keys. >> README.md
echo 2. Instala las dependencias (ej. npm install). >> README.md
echo 3. Empieza a desarrollar con superpoderes IA. >> README.md
echo. >> README.md
echo ## 📚 Documentación >> README.md
echo - [AI Engineering Guide](docs/AI_ENGINEERING_GUIDE.md) >> README.md
echo - [Instrucciones Copilot](.github/copilot-instructions.md) >> README.md
call :log_success "README.md creado."
goto :eof

:show_next_steps
echo.
call :log_success "¡Configuracion avanzada completada!"
echo.
echo ========================================
echo   PROXIMOS PASOS PARA SUPERPODERES IA
echo ========================================
echo.
echo 1. **Configura .env**: Abre el archivo \`.env\` y añade tus API keys y credenciales.
echo 2. **Abre en VS Code**: \`code .\`
echo 3. **Instala dependencias**: ej. \`npm install\` o \`pip install -r requirements.txt\`
echo 4. **Revisa la documentación**: Lee la guía en \`docs/AI_ENGINEERING_GUIDE.md\`.
echo 5. **¡Comienza a desarrollar!**: Tu entorno está listo y optimizado para IA.
echo.
echo 🌐 **Recursos**: https://github.com/javalenciacai/AI_Agents_Framework
echo.
goto :eof
