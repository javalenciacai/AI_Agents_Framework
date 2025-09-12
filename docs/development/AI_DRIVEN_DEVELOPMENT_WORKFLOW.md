# 🤖 Guía de Desarrollo Impulsado por IA: Un Flujo de Trabajo Unificado

Esta guía presenta un flujo de trabajo sistemático para desarrollar software utilizando agentes de IA (como GitHub Copilot, Gemini, etc.). El proceso está diseñado para ser adaptable, funcionando tanto para **proyectos que inician desde cero** como para **proyectos existentes** que requieren nuevas funcionalidades o mantenimiento.

El objetivo es maximizar la colaboración humano-IA, asegurando un desarrollo estructurado, de alta calidad y alineado con las mejores prácticas como SOLID, Clean Architecture y Shape Up.

---

## 🗺️ El Flujo de Trabajo Completo

El proceso se divide en 7 pasos clave, desde la configuración inicial del agente hasta la implementación y el mantenimiento.

### **Paso 1: Configuración del Agente (El Cerebro de la IA)**

**Objetivo**: Proporcionar al agente de IA todo el contexto necesario sobre el proyecto. Este es el paso más crítico para obtener resultados de alta calidad.

-   **Para Proyectos Nuevos**: Se genera un archivo de instrucciones desde cero, basado en las tecnologías y objetivos del proyecto.
-   **Para Proyectos Existentes**: Se le pide al agente que analice el proyecto y actualice o enriquezca el archivo de instrucciones existente.

---

#### ✒️ **Plantillas de Prompt**

**Plantilla (Proyecto Nuevo):**
```
Actúa como un arquitecto de software experto. Genera un archivo de instrucciones detallado en `[RUTA_AL_ARCHIVO_DE_INSTRUCCIONES]` para un nuevo proyecto de `[TIPO_DE_PROYECTO]` que usará el siguiente stack tecnológico: `[STACK_TECNOLÓGICO]`.

El archivo debe incluir:
- Roles y responsabilidades del agente (PO, Dev, QA).
- Principios de desarrollo (SOLID, Clean Architecture).
- El stack tecnológico detallado.
- La arquitectura de microservicios/monolito que se seguirá.
- Estructura de directorios.
- Estrategias de seguridad, testing y manejo de errores.
- Metodología de gestión de proyectos (Shape Up).
```

**Plantilla (Proyecto Existente):**
```
Actúa como un arquitecto de software experto. Analiza la totalidad de este workspace para entender su propósito, stack tecnológico y patrones de arquitectura.

Luego, lee el archivo de instrucciones existente en `[RUTA_AL_ARCHIVO_DE_INSTRUCCIONES]` y actualízalo para que refleje con precisión el estado actual del proyecto. Asegúrate de que la documentación sobre el stack, la arquitectura y las convenciones sea correcta y esté completa.
```

---

#### 💡 **Ejemplos Prácticos**

**Ejemplo (Proyecto Nuevo):**
> "Actúa como un arquitecto de software experto. Genera un archivo de instrucciones detallado en `.github/copilot-instructions.md` para un nuevo proyecto de **aplicación web full-stack** que usará el siguiente stack tecnológico: **React, TypeScript, Node.js, Express, MongoDB, Docker**. El archivo debe incluir roles, principios SOLID, el stack detallado, una arquitectura de microservicios, estructura de directorios, y la metodología Shape Up."

**Ejemplo (Proyecto Existente):**
> "Actúa como un arquitecto de software experto. Analiza todo este proyecto para entenderlo a fondo. Después, lee el archivo `GEMINI.md` y actualízalo para que refleje con precisión el stack tecnológico actual, la arquitectura de microservicios y las convenciones de código que has identificado."

---

### **Paso 2: Creación de la Iniciativa (Metodología Shape Up)**

**Objetivo**: Definir el "qué" y el "por qué" de una nueva funcionalidad o mejora, sin entrar en los detalles de implementación.

-   **Para Proyectos Nuevos/Existentes**: El proceso es el mismo. Se crea un nuevo directorio para la iniciativa y un archivo `01_initiative.md` que describe el problema, la solución y el alcance.

---

#### ✒️ **Plantillas de Prompt**

**Plantilla General:**
```
Actúa como Product Owner. Usando la metodología Shape Up, crea una nueva iniciativa en la ruta `plans/XX-[nombre-iniciativa]`.

**Contexto de la iniciativa**: `[Describe la funcionalidad o problema a resolver de forma clara y concisa. Proporciona contexto sobre el área del sistema afectada, por ejemplo: 'En el reporte de comisiones existente en /reports?tab=commissions...']`

El objetivo es `[OBJETIVO DE NEGOCIO]`.

Crea únicamente el archivo `01_initiative.md` con las siguientes secciones:
- **Problema**: Describe el dolor o la necesidad del usuario.
- **Solución**: Una descripción de alto nivel de la propuesta.
- **Alcance (Appetite)**: Define límites claros, qué incluye y qué no.
- **Riesgos**: Posibles obstáculos técnicos o de negocio.

No crees las Historias de Usuario (HU) todavía.
```

