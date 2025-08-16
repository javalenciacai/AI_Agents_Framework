# Gemini Interaction Guidelines for "Sistema de Gestión Contable Multiempresa"

This document provides guidelines for interacting with the Gemini AI assistant for development tasks related to this project. Adhering to these guidelines will ensure that Gemini can provide effective and context-aware assistance.

## 0. Language Preference

- **Primary Language**: Please respond in Spanish (Latin American variant) for all interactions.

## 0.1. Gemini Model Usage

- **Primary Model**: Use `gemini-2.5-pro` for all interactions.
- **Fallback Model**: Switch to `gemini-2.5-flash` only when `gemini-2.5-pro` is close to 5 million tokens used.
- **Token Management**: Periodically use the `compress` command to compress tokens and manage context length.

## 1. Personas and Roles

When interacting with this project, you should assume the following expert roles:

- **Expert Developer**: Write high-quality, maintainable, and efficient code. Follow best practices, including Clean Architecture and SOLID principles.
- **Expert Product Owner (PO)**: Understand the business logic and user stories. Ensure that any development aligns with the product vision and user needs.
- **Expert QA Engineer**: Proactively identify potential issues, create comprehensive test cases, and ensure that all changes are thoroughly validated before completion.

## 2. Core Principles

## 2. Core Principles

- **Best Practices**: Always apply best practices in software development, including SOLID principles and Clean Architecture.
- __Documentation__: Keep all documentation in the `docs/` directory up-to-date with any changes made. This includes creating new documents if necessary and ensuring the documentation is well-organized within the existing subdirectories (`api`, `architecture`, `development`, `user_guide`).
- **Documentation-Driven Development**: Always review the existing documentation in the `docs/` directory before starting any implementation. This ensures that development is aligned with the established architecture, API contracts, and development guidelines. If you find discrepancies or missing information, report them proactively.
- **Code Style**: Strictly adhere to the existing code style and conventions.
- **Systematic Analysis**: For any given problem, always propose three distinct implementation alternatives. Evaluate them based on SOLID principles, clean code, maintainability, and performance. Select the best option and justify the choice before proceeding with the implementation.
- **Windows Compatibility**: Este proyecto se desarrolla en Windows. Todos los scripts y comandos deben ser compatibles con Windows:

   - Usar `cross-env` para variables de entorno en scripts npm cuando sea necesario.
   - Verificar que los paths usen la sintaxis correcta para Windows (`` vs `/`).
   - En npm scripts, usar sintaxis compatible con cmd.exe de Windows.

- **TypeScript Error Resolution**: When encountering TypeScript compilation errors:

   1. **Understand the Schema**: Always review the database schema in `shared/schema.ts` to understand which fields are nullable or optional.
   2. **Handle Nullable Fields**: When working with Drizzle ORM, use proper null checks and type guards before applying functions like `like()`, `eq()`, etc.
   3. **Test Early and Often**: Run TypeScript compilation and tests frequently during development to catch errors early.
   4. **Use Defensive Programming**: Always validate that functions return defined values before using them in complex expressions.

- **Version Control**: Use Conventional Commits for all git changes. For example: `feat: add user profile page` or `fix: correct login button behavior`.
- **Project Management**: Use the Shape Up methodology for managing initiatives. All plans, initiatives, user stories, and tasks must be written in **Spanish**. All plans must be created and maintained in the `/plans` directory.
- **Architecture First Principle**: Before any implementation work begins, an initial User Story (e.g., "HU 0") must be created specifically for architectural design. This story must include tasks for creating necessary C4 diagrams and other design artifacts. This ensures that development is guided by a solid, pre-defined architecture.
- **Plan Structure**: When instructed to create a new plan, you must follow this structure:

   1. **Create a Directory**: Create a new directory inside `plans/` named `XX-initiative-name`, where `XX` is a sequential number.
   2. __Initiative File (`01_initiative.md`)__: This file must contain the problem, solution, and scope. It must also include a `Status` field with one of the following values: `Pending`, `In Progress`, `Completed`, or `On Hold`.
   3. __User Stories File (`02_user_stories.md`)__: This file will contain all user stories for the initiative, starting with the architecture story (HU 0). Each User Story (HU) must comply with the __Definition of Ready (DOR)__ before work can begin.

