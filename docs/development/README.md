# 🛠️ Development Guide - BackupGuard Pro

> **📋 PARTE DEL EJEMPLO**: BackupGuard Pro - Caso de uso completo del AI Agents Framework  
> **🎯 Ver guía completa**: [../example-backupguard/README.md](../example-backupguard/README.md)

## 📋 Índice

- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Testing Strategy](#testing-strategy)
- [Development Workflow](#development-workflow)
- [Debugging](#debugging)
- [Contributing](#contributing)

## 🚀 Getting Started

### Prerequisites
Asegúrate de tener instalado:
- **Node.js 18+** - Runtime principal
- **Docker & Docker Compose** - Contenedores y servicios
- **Git** - Control de versiones
- **VS Code** - Editor recomendado
- **MongoDB Compass** - GUI para MongoDB (opcional)
- **Redis CLI** - CLI para Redis (opcional)

### Quick Setup
```bash
# 1. Clonar el repositorio
git clone https://github.com/backupguard/backupguard-pro.git
cd backupguard-pro

# 2. Instalar dependencias globales
npm install -g pnpm
pnpm install

# 3. Configurar variables de entorno
cp .env.example .env.local
# Editar .env.local con tus configuraciones

# 4. Iniciar servicios de infraestructura
docker-compose up -d mongodb redis rabbitmq

# 5. Ejecutar migraciones de base de datos
pnpm run db:migrate

# 6. Iniciar todos los servicios en desarrollo
pnpm run dev
```

### Verificar Installation
```bash
# Verificar que todos los servicios estén corriendo
pnpm run health-check

# Expected output:
# ✅ API Gateway - http://localhost:8080
# ✅ User Service - http://localhost:3001
# ✅ Backup Service - http://localhost:3002
# ✅ Notification Service - http://localhost:3003
# ✅ Report Service - http://localhost:3004
# ✅ Config Service - http://localhost:3005
# ✅ Billing Service - http://localhost:3006
# ✅ Admin Dashboard - http://localhost:3000
# ✅ User Portal - http://localhost:3100
# ✅ MongoDB - mongodb://localhost:27017
# ✅ Redis - redis://localhost:6379
# ✅ RabbitMQ - http://localhost:15672
```

## 🏗️ Development Environment

### Directory Structure
```
backupguard-pro/
├── 🎯 Root Configuration
│   ├── package.json              # Workspace configuration
│   ├── pnpm-workspace.yaml       # Monorepo workspace
│   ├── docker-compose.yml        # Development services
│   ├── .env.example              # Environment template
│   └── turbo.json                # Build orchestration
│
├── 🎨 Frontend Applications
│   ├── apps/
│   │   ├── admin-dashboard/       # React admin app
│   │   ├── user-portal/          # React user app
│   │   └── mobile-app/           # React Native app
│   └── packages/
│       ├── ui-components/        # Shared UI library
│       ├── shared-types/         # TypeScript definitions
│       └── utils/               # Shared utilities
│
├── ⚙️ Backend Services
│   ├── services/
│   │   ├── api-gateway/          # Main API Gateway
│   │   ├── user-service/         # User management
│   │   ├── backup-service/       # Backup monitoring
│   │   ├── notification-service/ # Alerts & notifications
│   │   ├── report-service/       # Report generation
│   │   ├── config-service/       # Configuration management
│   │   └── billing-service/      # Billing & subscriptions
│   └── packages/
│       ├── database/             # MongoDB schemas
│       ├── queue/               # RabbitMQ utilities
│       ├── auth/                # Authentication logic
│       └── monitoring/          # Observability tools
│
├── 🤖 Client Agent
│   └── agent/
│       ├── src/                 # Go source code
│       ├── pkg/                 # Go packages
│       ├── cmd/                 # CLI commands
│       └── build/               # Build artifacts
│
├── 🚀 Infrastructure
│   ├── k8s/                     # Kubernetes manifests
│   ├── terraform/               # Infrastructure as Code
│   ├── monitoring/              # Prometheus/Grafana config
│   └── scripts/                 # Deployment scripts
│
└── 📚 Documentation
    ├── docs/                    # Technical documentation
    ├── api/                     # API specifications
    └── examples/                # Code examples
```

### Environment Configuration
```bash
# .env.local example
NODE_ENV=development
LOG_LEVEL=debug

# Database
MONGODB_URI=mongodb://localhost:27017/backupguard_dev
REDIS_URL=redis://localhost:6379

# Message Queue
RABBITMQ_URL=amqp://localhost:5672

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=15m
REFRESH_TOKEN_EXPIRES_IN=30d

# External Services
SENDGRID_API_KEY=your-sendgrid-api-key
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
STRIPE_SECRET_KEY=your-stripe-secret

# Frontend URLs
ADMIN_DASHBOARD_URL=http://localhost:3000
USER_PORTAL_URL=http://localhost:3100

# Service Discovery
API_GATEWAY_PORT=8080
USER_SERVICE_PORT=3001
BACKUP_SERVICE_PORT=3002
NOTIFICATION_SERVICE_PORT=3003
REPORT_SERVICE_PORT=3004
CONFIG_SERVICE_PORT=3005
BILLING_SERVICE_PORT=3006
```

### VS Code Configuration
```json
// .vscode/settings.json
{
  "typescript.preferences.includePackageJsonAutoImports": "auto",
  "eslint.workingDirectories": [
    "apps/admin-dashboard",
    "apps/user-portal",
    "services/api-gateway",
    "services/user-service",
    "services/backup-service"
  ],
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/.turbo": true
  }
}
```

### Recommended Extensions
```json
// .vscode/extensions.json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-typescript-next",
    "ms-vscode-remote.remote-containers",
    "humao.rest-client",
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "golang.go"
  ]
}
```

## 📁 Project Structure

### Monorepo Architecture
Utilizamos **pnpm workspaces** con **Turbo** para gestionar nuestro monorepo:

```json
// pnpm-workspace.yaml
packages:
  - "apps/*"
  - "services/*"
  - "packages/*"
  - "agent"
```

### Package Naming Convention
```
@backupguard/admin-dashboard     # Frontend apps
@backupguard/user-portal
@backupguard/api-gateway         # Backend services
@backupguard/user-service
@backupguard/ui-components       # Shared packages
@backupguard/shared-types
```

### Service Structure Template
```typescript
// services/[service-name]/
├── src/
│   ├── controllers/             # HTTP controllers
│   ├── services/               # Business logic
│   ├── models/                 # Data models
│   ├── middleware/             # Express middleware
│   ├── routes/                 # Route definitions
│   ├── validators/             # Input validation
│   ├── types/                  # TypeScript types
│   ├── config/                 # Configuration
│   ├── utils/                  # Utilities
│   └── app.ts                  # Express app setup
├── tests/
│   ├── unit/                   # Unit tests
│   ├── integration/            # Integration tests
│   └── fixtures/               # Test data
├── docs/
│   ├── api.md                  # API documentation
│   └── architecture.md         # Service architecture
├── package.json
├── tsconfig.json
├── jest.config.js
├── Dockerfile
└── README.md
```

## 📝 Coding Standards

### TypeScript Configuration
```json
// tsconfig.json (base)
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

### ESLint Configuration
```json
// .eslintrc.json
{
  "extends": [
    "@backupguard/eslint-config"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "prefer-const": "error",
    "no-var": "error"
  }
}
```

### Prettier Configuration
```json
// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

### Naming Conventions

#### Files and Directories
```typescript
// ✅ Good
user.controller.ts
backup.service.ts
auth.middleware.ts
user.types.ts
database.config.ts

// ❌ Bad
UserController.ts
backupService.ts
authMiddleware.ts
userTypes.ts
databaseConfig.ts
```

#### Variables and Functions
```typescript
// ✅ Good - camelCase
const userName = 'john_doe';
const isBackupActive = true;
const calculateBackupSize = () => { ... };

// ❌ Bad
const user_name = 'john_doe';
const IsBackupActive = true;
const calculate_backup_size = () => { ... };
```

#### Types and Interfaces
```typescript
// ✅ Good - PascalCase
interface UserProfile {
  id: string;
  email: string;
}

type BackupStatus = 'active' | 'failed' | 'pending';

// ❌ Bad
interface userProfile { ... }
type backupStatus = 'active' | 'failed' | 'pending';
```

#### Constants
```typescript
// ✅ Good - SCREAMING_SNAKE_CASE
const MAX_BACKUP_SIZE = 1024 * 1024 * 1024; // 1GB
const DEFAULT_CHECK_INTERVAL = 3600; // 1 hour

// ❌ Bad
const maxBackupSize = 1024 * 1024 * 1024;
const defaultCheckInterval = 3600;
```

### Code Organization Patterns

#### Controller Pattern
```typescript
// ✅ Good structure
export class UserController {
  constructor(
    private userService: UserService,
    private logger: Logger
  ) {}

  public async getProfile(req: Request, res: Response): Promise<void> {
    try {
      const userId = req.user.id;
      const profile = await this.userService.getProfile(userId);
      res.json({ success: true, data: profile });
    } catch (error) {
      this.logger.error('Error getting user profile', { error, userId });
      res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }
}
```

#### Service Pattern
```typescript
// ✅ Business logic in services
export class BackupService {
  constructor(
    private backupRepository: BackupRepository,
    private notificationService: NotificationService,
    private logger: Logger
  ) {}

  public async processBackupReport(
    clientId: string,
    report: BackupReport
  ): Promise<ProcessResult> {
    this.logger.info('Processing backup report', { clientId });

    // Validate report
    const validationResult = this.validateReport(report);
    if (!validationResult.isValid) {
      throw new ValidationError(validationResult.errors);
    }

    // Store backup data
    const backup = await this.backupRepository.create({
      clientId,
      ...report,
      processedAt: new Date(),
    });

    // Check for alerts
    await this.checkForAlerts(clientId, backup);

    return { success: true, backupId: backup.id };
  }

  private async checkForAlerts(clientId: string, backup: Backup): Promise<void> {
    // Alert logic here
  }
}
```

### Error Handling

#### Custom Error Classes
```typescript
// errors/base.error.ts
export abstract class BaseError extends Error {
  public abstract readonly statusCode: number;
  public abstract readonly isOperational: boolean;

  constructor(message: string, public readonly context?: Record<string, any>) {
    super(message);
    Object.setPrototypeOf(this, new.target.prototype);
    Error.captureStackTrace(this);
  }
}

// errors/validation.error.ts
export class ValidationError extends BaseError {
  public readonly statusCode = 400;
  public readonly isOperational = true;

  constructor(message: string, public readonly errors: ValidationFailure[]) {
    super(message);
  }
}

// errors/not-found.error.ts
export class NotFoundError extends BaseError {
  public readonly statusCode = 404;
  public readonly isOperational = true;
}
```

#### Error Middleware
```typescript
// middleware/error.middleware.ts
export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  logger.error('Request error', { error, path: req.path, method: req.method });

  if (error instanceof BaseError) {
    res.status(error.statusCode).json({
      success: false,
      error: {
        code: error.constructor.name.replace('Error', '').toUpperCase(),
        message: error.message,
        ...(error.context && { details: error.context }),
      },
    });
    return;
  }

  // Unhandled errors
  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'Internal server error',
    },
  });
};
```

## 🧪 Testing Strategy

### Testing Pyramid
```
           /\
          /  \
         / E2E \
        /______\
       /        \
      /Integration\
     /____________\
    /              \
   /      Unit      \
  /________________\
```

### Unit Tests (Jest)
```typescript
// tests/unit/services/backup.service.test.ts
describe('BackupService', () => {
  let service: BackupService;
  let mockRepository: jest.Mocked<BackupRepository>;
  let mockNotificationService: jest.Mocked<NotificationService>;

  beforeEach(() => {
    mockRepository = createMock<BackupRepository>();
    mockNotificationService = createMock<NotificationService>();
    service = new BackupService(mockRepository, mockNotificationService, logger);
  });

  describe('processBackupReport', () => {
    it('should process valid backup report successfully', async () => {
      // Arrange
      const clientId = 'client_123';
      const report: BackupReport = {
        backups: [
          {
            path: '/var/backup/db.sql',
            size: 1024,
            lastModified: new Date(),
          },
        ],
        timestamp: new Date(),
      };

      mockRepository.create.mockResolvedValue({
        id: 'backup_456',
        ...report,
      } as Backup);

      // Act
      const result = await service.processBackupReport(clientId, report);

      // Assert
      expect(result.success).toBe(true);
      expect(result.backupId).toBe('backup_456');
      expect(mockRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          clientId,
          ...report,
        })
      );
    });

    it('should throw ValidationError for invalid report', async () => {
      // Arrange
      const clientId = 'client_123';
      const invalidReport = {} as BackupReport;

      // Act & Assert
      await expect(
        service.processBackupReport(clientId, invalidReport)
      ).rejects.toThrow(ValidationError);
    });
  });
});
```

### Integration Tests
```typescript
// tests/integration/api/users.test.ts
describe('Users API', () => {
  let app: Application;
  let testDb: MongoMemoryServer;

  beforeAll(async () => {
    testDb = await MongoMemoryServer.create();
    const mongoUri = testDb.getUri();
    
    app = createApp({
      database: { uri: mongoUri },
      redis: { host: 'localhost', port: 6379 },
    });
  });

  afterAll(async () => {
    await testDb.stop();
  });

  beforeEach(async () => {
    await cleanDatabase();
  });

  describe('POST /api/users/register', () => {
    it('should register new user successfully', async () => {
      const userData = {
        email: 'test@example.com',
        password: 'SecurePass123!',
        firstName: 'John',
        lastName: 'Doe',
      };

      const response = await request(app)
        .post('/api/users/register')
        .send(userData)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.user.email).toBe(userData.email);
      expect(response.body.data.tokens).toBeDefined();
    });
  });
});
```

### E2E Tests (Playwright)
```typescript
// tests/e2e/user-registration.spec.ts
import { test, expect } from '@playwright/test';

test.describe('User Registration Flow', () => {
  test('should complete full registration process', async ({ page }) => {
    // Navigate to registration page
    await page.goto('/register');

    // Fill registration form
    await page.fill('[data-testid="organization-name"]', 'Test Corp');
    await page.fill('[data-testid="admin-email"]', 'admin@testcorp.com');
    await page.fill('[data-testid="admin-password"]', 'SecurePass123!');
    await page.fill('[data-testid="admin-first-name"]', 'John');
    await page.fill('[data-testid="admin-last-name"]', 'Doe');

    // Submit form
    await page.click('[data-testid="register-button"]');

    // Verify success
    await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
    await expect(page).toHaveURL('/dashboard');
  });
});
```

### Test Scripts
```json
// package.json scripts
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:integration": "jest --config jest.integration.config.js",
    "test:e2e": "playwright test",
    "test:all": "pnpm run test && pnpm run test:integration && pnpm run test:e2e"
  }
}
```

## 🔄 Development Workflow

### Git Workflow (Feature Branch)
```bash
# 1. Create feature branch
git checkout -b feature/backup-alerting

# 2. Make changes and commit
git add .
git commit -m "feat(notifications): add backup alerting system

- Implement alert severity levels
- Add email notification templates
- Configure Slack integration

Closes #123"

# 3. Push and create PR
git push origin feature/backup-alerting
# Create PR on GitHub

# 4. After approval, merge with squash
git checkout main
git pull origin main
git branch -d feature/backup-alerting
```

### Commit Message Convention
```
type(scope): description

[optional body]

[optional footer]
```

#### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks

#### Examples
```bash
feat(auth): implement JWT refresh token rotation

fix(backup): resolve memory leak in backup processing

docs(api): update authentication endpoints documentation

refactor(user): extract validation logic to separate module

test(notifications): add unit tests for email service
```

### Development Commands
```bash
# 🏃 Development
pnpm run dev                 # Start all services
pnpm run dev:frontend        # Start only frontend apps
pnpm run dev:backend         # Start only backend services
pnpm run dev:service user    # Start specific service

# 🔧 Building
pnpm run build               # Build all packages
pnpm run build:frontend      # Build frontend packages
pnpm run build:backend       # Build backend services

# 🧪 Testing
pnpm run test                # Run all unit tests
pnpm run test:watch          # Run tests in watch mode
pnpm run test:integration    # Run integration tests
pnpm run test:e2e           # Run E2E tests

# 📦 Packages
pnpm install                 # Install all dependencies
pnpm run clean               # Clean all build artifacts
pnpm run reset               # Reset node_modules and reinstall

# 🚀 Deployment
pnpm run deploy:staging      # Deploy to staging
pnpm run deploy:production   # Deploy to production

# 🔍 Quality
pnpm run lint                # Run ESLint
pnpm run lint:fix           # Fix ESLint errors
pnpm run type-check         # Run TypeScript checks
pnpm run format             # Format code with Prettier
```

### Pre-commit Hooks
```json
// .husky/pre-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

pnpm run lint-staged
```

```json
// package.json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  }
}
```

## 🐛 Debugging

### VS Code Debug Configuration
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug User Service",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/services/user-service/src/app.ts",
      "outFiles": ["${workspaceFolder}/services/user-service/dist/**/*.js"],
      "envFile": "${workspaceFolder}/.env.local",
      "runtimeArgs": ["-r", "ts-node/register"],
      "port": 9229
    },
    {
      "name": "Debug Tests",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--runInBand", "--no-cache", "--detectOpenHandles"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

### Logging Configuration
```typescript
// packages/monitoring/src/logger.ts
import winston from 'winston';

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: process.env.SERVICE_NAME || 'unknown',
    version: process.env.SERVICE_VERSION || '1.0.0',
  },
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error',
    }),
    new winston.transports.File({
      filename: 'logs/combined.log',
    }),
  ],
});

// Usage in services
logger.info('Processing backup report', {
  clientId: 'client_123',
  reportSize: 1024,
  correlationId: req.correlationId,
});
```

### Debug Scripts
```bash
# Debug specific service with inspector
node --inspect=0.0.0.0:9229 dist/app.js

# Debug with VS Code
code --inspect services/user-service/src/app.ts

# Debug tests
npm run test -- --inspect-brk

# Memory profiling
node --inspect --heap-prof dist/app.js

# CPU profiling
node --inspect --prof dist/app.js
```

## 🤝 Contributing

### Before You Start
1. Fork the repository
2. Create a feature branch
3. Set up development environment
4. Read the coding standards
5. Check existing issues and PRs

### Pull Request Process
1. **Description**: Clear description of changes
2. **Testing**: All tests pass, new tests added
3. **Documentation**: Update relevant documentation
4. **Review**: At least 2 approvals required
5. **Merge**: Squash merge to main branch

### Code Review Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added for new functionality
- [ ] Documentation updated
- [ ] No breaking changes or marked properly
- [ ] Security considerations addressed
- [ ] Performance impact considered

---

**¡Happy Coding! 🚀**

*Última actualización: 16 de agosto de 2025*