---

#### 💡 **Ejemplos Prácticos**

**Ejemplo (Basado en tu archivo .txt):**
> "Actúa como Product Owner. Usando la metodología Shape Up, crea una nueva iniciativa en `plans/02-pago-total-factura`.
>
> **Contexto**: En el reporte de comisiones (`/reports?tab=commissions`), necesitamos una forma de saber cuándo una factura ha sido pagada en su totalidad para poder liberar la comisión al vendedor. Una factura puede tener múltiples pagos (documentos hijos) a lo largo de varios meses. El último documento que salda la deuda debe marcar la factura como 'totalmente pagada'.
>
> El objetivo es identificar el momento exacto en que se debe pagar la comisión.
>
> Crea solo el archivo `01_initiative.md` con las secciones Problema, Solución, Alcance y Riesgos. No crees las HU aún."

---

### **Paso 3: Creación del Story Mapping**

**Objetivo**: Desglosar la iniciativa en un mapa de Historias de Usuario (HU) que representen el viaje del usuario.

-   **Para Proyectos Nuevos/Existentes**: Se crea el archivo `02_user_stories.md` dentro de la carpeta de la iniciativa, definiendo las HU en formato Gherkin.

---

#### ✒️ **Plantillas de Prompt**

**Plantilla General:**
```
Actúa como Product Owner. Para la iniciativa definida en `[RUTA_DE_LA_INICIATIVA]`, crea el Story Mapping en un nuevo archivo `02_user_stories.md`.

Desglosa la funcionalidad en Historias de Usuario (HU) lógicas. Para cada HU, utiliza el formato:
- **Como** `[ROL]`
- **Quiero** `[ACCIÓN/FUNCIONALIDAD]`
- **Para que** `[BENEFICIO]`

Asegúrate de incluir una HU 0 para el diseño de la arquitectura.

**Importante**: No definas las tareas de desarrollo ni ningún otro detalle. Detente después de crear el mapa de historias.
```

---

#### 💡 **Ejemplos Prácticos**

**Ejemplo:**
> "Actúa como PO. Para la iniciativa en `plans/02-pago-total-factura/`, crea el Story Mapping en `02_user_stories.md`. Desglosa la funcionalidad en HUs usando el formato 'Como..., Quiero..., Para que...'. Incluye una HU 0 para la arquitectura. No crees las tareas."

---

### **Paso 4: Enriquecimiento de HUs (Example Mapping)**

**Objetivo**: Transformar las HUs de simples declaraciones a especificaciones listas para el desarrollo, combinando las perspectivas de PO, QA y Dev.

-   **Fase 1 (Funcional)**: Se enfoca en reglas de negocio, escenarios y criterios de aceptación.
-   **Fase 2 (Técnica)**: Se añaden detalles de implementación, diagramas C4 y contratos de API.

---

#### ✒️ **Plantillas de Prompt**

**Plantilla (Fase Funcional y Técnica Combinada):**
```
Actúa como un equipo multidisciplinario (PO, QA, Dev). Revisa el archivo `[RUTA_AL_ARCHIVO_DE_HU]`.

Para cada Historia de Usuario, enriquece su contenido aplicando **Example Mapping** para agregar:
1.  **Información Funcional**:
    -   **Reglas de Negocio**: Lógicas clave y restricciones.
    -   **Escenarios (Gherkin)**: `Dado... Cuando... Entonces...` para casos de éxito y de error.
    -   **Criterios de Aceptación**: La lista de verificación para considerar la HU como 'Done'.

2.  **Información Técnica**:
    -   **Especificaciones Técnicas**: Enfoque de implementación, algoritmos, cambios en la base de datos.
    -   **Diagrama C4**: Un diagrama de componentes o código relevante (en formato Mermaid).
    -   **Contrato de API (API First)**: Endpoints, métodos, payloads y respuestas. Incluye ejemplos con `curl`.

Si falta información, consulta la documentación en `docs/` o haz preguntas claras. Asegúrate de que cada HU cumpla con el **Definition of Ready (DoR)**.

**Importante**: No agregues las tareas de desarrollo en este paso. Tu única responsabilidad es enriquecer las HUs con la información funcional y técnica. Detente cuando hayas finalizado.
```

---

#### 💡 **Ejemplos Prácticos**

**Ejemplo:**
> "Actúa como un equipo (PO, QA, Dev). Revisa `plans/02-pago-total-factura/02_user_stories.md`. Para cada HU, agrega:
> 1. **Funcional**: Reglas de negocio, escenarios Gherkin para facturas con uno y varios pagos, y criterios de aceptación.
> 2. **Técnico**: Especificaciones sobre cómo se modificará el modelo de datos, un diagrama C4 del servicio de reportes y el `user-service`, y el contrato del API endpoint que devolverá el estado de pago de la factura.
>
> Asegúrate de que todo cumpla con el DoR."

---

### **Paso 5: Creación de Tareas de Desarrollo**

