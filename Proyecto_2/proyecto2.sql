USE proyecto2;
DROP TABLE registrarCliente;
DROP TABLE registrarTipoCliente;
DROP TABLE registrarTipoCuenta;
DROP TABLE crearProductoServicio;
DROP TABLE registrarCuenta;
DROP TABLE realizarCompra;
DROP TABLE realizardeposito;
DROP TABLE realizarDebito;
DROP TABLE asignarTransaccion;
DROP TABLE registrarTipoTransaccion;


DROP TRIGGER IF EXISTS verificar_tipo_cliente_trigger;
DROP TRIGGER IF EXISTS verificar_not_null_trigger_cliente;
DROP TRIGGER IF EXISTS verificar_correos_trigger;
DROP TRIGGER IF EXISTS verificar_not_null_trigger_cliente;
DROP TRIGGER IF EXISTS verificar_telefono_trigger;
DROP TRIGGER IF EXISTS verificar_apellidos_trigger;
DROP TRIGGER IF EXISTS verificar_nombre_trigger;
DROP TRIGGER IF EXISTS verificar_descripcion_registrartipocliente_trigger;
DROP TRIGGER IF EXISTS verificar_not_null_trigger_tipocliente;
DROP TRIGGER IF EXISTS  before_insert_registrarTipoCliente;



DROP PROCEDURE IF EXISTS registrarTipoCliente;
DROP PROCEDURE IF EXISTS registrarCliente;
DROP PROCEDURE IF EXISTS mensaje;
-- Crear una tabla para registrar errores
CREATE TABLE registro_errores (
    Id_error INT AUTO_INCREMENT PRIMARY KEY,
    Mensaje_error VARCHAR(255),
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE PROCEDURE mensaje(IN msj VARCHAR(200))
BEGIN
    INSERT INTO registro_errores (Mensaje_error) VALUES (msj);
END //

DELIMITER ;



-- registrarCliente

CREATE TABLE Cliente (
  IdCliente INT(10) NOT NULL,
  Nombre VARCHAR(40) NOT NULL,
  Apellidos VARCHAR(40) NOT NULL,
  Telefono VARCHAR(40) NOT NULL,
  Correos VARCHAR(40) NOT NULL,
  Usuario VARCHAR(40) NOT NULL,
  Contraseña VARCHAR(200) NOT NULL,
  TipoCliente INT(10),
  PRIMARY KEY (idCliente),
  UNIQUE (Usuario)
);

ALTER TABLE Cliente
ADD FOREIGN KEY (TipoCliente) REFERENCES TipoCliente(IdTipo);
SELECT IdCliente FROM Cliente WHERE IdCliente = 202402;


DELIMITER //
CREATE PROCEDURE registrarCliente(
-- PARAMETROS
IN IdCliente INT(10),
IN Nombre VARCHAR(40),
IN Apellidos VARCHAR(40),
IN Telefono VARCHAR(40),
IN Correos VARCHAR(40),
IN Usuario VARCHAR(40),
IN Contraseña VARCHAR(200),
IN TipoCliente INT(10)
)
procccliente: BEGIN
DECLARE has_errors BOOLEAN DEFAULT FALSE;
TRUNCATE TABLE registro_errores;
IF IdCliente IS NULL THEN
	call mensaje('EL IdCliente no puede ser nulo');
	SET has_errors = TRUE;
    
-- ELSE 
-- IF EXISTS (SELECT 1 FROM Cliente WHERE IdCliente = IdCliente) THEN
 --    CALL mensaje('El IdCliente ya existe');
--     SET has_errors = TRUE;
-- END IF;

    END IF;

IF Nombre =''  THEN
	call mensaje('El Nombre no puede ser nulo');
	SET has_errors = TRUE;
ELSE 
	IF  NOT verificarAtributoLetras(Nombre) THEN
		call  mensaje('El Nombre no cumple con la sintaxis correcta');
		SET has_errors = TRUE;
	END IF;
END IF;
IF Apellidos =''  THEN
	call mensaje('El Apellido no puede ser nulo');
	SET has_errors = TRUE;
ELSE 
	IF  NOT verificarAtributoLetras(Apellidos) THEN
		call  mensaje('El Apellidos no cumple con la sintaxis correcta');
		SET has_errors = TRUE;
	END IF;
END IF;
IF Telefono =''  THEN
	call  mensaje('El Telefono no puede ser nulo');
	SET has_errors = TRUE;
    
ELSE 
	IF  NOT verificarTelefono(Telefono) THEN
		call  mensaje('El Telefono no cumple con la sintaxis correcta');
		SET has_errors = TRUE;
	END IF;
    
    END IF;
IF Correos =''  THEN
	call  mensaje('El Correos no puede ser nulo');
	SET has_errors = TRUE;
ELSE
    IF NOT verificarCorreos(Correos) THEN
        CALL mensaje('El Correos no cumple con la sintaxis correcta');
        SET has_errors = TRUE;
    END IF;
END IF;
IF Usuario =''  THEN
	call  mensaje('El Usuario no puede ser nulo');
	SET has_errors = TRUE;
    END IF;
IF Contraseña =''  THEN
	call  mensaje('El Contraseña no puede ser nulo');
	SET has_errors = TRUE;
    END IF;
IF TipoCliente IS NULL THEN
	call mensaje('EL TipoCliente no puede ser nulo');
	SET has_errors = TRUE;
    END IF;
IF TipoCliente NOT IN (SELECT IdTipo FROM TipoCliente) THEN
	call  mensaje('El TipoCliente no existe');
	SET has_errors = TRUE;
    END IF;
    

-- IF Correos NOT REGEXP '^(\\w+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?:-(\\w+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}))*$' THEN
-- 	call  mensaje('El Correos no cumple con la sintaxis correcta');
-- 	SET has_errors = TRUE;
  --  END IF;
    

    IF NOT has_errors THEN
        INSERT INTO Cliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente) VALUES (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente) ;

	ELSE 
		SELECT * FROM registro_errores;
    END IF;    
    
