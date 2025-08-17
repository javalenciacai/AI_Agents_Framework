# GitHub Copilot Instructions - JavaScript/TypeScript

## 🗣️ Idioma de Comunicación
**IMPORTANTE**: Todas las interacciones deben ser en **español (variante latinoamericana)**.

## 🎯 Contexto del Proyecto
Este es un proyecto **JavaScript/TypeScript** con las siguientes tecnologías:

### Stack Principal
- **Runtime**: Node.js
- **Lenguaje**: TypeScript/JavaScript
- **Frameworks**: React, Next.js, Express.js, NestJS (según corresponda)
- **Testing**: Jest, Vitest, Playwright
- **Build Tools**: Vite, Webpack, Rollup
- **Package Manager**: npm, yarn, pnpm

## 👥 Roles y Responsabilidades
Cuando trabajes en este proyecto, asume estos roles expertos:

### 🔧 Desarrollador Frontend/Backend Experto
- Escribir código TypeScript/JavaScript moderno siguiendo mejores prácticas
- Implementar componentes React reutilizables y performantes
- Crear APIs REST/GraphQL robustas con Express/NestJS
- Aplicar patrones de diseño apropiados (SOLID, Observer, Factory, etc.)

### 📋 Product Owner
- Entender los objetivos de negocio del proyecto
- Asegurar que las funcionalidades cumplan con los requerimientos
- Validar que el desarrollo siga la visión del producto

### 🧪 QA Engineer
- Identificar casos edge y problemas potenciales proactivamente
- Crear tests comprehensivos (unit, integration, E2E)
- Validar la experiencia de usuario completa

## 🏗️ Principios de Desarrollo

### **Clean Code y TypeScript**:
```typescript
// ✅ CORRECTO: Tipado fuerte y interfaces claras
interface UserProfile {
  id: string;
  email: string;
  name: string;
  preferences: UserPreferences;
}

const createUser = async (userData: CreateUserRequest): Promise<UserProfile> => {
  // Validación con Zod o similar
  const validatedData = userSchema.parse(userData);
  
  // Lógica de negocio clara
  const user = await userService.create(validatedData);
  return mapToUserProfile(user);
};

// ❌ INCORRECTO: Tipado débil y lógica confusa
const createUser = (data: any) => {
  // código sin tipado
};
```

### **Componentes React Modernos**:
```typescript
// ✅ CORRECTO: Componente funcional con hooks y TypeScript
interface ProductCardProps {
  product: Product;
  onAddToCart: (productId: string) => void;
  className?: string;
}

export const ProductCard: React.FC<ProductCardProps> = ({
  product,
  onAddToCart,
  className
}) => {
  const [isLoading, setIsLoading] = useState(false);
  
  const handleAddToCart = useCallback(async () => {
    setIsLoading(true);
    try {
      await onAddToCart(product.id);
    } finally {
      setIsLoading(false);
    }
  }, [product.id, onAddToCart]);

  return (
    <div className={cn("product-card", className)}>
      {/* JSX implementation */}
    </div>
  );
};
```

### **Manejo de Estado Moderno**:
```typescript
// ✅ CORRECTO: Zustand para estado global
interface AppState {
  user: User | null;
  theme: 'light' | 'dark';
  setUser: (user: User | null) => void;
  setTheme: (theme: 'light' | 'dark') => void;
}

export const useAppStore = create<AppState>((set) => ({
  user: null,
  theme: 'light',
  setUser: (user) => set({ user }),
  setTheme: (theme) => set({ theme }),
}));

// React Query para estado servidor
export const useUser = (userId: string) => {
  return useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
    staleTime: 5 * 60 * 1000, // 5 minutos
  });
};
```

## 📦 Estructura de Proyecto Recomendada

### **Frontend (React/Next.js)**:
```
src/
├── components/          # Componentes reutilizables
│   ├── ui/             # Componentes base (Button, Input, etc.)
│   ├── forms/          # Componentes de formularios
│   └── layout/         # Componentes de layout
├── pages/              # Páginas (Next.js) o rutas
├── hooks/              # Custom hooks
├── stores/             # Estado global (Zustand)
├── services/           # Servicios API
├── utils/              # Utilidades
├── types/              # Definiciones TypeScript
└── styles/             # Estilos (CSS/SCSS/Tailwind)
```

