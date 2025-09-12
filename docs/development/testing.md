# 🧪 Testing Guide - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Estrategia de Testing](#estrategia-de-testing)
- [Testing por Capas](#testing-por-capas)
- [Herramientas y Setup](#herramientas-y-setup)
- [Pruebas Unitarias](#pruebas-unitarias)
- [Pruebas de Integración](#pruebas-de-integración)
- [Pruebas E2E](#pruebas-e2e)
- [Testing de Performance](#testing-de-performance)
- [CI/CD Pipeline](#cicd-pipeline)

---

## 🎯 Estrategia de Testing

### **Pirámide de Testing**
```
        /\
       /E2E\      ← Pocas pruebas, alto valor
      /____\
     /      \
    /Integration\ ← Pruebas de API y servicios
   /____________\
  /              \
 /   Unit Tests   \  ← Mayoría de pruebas, rápidas
/__________________\
```

### **Cobertura de Código**
- **Objetivo**: 85%+ de cobertura
- **Mínimo para CI/CD**: 80%
- **Crítico**: 95%+ en lógica de negocio

---

## 🏗️ Testing por Capas

### **Backend (Microservicios)**
```typescript
// Estructura de testing por microservicio
services/
├── api-gateway/
│   ├── __tests__/
│   │   ├── unit/           # Pruebas unitarias
│   │   ├── integration/    # Pruebas de API
│   │   └── e2e/           # Flujos completos
├── user-service/
│   ├── __tests__/
│   └── ...
```

### **Frontend (React)**
```typescript
// Estructura de testing frontend
frontends/admin-dashboard/
├── src/
│   ├── components/
│   │   ├── __tests__/      # Pruebas de componentes
│   ├── hooks/
│   │   ├── __tests__/      # Pruebas de hooks
│   ├── services/
│   │   ├── __tests__/      # Pruebas de servicios
│   └── utils/
│       ├── __tests__/      # Pruebas de utilidades
```

---

## 🛠️ Herramientas y Setup

### **Backend Testing Stack**
```json
{
  "testing": {
    "framework": "Jest",
    "assertions": "Jest Matchers",
    "mocking": "Jest Mocks",
    "coverage": "Jest Coverage",
    "integration": "Supertest",
    "database": "MongoDB Memory Server"
  }
}
```

### **Frontend Testing Stack**
```json
{
  "testing": {
    "framework": "Vitest",
    "rendering": "React Testing Library",
    "e2e": "Playwright",
    "visual": "Chromatic",
    "mocking": "MSW (Mock Service Worker)"
  }
}
```

### **Configuración Jest (Backend)**
```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/types/**/*'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  setupFilesAfterEnv: ['<rootDir>/src/test/setup.ts']
};
```

### **Configuración Vitest (Frontend)**
```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    coverage: {
      reporter: ['text', 'json', 'html'],
      threshold: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80
        }
      }
    }
  }
})
```

---

## 🧩 Pruebas Unitarias

### **Ejemplo: Testing de Servicio (Backend)**
```typescript
// __tests__/unit/backup-monitor.service.test.ts
import { BackupMonitorService } from '../../../src/services/backup-monitor.service';
import { BackupRepository } from '../../../src/repositories/backup.repository';

describe('BackupMonitorService', () => {
  let service: BackupMonitorService;
  let mockRepository: jest.Mocked<BackupRepository>;

  beforeEach(() => {
    mockRepository = {
      findByStatus: jest.fn(),
      updateStatus: jest.fn(),
      create: jest.fn(),
    } as any;
    
    service = new BackupMonitorService(mockRepository);
  });

  describe('checkBackupHealth', () => {
    it('should return healthy when backup is recent', async () => {
      // Arrange
      const recentBackup = {
        id: '1',
        lastBackup: new Date(Date.now() - 1000 * 60 * 60), // 1 hour ago
        status: 'completed'
      };
      mockRepository.findByStatus.mockResolvedValue([recentBackup]);

      // Act
      const result = await service.checkBackupHealth('client-1');

      // Assert
      expect(result.status).toBe('healthy');
      expect(result.lastBackup).toEqual(recentBackup.lastBackup);
    });

    it('should return warning when backup is old', async () => {
      // Arrange
      const oldBackup = {
        id: '1',
        lastBackup: new Date(Date.now() - 1000 * 60 * 60 * 25), // 25 hours ago
        status: 'completed'
      };
      mockRepository.findByStatus.mockResolvedValue([oldBackup]);

      // Act
      const result = await service.checkBackupHealth('client-1');

      // Assert
      expect(result.status).toBe('warning');
      expect(result.message).toContain('Backup is older than 24 hours');
    });
  });
});
```

### **Ejemplo: Testing de Componente (Frontend)**
```typescript
// __tests__/components/BackupStatusCard.test.tsx
import { render, screen } from '@testing-library/react';
import { BackupStatusCard } from '../../../src/components/BackupStatusCard';

describe('BackupStatusCard', () => {
  it('should render healthy status correctly', () => {
    // Arrange
    const props = {
      clientName: 'Test Client',
      status: 'healthy' as const,
      lastBackup: new Date('2023-12-10T10:00:00Z'),
      nextBackup: new Date('2023-12-11T10:00:00Z')
    };

    // Act
    render(<BackupStatusCard {...props} />);

    // Assert
    expect(screen.getByText('Test Client')).toBeInTheDocument();
    expect(screen.getByText('Healthy')).toBeInTheDocument();
    expect(screen.getByTestId('status-icon')).toHaveClass('text-green-500');
  });

  it('should render warning status with correct styling', () => {
    // Arrange
    const props = {
      clientName: 'Warning Client',
      status: 'warning' as const,
      lastBackup: new Date('2023-12-09T10:00:00Z'),
      nextBackup: new Date('2023-12-11T10:00:00Z')
    };

    // Act
    render(<BackupStatusCard {...props} />);

    // Assert
    expect(screen.getByText('Warning')).toBeInTheDocument();
    expect(screen.getByTestId('status-icon')).toHaveClass('text-yellow-500');
  });
});
```

---

## 🔗 Pruebas de Integración

### **Ejemplo: Testing de API**
```typescript
// __tests__/integration/backup-monitor.api.test.ts
import request from 'supertest';
import { app } from '../../src/app';
import { MongoMemoryServer } from 'mongodb-memory-server';
import mongoose from 'mongoose';

describe('Backup Monitor API', () => {
  let mongoServer: MongoMemoryServer;

  beforeAll(async () => {
    mongoServer = await MongoMemoryServer.create();
    const uri = mongoServer.getUri();
    await mongoose.connect(uri);
  });

  afterAll(async () => {
    await mongoose.disconnect();
    await mongoServer.stop();
  });

  afterEach(async () => {
    const collections = mongoose.connection.collections;
    for (const key in collections) {
      await collections[key].deleteMany({});
    }
  });

  describe('GET /api/v1/backups/status/:clientId', () => {
    it('should return backup status for existing client', async () => {
      // Arrange
      const clientId = 'test-client-123';
      
      // Crear datos de prueba
      await request(app)
        .post('/api/v1/backups')
        .send({
          clientId,
          status: 'completed',
          timestamp: new Date(),
          size: 1024000
        });

      // Act
      const response = await request(app)
        .get(`/api/v1/backups/status/${clientId}`)
        .expect(200);

      // Assert
      expect(response.body).toHaveProperty('clientId', clientId);
      expect(response.body).toHaveProperty('status');
      expect(response.body).toHaveProperty('lastBackup');
    });

    it('should return 404 for non-existing client', async () => {
      // Act & Assert
      await request(app)
        .get('/api/v1/backups/status/non-existing-client')
        .expect(404);
    });
  });
});
```

---

## 🎭 Pruebas E2E

### **Configuración Playwright**
```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### **Ejemplo: Flujo E2E Completo**
```typescript
// e2e/backup-monitoring-flow.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Backup Monitoring Flow', () => {
  test('should monitor backup status end-to-end', async ({ page }) => {
    // Arrange: Navigate to dashboard
    await page.goto('/dashboard');
    await expect(page.getByRole('heading', { name: 'Backup Dashboard' })).toBeVisible();

    // Act: Add new client
    await page.getByRole('button', { name: 'Add Client' }).click();
    await page.getByLabel('Client Name').fill('E2E Test Client');
    await page.getByLabel('Server Address').fill('192.168.1.100');
    await page.getByRole('button', { name: 'Save Client' }).click();

    // Assert: Client appears in list
    await expect(page.getByText('E2E Test Client')).toBeVisible();

    // Act: Check backup status
    await page.getByRole('button', { name: 'Check Status' }).click();
    
    // Assert: Status is displayed
    await expect(page.getByTestId('backup-status')).toBeVisible();
    await expect(page.getByText(/Last backup:/)).toBeVisible();
  });

  test('should handle backup failure alerts', async ({ page }) => {
    // Simulate backup failure scenario
    await page.goto('/dashboard');
    
    // Mock API response for failed backup
    await page.route('/api/v1/backups/status/*', (route) => {
      route.fulfill({
        status: 200,
        body: JSON.stringify({
          status: 'failed',
          lastBackup: new Date(Date.now() - 1000 * 60 * 60 * 48), // 48 hours ago
          error: 'Connection timeout'
        })
      });
    });

    await page.reload();
    
    // Assert: Failure alert is shown
    await expect(page.getByRole('alert')).toBeVisible();
    await expect(page.getByText('Connection timeout')).toBeVisible();
  });
});
```

---

## ⚡ Testing de Performance

### **Ejemplo: Load Testing con Artillery**
```yaml
# artillery-config.yml
config:
  target: 'http://localhost:8080'
  phases:
    - duration: 60
      arrivalRate: 10
    - duration: 120
      arrivalRate: 50
  variables:
    clientId: "test-client-{{ $randomString() }}"

scenarios:
  - name: "Backup Status Check"
    weight: 70
    flow:
      - get:
          url: "/api/v1/backups/status/{{ clientId }}"
          headers:
            Authorization: "Bearer {{ $randomString() }}"
      - think: 1

  - name: "Create Backup Record"
    weight: 30
    flow:
      - post:
          url: "/api/v1/backups"
          json:
            clientId: "{{ clientId }}"
            status: "completed"
            size: 1048576
```

---

## 🚀 CI/CD Pipeline

### **GitHub Actions Workflow**
```yaml
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]
    
    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run unit tests
        run: npm run test:unit
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  integration-tests:
    runs-on: ubuntu-latest
    services:
      mongodb:
        image: mongo:6.0
        env:
          MONGO_INITDB_ROOT_USERNAME: test
          MONGO_INITDB_ROOT_PASSWORD: test
        ports:
          - 27017:27017
      redis:
        image: redis:7
        ports:
          - 6379:6379
    
    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          MONGODB_URI: mongodb://test:test@localhost:27017/test
          REDIS_URL: redis://localhost:6379

  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Run E2E tests
        run: npm run test:e2e
      
      - name: Upload Playwright report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
```

---

## 📊 Scripts de Testing

### **Package.json Scripts**
```json
{
  "scripts": {
    "test": "npm run test:unit && npm run test:integration",
    "test:unit": "jest --testPathPattern=unit",
    "test:integration": "jest --testPathPattern=integration",
    "test:e2e": "playwright test",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:performance": "artillery run artillery-config.yml"
  }
}
```

---

## 🎯 Mejores Prácticas

### **Testing Guidelines**
1. **Arrange-Act-Assert**: Estructura clara en todas las pruebas
2. **Descriptive Names**: Nombres que expliquen el escenario
3. **Single Responsibility**: Una prueba = un escenario
4. **Independent Tests**: No depender de orden de ejecución
5. **Fast Feedback**: Priorizar velocidad en pruebas unitarias

### **Coverage Guidelines**
- **100%**: Funciones críticas de seguridad y pagos
- **90%+**: Lógica de negocio principal
- **80%+**: Servicios y controladores
- **70%+**: Utilidades y helpers

---

## 🔍 Debugging Tests

### **Comandos Útiles**
```bash
# Ejecutar prueba específica
npm test -- --testNamePattern="should check backup health"

# Debug con Node inspector
node --inspect-brk node_modules/.bin/jest --runInBand

# Ver coverage detallado
npm run test:coverage -- --verbose

# Ejecutar solo pruebas modificadas
npm test -- --onlyChanged
```

---

## 📚 Recursos Adicionales

- **[Jest Documentation](https://jestjs.io/docs/getting-started)**
- **[React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)**
- **[Playwright Documentation](https://playwright.dev/)**
- **[Testing Best Practices](https://github.com/goldbergyoni/javascript-testing-best-practices)**

---

> **💡 Nota**: Esta guía es parte del ejemplo BackupGuard Pro y demuestra una estrategia de testing completa para microservicios con frontend React.
