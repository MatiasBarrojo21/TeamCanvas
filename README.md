# TeamCanvas 🎨

Autor Matias Barrojo.

Aplicación Android tipo Trello desarrollada por Matías Barrojo como proyecto personal de ingeniería.

TeamCanvas es una aplicación Android inspirada en Trello, desarrollada como proyecto personal. Permite gestionar tableros, tareas colaborativas, etiquetas, comentarios, estadísticas y mucho más.
## 📱 Tecnologías utilizadas

- **Frontend**: Flutter
- **Backend**: Node.js + Express
- **Base de datos**: MySQL
- **Notificaciones**: flutter_local_notifications
- **Almacenamiento**: Firebase Storage (adjuntos)
- **Autenticación**: JWT + SharedPreferences
- **Internacionalización**: easy_localization

## 🧠 Funcionalidades principales

- Registro/Login de usuario con JWT
- Perfil editable (nombre, email, contraseña, foto)
- Creación y gestión de tableros
- Tareas colaborativas con múltiples asignados
- Etiquetas, filtros y comentarios por tarea
- Estadísticas por tablero (tareas completadas, pendientes)
- Notificaciones programadas según fecha límite
- Soporte multilenguaje (español / inglés)
- Tema claro / oscuro con cambio en tiempo real
- Exportación de tareas en CSV / JSON
- Historial de actividad (audit log)
- Control de versiones en tareas
- Cierre de sesiones remotas por seguridad
- Modo offline con sincronización
- Dashboard personal de tareas asignadas
- Control de roles por tablero: admin, editor, lector

## 🗂️ Estructura del proyecto

- `database/`: contiene el esquema SQL inicial.