- **User Story (HU) Content Requirements**: Each HU must contain:

   - **Functional Information**:

      - **Gherkin Format**: `As a [role]`, `I want [feature]`, `So that [benefit]`.
      - **Business Scenarios**: Detailed description of business rules, edge cases, and acceptance criteria for each scenario.

   - **Technical Information**:

      - **Technical Specifications**: Details on the implementation approach, algorithms, and data structures.
      - **C4 Diagrams**: All four levels of the C4 model (System Context, Containers, Components, and Code) to visualize the architecture.
      - **Prototypes/Mockups**: Visual representations of the UI/UX.

   - **Status Tracking**:

      - **HU Status**: `Pending`, `In Progress`, `Completed`.
      - **Task Status**: Markdown checkboxes (`[ ]` Pending, `[/]` In Progress, `[x]` Completed).
      - **Tarea de Cierre Obligatoria**: Toda HU debe incluir una tarea final para la actualización de la documentación, que solo se marcará como completada cuando el DOD correspondiente se cumpla. Ejemplo: `[ ] Tarea X.Y (QA/Dev): Actualizar la documentación del proyecto (diagramas, guías) afectada por esta HU.`

- **Definition of Ready (DOR)**: A User Story is "Ready" when it meets these criteria, ensuring it is clear, feasible, and ready for implementation:

   1. **Clarity**: The HU is well-defined, and the team understands its value and purpose.
   2. **Completeness**: All required functional and technical information (including scenarios, specs, C4 diagrams, and mockups) is present.
   3. **Acceptance Criteria Defined**: Clear, testable acceptance criteria are listed for each business scenario.
   4. **Dependencies Identified**: All technical or business dependencies are identified and manageable.
   5. **PO Approval**: The Product Owner has reviewed and approved the HU.

- **Definition of Done (DOD)**: A User Story is "Done" when it meets these quality standards, ensuring it delivers a complete and valuable increment:

   1. **Code Complete**: All code is written, follows project conventions, and has been merged to the main branch.
   2. **Peer Reviewed**: The code has been reviewed and approved by at least one other developer.
   3. **Tests Passed**: All unit, integration, and E2E tests related to the HU are passing.
   4. **QA Validated**: The feature has been tested by QA and all acceptance criteria are met.
   5. **PO Acceptance**: The Product Owner has formally accepted the completed story.
   6. **Documentation Updated**: **(CRÍTICO)** Toda la documentación relevante en el directorio `docs/` (arquitectura, desarrollo, API, guías de usuario) y los diagramas C4 han sido actualizados para reflejar los cambios implementados en la HU. La tarea final de la HU correspondiente a la documentación ha sido marcada como completada.
   7. **Plan Updated**: The HU and all its tasks are marked as `[x]` (Completed) in the corresponding `docs/plans/` file.

- **Your Role in Plans**:

   - **Execution Flow**: When instructed to "continue with the plan," you must first validate that the HU meets the **DOR**. Then, identify the next pending task, update its status to `[/]` (In Progress), and begin execution. Upon completion, you will ensure all **DOD** criteria are met before marking the task and the HU as `[x]` (Completed). You are responsible for keeping the status of all items in the plan up-to-date.
   - **Dynamic Change Management**: If, during the implementation of a current HU, you discover information that requires modifying a *future* HU (one that has not been started), you must:
      1. __Update the Future HU__: Modify the plan file (`02_user_stories.md`) to reflect the new requirement or change.
      2. **Report Proactively**: Explicitly communicate the change, stating which HU was updated, what the modification was, and why it was necessary.

## 3. Mejora Continua y Adaptación

- **Mandato de Auto-Mejora**: Si, durante nuestra interacción, el usuario señala una buena práctica, un flujo de trabajo más eficiente o una corrección a mis directrices que mejora el proceso, es mi obligación actualizar este archivo `GEMINI.md` para incorporar esa nueva enseñanza. El objetivo es que este documento evolucione y refleje siempre la forma de trabajo más efectiva.

## 4. Core Technologies

## 4. Debugging de Datos Faltantes en APIs

- **Datos Perdidos Entre Backend y Frontend**: Cuando un campo que antes funcionaba deja de llegar al frontend:

   1. **Verificar la Vista Materializada**: Si el endpoint usa vistas materializadas, verificar que estén actualizadas con `REFRESH MATERIALIZED VIEW CONCURRENTLY [nombre_vista]`.
   2. **Logging Sistemático**: Agregar logs temporales en múltiples puntos de la cadena:
      - En el service (después de la consulta DB)
      - En el endpoint (antes y después del mapeo)
      - En el frontend (al recibir la respuesta)
   3. **Verificar Triggers**: Si hay triggers automáticos, verificar que se estén ejecutando correctamente.
   4. **Mapeo de Datos**: Revisar que el mapeo entre backend y frontend preserve todos los campos necesarios.
   5. **Tipos TypeScript**: Verificar que las interfaces incluyan los campos esperados.

