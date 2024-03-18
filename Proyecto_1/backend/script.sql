USE bdmysql;


CREATE TABLE `paises` (
  `id_pais` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_pais`));


CREATE TABLE `categorias` (
  `id_categoria` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_categoria`));


CREATE TABLE `clientes` (
`id_cliente` INT NOT NULL,
`Nombre` VARCHAR(45) NOT NULL,
`Apellido` VARCHAR(45) NOT NULL,
`Direccion` VARCHAR(45) NOT NULL,
`Telefono` VARCHAR(10) NOT NULL,
`Tarjeta` BIGINT NOT NULL,
`Edad` INT NOT NULL,
`Salario` INT NOT NULL,
`Genero` CHAR(1) NOT NULL,
`id_pais` INT NOT NULL,

PRIMARY KEY (`id_cliente`));






  CREATE TABLE `detalle_orden` (
  `id_detalle_orden` INT NOT NULL,
  `id_orden` INT NOT NULL,
  `linea_orden` INT NOT NULL,
  `id_vendedor` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `cantidad` INT NOT NULL,

  PRIMARY KEY (`id_detalle_orden`));


  CREATE TABLE `orden` (
  `id_orden` INT NOT NULL,
  `fecha_orden` DATE NOT NULL,
  `id_cliente` INT NOT NULL,
  
  PRIMARY KEY (`id_orden`));




  CREATE TABLE `productos` (
  `id_producto` INT NOT NULL,
  `Nombres` VARCHAR(45) NOT NULL,
  `Precio` FLOAT NOT NULL,
  `id_categoria` INT NOT NULL,
  
  PRIMARY KEY (`id_producto`));



  CREATE TABLE `vendedores` (
  `id_vendedor` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `id_pais` INT NOT NULL,
  
  PRIMARY KEY (`id_vendedor`));



TRUNCATE bdmysql.clientes;
TRUNCATE bdmysql.paises;
TRUNCATE bdmysql.orden;
TRUNCATE bdmysql.productos;
TRUNCATE bdmysql.vendedores;
TRUNCATE bdmysql.categorias;
TRUNCATE bdmysql.detalle_orden;