END //
    
DELIMITER ;
-- .........................


-- Insertar cliente 1
INSERT INTO registrarCliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente)
VALUES (1, 'Juan', 'Perez', '12345678', 'juan@example.com', 'juanperez', 'contraseña123', 1);

-- Insertar cliente 2
INSERT INTO registrarCliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente)
VALUES (2, 'María', 'González', '98765432', 'maria@example.com', 'mariagonzalez', 'password456', 2);

-- Insertar cliente 3
INSERT INTO registrarCliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente)
VALUES (3, 'Pedro', 'Martínez', '45678901-98765432', 'pedro@example.com', 'pedromartinez', 'pwd123', 3);

-- Insertar cliente 4
INSERT INTO registrarCliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente)
VALUES (4, 'Ana', 'López', '98765432-45532366', 'ana@example.com', 'anlopez', 'pass321', 4);

-- Insertar cliente 5
INSERT INTO registrarCliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente)
VALUES (5, 'Carlos', 'Sánchez', '23412348965', 'carlos@example.com', 'carsan', 'clave567', 1);

INSERT INTO registrarCliente (idCliente, Nombre, Apellidos, Telefono, Correos, Usuario, Contraseña, TipoCliente)
VALUES (6, 'cristian', 'gomez', '12348965', 'weewe@example.com', 'cursi', 'clave', 6);

-- SHOW TRIGGERS;

-- registrarTipoCliente
CREATE TABLE TipoCliente(
IdTipo INT(10) AUTO_INCREMENT PRIMARY KEY,
Nombre VARCHAR(25) NOT NULL,
Descripcion VARCHAR(100) NOT NULL
);

DELIMITER //

CREATE PROCEDURE registrarTipoCliente(
    -- PARAMETROS
    IN Nombre VARCHAR(25),
    IN Descripcion VARCHAR(100)
)
proctccliente: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;
    IF Descripcion NOT REGEXP '^[A-Za-záéíóúÁÉÍÓÚüÜñÑ ]+$' THEN
        CALL mensaje('La descripcion no cumple con la sintaxis necesaria');
        SET has_errors = TRUE;
    END IF;

    IF Nombre = '' THEN
        CALL mensaje('El nombre no puede ser nulo');
        SET has_errors = TRUE;
    END IF;

    IF Descripcion = '' THEN
        CALL mensaje('El Descripcion no puede ser nulo');
        SET has_errors = TRUE;
    END IF;

    IF NOT has_errors THEN
        INSERT INTO TipoCliente (Nombre, Descripcion) VALUES (Nombre, Descripcion);
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;




-- DELIMITER //

-- CREATE TRIGGER verificar_not_null_trigger_tipocliente
-- BEFORE INSERT ON registrarTipoCliente
-- FOR EACH ROW
-- BEGIN

--    IF NEW.Nombre = '' THEN
--        INSERT INTO registro_errores (Mensaje_error) VALUES ('Los Apellidos no puede estar vacía');
--    END IF;


--    IF NEW.Descripcion = '' THEN
--        INSERT INTO registro_errores (Mensaje_error) VALUES ('La Descripcion no puede estar vacía');
--    END IF;

-- END //

-- DELIMITER ;





-- Insertar tipo de cliente 1
call registrarTipoCliente('', '');

INSERT INTO registrarTipoCliente (Nombre, Descripcion)
VALUES ('Individual Nacional', 'individual de nacionalidad guatemalteca');

-- Insertar tipo de cliente 2
INSERT INTO registrarTipoCliente (Nombre, Descripcion)
VALUES ('Individ Extranjero', 'individual de nacionalidad extranjera');

-- Insertar tipo de cliente 3
INSERT INTO registrarTipoCliente (Nombre, Descripcion)
VALUES ('Empresa PyMe', 'empresa de tipo pequeña o mediana');

-- Insertar tipo de cliente 4
INSERT INTO registrarTipoCliente (Nombre, Descripcion)
VALUES ('Empresa S.C', 'empresa grandes de sociedad colectiva1');





-- registrarCuenta 
CREATE TABLE Cuenta(
Id_cuenta INT(10) NOT NULL PRIMARY KEY,
Monto_apertura DECIMAL(12,2) NOT NULL CHECK (Monto_apertura > 0),
Saldo_cuenta DECIMAL(12,2) NOT NULL CHECK (Saldo_cuenta >= 0),
Descripcion VARCHAR(50) NOT NULL,
Fecha_de_apertura DATETIME,
Otros_detalles VARCHAR (100),
Tipo_Cuenta Integer(10),
IdCliente Integer(10)

);

DELIMITER //