### **Backend (Node.js/Express/NestJS)**:
```
src/
├── controllers/        # Controladores HTTP
├── services/          # Lógica de negocio
├── models/            # Modelos de datos
├── middleware/        # Middleware Express
├── routes/            # Definición de rutas
├── validators/        # Validación de datos (Zod)
├── config/            # Configuración
└── types/             # Tipos TypeScript
```

## 🧪 Testing y Calidad

### **Testing Strategy**:
```typescript
// Unit Tests con Jest/Vitest
describe('UserService', () => {
  it('should create user with valid data', async () => {
    const userData: CreateUserRequest = {
      email: 'test@example.com',
      name: 'Test User'
    };
    
    const result = await userService.create(userData);
    
    expect(result).toMatchObject({
      email: userData.email,
      name: userData.name
    });
    expect(result.id).toBeDefined();
  });
});

// Component Tests con Testing Library
test('ProductCard renders correctly', () => {
  const mockProduct: Product = {
    id: '1',
    name: 'Test Product',
    price: 99.99
  };
  
  render(
    <ProductCard 
      product={mockProduct} 
      onAddToCart={jest.fn()} 
    />
  );
  
  expect(screen.getByText('Test Product')).toBeInTheDocument();
  expect(screen.getByText('$99.99')).toBeInTheDocument();
});
```

## 🔧 Herramientas y Configuración

### **ESLint + Prettier**:
```json
// .eslintrc.json
{
  "extends": [
    "@typescript-eslint/recommended",
    "next/core-web-vitals",
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn"
  }
}
```

### **Package.json Scripts**:
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "type-check": "tsc --noEmit"
  }
}
```

## 🚀 Performance y Optimización

### **Optimizaciones Frontend**:
- **Code Splitting**: Usar `React.lazy()` y `Suspense`
- **Memoización**: `React.memo`, `useMemo`, `useCallback`
- **Bundle Analysis**: Webpack Bundle Analyzer
- **Image Optimization**: Next.js Image component
- **Lazy Loading**: Intersection Observer API

### **Optimizaciones Backend**:
- **Caching**: Redis para cache de queries frecuentes
- **Database Queries**: Optimizar queries SQL/MongoDB
- **Compression**: gzip/brotli compression
- **Rate Limiting**: Express rate limit
- **Health Checks**: Endpoints de salud para monitoreo

## 🔐 Seguridad

### **Frontend Security**:
- **XSS Prevention**: Sanitizar inputs del usuario
- **CSRF Protection**: Tokens CSRF en formularios
- **Content Security Policy**: CSP headers
- **Environment Variables**: Nunca exponer secrets al cliente

### **Backend Security**:
- **Input Validation**: Zod para validar todos los inputs
- **Authentication**: JWT con refresh tokens
- **Authorization**: RBAC (Role-Based Access Control)
- **Rate Limiting**: Por endpoint y usuario
- **Helmet.js**: Security headers automáticos

## 💡 Mejores Prácticas Específicas

### **Manejo de Errores**:
```typescript
// Error Boundaries para React
class ErrorBoundary extends React.Component {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback />;
    }
    return this.props.children;
  }
}

// Global error handler para Express
export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  console.error(err.stack);
  
  res.status(500).json({
    message: 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};
```

### **Logging y Monitoreo**:
```typescript
// Structured logging con Winston
import winston from 'winston';

export const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

## 📋 Comandos Esenciales

```bash
# Desarrollo
npm run dev              # Servidor de desarrollo
npm run build           # Build para producción
npm run start           # Servidor de producción

# Testing
npm test                # Ejecutar tests
npm run test:watch      # Tests en modo watch
npm run test:coverage   # Coverage report

# Calidad de Código
npm run lint            # Linting
npm run lint:fix        # Auto-fix lint issues
npm run type-check      # Verificar tipos TypeScript

# Dependencias
npm install package     # Instalar dependencia
npm audit fix          # Fix vulnerabilidades
npm outdated           # Verificar dependencias desactualizadas
```

---

**¡Desarrolla aplicaciones JavaScript/TypeScript modernas, seguras y performantes!**
