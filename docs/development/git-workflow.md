# Git Flow - BackupGuard Pro

## 🌳 Estrategia de Ramas

Este proyecto utiliza un flujo de trabajo Git con **3 ramas principales** para garantizar estabilidad y facilitar el desarrollo colaborativo.

### 📊 Estructura de Ramas

```
main (producción)     ←── testing ←── develop (desarrollo)
  ↑                        ↑           ↑
🚀 Releases            🧪 QA Tests   🔧 Features
```

## 🎯 Propósito de cada Rama

### 🟢 **main** - Rama de Producción
- **Propósito**: Código estable listo para producción
- **Protección**: Solo merge desde `testing` después de QA completo
- **Despliegue**: Automático a producción via CI/CD
- **Reglas**:
  - ❌ No commits directos
  - ✅ Solo merges desde `testing`
  - ✅ Requiere pull request + 2 aprobaciones
  - ✅ Todos los tests deben pasar

### 🟡 **testing** - Rama de QA/Staging
- **Propósito**: Validación y testing antes de producción
- **Ambiente**: Staging environment (staging.backupguard.pro)
- **Despliegue**: Automático a staging via CI/CD
- **Reglas**:
  - ❌ No commits directos de features
  - ✅ Solo merges desde `develop`
  - ✅ Testing E2E completo
  - ✅ Validación de performance

### 🔵 **develop** - Rama de Desarrollo
- **Propósito**: Integración de nuevas características
- **Ambiente**: Development environment (dev.backupguard.pro)
- **Despliegue**: Automático a desarrollo via CI/CD
- **Reglas**:
  - ✅ Merge de feature branches
  - ✅ Integración continua
  - ✅ Tests unitarios + integración

## 🔄 Flujo de Trabajo

### 1. **Desarrollo de Features**
```bash
# Crear feature branch desde develop
git checkout develop
git pull origin develop
git checkout -b feature/backup-alerting

# Desarrollo...
git add .
git commit -m "feat(notifications): add backup alerting system"

# Push y crear Pull Request a develop
git push origin feature/backup-alerting
```

### 2. **Integración a Development**
```bash
# Merge feature a develop (via Pull Request)
git checkout develop
git pull origin develop
git merge feature/backup-alerting
git push origin develop

# Deploy automático a dev.backupguard.pro
```

### 3. **Promoción a Testing**
```bash
# Cuando develop esté estable
git checkout testing
git pull origin testing
git merge develop
git push origin testing

# Deploy automático a staging.backupguard.pro
# Ejecutar tests E2E automáticos
```

### 4. **Release a Producción**
```bash
# Después de QA exitoso en testing
git checkout main
git pull origin main
git merge testing
git tag v1.0.0
git push origin main --tags

# Deploy automático a backupguard.pro
```

## 📝 Convenciones de Commits

Seguimos **Conventional Commits** para mensajes descriptivos:

```bash
feat(scope): descripción corta
fix(scope): descripción del bug corregido
docs(scope): cambios en documentación
style(scope): formateo, sin cambios de código
refactor(scope): refactorización de código
test(scope): agregar o modificar tests
chore(scope): tareas de mantenimiento
```

### Ejemplos:
```bash
feat(auth): implement JWT refresh token rotation
fix(backup): resolve memory leak in backup processing
docs(api): update authentication endpoints documentation
refactor(user): extract validation logic to separate module
test(notifications): add unit tests for email service
```

## 🛡️ Protecciones de Ramas

### Configuración Recomendada (GitHub/GitLab):

#### **main** branch:
- ✅ Require pull request reviews (2 required)
- ✅ Dismiss stale PR reviews when new commits are pushed
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Include administrators in restrictions

#### **testing** branch:
- ✅ Require pull request reviews (1 required)
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging

#### **develop** branch:
- ✅ Require status checks to pass before merging
- ✅ Auto-delete head branches after merge

## 🚀 Automatización CI/CD

### Pipeline Configuration:

```yaml
# .github/workflows/ci-cd.yml
name: BackupGuard Pro CI/CD

on:
  push:
    branches: [main, testing, develop]
  pull_request:
    branches: [main, testing, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test
      - name: Run integration tests
        run: npm run test:integration
        
  deploy-dev:
    if: github.ref == 'refs/heads/develop'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Development
        run: echo "Deploy to dev.backupguard.pro"
        
  deploy-staging:
    if: github.ref == 'refs/heads/testing'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Staging
        run: echo "Deploy to staging.backupguard.pro"
      - name: Run E2E tests
        run: npm run test:e2e
        
  deploy-prod:
    if: github.ref == 'refs/heads/main'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Production
        run: echo "Deploy to backupguard.pro"
```

## 🔧 Comandos Útiles

### Sincronización:
```bash
# Sincronizar todas las ramas
git checkout main && git pull origin main
git checkout testing && git pull origin testing  
git checkout develop && git pull origin develop

# Ver estado de todas las ramas
git branch -vv
```

### Hotfixes de Emergencia:
```bash
# Para fixes críticos en producción
git checkout main
git checkout -b hotfix/critical-security-fix
# Hacer el fix...
git commit -m "fix(security): patch critical vulnerability"

# Merge directo a main Y develop
git checkout main
git merge hotfix/critical-security-fix
git checkout develop  
git merge hotfix/critical-security-fix
```

### Limpieza:
```bash
# Eliminar ramas feature mergeadas
git branch --merged develop | grep -v "develop\|main\|testing" | xargs -n 1 git branch -d

# Limpiar referencias remotas
git remote prune origin
```

## 📊 Métricas y Monitoreo

### KPIs de Git Flow:
- **Lead Time**: Tiempo desde commit hasta producción
- **Deployment Frequency**: Frecuencia de deploys a main
- **Mean Time to Recovery**: Tiempo promedio de recuperación de fallos
- **Change Failure Rate**: Porcentaje de deploys que requieren hotfix

### Herramientas Recomendadas:
- **GitHub Actions** para CI/CD
- **SonarQube** para calidad de código
- **Dependabot** para actualizaciones de dependencias
- **CodeClimate** para métricas de mantenibilidad

---

**¡Recuerda**: Este flujo está diseñado para garantizar la máxima estabilidad en producción mientras permite desarrollo ágil y testing exhaustivo.

*Última actualización: 16 de agosto de 2025*
