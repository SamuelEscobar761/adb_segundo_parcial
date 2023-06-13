-- Creación de la base de datos
CREATE DATABASE adb;

-- Usar la base de datos
USE adb;

-- Creación de las tablas
CREATE TABLE departamento (
  id INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE direccion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero INT,
  calle VARCHAR(100),
  barrio VARCHAR(100),
  departamento_id INT,
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (departamento_id) REFERENCES departamento (id)
);

CREATE TABLE persona (
  ci INT PRIMARY KEY,
  nombre VARCHAR(100),
  apellido_paterno VARCHAR(100),
  apellido_materno VARCHAR(100),
  fecha_nacimiento DATE,
  disponible BOOLEAN DEFAULT true
);

CREATE TABLE empresa (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion_id INT,
  capital DECIMAL(10, 2),
  rubro VARCHAR(100),
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (direccion_id) REFERENCES direccion (id)
);

CREATE TABLE registro_comercial (
  id INT AUTO_INCREMENT PRIMARY KEY,
  empresa_id INT,
  fecha_registro DATE,
  fecha_vencimiento DATE,
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (empresa_id) REFERENCES empresa (id)
);

CREATE TABLE accionista (
  persona_ci INT,
  empresa_id INT,
  cantidad_acciones INT,
  PRIMARY KEY (persona_ci, empresa_id),
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (persona_ci) REFERENCES persona (ci),
  FOREIGN KEY (empresa_id) REFERENCES empresa (id)
);

CREATE TABLE socio (
  persona_ci INT,
  empresa_id INT,
  porcentaje_participacion DECIMAL(5, 2),
  PRIMARY KEY (persona_ci, empresa_id),
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (persona_ci) REFERENCES persona (ci),
  FOREIGN KEY (empresa_id) REFERENCES empresa (id)
);

CREATE TABLE representante_legal (
  persona_ci INT,
  empresa_id INT,
  fecha_eleccion DATE,
  numero_poder INT,
  PRIMARY KEY (persona_ci, empresa_id),
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (persona_ci) REFERENCES persona (ci),
  FOREIGN KEY (empresa_id) REFERENCES empresa (id)
);

CREATE TABLE duenho (
  persona_ci INT,
  empresa_id INT,
  PRIMARY KEY (persona_ci, empresa_id),
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (persona_ci) REFERENCES persona (ci),
  FOREIGN KEY (empresa_id) REFERENCES empresa (id)
);

CREATE TABLE empleado (
  persona_ci INT,
  empresa_id INT,
  cargo VARCHAR(100),
  salario DECIMAL(10, 2),
  fecha_inicio DATE,
  fecha_fin DATE,
  PRIMARY KEY (persona_ci, empresa_id),
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (persona_ci) REFERENCES persona (ci),
  FOREIGN KEY (empresa_id) REFERENCES empresa (id)
);

CREATE TABLE sucursal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  empresa_id INT,
  direccion_id INT,
  disponible BOOLEAN DEFAULT true,
  FOREIGN KEY (empresa_id) REFERENCES empresa (id),
  FOREIGN KEY (direccion_id) REFERENCES direccion (id)
);

CREATE TABLE auditoria_empresa (
  id INT AUTO_INCREMENT PRIMARY KEY,
  empresa_id INT,
  fecha_modificacion TIMESTAMP,
  usuario_modificacion VARCHAR(100),
  descripcion VARCHAR(255)
);

CREATE TABLE auditoria_duenho (
  id INT AUTO_INCREMENT PRIMARY KEY,
  persona_ci INT,
  empresa_id INT,
  fecha_modificacion TIMESTAMP,
  usuario_modificacion VARCHAR(100),
  descripcion VARCHAR(255)
);

CREATE TABLE auditoria_accionista (
  id INT AUTO_INCREMENT PRIMARY KEY,
  persona_ci INT,
  empresa_id INT,
  fecha_modificacion TIMESTAMP,
  usuario_modificacion VARCHAR(100),
  descripcion VARCHAR(255)
);

CREATE TABLE auditoria_socio (
  id INT AUTO_INCREMENT PRIMARY KEY,
  persona_ci INT,
  empresa_id INT,
  fecha_modificacion TIMESTAMP,
  usuario_modificacion VARCHAR(100),
  descripcion VARCHAR(255)
);