CREATE PROCEDURE registrarCuenta(
    -- PARAMETROS
    IN Id_cuenta INT(10),
    IN Monto_apertura DECIMAL(12,2),
    IN Saldo_cuenta DECIMAL(12,2),
    IN Descripcion VARCHAR(50),
    IN Otros_detalles VARCHAR (100) ,
    IN Tipo_Cuenta Integer(10),
    IN IdCliente Integer(10)
)
proctccuenta: BEGIN
	DECLARE Fecha_de_apertura DATETIME;
    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;
    

    -- Obtener la fecha y hora actuales
    SET Fecha_de_apertura = NOW();


    IF Id_cuenta IS NULL THEN
        CALL mensaje('El Id_cuenta no puede ser nulo');
        SET has_errors = TRUE;
    END IF;

    IF Monto_apertura IS NULL THEN
        CALL mensaje('El Monto_apertura no puede ser nulo');
        SET has_errors = TRUE;
    END IF;
    IF Saldo_cuenta IS NULL THEN
        CALL mensaje('El Saldo_cuenta no puede ser nulo');
        SET has_errors = TRUE;
    END IF;
    IF Descripcion IS NULL THEN
        CALL mensaje('La Descripcion no puede ser nulo');
        SET has_errors = TRUE;
    END IF;
    IF Descripcion = '' THEN
        CALL mensaje('La Descripcion no puede estar vacia');
        SET has_errors = TRUE;
    END IF;
     IF Tipo_Cuenta IS NULL THEN
        CALL mensaje('El Tipo_Cuenta no puede ser nulo');
        SET has_errors = TRUE;
    END IF;
    IF IdCliente IS NULL THEN
        CALL mensaje('El IdCliente no puede ser nulo');
        SET has_errors = TRUE;
    END IF;
    
    IF Saldo_cuenta < 0 THEN
         CALL mensaje('El saldo de la cuenta no puede ser menor que 0');
         SET has_errors = TRUE;
    END IF;

    IF Monto_apertura < 0 THEN
        CALL mensaje('El monto de apertura de la cuenta no puede ser negativo');
        SET has_errors = TRUE;
        
    END IF;    
    
	IF Tipo_Cuenta NOT IN (SELECT Codigo FROM TipoCuenta) THEN
		call  mensaje('El Tipo_Cuenta no existe');
		SET has_errors = TRUE;
	END IF;    
		
	IF IdCliente NOT IN (SELECT IdCliente FROM Cliente) THEN
		call  mensaje('El cliente no existe');
		SET has_errors = TRUE;
	END IF;    
	IF Id_cuenta  IN (SELECT Id_cuenta FROM Cuenta) THEN
		call  mensaje('La cuenta ya existe');
		SET has_errors = TRUE;
	END IF;    
    
    IF Otros_detalles IS NULL THEN
        SET Otros_detalles = 'no hay detalles';
    END IF;
    
    IF NOT has_errors THEN
       INSERT INTO Cuenta (Id_cuenta, Monto_apertura, Saldo_cuenta, Descripcion,Fecha_de_apertura,Otros_detalles, Tipo_Cuenta, IdCliente) VALUES (Id_cuenta, Monto_apertura ,Saldo_cuenta , Descripcion ,Fecha_de_apertura, Otros_detalles , Tipo_Cuenta, IdCliente);
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;




-- Insertar cuenta 1
INSERT INTO registrarCuenta (Id_cuenta, Monto_apertura, Saldo_cuenta, Descripcion, Tipo_Cuenta, IdCliente)
VALUES (1, 1000.00, 1000.00, 'Cuenta de Ahorro', 1, 1);

-- Insertar cuenta 2
INSERT INTO registrarCuenta (Id_cuenta, Monto_apertura, Saldo_cuenta, Descripcion, Tipo_Cuenta, IdCliente)
VALUES (2, 2000.00, 2000.00, 'Cuenta Corriente', 2, 2);

-- Insertar cuenta 3
INSERT INTO registrarCuenta (Id_cuenta, Monto_apertura, Saldo_cuenta, Descripcion, Tipo_Cuenta, IdCliente)
VALUES (3, 1500.00, 1500.00, 'Cuenta de Ahorro', 1, 3);

-- Insertar cuenta 4
INSERT INTO registrarCuenta (Id_cuenta, Monto_apertura, Saldo_cuenta, Descripcion, Tipo_Cuenta, IdCliente)
VALUES (4, 3000.00, 3000.00, 'Cuenta Corriente', 2, 4);

-- Insertar cuenta 5
INSERT INTO registrarCuenta (Id_cuenta, Monto_apertura, Saldo_cuenta, Descripcion, Tipo_Cuenta, IdCliente)
VALUES (5, 5000.00, 5000.00, 'Cuenta de Ahorro', 1, 5);



-- registrarTipoCuenta

CREATE TABLE TipoCuenta(
Codigo INT(10) AUTO_INCREMENT PRIMARY KEY,
Nombre VARCHAR(50) NOT NULL,
Descripcion VARCHAR(100) NOT NULL
);

ALTER TABLE Cuenta
ADD FOREIGN KEY (Tipo_Cuenta) REFERENCES TipoCuenta(Codigo);

ALTER TABLE Cuenta
ADD FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);

DELIMITER //

CREATE PROCEDURE registrarTipoCuenta(
    -- PARAMETROS
    IN Nombre VARCHAR(50),
    IN Descripcion VARCHAR(100)
)
proctccliente: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;


    IF Nombre = '' THEN
        CALL mensaje('El nombre no puede ser nulo');
        SET has_errors = TRUE;
    END IF;

    IF Descripcion = '' THEN
        CALL mensaje('El Descripcion no puede ser nulo');
        SET has_errors = TRUE;
    END IF;

    IF NOT has_errors THEN
        INSERT INTO TipoCuenta(Nombre, Descripcion) VALUES (Nombre, Descripcion);
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;

-- Insertar tipo de cuenta 1
INSERT INTO registrarTipoCuenta (Nombre, Descripcion)
VALUES ('Cuenta de Cheques', 'Este tipo de cuenta ofrece la facilidad de emitir cheques para realizar transacciones monetarias');

-- Insertar tipo de cuenta 2
INSERT INTO registrarTipoCuenta (Nombre, Descripcion)
VALUES ('Cuenta de Ahorros', 'Esta cuenta genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo.');


-- Insertar tipo de cuenta 3
INSERT INTO registrarTipoCuenta (Nombre, Descripcion)
VALUES ('CuentadeAhorro Plus', 'Con una tasa de interés anual del 10%, esta cuenta de ahorros ofrece mayores rendimientos.');

-- Insertar tipo de cuenta 4
INSERT INTO registrarTipoCuenta (Nombre, Descripcion)
VALUES ('Tipo 4', 'Descripción del Tipo 4');