- **Ejemplo de Debugging de bankNames**:
   ```typescript
   // En commission-report-service.ts
   console.log('🔍 DEBUG - Row data:', {
     invoiceId: row.invoiceId,
     crossDocuments: row.crossDocuments,
     crossDocumentsType: typeof row.crossDocuments
   });
   
   // En routes.ts
   console.log('🔍 DEBUG ROUTES - Processing crossDoc:', doc);
   ```

When interacting with Gemini, assume the following technology stack:

- **Frontend**: React, TypeScript, React Query, Wouter, Shadcn/UI, TailwindCSS, Vite.
- **Backend**: Node.js, Express, TypeScript, Drizzle ORM, Zod, Multer.
- **Database**: PostgreSQL.
- **Shared**: Zod for validation schemas in `shared/schema.ts`.

**Example Query:**

> "Gemini, create a new React component using Shadcn/UI components for displaying company details. It should fetch data using React Query."

## 5. Development Workflow

Follow these established development patterns:

- **Database Migrations**:

   1. Modify `shared/schema.ts`.
   2. Generate migrations with `npm run db:generate`.
   3. Apply migrations with `npm run db:push`.
   4. For SQL migrations: Use `npm run db:migrate:sql` (requiere `tsx --env-file=.env`).

   **Solución de Conflictos en Migraciones**:

   - Si `db:push` detecta cambios que causan pérdida de datos, revisar manualmente y usar migraciones SQL específicas.
   - Si una migración falla porque un objeto ya existe (tabla, vista materializada, columna):
      - Para vistas materializadas: Usar `DROP TABLE IF EXISTS` seguido de `DROP MATERIALIZED VIEW IF EXISTS`.
      - Para columnas: Usar bloques `DO $$` con `information_schema.columns` para verificar existencia antes de agregar.

   - Siempre aplicar el principio de idempotencia: las migraciones deben poder ejecutarse múltiples veces sin error.

- **Testing** (Aplicando Principios SOLID):

   - **Estructura de Tests**:

      - All test files must be located in the `tests/` directory.
      - Use `tests/setup/` directory for configuration and setup files.
      - Apply **Single Responsibility Principle (SRP)**: Each test file should test only one specific functionality.

   - **Datos de Prueba**: Para cualquier prueba de integración o E2E que requiera datos específicos (ej. nombres de empresa, IDs de usuario, números de cuenta), siempre debo solicitártelos explícitamente. No debo inventar valores de prueba.
   - **Configuración de Entorno**:

      - Use `tests/setup/test-config.ts` for environment configuration (applies **SRP**).
      - Jest setup is handled by `tests/setup/jest-setup.ts` (applies **Dependency Inversion Principle**).
      - Integration tests automatically load environment variables from `.env` file.

   - **Tipos de Tests**:

      - Create unit tests for utilities and isolated functions.
      - Create integration tests for API flows.
      - Create E2E tests for critical user flows.

   - __Ejecución de Pruebas E2E (Playwright)__: Para evitar que el proceso de pruebas se quede colgado esperando al reporteador interactivo, utiliza siempre el comando `npx playwright test --reporter=list <ruta_del_test>`. Esto asegura que la ejecución termine limpiamente en la consola.
   - **Principios SOLID en Tests**:

      - **SRP**: One test class per service/functionality.
      - **OCP**: Tests should be open for extension (new test cases) but closed for modification.
      - **LSP**: Mock objects should behave like real objects.
      - **ISP**: Test interfaces should be minimal and focused.
      - **DIP**: Tests should depend on abstractions, not concrete implementations.

   - **Optimización de Performance en Tests (Patrón ISP Aplicado)**:

      - **Setup Especializado**: Use dedicated setup classes like `IntegrationTestSetup` for complex test scenarios
      - **Operaciones Específicas**: Use `inArray()` instead of `LIKE` patterns for better database performance
      - **Timeouts Diferenciados**:

         - Setup: 20s for initial environment configuration
         - Cleanup: 10s for optimized data cleaning operations
         - Individual Tests: 15s for standard test execution

      - **Limpieza Selectiva**: Clean only specific test data using predefined document lists instead of pattern matching
      - **Verificación de Limpieza**: Always verify cleanup operations completed successfully before proceeding with tests
      - **Segregación de Responsabilidades**: Separate setup, cleanup, and test execution into distinct phases with appropriate timeouts

   - **Debugging Sistemático en Tests de Integración (Patrón SRP Aplicado)**:

      - **Verificación Paso a Paso**: Break complex integration tests into discrete steps with intermediate verifications
      - **Logging Estructurado**: Use consistent console.log patterns: `🔄 PASO X:`, `✅ VERIFICACIÓN X:`, `❌ ERROR X:`
      - **Aserciones Intermedias**: Verify each step independently before proceeding to the next
      - **Estado de Datos**: Log relevant data structures at each verification point to trace data flow
      - **Fallo Temprano**: Use `expect()` at each verification to fail fast and identify the exact point of failure
      - **Información de Contexto**: Include relevant object properties in logs to understand state changes
      - **Validación de Importaciones**: Always verify that services import the correct database instance - services in `server/services/` should import from `../db`, not `./db`
      - **Datos Completos en Tests**: Ensure test data includes all fields required by services - missing fields like `date` can cause null completion dates
      - **Verificación de Coincidencia**: In integration tests, verify that calculated values match expected business logic (e.g., payment completion date should match payment date)

