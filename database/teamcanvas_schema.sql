-- 1. Usuarios
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  photo_url TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tableros
CREATE TABLE boards (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  created_by INT,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 3. Miembros del tablero + rol
CREATE TABLE board_members (
  user_id INT,
  board_id INT,
  role ENUM('admin', 'editor', 'viewer') DEFAULT 'viewer',
  PRIMARY KEY (user_id, board_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (board_id) REFERENCES boards(id)
);

-- 4. Tareas
CREATE TABLE tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  board_id INT,
  title VARCHAR(200),
  description TEXT,
  due_date DATETIME,
  is_completed BOOLEAN DEFAULT FALSE,
  created_by INT,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (board_id) REFERENCES boards(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 5. Asignaciones a tareas
CREATE TABLE task_assignees (
  task_id INT,
  user_id INT,
  PRIMARY KEY (task_id, user_id),
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 6. Etiquetas
CREATE TABLE tags (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  color VARCHAR(20)  -- Ej: "#FF0000"
);

-- 7. Etiquetas asignadas a tareas
CREATE TABLE task_tags (
  task_id INT,
  tag_id INT,
  PRIMARY KEY (task_id, tag_id),
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- 8. Comentarios por tarea
CREATE TABLE comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT,
  user_id INT,
  content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 9. Versiones de tarea
CREATE TABLE task_versions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT,
  title TEXT,
  description TEXT,
  updated_by INT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (updated_by) REFERENCES users(id)
);

-- 10. Notificaciones programadas
CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT,
  user_id INT,
  scheduled_at DATETIME,
  is_sent BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (task_id) REFERENCES tasks(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 11. Historial de actividad (audit log)
CREATE TABLE activity_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  board_id INT,
  user_id INT,
  action TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (board_id) REFERENCES boards(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
