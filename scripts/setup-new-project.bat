@echo off
setlocal enabledelayedexpansion

REM ========================================
REM AI Agents Framework - Setup Básico
REM Configuración automática para proyectos NUEVOS
REM Basado en proceso manual optimizado
REM ========================================

set "REPO_URL=https://raw.githubusercontent.com/javalenciacai/AI_Agents_Framework/main"

echo.
echo ========================================
echo   AI Agents Framework - Setup Básico
echo   Configuración para proyecto NUEVO
echo ========================================
echo.

REM Obtener nombre del proyecto
set "PROJECT_NAME=%~1"
if "%PROJECT_NAME%"=="" (
    set /p PROJECT_NAME="Nombre del proyecto: "
)

if "%PROJECT_NAME%"=="" (
    echo [ERROR] Nombre del proyecto requerido
    pause
    exit /b 1
)

echo [INFO] Configurando proyecto: %PROJECT_NAME%

REM Verificar herramientas
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] curl no encontrado. Intentando con PowerShell...
    set "USE_POWERSHELL=true"
) else (
    set "USE_POWERSHELL=false"
)

REM Crear directorio del proyecto
if not exist "%PROJECT_NAME%" mkdir "%PROJECT_NAME%"
cd "%PROJECT_NAME%"

echo [INFO] Creando estructura básica...

REM Crear directorios esenciales
if not exist ".github" mkdir ".github"
if not exist ".vscode" mkdir ".vscode"
if not exist "docs" mkdir "docs"
if not exist "ai-config" mkdir "ai-config"

REM Descargar archivos esenciales
echo [INFO] Descargando configuraciones AI desde GitHub...
call :download_file "%REPO_URL%/.github/copilot-instructions.md" ".github\copilot-instructions.md"
call :download_file "%REPO_URL%/ai-config/vscode-extensions/settings.json" ".vscode\settings.json"
call :download_file "%REPO_URL%/ai-config/vscode-extensions/extensions.json" ".vscode\extensions.json"
call :download_file "%REPO_URL%/docs/AI_ENGINEERING_GUIDE.md" "docs\AI_ENGINEERING_GUIDE.md"

echo [INFO] Creando archivo .env básico...

if exist ".github\copilot-instructions.md" (
    echo [WARNING] Configuraciones IA ya existen, omitiendo...
) else (
    if exist "ai-config\copilot-instructions" (
        xcopy /E /Y "ai-config\copilot-instructions\*" ".github\" >nul 2>&1
        echo [SUCCESS] Configuraciones Copilot copiadas
    ) else (
        echo [INFO] Creando configuracion basica de Copilot...
        (
            echo # GitHub Copilot Instructions - %PROJECT_TYPE% Project
            echo.
            echo ## Project Context
            echo This is a %PROJECT_TYPE% project using AI Agents Framework.
            echo.
            echo ## Coding Standards
            echo - Follow clean code principles
            echo - Use meaningful variable names
            echo - Add comments for complex logic
            echo - Maintain consistent formatting
            echo.
            echo ## AI Assistant Guidelines
            echo - Provide code suggestions that follow project patterns
            echo - Consider performance and security best practices
            echo - Suggest relevant testing approaches
            echo - Help with documentation when needed
        ) > ".github\copilot-instructions.md"
        echo [SUCCESS] Configuracion basica de Copilot creada
    )
)

REM Crear .env.example si no existe
if not exist ".env.example" (
    echo [INFO] Creando archivo .env.example...
    (
        echo # AI Agents Framework - Environment Variables
        echo.
        echo # Database Configuration
        echo DATABASE_URL=
        echo.
        echo # AI API Keys
        echo OPENAI_API_KEY=
        echo ANTHROPIC_API_KEY=
        echo GOOGLE_AI_API_KEY=
        echo.
        echo # Development
        echo NODE_ENV=development
        echo DEBUG=true
    ) > ".env.example"
    echo [SUCCESS] Archivo .env.example creado
)

