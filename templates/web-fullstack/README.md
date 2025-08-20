# 🌐 Template: Aplicación Web Full-Stack

Este template proporciona una base completa para desarrollar aplicaciones web full-stack modernas con integración de Agentes IA desde el primer día.

## 🎯 **Stack Tecnológico**

### **Frontend**
- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite
- **Styling**: Tailwind CSS + Radix UI
- **State Management**: Zustand + React Query
- **Routing**: React Router v6
- **Forms**: React Hook Form + Zod validation
- **Testing**: Vitest + Testing Library

### **Backend**
- **Runtime**: Node.js 18+
- **Framework**: Express.js + TypeScript
- **Database**: MongoDB + Mongoose
- **Validation**: Zod
- **Authentication**: JWT + Refresh Tokens
- **API Documentation**: Swagger/OpenAPI
- **Testing**: Jest + Supertest

### **DevOps & Herramientas**
- **Containerización**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Linting**: ESLint + Prettier
- **Git Hooks**: Husky + lint-staged
- **Monorepo**: Turborepo (opcional)

## 📁 **Estructura del Proyecto**

```
web-fullstack-app/
├── 📱 frontend/                    # Aplicación React
│   ├── src/
│   │   ├── components/            # Componentes reutilizables
│   │   │   ├── ui/               # Componentes base (Button, Input, etc.)
│   │   │   ├── forms/            # Componentes de formularios
│   │   │   └── layout/           # Layout components
│   │   ├── pages/                # Páginas/Rutas principales
│   │   ├── hooks/                # Custom React hooks
│   │   ├── stores/               # Estado global (Zustand)
│   │   ├── services/             # API calls y servicios
│   │   ├── utils/                # Utilidades y helpers
│   │   ├── types/                # Definiciones TypeScript
│   │   └── styles/               # Estilos globales
│   ├── public/                   # Assets estáticos
│   ├── tests/                    # Tests del frontend
│   ├── package.json
│   ├── vite.config.ts
│   ├── tailwind.config.js
│   └── tsconfig.json
├── 🚀 backend/                     # API Node.js
│   ├── src/
│   │   ├── controllers/          # Controladores HTTP
│   │   ├── services/             # Lógica de negocio
│   │   ├── models/               # Modelos de datos (Mongoose)
│   │   ├── middleware/           # Middleware Express
│   │   ├── routes/               # Definición de rutas
│   │   ├── validators/           # Validación con Zod
│   │   ├── config/               # Configuración (DB, ENV, etc.)
│   │   └── types/                # Tipos TypeScript
│   ├── tests/                    # Tests del backend
│   ├── docs/                     # Documentación API
│   ├── package.json
│   ├── tsconfig.json
│   └── jest.config.js
├── 🐳 docker/                      # Configuración Docker
│   ├── frontend.Dockerfile
│   ├── backend.Dockerfile
│   └── docker-compose.yml
├── 🔧 scripts/                     # Scripts de automatización
│   ├── setup.sh
│   ├── dev.sh
│   └── deploy.sh
├── 📋 docs/                        # Documentación del proyecto
│   ├── AI_ENGINEERING_GUIDE.md    # Guía de desarrollo con IA
│   ├── api/                       # Documentación API
│   └── deployment/                # Guías de despliegue
├── .github/                       # Configuración GitHub
│   ├── workflows/                 # GitHub Actions
│   └── copilot-instructions.md    # Instrucciones para IA
├── package.json                   # Root package.json (monorepo)
├── README.md
└── .gitignore
```

## 🚀 **Setup y Desarrollo**

### **1. Configuración Inicial**
```bash
# Clonar el template
git clone [template-repo] mi-aplicación-web
cd mi-aplicación-web

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus configuraciones

# Inicializar base de datos
npm run db:setup
```

### **2. Desarrollo Local**
```bash
# Iniciar todos los servicios
npm run dev

# O iniciar servicios individualmente
npm run dev:frontend    # Frontend en http://localhost:5173
npm run dev:backend     # Backend en http://localhost:3001
npm run dev:db          # MongoDB en Docker
```

### **3. Testing**
```bash
# Ejecutar todos los tests
npm test

# Tests por servicio
npm run test:frontend
npm run test:backend
npm run test:e2e

# Coverage
npm run test:coverage
```

## 🤖 **Integración con Agentes IA**

### **Prompts Optimizados Incluidos**

#### **🏗️ Arquitectura y Diseño**
```
Actúa como un arquitecto de software experto. Necesito diseñar [funcionalidad específica] 
para una aplicación web full-stack con React + Node.js + MongoDB.

Contexto del proyecto:
- Stack: React 18, TypeScript, Node.js, Express, MongoDB
- Arquitectura: Frontend SPA + API REST
- Patrones: Clean Architecture, SOLID principles

Proporciona:
1. Diagrama de componentes C4 (niveles 2-3)
2. Estructura de datos (MongoDB schemas)
3. Endpoints API REST necesarios
4. Componentes React principales
5. Flujo de estado con Zustand

Responde en español con código TypeScript.
```