-- Insertar tipo de cuenta 5
INSERT INTO registrarTipoCuenta (Nombre, Descripcion)
VALUES ('Tipo 5', 'Descripción del Tipo 5');




-- Agrega una columna en la tabla registrarCuenta que será la clave foránea
-- ALTER TABLE registrarCuenta
-- ADD COLUMN idCliente INT(10) NOT NULL,
-- ADD CONSTRAINT fk_idCliente FOREIGN KEY (idCliente) REFERENCES registrarCliente(idCliente);









-- crearProductoServicio

CREATE TABLE ProductoServicio(
Codigo_del_producto_servicio INTEGER ,
Tipo INT(1) NOT NULL CHECK (Tipo IN (1, 2)),
Costo DECIMAL(12,2),
Descripcion_producto_servicio VARCHAR (100) 
);



DELIMITER //

CREATE PROCEDURE crearProductoServicio(
    -- PARAMETROS
    IN Codigo_del_producto_servicio INTEGER,
    IN Tipo INT(10),
    IN Costo DECIMAL(12,2),
    IN Descripcion_producto_servicio VARCHAR (100)
)
proctccliente: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;
-- 	IF Codigo_del_producto_servicio IN (1,2,3,4,5,6,7,8,9,10) AND Tipo != 1 THEN
-- 		CALL mensaje('el codigo indicado no pertenece al tipo indicado');
--         SET has_errors = TRUE;
 --    END IF;
-- 	IF Codigo_del_producto_servicio IN (11,12,13,14,15,16,17) AND Tipo != 2 THEN
-- 		CALL mensaje('el codigo indicado no pertenece al tipo indicado');
  --       SET has_errors = TRUE;
  --   END IF;
    
	IF Tipo = 1 THEN
		IF Costo IS NULL THEN
			CALL mensaje('el Costo no puede ser nulo ya que se trata de un servicio');
			SET has_errors = TRUE;
		END IF;
	END IF;
    
    IF Tipo NOT IN (1,2) THEN
		CALL mensaje('el Tipo no pertenece a 1 o 2');
        SET has_errors = TRUE;
    END IF;
    IF Descripcion_producto_servicio IS NULL THEN
		SET Descripcion_producto_servicio = 'no hay Descripcion';
    END IF;

    IF NOT has_errors THEN
        INSERT INTO ProductoServicio (Codigo_del_producto_servicio, Tipo, Costo,Descripcion_producto_servicio) VALUES (Codigo_del_producto_servicio, Tipo, Costo,Descripcion_producto_servicio);

	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;

-- Insertar producto/servicio 1
INSERT INTO crearProductoServicio (Tipo, Costo, Descripcion_producto)
VALUES (1, 50.00, 'Producto 1');

-- Insertar producto/servicio 2
INSERT INTO crearProductoServicio (Tipo, Costo, Descripcion_producto)
VALUES (2, 100.00, 'Servicio 1');

-- Insertar producto/servicio 3
INSERT INTO crearProductoServicio (Tipo, Costo, Descripcion_producto)
VALUES (1, 30.00, 'Producto 2');

-- Insertar producto/servicio 4
INSERT INTO crearProductoServicio (Tipo, Costo, Descripcion_producto)
VALUES (2, 80.00, 'Servicio 2');

-- Insertar producto/servicio 5
INSERT INTO crearProductoServicio (Tipo, Costo, Descripcion_producto)
VALUES (1, 70.00, 'Producto 3');



-- realizarCompra

CREATE TABLE Compras(
Id_compra INTEGER NOT NULL PRIMARY KEY,
Fecha Date NOT NULL,
Importe_compra DECIMAL(12,2) NOT NULL,
Otros_detalles VARCHAR (40),
Codigo_del_producto_servicio INTEGER,
Id_cliente Integer
);

-- CREATE INDEX idx_codigo_producto_servicio
-- ON ProductoServicio (Codigo_del_producto_servicio);

ALTER TABLE Compras
ADD FOREIGN KEY (Codigo_del_producto_servicio) REFERENCES ProductoServicio(Codigo_del_producto_servicio);
ALTER TABLE Compras
ADD FOREIGN KEY (Id_cliente) REFERENCES Cliente(IdCliente);

DELIMITER //

CREATE PROCEDURE realizarCompra(
    -- PARAMETROS
    IN Id_compra INTEGER,
    IN Fecha Date,
    IN Importe_compra DECIMAL(12,2),
    IN Otros_detalles VARCHAR (100),
    IN Codigo_del_producto_servicio INTEGER,
    IN Id_cliente Integer
)
proctccompra: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;
	IF Id_compra IS NULL THEN
		CALL mensaje('el Id_compra no puede ser nulo');
        SET has_errors = TRUE;
    END IF;	
	IF Fecha IS NULL THEN
		CALL mensaje('el Fecha no puede ser nulo');
        SET has_errors = TRUE;
    END IF;	

	IF EXISTS (SELECT * FROM ProductoServicio WHERE Codigo_del_producto_servicio = Codigo_del_producto_servicio AND Tipo = 2) THEN
			IF Importe_compra IS NULL THEN 
				CALL mensaje('el Importe_compra no puede ser nulo ya que se trata de un producto');
				SET has_errors = TRUE;
			END IF;	
	ELSE 
    		IF Importe_compra IS NULL THEN 
			SET Importe_compra = "no hay importe compra";
             END IF;
      END IF;
      
	IF Otros_detalles IS NULL THEN 
		SET Otros_detalles = "no hay detalles";
	END IF;
    
	IF Id_cliente NOT IN (SELECT IdCliente FROM Cliente) THEN
		call  mensaje('El Id_cliente no existe');
		SET has_errors = TRUE;
	END IF;
	IF Id_cliente IS NULL THEN
		call  mensaje('El Id_cliente no puede ser nulo');
		SET has_errors = TRUE;
	END IF;

    IF NOT has_errors THEN
		INSERT INTO Compra(Id_compra, Fecha, Importe_compra, Otros_detalles, Codigo_del_producto_servicio, Id_cliente) VALUES (Id_compra, Fecha, Importe_compra, Otros_detalles, Codigo_del_producto_servicio, Id_cliente);
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;

