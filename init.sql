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

DELIMITER ;


-- Stored Procedures
DELIMITER //

CREATE PROCEDURE sp_insertar_registro_comercial(
  IN p_empresa_id INT,
  IN p_fecha_registro DATE,
  IN p_fecha_vencimiento DATE
)
BEGIN
  INSERT INTO registro_comercial (empresa_id, fecha_registro, fecha_vencimiento)
  VALUES (p_empresa_id, p_fecha_registro, p_fecha_vencimiento);
END //

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

CREATE PROCEDURE sp_insertar_direccion(
  IN p_numero INT,
  IN p_calle VARCHAR(100),
  IN p_barrio VARCHAR(100),
  IN p_departamento_id INT
)
BEGIN
  INSERT INTO direccion (numero, calle, barrio, departamento_id)
  VALUES (p_numero, p_calle, p_barrio, p_departamento_id);
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

DELIMITER ;

-- Agregar 5 stored procedures relevantes

-- Stored Procedure para calcular el salario promedio de los empleados de una empresa
DELIMITER //

CREATE PROCEDURE sp_calcular_salario_promedio(
  IN p_empresa_id INT,
  OUT p_salario_promedio DECIMAL(10, 2)
)
BEGIN
  SELECT AVG(salario) INTO p_salario_promedio
  FROM empleado
  WHERE empresa_id = p_empresa_id;
END //

DELIMITER ;

-- Stored Procedure para obtener la lista de personas mayores de edad
DELIMITER //

CREATE PROCEDURE sp_obtener_personas_mayores_edad()
BEGIN
  SELECT *
  FROM persona
  WHERE DATEDIFF(CURDATE(), fecha_nacimiento) >= 18;
END //

DELIMITER ;

-- Stored Procedure para eliminar un registro de empleado
DELIMITER //

CREATE PROCEDURE sp_eliminar_empleado(
  IN p_persona_ci INT,
  IN p_empresa_id INT
)
BEGIN
  DELETE FROM empleado
  WHERE persona_ci = p_persona_ci AND empresa_id = p_empresa_id;
END //

DELIMITER ;

-- Stored Procedure para actualizar el capital de una empresa
DELIMITER //

CREATE PROCEDURE sp_actualizar_capital_empresa(
  IN p_empresa_id INT,
  IN p_nuevo_capital DECIMAL(10, 2)
)
BEGIN
  UPDATE empresa
  SET capital = p_nuevo_capital
  WHERE id = p_empresa_id;
END //

DELIMITER ;

-- Stored Procedure para obtener las direcciones disponibles
DELIMITER //

CREATE PROCEDURE sp_obtener_direcciones_disponibles()
BEGIN
  SELECT *
  FROM direccion
  WHERE disponible = true;
END //

DELIMITER ;