REM Crear README básico si no existe
if not exist "README.md" (
    echo [INFO] Creando README.md base...
    (
        echo # Mi Proyecto con AI Agents Framework
        echo.
        echo Este proyecto utiliza el AI Agents Framework para desarrollo acelerado con IA.
        echo.
        echo ## 🚀 Setup Rapido
        echo.
        echo 1. **Configurar variables de entorno:**
        echo    ```bash
        echo    cp .env.example .env
        echo    # Editar .env con tus API keys
        echo    ```
        echo.
        echo 2. **Verificar agentes IA:**
        echo    - GitHub Copilot activo en VS Code
        echo    - Revisar `.github/copilot-instructions.md`
        echo.
        echo 3. **¡Empezar a desarrollar con superpoderes!**
        echo.
        echo ## 📚 Documentacion
        echo.
        echo - [AI Engineering Guide](./docs/AI_ENGINEERING_GUIDE.md^)
        echo - [Configuraciones IA](./ai-config/^)
        echo - [Framework Completo](https://github.com/javalenciacai/AI_Agents_Framework^)
        echo.
        echo ## 🔧 Stack Detectado
        echo.
        echo - **Tipo de proyecto:** %PROJECT_TYPE%
        echo - **Framework base:** AI Agents Framework
        echo.
        echo ---
        echo.
        echo **⚡ Powered by [AI Agents Framework](https://github.com/javalenciacai/AI_Agents_Framework^)**
    ) > "README.md"
    echo [SUCCESS] README.md base creado
)

REM Configurar .gitignore básico
if not exist ".gitignore" (
    echo [INFO] Creando .gitignore...
    (
        echo # Environment variables
        echo .env
        echo .env.local
        echo .env.*.local
        echo.
        echo # Dependencies
        echo node_modules/
        echo __pycache__/
        echo *.pyc
        echo .Python
        echo venv/
        echo env/
        echo.
        echo # Build outputs
        echo dist/
        echo build/
        echo target/
        echo *.class
        echo *.jar
        echo.
        echo # IDE
        echo .vscode/settings.json
        echo .idea/
        echo *.swp
        echo *.swo
        echo.
        echo # Logs
        echo *.log
        echo logs/
        echo npm-debug.log*
        echo.
        echo # OS
        echo .DS_Store
        echo Thumbs.db
        echo.
        echo # AI Configs (keep instructions, ignore local settings^)
        echo .copilot-settings.json
        echo .continue/
    ) > ".gitignore"
    echo [SUCCESS] .gitignore creado
)

REM Configuración específica por lenguaje
if "%PROJECT_TYPE%"=="javascript" (
    echo [INFO] Configurando optimizaciones para JavaScript/Node.js...
    
    if not exist "package.json" (
        echo [INFO] Creando package.json basico...
        (
            echo {
            echo   "name": "mi-proyecto-ai",
            echo   "version": "1.0.0",
            echo   "description": "Proyecto con AI Agents Framework",
            echo   "main": "index.js",
            echo   "scripts": {
            echo     "start": "node index.js",
            echo     "dev": "nodemon index.js",
            echo     "test": "jest"
            echo   },
            echo   "keywords": ["ai", "framework"],
            echo   "author": "",
            echo   "license": "MIT"
            echo }
        ) > "package.json"
        echo [SUCCESS] package.json basico creado
    )
)

if "%PROJECT_TYPE%"=="python" (
    echo [INFO] Configurando optimizaciones para Python...
    
    if not exist "requirements.txt" (
        echo [INFO] Creando requirements.txt basico...
        (
            echo # AI Framework Dependencies
            echo python-dotenv
            echo requests
            echo.
            echo # Development Dependencies  
            echo pytest
            echo black
            echo flake8
        ) > "requirements.txt"
        echo [SUCCESS] requirements.txt basico creado
    )
)

REM Mostrar siguiente pasos
echo.
echo ========================================
echo   CONFIGURACION BASICA COMPLETADA
echo ========================================
echo.
echo ✅ Tu proyecto ya tiene configuracion basica de IA
echo.
echo 📋 Siguientes pasos:
echo.
echo 1. **Configurar API Keys:**
echo    - Copiar: cp .env.example .env
echo    - Editar .env con tus claves de OpenAI, Anthropic, etc.
echo.
echo 2. **Verificar Agentes IA:**
echo    - Abrir VS Code: code .
echo    - Verificar GitHub Copilot activo
echo    - Revisar .github/copilot-instructions.md
echo.
echo 3. **Para configuracion avanzada:**
echo    - Ejecutar: scripts\setup-new-project-advanced.bat
echo    - Configurar bases de datos, MCP, etc.
echo.
echo 4. **¡Comenzar desarrollo!**
echo    - Tu proyecto ya tiene superpoderes IA
echo.
echo 📚 Mas informacion:
echo - Documentacion: https://github.com/javalenciacai/AI_Agents_Framework
echo - Guias IA: ./docs/AI_ENGINEERING_GUIDE.md
echo.

pause
goto :eof

REM ===============================
REM Funciones auxiliares
REM ===============================

:download_file
set "url=%~1"
set "output=%~2"

REM Crear directorio si no existe
for %%F in ("%output%") do set "dir=%%~dpF"
if not exist "%dir%" mkdir "%dir%"

echo [INFO] Descargando: %output%

REM Intentar con curl primero
curl -s -L -o "%output%" "%url%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] ✅ %output%
    goto :eof
)

REM Fallback a PowerShell
powershell -Command "try { (New-Object System.Net.WebClient).DownloadFile('%url%', '%output%') } catch { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] ✅ %output%
    goto :eof
)

echo [WARNING] ⚠️  No se pudo descargar %output%
goto :eof