-- Insertar compra 1
INSERT INTO realizarCompra (Fecha, Importe_compra, Otros_detalles, Id_cliente)
VALUES ('2024-03-31', 150.00, 'Compra de alimentos', 1);

-- Insertar compra 2
INSERT INTO realizarCompra (Fecha, Importe_compra, Otros_detalles, Id_cliente)
VALUES ('2024-03-30', 200.00, 'Compra de ropa', 2);

-- Insertar compra 3
INSERT INTO realizarCompra (Fecha, Importe_compra, Otros_detalles, Id_cliente)
VALUES ('2024-03-29', 75.00, 'Compra de libros', 3);

-- Insertar compra 4
INSERT INTO realizarCompra (Fecha, Importe_compra, Otros_detalles, Id_cliente)
VALUES ('2024-03-28', 300.00, 'Compra de electrónicos', 4);

-- Insertar compra 5
INSERT INTO realizarCompra (Fecha, Importe_compra, Otros_detalles, Id_cliente)
VALUES ('2024-03-27', 50.00, 'Compra de juguetes', 5);



-- realizarDeposito
CREATE TABLE Depositos(
Id_deposito INTEGER NOT NULL,
Fecha DATE NOT NULL,
Monto DECIMAL(12,2) NOT NULL,
Otros_detalles VARCHAR (40),
Id_cliente Integer
);
ALTER TABLE Debitos
ADD FOREIGN KEY (Id_cliente) REFERENCES Cliente(IdCliente);