#### **🧩 Desarrollo de Componentes**
```
Crea un componente React moderno para [descripción del componente].

Requisitos técnicos:
- TypeScript estricto con interfaces claras
- Tailwind CSS para estilos
- React Hook Form para formularios
- Zod para validación
- Accesibilidad (ARIA) completa
- Responsive design
- Error handling robusto

Incluye:
1. Componente principal con tipos
2. Hook personalizado si es necesario
3. Tests con Testing Library
4. Documentación JSDoc

Estilo de código: Clean Code, principios SOLID
```

#### **🔌 Desarrollo de API**
```
Desarrolla un endpoint API REST para [funcionalidad específica].

Stack backend:
- Node.js + Express + TypeScript
- MongoDB + Mongoose
- Zod para validación
- JWT para autenticación

Implementa:
1. Controller con manejo de errores
2. Service layer con lógica de negocio
3. Modelo Mongoose con validaciones
4. Middleware de validación con Zod
5. Tests unitarios con Jest
6. Documentación OpenAPI/Swagger

Sigue principios SOLID y Clean Architecture.
```

### **Configuración de Agentes Incluida**

El template incluye configuración optimizada para:

- **GitHub Copilot**: Instrucciones específicas para el stack
- **Cursor**: Reglas de código y patrones
- **Continue**: Configuración para desarrollo local
- **Claude/ChatGPT**: Prompts de contexto completo

## 🎨 **Características del Frontend**

### **Componentes UI Modernos**
```typescript
// Ejemplo: Componente Button reutilizable
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  icon?: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  loading = false,
  icon,
  children,
  className,
  disabled,
  ...props
}) => {
  // Implementación con Tailwind CSS y lógica completa
};
```

### **Estado Global con Zustand**
```typescript
// Store de autenticación
interface AuthState {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  refreshToken: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  // Implementación completa del store
}));
```

### **React Query para Estado del Servidor**
```typescript
// Hook para gestión de usuarios
export const useUsers = (filters?: UserFilters) => {
  return useQuery({
    queryKey: ['users', filters],
    queryFn: () => userService.getUsers(filters),
    staleTime: 5 * 60 * 1000, // 5 minutos
    retry: 3,
  });
};
```

## 🔧 **Características del Backend**

### **Clean Architecture**
```typescript
// Service Layer
export class UserService {
  constructor(
    private userRepository: UserRepository,
    private emailService: EmailService
  ) {}

  async createUser(userData: CreateUserDto): Promise<User> {
    // Validación
    const validatedData = createUserSchema.parse(userData);
    
    // Lógica de negocio
    const existingUser = await this.userRepository.findByEmail(validatedData.email);
    if (existingUser) {
      throw new ConflictError('Email already exists');
    }

    // Crear usuario
    const user = await this.userRepository.create(validatedData);
    
    // Efectos secundarios
    await this.emailService.sendWelcomeEmail(user.email);
    
    return user;
  }
}
```

### **Validación con Zod**
```typescript
// Schemas de validación
export const createUserSchema = z.object({
  email: z.string().email('Email inválido'),
  name: z.string().min(2, 'Nombre debe tener al menos 2 caracteres'),
  password: z.string().min(8, 'Password debe tener al menos 8 caracteres'),
  role: z.enum(['admin', 'user']).default('user'),
});

export type CreateUserDto = z.infer<typeof createUserSchema>;
```

## 🧪 **Testing Comprensivo**

### **Frontend Testing**
- **Unit Tests**: Componentes individuales
- **Integration Tests**: Flujos completos de usuario
- **E2E Tests**: Playwright para escenarios críticos
- **Visual Regression**: Chromatic para componentes UI

### **Backend Testing**
- **Unit Tests**: Servicios y utilidades
- **Integration Tests**: Endpoints API completos
- **Database Tests**: Operaciones con MongoDB
- **Performance Tests**: Load testing con Artillery

## 🚀 **Deployment Ready**

### **Docker Configuration**
```dockerfile
# Multi-stage build optimizado
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### **CI/CD Pipeline**
```yaml
# GitHub Actions workflow
name: CI/CD Pipeline
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run test:all
      - run: npm run build
```

## 📋 **Siguiente Pasos**

1. **Personalizar el template** según tu proyecto específico
2. **Configurar variables de entorno** para tu stack
3. **Adaptar la base de datos** schema a tus necesidades
4. **Customizar componentes UI** con tu design system
5. **Configurar servicios externos** (email, payments, etc.)
6. **Setup CI/CD** para tu entorno de producción

---

**¡Template completo para desarrollo web full-stack con IA integrada desde el día 1!**

*Desarrollado siguiendo mejores prácticas y optimizado para máxima productividad con Agentes IA*