**Objetivo**: Desglosar cada HU en tareas técnicas, atómicas y accionables.

-   **Para Proyectos Nuevos/Existentes**: Una vez que la HU está enriquecida y cumple el DoR, el equipo define las tareas necesarias para cumplir el Definition of Done (DoD).

---

#### ✒️ **Plantillas de Prompt**

**Plantilla General:**
```
Actúa como un equipo de desarrollo (PO, QA, Dev). Para cada HU en `[RUTA_AL_ARCHIVO_DE_HU]`, que ya cumple con el DoR, define las tareas técnicas necesarias para su implementación.

Añade una sección `### Tareas de Desarrollo` al final de cada HU. Las tareas deben ser una lista de checkboxes en Markdown y cubrir todo el ciclo de vida para cumplir con el DoD:
-   `[ ] Tarea 0: Configurar entorno y pruebas iniciales.`
-   `[ ] Tarea 1 (Backend): Modificar el modelo [NombreModelo] y el esquema de la base de datos.`
-   `[ ] Tarea 2 (Backend): Crear/actualizar el endpoint [Metodo /ruta].`
-   `[ ] Tarea 3 (Backend): Implementar la lógica de negocio en [NombreServicio].`
-   `[ ] Tarea 4 (Frontend): Crear/actualizar el componente [NombreComponente].`
-   `[ ] Tarea 5 (Frontend): Integrar el componente con el servicio de datos.`
-   `[ ] Tarea 6 (QA): Crear pruebas unitarias para el backend y frontend.`
-   `[ ] Tarea 7 (QA): Crear pruebas de integración para el flujo completo.`
-   `[ ] Tarea 8 (DevOps/Doc): Actualizar la documentación de la API y el `README.md`.`
```

---

### **Paso 6: Desarrollo y Ejecución del Plan**

**Objetivo**: Implementar el código, siguiendo el plan y actualizando el estado de las tareas.

-   **Para Proyectos Nuevos/Existentes**: El agente de IA, actuando como desarrollador, toma una tarea a la vez, la implementa y la marca como completada.

---

#### ✒️ **Plantillas de Prompt**

**Plantilla para iniciar o continuar el desarrollo:**
```
Actúa como un desarrollador de software experto. Continúa con el plan de la iniciativa `[RUTA_DE_LA_INICIATIVA]`.

1.  **Revisa el estado actual**: Lee el archivo `02_user_stories.md` para identificar la próxima tarea pendiente (`[ ]`).
2.  **Analiza el código existente**: Antes de modificar, analiza el código relevante para entender el contexto y evitar duplicar funcionalidades.
3.  **Implementa la tarea**: Escribe o modifica el código necesario, aplicando principios SOLID y buenas prácticas.
4.  **Crea pruebas**: Añade pruebas unitarias para validar tu implementación.
5.  **Actualiza el plan**: Una vez finalizada y probada, actualiza el archivo `02_user_stories.md` marcando la tarea como completada (`[x]`).

Procede paso a paso, de forma cuidadosa y sistemática. Enfócate únicamente en la primera tarea pendiente.
```

---

### **Paso 7: Consejos Adicionales (Errores, Documentación, etc.)**

**Objetivo**: Utilizar la IA para tareas auxiliares comunes en el ciclo de vida del desarrollo.

---

#### ✒️ **Plantillas de Prompt**

**Plantilla para Analizar Errores:**
```
Actúa como un ingeniero de software senior experto en debugging. He encontrado un error.

**Error**: `[Pega aquí el log de error completo]`
**Contexto**: `[Describe lo que estabas haciendo cuando ocurrió el error, por ejemplo: 'al ejecutar las pruebas de integración del user-service']`

Analiza profundamente la causa raíz de este error. Propón 3 posibles soluciones, ordenadas de la más probable y simple a la más compleja. Para cada solución, explica sus pros y sus contras.
```
> **Prompt de seguimiento:** `Aplica la solución 1. Procede paso a paso y asegúrate de verificar que el error se ha resuelto.`

**Plantilla para Documentar un Proyecto Existente:**
```
Actúa como un arquitecto de software y escritor técnico. Tu misión es documentar este proyecto.

1.  **Análisis Profundo**: Revisa exhaustivamente todo el código del workspace para obtener un entendimiento completo de su arquitectura, funcionalidades y stack tecnológico.
2.  **Generación de Documentación**: Actualiza el archivo `README.md` en la raíz del proyecto con la siguiente estructura:
    -   **Descripción General**: ¿Qué hace el proyecto?
    -   **Stack Tecnológico**: Lista de tecnologías.
    -   **Arquitectura**:
        -   Descripción de alto nivel.
        -   **Diagramas C4 (formato Mermaid)**: Incluye los 4 niveles (Contexto, Contenedores, Componentes y Código).
    -   **Guía de Inicio Rápido**: Cómo instalar y ejecutar el proyecto.
    -   **Estructura de Directorios**: Explicación de las carpetas clave.

Mantenlo simple, claro y bien estructurado.
```