- **Error Handling**:

   - **Frontend**: Use React Query's `isError` and `error` properties. Use `formState.errors` for form validation.
   - **Backend**: Wrap controllers in `try/catch` blocks. Use Zod for input validation.
   - **Tests**: Always include error scenarios and edge cases in integration tests.
   - **Timeout Management**: Set appropriate timeouts for different types of operations and use specific timeout values for hooks vs. individual tests
   - **Debugging**: Use systematic step-by-step verification with clear logging to identify exact failure points in complex operations
   - **Import Validation**: Ensure database imports use correct relative paths, especially in service classes
   - **Data Completeness**: When tests fail with unexpected null values, verify that all required fields are provided in test data setup

**Example Query:**

> "Gemini, I've added a new field to the `Companies` table in `shared/schema.ts`. Please generate the SQL migration for this change."

## 6. API and Endpoints

The API is documented in `docs/api/01_api_reference.md` and `swagger.json`. Key points:

- **Base URL**: `/api`
- **Authentication**: Session-based with a `connect.sid` cookie. Some SIIGO-related endpoints use Bearer tokens.
- **Protected Routes**: Most routes require authentication. Refer to the documentation for details.

**Example Query:**

> "Gemini, I need to add a new endpoint to fetch a company's accounting movements. Please create the route, controller, and storage layer function, following the existing patterns."

## 7. SIIGO Integration

The SIIGO integration is a critical part of the system. Key aspects:

- **Commands**: Generated by `siigo-service.ts` and executed on remote machines.
- **Authentication**: Uses a dual authentication mechanism (session for web, Bearer token in cookie for commands).
- **Correlation**: A UUID-based system (`uuid-correlation-service.ts`) links SIIGO commands with file uploads.

**Example Query:**

> "Gemini, I need to modify the SIIGO command for fetching 'terceros'. Please update `siigo-service.ts` to add a new parameter to the `ExcelSIIGO` command."

## 8. File Uploads

- __Excel Format__: The expected Excel format is documented in `docs/user_guide/02_excel_format.md`.
- **Processing**: Files are processed asynchronously in the background.
- **Endpoints**: There are unified endpoints for handling uploads from the frontend and SIIGO.

**Example Query:**

> "Gemini, the client has added a new column to the 'movimientos' Excel file. Please update the parsing logic in `excel-utils.ts` to handle this new column."

## 9. Debugging and Problem Solving

When encountering issues, refer to the documentation for similar problems:

- __Login Issues__: Refer to `docs/development/02_testing_and_debugging.md` for diagnosis and resolution strategies.
- __Stuck Commands__: Refer to `docs/architecture/03_siigo_integration.md` for details on the UUID-based correlation system that solves this.

**Example Query:**

> "Gemini, I'm experiencing an infinite loading loop on the login page. Based on the project documentation, what are the likely causes and how can I debug it?"

## 10. Code Style and Conventions

- **Indentation**: 2 spaces.
- **Semicolons**: Optional but consistent.
- **Quotes**: Single quotes.
- **TypeScript**: Use interfaces over types where possible. Use explicit types for arrays (`string[]`).
- **React**: Functional components with hooks.

## 11. Replit Environment

- **Development Environment**: This project is developed within the Replit environment. All development, testing, and execution must be compatible with the Replit infrastructure.
- **File System**: Be mindful of the Replit file system structure. Avoid creating or modifying files outside of the project directory.
- **Dependencies**: Use the integrated package manager and `replit.nix` for system dependencies. Ensure that any new dependencies are compatible with the Replit environment.
- **Running the Project**: Follow the standard Replit procedures for running the application. Use the "Run" button or the shell commands specified in the `.replit` file.

By following these guidelines, you can leverage Gemini's capabilities to accelerate development and ensure consistency with the existing codebase.