CREATE TABLE auditoria_representante_legal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  persona_ci INT,
  empresa_id INT,
  fecha_modificacion TIMESTAMP,
  usuario_modificacion VARCHAR(100),
  descripcion VARCHAR(255)
);

-- Triggers
DELIMITER //

CREATE TRIGGER auditar_empresa
AFTER INSERT ON empresa
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_empresa (empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (NEW.id, CURRENT_TIMESTAMP(), USER(), 'Se modificó la empresa');
END //

CREATE TRIGGER auditar_empresa_update
AFTER UPDATE ON empresa
FOR EACH ROW
BEGIN
  IF NEW.id <> OLD.id THEN
    INSERT INTO auditoria_empresa (empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
    VALUES (NEW.id, CURRENT_TIMESTAMP(), USER(), 'Se modificó la empresa');
  END IF;
END //

CREATE TRIGGER auditar_empresa_delete
AFTER DELETE ON empresa
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_empresa (empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (OLD.id, CURRENT_TIMESTAMP(), USER(), 'Se modificó la empresa');
END //

CREATE TRIGGER auditar_duenho
AFTER INSERT ON duenho
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_duenho (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el dueño');
END //

CREATE TRIGGER auditar_duenho_update
AFTER UPDATE ON duenho
FOR EACH ROW
BEGIN
  IF NEW.persona_ci <> OLD.persona_ci OR NEW.empresa_id <> OLD.empresa_id THEN
    INSERT INTO auditoria_duenho (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
    VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el dueño');
  END IF;
END //

CREATE TRIGGER auditar_duenho_delete
AFTER DELETE ON duenho
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_duenho (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (OLD.persona_ci, OLD.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el dueño');
END //

CREATE TRIGGER auditar_accionista
AFTER INSERT ON accionista
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_accionista (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el accionista');
END //

CREATE TRIGGER auditar_accionista_update
AFTER UPDATE ON accionista
FOR EACH ROW
BEGIN
  IF NEW.persona_ci <> OLD.persona_ci OR NEW.empresa_id <> OLD.empresa_id THEN
    INSERT INTO auditoria_accionista (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
    VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el accionista');
  END IF;
END //

CREATE TRIGGER auditar_accionista_delete
AFTER DELETE ON accionista
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_accionista (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (OLD.persona_ci, OLD.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el accionista');
END //

CREATE TRIGGER auditar_socio
AFTER INSERT ON socio
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_socio (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el socio');
END //

CREATE TRIGGER auditar_socio_update
AFTER UPDATE ON socio
FOR EACH ROW
BEGIN
  IF NEW.persona_ci <> OLD.persona_ci OR NEW.empresa_id <> OLD.empresa_id THEN
    INSERT INTO auditoria_socio (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
    VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el socio');
  END IF;
END //

CREATE TRIGGER auditar_socio_delete
AFTER DELETE ON socio
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_socio (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (OLD.persona_ci, OLD.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el socio');
END //

CREATE TRIGGER auditar_representante_legal
AFTER INSERT ON representante_legal
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_representante_legal (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el representante legal');
END //

CREATE TRIGGER auditar_representante_legal_update
AFTER UPDATE ON representante_legal
FOR EACH ROW
BEGIN
  IF NEW.persona_ci <> OLD.persona_ci OR NEW.empresa_id <> OLD.empresa_id THEN
    INSERT INTO auditoria_representante_legal (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
    VALUES (NEW.persona_ci, NEW.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el representante legal');
  END IF;
END //

CREATE TRIGGER auditar_representante_legal_delete
AFTER DELETE ON representante_legal
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_representante_legal (persona_ci, empresa_id, fecha_modificacion, usuario_modificacion, descripcion)
  VALUES (OLD.persona_ci, OLD.empresa_id, CURRENT_TIMESTAMP(), USER(), 'Se modificó el representante legal');
END //

-- Verificar que las personas sean mayores de edad en los Triggers
CREATE TRIGGER verificar_mayor_edad_persona
BEFORE INSERT ON persona
FOR EACH ROW
BEGIN
  IF DATEDIFF(CURDATE(), NEW.fecha_nacimiento) < 18 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La persona debe ser mayor de edad';
  END IF;
END //

CREATE TRIGGER tr_verificar_salario_insert
BEFORE INSERT ON empleado
FOR EACH ROW
BEGIN
  IF NEW.salario < 2362 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El salario debe ser superior a 2362';
  END IF;
END //

CREATE TRIGGER tr_verificar_salario_update
BEFORE UPDATE ON empleado
FOR EACH ROW
BEGIN
  IF NEW.salario < 2362 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El salario debe ser superior a 2362';
  END IF;
END //

CREATE TRIGGER tr_fecha_fin_superior_fecha_inicio
BEFORE INSERT ON empleado
FOR EACH ROW
BEGIN
  IF NEW.fecha_fin <= NEW.fecha_inicio THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha_fin debe ser superior a la fecha_inicio';
  END IF;
END//

DELIMITER ;


-- Stored Procedures
DELIMITER //

CREATE PROCEDURE sp_modificar_empleado(
  IN p_persona_ci INT,
  IN p_empresa_id INT,
  IN p_cargo VARCHAR(100),
  IN p_salario DECIMAL(10, 2),
  IN p_fecha_inicio DATE,
  IN p_fecha_fin DATE
)
BEGIN
  UPDATE empleado
  SET cargo = p_cargo, salario = p_salario, fecha_inicio = p_fecha_inicio, fecha_fin = p_fecha_fin
  WHERE persona_ci = p_persona_ci AND empresa_id = p_empresa_id;
END //

-- Verificar que la foreign key de persona_ci exista en la tabla persona en el stored procedure
CREATE PROCEDURE sp_insertar_socio(
  IN p_persona_ci INT,
  IN p_empresa_id INT,
  IN p_porcentaje_participacion DECIMAL(5, 2)
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM persona WHERE ci = p_persona_ci) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La persona no existe';
  END IF;
  
  INSERT INTO socio (persona_ci, empresa_id, porcentaje_participacion)
  VALUES (p_persona_ci, p_empresa_id, p_porcentaje_participacion);
END //

-- Verificar que la foreign key de empresa_id exista en la tabla empresa en el stored procedure
CREATE PROCEDURE sp_modificar_accionista(
  IN p_persona_ci INT,
  IN p_empresa_id INT,
  IN p_cantidad_acciones INT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM empresa WHERE id = p_empresa_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La empresa no existe';
  END IF;
  
  UPDATE accionista
  SET cantidad_acciones = p_cantidad_acciones
  WHERE persona_ci = p_persona_ci AND empresa_id = p_empresa_id;
END //

-- Verificar que la foreign key de direccion_id exista en la tabla direccion en el stored procedure
CREATE PROCEDURE sp_insertar_sucursal(
  IN p_empresa_id INT,
  IN p_direccion_id INT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM direccion WHERE id = p_direccion_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La dirección no existe';
  END IF;
  
  INSERT INTO sucursal (empresa_id, direccion_id)
  VALUES (p_empresa_id, p_direccion_id);
END //

CREATE PROCEDURE sp_calcular_salario_promedio(
  IN p_empresa_id INT,
  OUT p_salario_promedio DECIMAL(10, 2)
)
BEGIN
  SELECT AVG(salario) INTO p_salario_promedio
  FROM empleado
  WHERE empresa_id = p_empresa_id;
END //

-- Stored Procedure para obtener la lista de personas mayores de edad

CREATE PROCEDURE sp_obtener_empleados_mayores_edad(
  IN p_edad INT
)
BEGIN
  SELECT *
  FROM persona
  WHERE DATEDIFF(CURDATE(), fecha_nacimiento) >= p_edad;
END //


-- Stored Procedure para quitar la disponibilidad de un registro de empleado

CREATE PROCEDURE sp_modificar_estado_empleado(
  IN p_persona_ci INT,
  IN p_empresa_id INT,
  IN p_disponible BOOLEAN
)
BEGIN
  UPDATE empleado
  SET disponible = p_disponible
  WHERE persona_ci = p_persona_ci AND empresa_id = p_empresa_id;
END //


-- Stored Procedure para actualizar el capital de una empresa

CREATE PROCEDURE sp_actualizar_capital_empresa(
  IN p_empresa_id INT,
  IN p_nuevo_capital DECIMAL(10, 2)
)
BEGIN
  UPDATE empresa
  SET capital = p_nuevo_capital
  WHERE id = p_empresa_id;
END //

CREATE PROCEDURE sp_buscar_empresas_por_capital(
  IN p_monto_capital DECIMAL(10, 2)
)
BEGIN
  SELECT *
  FROM empresa
  WHERE capital > p_monto_capital;
END //

CREATE PROCEDURE sp_buscar_empresas_por_porcentaje_participacion(
  IN p_porcentaje DECIMAL(5, 2)
)
BEGIN
  SELECT *
  FROM empresa e
  INNER JOIN socio s ON e.id = s.empresa_id
  WHERE s.porcentaje_participacion > p_porcentaje;
END //

CREATE PROCEDURE sp_buscar_empresas_por_cantidad_acciones(
  IN p_cantidad_acciones INT
)
BEGIN
  SELECT *
  FROM empresa e
  INNER JOIN accionista a ON e.id = a.empresa_id
  WHERE a.cantidad_acciones > p_cantidad_acciones;
END //

CREATE PROCEDURE sp_buscar_personas_menores_salario(
  IN p_edad INT,
  IN p_salario DECIMAL(10, 2)
)
BEGIN
  SELECT p.*
  FROM persona p
  INNER JOIN empleado e ON p.ci = e.persona_ci
  WHERE DATEDIFF(CURDATE(), p.fecha_nacimiento) < p_edad
    AND e.salario > p_salario;
END //



DELIMITER ;

-- Indices
CREATE INDEX idx_empresa_capital ON empresa (capital);
CREATE INDEX idx_socio_porcentaje_participacion ON socio (porcentaje_participacion);
CREATE INDEX idx_accionista_cantidad_acciones ON accionista (cantidad_acciones);
CREATE INDEX idx_empleado_salario ON empleado (salario);
CREATE INDEX idx_persona_fecha_nacimiento ON persona (fecha_nacimiento);


-- Tabla: departamento
INSERT INTO departamento (id, nombre)
VALUES (1, 'La Paz'),
       (2, 'Santa Cruz'),
       (3, 'Cochabamba'),
       (4, 'Beni'),
       (5, 'Chuquisaca'),
       (6, 'Pando'),
       (7, 'Oruro'),
       (8, 'Potosi'),
       (9, 'Tarija');

-- Tabla: direccion
INSERT INTO direccion (numero, calle, barrio, departamento_id)
VALUES (123, 'Calle Principal', 'Centro', 1),
       (456, 'Avenida del Sol', 'Residencial', 2),
       (789, 'Calle de la Luna', 'Oeste', 3),
       (234, 'Avenida de los Árboles', 'Este', 4),
       (567, 'Calle del Mar', 'Playa', 5),
       (890, 'Avenida de las Flores', 'Jardín', 6),
       (345, 'Calle de los Pinos', 'Bosque', 7),
       (678, 'Avenida de las Montañas', 'Montaña', 8),
       (901, 'Calle de las Estrellas', 'Estrellado', 9),
       (123, 'Avenida de los Ríos', 'Riberas', 2);

-- Tabla: persona
INSERT INTO persona (ci, nombre, apellido_paterno, apellido_materno, fecha_nacimiento)
VALUES (123456, 'Juan', 'Pérez', 'Gómez', '1990-01-01'),
       (234567, 'María', 'González', 'López', '1991-02-02'),
       (345678, 'Carlos', 'Ramírez', 'Hernández', '1992-03-03'),
       (456789, 'Ana', 'Torres', 'Sánchez', '1993-04-04'),
       (567890, 'Pedro', 'Martínez', 'Rodríguez', '1994-05-05'),
       (678901, 'Laura', 'Díaz', 'Fernández', '1995-06-06'),
       (789012, 'Luis', 'Vargas', 'Jiménez', '1996-07-07'),
       (890123, 'Marta', 'Moreno', 'García', '1997-08-08'),
       (901234, 'José', 'López', 'Silva', '1998-09-09'),
       (224341, 'Sofía', 'Herrera', 'Ortega', '1999-10-10');

-- Tabla: empresa
INSERT INTO empresa (nombre, direccion_id, capital, rubro)
VALUES ('Apple', 1, 1000000.00, 'Tecnología'),
       ('Samsung', 2, 2000000.00, 'Electrónica'),
       ('Microsoft', 3, 3000000.00, 'Software'),
       ('Amazon', 4, 4000000.00, 'Comercio Electrónico'),
       ('Google', 5, 5000000.00, 'Internet'),
       ('Facebook', 6, 6000000.00, 'Redes Sociales'),
       ('Tesla', 7, 7000000.00, 'Automotriz'),
       ('Netflix', 8, 8000000.00, 'Entretenimiento'),
       ('Nike', 9, 9000000.00, 'Deportes'),
       ('Coca-Cola', 10, 10000000.00, 'Bebidas');

-- Tabla: registro_comercial
INSERT INTO registro_comercial (empresa_id, fecha_registro, fecha_vencimiento)
VALUES (1, '2023-01-01', '2025-01-01'),
       (2, '2023-02-01', '2025-02-01'),
       (3, '2023-03-01', '2025-03-01'),
       (4, '2023-04-01', '2025-04-01'),
       (5, '2023-05-01', '2025-05-01'),
       (6, '2023-06-01', '2025-06-01'),
       (7, '2023-07-01', '2025-07-01'),
       (8, '2023-08-01', '2025-08-01'),
       (9, '2023-09-01', '2025-09-01'),
       (10, '2023-10-01', '2025-10-01');

-- Tabla: accionista
INSERT INTO accionista (persona_ci, empresa_id, cantidad_acciones)
VALUES (123456, 1, 100),
       (234567, 2, 200),
       (345678, 3, 300),
       (456789, 4, 400),
       (567890, 5, 500),
       (678901, 6, 600),
       (789012, 7, 700),
       (890123, 8, 800),
       (901234, 9, 900),
       (123456, 10, 1000);

-- Tabla: socio
INSERT INTO socio (persona_ci, empresa_id, porcentaje_participacion)
VALUES (123456, 1, 10.5),
       (234567, 2, 20.5),
       (345678, 3, 30.5),
       (456789, 4, 40.5),
       (567890, 5, 50.5),
       (678901, 6, 60.5),
       (789012, 7, 70.5),
       (890123, 8, 80.5),
       (901234, 9, 90.5),
       (123456, 10, 100.0);

-- Tabla: representante_legal
INSERT INTO representante_legal (persona_ci, empresa_id, fecha_eleccion, numero_poder)
VALUES (123456, 1, '2022-01-01', 123),
       (234567, 2, '2022-02-01', 234),
       (345678, 3, '2022-03-01', 345),
       (456789, 4, '2022-04-01', 456),
       (567890, 5, '2022-05-01', 567),
       (678901, 6, '2022-06-01', 678),
       (789012, 7, '2022-07-01', 789),
       (890123, 8, '2022-08-01', 890),
       (901234, 9, '2022-09-01', 901),
       (123456, 10, '2022-10-01', 1234);

-- Tabla: duenho
INSERT INTO duenho (persona_ci, empresa_id)
VALUES (123456, 1),
       (234567, 2),
       (345678, 3),
       (456789, 4),
       (567890, 5),
       (678901, 6),
       (789012, 7),
       (890123, 8),
       (901234, 9),
       (123456, 10);

-- Tabla: empleado
INSERT INTO empleado (persona_ci, empresa_id, cargo, salario, fecha_inicio, fecha_fin)
VALUES (123456, 1, 'Gerente de Ventas', 5000.00, '2021-01-01', NULL),
       (234567, 2, 'Analista de Marketing', 3000.00, '2022-02-01', NULL),
       (345678, 3, 'Desarrollador de Software', 4000.00, '2023-03-01', NULL),
       (456789, 4, 'Contador', 3500.00, '2022-04-01', '2023-04-01'),
       (567890, 5, 'Diseñador Gráfico', 3200.00, '2023-05-01', NULL),
       (678901, 6, 'Especialista en RRHH', 3800.00, '2021-06-01', NULL),
       (789012, 7, 'Ingeniero de Proyectos', 4500.00, '2022-07-01', NULL),
       (890123, 8, 'Analista Financiero', 4000.00, '2023-08-01', NULL),
       (901234, 9, 'Consultor de Ventas', 5500.00, '2021-09-01', NULL),
       (123456, 10, 'Ejecutivo de Cuentas', 4800.00, '2022-10-01', NULL);

-- Tabla: sucursal
INSERT INTO sucursal (empresa_id, direccion_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10);