DELIMITER //
CREATE PROCEDURE realizarDeposito(
    -- PARAMETROS
    IN Id_deposito INTEGER ,
    IN Fecha Date,
    IN Monto DECIMAL(12,2),
    IN Otros_detalles VARCHAR (40),
    IN Id_cliente Integer
)
proctcdepositos: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;

	IF Id_deposito IS NULL THEN
		call  mensaje('El Id_deposito no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Fecha IS NULL THEN
		call  mensaje('El Fecha no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Monto IS NULL THEN
		call  mensaje('El Monto no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Otros_detalles = "" THEN
		SET Otros_detalles = "no hay otros detalles";
    END IF;
	IF Otros_detalles IS NULL THEN
		SET Otros_detalles = "no hay otros detalles";
    END IF;
	IF Id_cliente IS NULL THEN
		call  mensaje('El Id_cliente no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Id_cliente NOT IN (SELECT IdCliente FROM Cliente) THEN
		call  mensaje('El Id_cliente no existe');
		SET has_errors = TRUE;
	END IF;    
    
    IF NOT has_errors THEN
		INSERT INTO Depositos(Id_deposito, Fecha, Monto, Otros_detalles, Id_cliente) VALUES (Id_deposito, Fecha, Monto, Otros_detalles, Id_cliente) ;
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;


-- Insertar depósito 1
INSERT INTO realizarDeposito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-31', 500.00, 'Depósito de ahorros', 1);

-- Insertar depósito 2
INSERT INTO realizarDeposito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-30', 700.00, 'Depósito de sueldo', 2);

-- Insertar depósito 3
INSERT INTO realizarDeposito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-29', 300.00, 'Depósito de bonificación', 3);

-- Insertar depósito 4
INSERT INTO realizarDeposito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-28', 1000.00, 'Depósito de ahorros', 4);

-- Insertar depósito 5
INSERT INTO realizarDeposito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-27', 200.00, 'Depósito de regalos', 5);


-- realizarDebito
CREATE TABLE Debitos(
Id_debito INTEGER NOT NULL PRIMARY KEY,
Fecha DATE NOT NULL,
Monto DECIMAL(12,2) NOT NULL,
Otros_detalles VARCHAR (40),
Id_cliente Integer
);


DELIMITER //
CREATE PROCEDURE realizarDebito(
    -- PARAMETROS
    IN Id_debito INTEGER ,
    IN Fecha Date,
    IN Monto DECIMAL(12,2),
    IN Otros_detalles VARCHAR (40),
    IN Id_cliente Integer
)
proctcdebitos: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;

	IF Id_deposito IS NULL THEN
		call  mensaje('El Id_deposito no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Fecha IS NULL THEN
		call  mensaje('El Fecha no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Monto IS NULL THEN
		call  mensaje('El Monto no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Otros_detalles = "" THEN
		SET Otros_detalles = "no hay otros detalles";
    END IF;
	IF Otros_detalles IS NULL THEN
		SET Otros_detalles = "no hay otros detalles";
    END IF;
	IF Id_cliente IS NULL THEN
		call  mensaje('El Id_cliente no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Id_cliente NOT IN (SELECT IdCliente FROM Cliente) THEN
		call  mensaje('El Id_cliente no existe');
		SET has_errors = TRUE;
	END IF;    
    
    IF NOT has_errors THEN
		INSERT INTO Debitos(Id_deposito, Fecha, Monto, Otros_detalles, Id_cliente) VALUES (Id_deposito, Fecha, Monto, Otros_detalles, Id_cliente) ;
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;


-- Insertar débito 1
INSERT INTO realizarDebito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-31', 100.00, 'Pago de factura', 1);

-- Insertar débito 2
INSERT INTO realizarDebito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-30', 50.00, 'Retiro de efectivo', 2);

-- Insertar débito 3
INSERT INTO realizarDebito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-29', 25.00, 'Compra en línea', 3);

-- Insertar débito 4
INSERT INTO realizarDebito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-28', 200.00, 'Pago de servicios', 4);

-- Insertar débito 5
INSERT INTO realizarDebito (Fecha, Monto, Otros_detalles, Id_cliente)
VALUES ('2024-03-27', 75.00, 'Compra en supermercado', 5);


-- asignarTransaccion
CREATE TABLE Transacciones(
Id_transaccion INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
Fecha DATE NOT NULL,
Otros_detalles VARCHAR (40),
Id_tipo_transacción Integer,
Id_compra Integer,
No_cuenta Integer(10)
);
ALTER TABLE Transacciones
ADD FOREIGN KEY (Id_tipo_transacción) REFERENCES TipoTransaccion(Codigo_transaccion);

ALTER TABLE Transacciones
ADD FOREIGN KEY (Id_compra) REFERENCES Compras(Id_compra);

ALTER TABLE Transacciones
ADD FOREIGN KEY (No_cuenta) REFERENCES Cuenta(Id_cuenta);


DELIMITER //
CREATE PROCEDURE asignarTransaccion(
    -- PARAMETROS
    IN Fecha Date,
    IN Otros_detalles VARCHAR (40),
    IN Id_tipo_transacción Integer,
    IN Id_compra INTEGER,
    IN No_cuenta Integer(10)
)
proctctransacciones: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;
	IF Otros_detalles = "" THEN
		SET Otros_detalles = "no hay detalles";
	END IF;
	IF Otros_detalles IS NULL THEN
		SET Otros_detalles = "no hay detalles";
	END IF;
	IF Fecha IS NULL THEN
		call  mensaje('El Fecha no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Id_tipo_transacción IS NULL THEN
		call  mensaje('El Id_tipo_transacción no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF Id_compra IS NULL THEN
		call  mensaje('El Id_compra no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
	IF No_cuenta IS NULL THEN
		call  mensaje('El No_cuenta no puede ser nulo');
		SET has_errors = TRUE;
    END IF;

	IF Id_tipo_transacción NOT IN (SELECT Codigo_transaccion FROM TipoTransaccion) THEN
		call  mensaje('El Codigo_transaccion no existe');
		SET has_errors = TRUE;
	END IF;    
    
	IF Id_compra NOT IN (SELECT Id_compra FROM Compra) THEN
		call  mensaje('El Id_compra no existe');
		SET has_errors = TRUE;
	END IF;    
    
    
    IF NOT has_errors THEN
		INSERT INTO Transacciones(Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta) VALUES (Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta);
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;


-- Insertar transacción 1
INSERT INTO asignarTransaccion (Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta)
VALUES ('2024-03-31', 'Transacción 1', 1, 1, 1);

-- Insertar transacción 2
INSERT INTO asignarTransaccion (Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta)
VALUES ('2024-03-30', 'Transacción 2', 2, 2, 2);

-- Insertar transacción 3
INSERT INTO asignarTransaccion (Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta)
VALUES ('2024-03-29', 'Transacción 3', 3, 3, 3);

-- Insertar transacción 4
INSERT INTO asignarTransaccion (Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta)
VALUES ('2024-03-28', 'Transacción 4', 4, 4, 4);

-- Insertar transacción 5
INSERT INTO asignarTransaccion (Fecha, Otros_detalles, Id_tipo_transacción, Id_compra, No_cuenta)
VALUES ('2024-03-27', 'Transacción 5', 5, 5, 5);



-- registrarTipoTransaccion
CREATE TABLE TipoTransaccion(
Codigo_transaccion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Nombre VARCHAR (20),
Descripcion VARCHAR (20)
);


DELIMITER //
CREATE PROCEDURE registrarTipoTransaccion(
    -- PARAMETROS
    IN Nombre VARCHAR (20),
    IN Descripcion VARCHAR (20)
)
proctctipotransacciones: BEGIN

    DECLARE has_errors BOOLEAN DEFAULT FALSE;
    TRUNCATE TABLE registro_errores;
    IF Descripcion IS NULL THEN
		call  mensaje('El Descripcion no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
    IF Descripcion = "" THEN
		call  mensaje('El Descripcion no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
    IF Nombre = "" THEN
		call  mensaje('El Nombre no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
    IF Nombre IS NULL THEN
		call  mensaje('El Nombre no puede ser nulo');
		SET has_errors = TRUE;
    END IF;
    
    IF NOT has_errors THEN
		INSERT INTO TipoTransaccion(Nombre, Descripcion) VALUES (Nombre, Descripcion);
	ELSE 
		SELECT * FROM registro_errores;
    END IF;
END //

DELIMITER ;

-- Insertar tipo de transacción 1
INSERT INTO registrarTipoTransaccion (Nombre, Descripcion)
VALUES ('Tipo 1', 'Descripción del Tipo ');

-- Insertar tipo de transacción 2
INSERT INTO registrarTipoTransaccion (Nombre, Descripcion)
VALUES ('Tipo 2', 'Descripción del Tipo ');

-- Insertar tipo de transacción 3
INSERT INTO registrarTipoTransaccion (Nombre, Descripcion)
VALUES ('Tipo 3', 'Descripción del Tipo ');

-- Insertar tipo de transacción 4
INSERT INTO registrarTipoTransaccion (Nombre, Descripcion)
VALUES ('Tipo 4', 'Descripción del Tipo ');

-- Insertar tipo de transacción 5
INSERT INTO registrarTipoTransaccion (Nombre, Descripcion)
VALUES ('Tipo 5', 'Descripción del Tipo ');



-- Funciones

DELIMITER //

CREATE FUNCTION tablaExiste(tabla_nombre VARCHAR(100))
RETURNS BOOLEAN
BEGIN
    DECLARE tabla_existente INT;
    
    -- Verificar si la tabla existe
    SET tabla_existente = (
        SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = DATABASE() AND table_name = tabla_nombre
    );
    
    -- Retornar true si la tabla existe, de lo contrario, false
    IF tabla_existente > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

DELIMITER ;




DELIMITER //

CREATE FUNCTION verificarAtributoLetras(
    input VARCHAR(100)
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result BOOLEAN;

    IF input REGEXP '^[A-Za-záéíóúÁÉÍÓÚüÜñÑ ]+$' THEN
        SET result = TRUE;
    ELSE
        SET result = FALSE;
    END IF;

    RETURN result;
END //

DELIMITER ;


DELIMITER //

CREATE FUNCTION verificarTelefono(
    input VARCHAR(100)
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result BOOLEAN;

    IF input REGEXP '^[0-9]{8}(-[0-9]{4})?|[0-9]{11}$' THEN
        SET result = TRUE;
    ELSE
        SET result = FALSE;
    END IF;

    RETURN result;
END //

DELIMITER ;


DELIMITER //

CREATE FUNCTION verificarCorreos(
    input VARCHAR(100)
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE result BOOLEAN;

    IF input REGEXP '^(\\w+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?:-(\\w+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}))*$' THEN
        SET result = TRUE;
    ELSE
        SET result = FALSE;
    END IF;

    RETURN result;
END //

DELIMITER ;




-- REPORTEEES

DELIMITER //
CREATE PROCEDURE consultarSaldoCliente (
    IN Numero_de_cuenta INT
)
BEGIN
    DECLARE cliente_nombre VARCHAR(40);
    DECLARE cliente_tipo VARCHAR(20);
    DECLARE cuenta_tipo VARCHAR(20);
    DECLARE cuenta_saldo DECIMAL(12,2);
    DECLARE cuenta_apertura DECIMAL(12,2);

    -- Obtener el nombre del cliente, tipo de cliente, tipo de cuenta, saldo de la cuenta y saldo de apertura
    SELECT c.Nombre, tc.Nombre, tcu.Nombre, cu.Saldo_cuenta, cu.Monto_apertura
    INTO cliente_nombre, cliente_tipo, cuenta_tipo, cuenta_saldo, cuenta_apertura
    FROM Cliente c
    INNER JOIN Cuenta cu ON c.IdCliente = cu.IdCliente
    INNER JOIN TipoCliente tc ON c.TipoCliente = tc.IdTipo
    INNER JOIN TipoCuenta tcu ON cu.Tipo_Cuenta = tcu.Codigo
    WHERE cu.Id_cuenta = Numero_de_cuenta;

    -- Mostrar los resultados
    SELECT cliente_nombre AS 'Nombre del Cliente',
           cliente_tipo AS 'Tipo de Cliente',
           cuenta_tipo AS 'Tipo de Cuenta',
           cuenta_saldo AS 'Saldo de la Cuenta',
           cuenta_apertura AS 'Saldo de Apertura';
END //
DELIMITER ;




DELIMITER //
CREATE PROCEDURE consultarMovsCliente (
    IN idCliente INT
)
BEGIN
    -- Declaración de variables
    DECLARE tipo_servicio VARCHAR(100);

    -- Consulta para obtener los movimientos del cliente
    SELECT T.Id_transaccion AS 'Id transacción',
           TT.Nombre AS 'Tipo transacción',
           T.Monto AS 'Monto',
           PS.Descripcion_producto_servicio AS 'Tipo de servicio',
           T.No_cuenta AS 'No. cuenta',
           TC.Nombre AS 'Tipo cuenta'
    FROM Transacciones T
    INNER JOIN TipoTransaccion TT ON T.Id_tipo_transacción = TT.Codigo_transaccion
    LEFT JOIN ProductoServicio PS ON T.Codigo_del_producto_servicio = PS.Codigo_del_producto_servicio
    INNER JOIN Cuenta C ON T.No_cuenta = C.Id_cuenta
    INNER JOIN TipoCuenta TC ON C.Tipo_Cuenta = TC.Codigo
    WHERE C.IdCliente = idCliente;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE consultarCliente (
    IN idCliente INT
)
BEGIN
    -- Declaración de variables
    DECLARE nombreCompleto VARCHAR(100);
    DECLARE numCuentas INT;
    DECLARE tiposCuentas VARCHAR(255);

    -- Obtener el nombre completo concatenado del cliente
    SELECT CONCAT(Nombre, ' ', Apellidos) INTO nombreCompleto FROM Cliente WHERE IdCliente = idCliente;

    -- Obtener el número de cuentas del cliente
    SELECT COUNT(*) INTO numCuentas FROM Cuenta WHERE IdCliente = idCliente;

    -- Obtener los tipos de cuentas del cliente
    SELECT GROUP_CONCAT(TipoCuenta.Nombre SEPARATOR ', ') INTO tiposCuentas
    FROM Cuenta
    INNER JOIN TipoCuenta ON Cuenta.Tipo_Cuenta = TipoCuenta.Codigo
    WHERE IdCliente = idCliente;

    -- Mostrar los resultados
    SELECT idCliente AS 'Id cliente',
           nombreCompleto AS 'Nombre completo',
           Usuario AS 'Usuario',
           Telefono AS 'Teléfono(s)',
           Correos AS 'Correo(s)',
           numCuentas AS 'No. cuenta(s) que posee (cantidad)',
           tiposCuentas AS 'Tipo(s) de cuenta que posee';
END //
DELIMITER ;

-- predeterminados
SELECT * FROM TipoCliente;
call registrarTipoCliente('Individual Nacional', 'Este tipo de cliente es una persona individual de nacionalidad guatemalteca');
call registrarTipoCliente('Individual Extranjero', 'Este tipo de cliente es una persona individual de nacionalidad extranjera');
call registrarTipoCliente('Empresa PyMe', 'Este tipo de cliente es una empresa de tipo pequeña o mediana');
call registrarTipoCliente('Empresa S.C ', 'Este tipo de cliente corresponde a las empresa grandes que tienen una sociedad colectiva');


SELECT * FROM TipoCuenta;
call registrarTipoCuenta("Cuenta de Cheques","Este tipo de cuenta ofrece la facilidad de emitir cheques para realizar transacciones monetarias");
call registrarTipoCuenta("Cuenta de Ahorros","Esta cuenta genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo");
call registrarTipoCuenta("Cuenta de Ahorro Plus","Con una tasa de interés anual del 10%, esta cuenta de ahorros ofrece mayores rendimientos");
call registrarTipoCuenta("Pequeña Cuenta","Una cuenta de ahorros con un interés semestral del 0.5%, ideal para pequeños ahorros y movimientos");
call registrarTipoCuenta("Cuenta de Nómina","Diseñada para recibir depósitos de sueldo y realizar pagos, con acceso a servicios bancarios básicos");
call registrarTipoCuenta("Cuenta de Inversión","Orientada a inversionistas, ofrece opciones de inversión y rendimientos más altos que una cuenta de ahorros estándar");


SELECT * FROM ProductoServicio;

call crearProductoServicio(1,1,10.00,"Servicio de tarjeta de debito");
call crearProductoServicio(2,1,10.00,"Servicio de chequera");
call crearProductoServicio(3,1,400.00,"Servicio de asesoramiento financiero");
call crearProductoServicio(4,1,5.00,"Servicio de banca personal");
call crearProductoServicio(5,1,30.00,"Seguro de vida");
call crearProductoServicio(6,1,100.00,"Seguro de vida plus");
call crearProductoServicio(7,1,300.00,"Seguro de automóvil");
call crearProductoServicio(8,1,500.00,"Seguro de automóvil plus");
call crearProductoServicio(9,1,00.05,"Servicio de deposito");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");
call crearProductoServicio(11,2,00.10,"Pago de energía Eléctrica (EEGSA)");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");
call crearProductoServicio(10,1,00.10,"Servicio de Debito");







-- INSERSICON DE DATOS

-- INSERCION DE DATOS CLIENTES Y CUENTAS.
-- REGISTROS CLIENTES
select * from Cliente;
CALL registrarCliente(202401, 'Cliente','UnoNacional','50210001000','clienteuno@calificacion.com.gt','userclienteuno','ClIeNtE1202401',1);
CALL registrarCliente(202402, 'Cliente','DosExtranjero','50820002000','cliente2ext@calificacion.com.gt','userclienteextranjero','ExtraNjer0Pass@word',2);
CALL registrarCliente(202403, 'Cliente','TresPyme','50230223480-35503080-32803060-50235253030','clientetres@pyme.com.gt','userclientepyme','PyMeeMpresa@pass',3);
CALL registrarCliente(202404, 'Cliente','CuatroEmpresaSC','50240004000-40014002','EmpresaSC@noespyme.com.gt','userclienteEmpresaSC','SCeMpreEsa@2024',4);
-- VALIDACIONES DE CLIENTES
CALL registrarCliente(202405, 'Cliente','numero5','50240004000-40014002','noregistrar@noespyme.com.gt','userclienteEmpresaSC','SCeMpreEsa@2024','5');
CALL registrarCliente(202405, 'Cliente','cinco','50240004000-40014002','noregistrar@noespyme.com.gt','userclienteEmpresaSC','SCeMpreEsa@2024','5'); 
CALL registrarCliente(20240t, 'Cliente','cinco','50240004000-40014002','noregistrar@noespyme.com.gt','userclienteEmpresaSC','SCeMpreEsa@2024','5');  -- erroer

-- REGISTROS TIPO CLIENTES
CALL registrarTipoCliente('ClienteExtra', 'Cliente Extraordinario');
-- VALIDACIONES DE TIPO CLIENTES
CALL registrarTipoCliente('ClienteExtraDos', 'Cliente Extraordinario 2'); -- error numeros
CALL registrarTipoCliente('ClienteExtra', 'Cliente Extraordinario'); -- tipo de cliente ya existe


-- REGISTROS CUENTA
--            idcuenta, montoapertura,*saldo, descripcion,                   fechaapertura,             otrosdetalles,idtipocuenta,idcliente
 -- cuenta cheques
CALL registrarCuenta(20250030,1800.00,1800.00,'Apertura de cuenta cheques con Q1800.00','esta apertura tiene fecha',1,202401); -- cuenta cheques
CALL registrarCuenta(20250002,800.00,800.00,'Apertura de cuenta ahorro con Q800.00','esta apertura tiene fecha',2,202401); -- cuenta ahorro
CALL registrarCuenta(20250003,4900.00,4900.00,'Apertura de cuenta plus con Q4900.00','',3,202402); -- ahorro plus
CALL registrarCuenta(20250004,100.00,100.00,'Apertura de cuenta pequeña con Q100.00','esta apertura tiene fecha',4,202403); -- cuenta pequeña
CALL registrarCuenta(20250005,4200.00,4200.00,'Apertura de cuenta nomina con Q4200.00','esta apertura no tiene fecha',5,202404); -- cuenta nomina
CALL registrarCuenta(20250006,1100.00,1100.00,'Apertura de cuenta inversion con Q1100.00','esta apertura no tiene fecha',6,202404); -- cuenta inversión
-- VALIDACIONES DE CUENTA
CALL registrarCuenta(20250007,2800.00,2800.10,'Apertura de cuenta cheques con Q2800.00','esta apertura tiene fecha',1,202401); -- error saldo
CALL registrarCuenta(20250007,1100.00,1100.00,'Apertura de cuenta inversion con Q1100.00','',6,202405); -- error cliente no existe
CALL registrarCuenta(20250007,1100.00,1100.00,'Apertura de cuenta inversion con Q1100.00','no existe tipo de cuenta',8,202404); -- tipo de cuenta no existe
CALL registrarCuenta(20250005,4200.00,4200.00,'Apertura de cuenta nomina con Q4200.00','esta apertura no tiene fecha',5,202404); -- cuenta nominas ya existe
