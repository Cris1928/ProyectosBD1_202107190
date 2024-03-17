from flask import Flask, jsonify
import mysql.connector
import pandas as pd
app = Flask(__name__) 

# Configuración de la conexión a la base de datos
db_config = {
    'user': 'root',
    'password': 'secret',
    'host': 'localhost',
    'database': 'bdmysql',
    'port': 3306,
}
# Función para establecer una conexión a la base de datos
def connect_to_database():
    connection = mysql.connector.connect(**db_config)
    return connection

# Ruta de ejemplo para obtener datos de la base de datos
@app.route('/api/data', methods=['GET'])
def get_data():
    try:
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Ejecutar una consulta de ejemplo
        query = "SELECT * FROM paises"
        cursor.execute(query)
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        return jsonify(result)

    except Exception as e:
        return jsonify({'error': str(e)})

# Ruta para cargar datos desde un archivo CSV a la tabla "paises"
@app.route('/api/data/cargarmodelo', methods=['GET'])
def load_countries_data():
    try:
        # Leer datos desde el archivo CSV
        df = pd.read_csv('../db_csv/paises.csv', sep=';')

        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()

        # Insertar los datos en la tabla "paises"
        for index, row in df.iterrows():
            query = "INSERT INTO paises (id_pais, nombre) VALUES (%s, %s)"
            values = (row['id_pais'], row['nombre'])
            cursor.execute(query, values)

  

        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()




        df = pd.read_csv('../db_csv/clientes.csv', sep=';')

        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()

        # Insertar los datos en la tabla "paises"
        for index, row in df.iterrows():
            query = "INSERT INTO clientes (id_cliente, Nombre, Apellido, Direccion, Telefono, Tarjeta, Edad, Salario, Genero, id_pais) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            values = (row['id_cliente'], row['Nombre'], row['Apellido'], row['Direccion'], row['Telefono'], row['Tarjeta'], row['Edad'], row['Salario'], row['Genero'], row['id_pais'])
            cursor.execute(query, values)



        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()


        df = pd.read_csv('../db_csv/productos.csv', sep=';')

        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()

        # Insertar los datos en la tabla "paises"
        for index, row in df.iterrows():
            query = "INSERT INTO productos (id_producto, Nombres, Precio, id_categoria) VALUES (%s, %s, %s, %s)"
            values = (row['id_producto'], row['Nombre'], row['Precio'], row['id_categoria'])
            cursor.execute(query, values)




        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()


        df = pd.read_csv('../db_csv/Categorias.csv', sep=';')

        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()

        # Insertar los datos en la tabla "paises"
        for index, row in df.iterrows():
            query = "INSERT INTO categorias (id_categoria, nombre) VALUES (%s, %s)"
            values = ( row['id_categoria'], row['nombre'])
            cursor.execute(query, values)

 



        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()


        df = pd.read_csv('../db_csv/vendedores.csv', sep=';')

        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()

        # Insertar los datos en la tabla "paises"
        for index, row in df.iterrows():
            query = "INSERT INTO vendedores (id_vendedor, nombre, id_pais) VALUES (%s, %s, %s)"
            values = ( row['id_vendedor'], row['nombre'],row['id_pais'] )
            cursor.execute(query, values)

   



        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()










        df = pd.read_csv('../db_csv/ordenes.csv', sep=';')
        # Convertir el formato de fecha del archivo CSV al formato esperado por MySQL
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()

        df['fecha_orden'] = pd.to_datetime(df['fecha_orden'], format='%d/%m/%Y').dt.strftime('%Y-%m-%d')
        
        cont=0
        unique_orders = df.groupby('id_orden').first()[['fecha_orden', 'id_cliente']]

        for index, row in unique_orders.iterrows():
            query = "INSERT INTO orden (id_orden, fecha_orden, id_cliente) VALUES (%s, %s, %s)"
            values = (index, row['fecha_orden'], row['id_cliente'])
            cursor.execute(query, values)

        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()


        df = pd.read_csv('../db_csv/ordenes.csv', sep=';')
        #.. Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        
        for index, row in df.iterrows():
            cont=cont+1
            query = "INSERT INTO detalle_orden (id_detalle_orden, id_orden, linea_orden, id_vendedor, id_producto, cantidad) VALUES (%s, %s, %s, %s, %s, %s)"
            values = ( cont, row['id_orden'],row['linea_orden'],row['id_vendedor'],row['id_producto'],row['cantidad'] )
            cursor.execute(query, values)





        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({'message': 'Datos cargados con éxito "'})
    

    
    except Exception as e:
        return jsonify({'error': str(e)})


# Ruta para borrar la información de todas las tablas de la base de datos
@app.route('/api/data/borrarinfodb', methods=['GET'])
def delete_data():
    try:
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE clientes;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()



        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE categorias;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()


        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE detalle_orden;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()

        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE orden;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()



        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE paises;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()



        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE productos;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()



        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor()
        query = "TRUNCATE vendedores;"
        cursor.execute(query)
        # Confirmar la transacción y cerrar la conexión
        connection.commit()
        cursor.close()
        connection.close()



        return jsonify({'message': 'Datos borrados con éxito "'})


    except Exception as e:
        return jsonify({'error': str(e)})




@app.route('/api/data/consulta1', methods=['GET'])
def consulta1():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
            SELECT clientes.id_cliente, clientes.Nombre, clientes.Apellido, paises.nombre AS Pais, 
            SUM(detalle_orden.cantidad * productos.Precio) AS Monto_Total
            FROM clientes
            JOIN orden ON clientes.id_cliente = orden.id_cliente
            JOIN detalle_orden ON orden.id_orden = detalle_orden.id_orden
            JOIN productos ON detalle_orden.id_producto = productos.id_producto
            JOIN paises ON clientes.id_pais = paises.id_pais
            GROUP BY clientes.id_cliente, clientes.Nombre, clientes.Apellido, paises.nombre
            ORDER BY Monto_Total DESC
            LIMIT 1;
            """


        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})


@app.route('/api/data/consulta2', methods=['GET'])
def consulta2():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
       SELECT
    max_productos.id_producto AS id_producto_mas_comprado,
    max_productos.nombres AS nombre_producto_mas_comprado,
    max_productos.categoria AS categoria_producto_mas_comprado,
    max_productos.cantidad AS cantidad_unidades_mas_comprada,
    max_productos.monto AS monto_vendido_mas_comprado,
    min_productos.id_producto AS id_producto_menos_comprado,
    min_productos.nombres AS nombre_producto_menos_comprado,
    min_productos.categoria AS categoria_producto_menos_comprado,
    min_productos.cantidad AS cantidad_unidades_menos_comprada,
    min_productos.monto AS monto_vendido_menos_comprado
FROM
    (SELECT
        d.id_producto,
        p.nombres,
        c.nombre AS categoria,
        SUM(d.cantidad) AS cantidad,
        SUM(d.cantidad * p.precio) AS monto
    FROM
        detalle_orden d
    JOIN
        productos p ON d.id_producto = p.id_producto
    JOIN
        categorias c ON p.id_categoria = c.id_categoria
    GROUP BY
        d.id_producto
    ORDER BY
        cantidad DESC
    LIMIT 1) AS max_productos,
    (SELECT
        d.id_producto,
        p.nombres,
        c.nombre AS categoria,
        SUM(d.cantidad) AS cantidad,
        SUM(d.cantidad * p.precio) AS monto
    FROM
        detalle_orden d
    JOIN
        productos p ON d.id_producto = p.id_producto
    JOIN
        categorias c ON p.id_categoria = c.id_categoria
    GROUP BY
        d.id_producto
    ORDER BY
        cantidad ASC
    LIMIT 1) AS min_productos;
        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})





@app.route('/api/data/consulta3', methods=['GET'])
def consulta3():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
        SELECT vendedores.id_vendedor, vendedores.nombre AS Nombre_Vendedor, SUM(detalle_orden.cantidad * productos.Precio) AS Monto_Total_Vendido
        FROM vendedores
        JOIN detalle_orden ON vendedores.id_vendedor = detalle_orden.id_vendedor
        JOIN productos ON detalle_orden.id_producto = productos.id_producto
        GROUP BY vendedores.id_vendedor, vendedores.nombre
        ORDER BY Monto_Total_Vendido DESC
        LIMIT 1;
        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})





@app.route('/api/data/consulta4', methods=['GET'])
def consulta4():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
       SELECT nombre_pais, monto_total_ventas
FROM (
    SELECT
        pais.nombre AS nombre_pais,
        SUM(detalle_orden.cantidad * productos.precio) AS monto_total_ventas
    FROM
        detalle_orden
    JOIN
        productos ON detalle_orden.id_producto = productos.id_producto
    JOIN
        vendedores ON detalle_orden.id_vendedor = vendedores.id_vendedor
    JOIN
        paises AS pais ON vendedores.id_pais = pais.id_pais
    GROUP BY
        pais.nombre
    ORDER BY
        monto_total_ventas DESC
    LIMIT 1
) AS max_vendido

UNION

SELECT nombre_pais, monto_total_ventas
FROM (
    SELECT
        pais.nombre AS nombre_pais,
        SUM(detalle_orden.cantidad * productos.precio) AS monto_total_ventas
    FROM
        detalle_orden
    JOIN
        productos ON detalle_orden.id_producto = productos.id_producto
    JOIN
        vendedores ON detalle_orden.id_vendedor = vendedores.id_vendedor
    JOIN
        paises AS pais ON vendedores.id_pais = pais.id_pais
    GROUP BY
        pais.nombre
    ORDER BY
        monto_total_ventas ASC
    LIMIT 1
) AS min_vendido;

        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})



@app.route('/api/data/consulta5', methods=['GET'])
def consulta5():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
       SELECT 
    pais.id_pais,
    pais.nombre AS nombre_pais,
    SUM(detalle_orden.cantidad * productos.precio) AS monto_total
FROM 
    detalle_orden
JOIN 
    productos ON detalle_orden.id_producto = productos.id_producto
JOIN 
    vendedores ON detalle_orden.id_vendedor = vendedores.id_vendedor
JOIN 
    paises AS pais ON vendedores.id_pais = pais.id_pais
GROUP BY 
    pais.id_pais, pais.nombre
ORDER BY 
    monto_total ASC
LIMIT 5;


        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})






@app.route('/api/data/consulta6', methods=['GET'])
def consulta6():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
     SELECT nombre_categoria, cantidad_total_comprada
FROM (
    SELECT
        categoria.nombre AS nombre_categoria,
        SUM(detalle_orden.cantidad) AS cantidad_total_comprada
    FROM
        detalle_orden
    JOIN
        productos ON detalle_orden.id_producto = productos.id_producto
    JOIN
        categorias AS categoria ON productos.id_categoria = categoria.id_categoria
    GROUP BY
        categoria.nombre
    ORDER BY
        cantidad_total_comprada DESC
    LIMIT 1
) AS max_comprada

UNION

SELECT nombre_categoria, cantidad_total_comprada
FROM (
    SELECT
        categoria.nombre AS nombre_categoria,
        SUM(detalle_orden.cantidad) AS cantidad_total_comprada
    FROM
        detalle_orden
    JOIN
        productos ON detalle_orden.id_producto = productos.id_producto
    JOIN
        categorias AS categoria ON productos.id_categoria = categoria.id_categoria
    GROUP BY
        categoria.nombre
    ORDER BY
        cantidad_total_comprada ASC
    LIMIT 1
) AS min_comprada;


        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})





@app.route('/api/data/consulta7', methods=['GET'])
def consulta7():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
    SELECT 
    nombre_pais,
    nombre_categoria,
    cantidad_total_comprada
FROM (
    SELECT 
        p.nombre AS nombre_pais,
        c.nombre AS nombre_categoria,
        SUM(do.cantidad) AS cantidad_total_comprada,
        ROW_NUMBER() OVER(PARTITION BY p.id_pais ORDER BY SUM(do.cantidad) DESC) AS ranking
    FROM 
        detalle_orden do
    JOIN 
        productos pr ON do.id_producto = pr.id_producto
    JOIN 
        categorias c ON pr.id_categoria = c.id_categoria
    JOIN 
        vendedores v ON do.id_vendedor = v.id_vendedor
    JOIN 
        paises p ON v.id_pais = p.id_pais
    GROUP BY 
        p.id_pais, c.id_categoria
) AS ranked_data
WHERE 
    ranking = 1;

        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})





@app.route('/api/data/consulta8', methods=['GET'])
def consulta8():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
   SELECT 
    MONTH(o.fecha_orden) AS numero_mes,
    SUM(d.cantidad * p.precio) AS monto_total
FROM 
    orden o
JOIN 
    detalle_orden d ON o.id_orden = d.id_orden
JOIN 
    productos p ON d.id_producto = p.id_producto
JOIN 
    vendedores v ON d.id_vendedor = v.id_vendedor
JOIN 
    paises pa ON v.id_pais = pa.id_pais
WHERE 
    pa.nombre = 'Inglaterra'
GROUP BY 
    numero_mes
ORDER BY 
    numero_mes;

        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})










@app.route('/api/data/consulta9', methods=['GET'])
def consulta9():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """
SELECT
    mes_max.numero_mes AS mes_mas_ventas,
    mes_max.monto_max AS monto_max_ventas,
    mes_min.numero_mes AS mes_menos_ventas,
    mes_min.monto_min AS monto_min_ventas
FROM
    (SELECT
        MONTH(o.fecha_orden) AS numero_mes,
        SUM(d.cantidad * p.precio) AS monto_max
    FROM
        orden o
    JOIN
        detalle_orden d ON o.id_orden = d.id_orden
    JOIN
        productos p ON d.id_producto = p.id_producto
    GROUP BY
        numero_mes
    ORDER BY
        monto_max DESC
    LIMIT 1) AS mes_max,
    (SELECT
        MONTH(o.fecha_orden) AS numero_mes,
        SUM(d.cantidad * p.precio) AS monto_min
    FROM
        orden o
    JOIN
        detalle_orden d ON o.id_orden = d.id_orden
    JOIN
        productos p ON d.id_producto = p.id_producto
    GROUP BY
        numero_mes
    ORDER BY
        monto_min ASC
    LIMIT 1) AS mes_min;


        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})




@app.route('/api/data/consulta10', methods=['GET'])
def consulta10():
    try:

  
        # Establecer conexión a la base de datos
        connection = connect_to_database()

        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)

        # Definir la consulta SQL
        query = """

SELECT 
    productos.id_producto,
    productos.nombres AS nombre_producto,
    SUM(detalle_orden.cantidad * productos.precio) AS monto_total_ventas
FROM 
    detalle_orden
JOIN 
    productos ON detalle_orden.id_producto = productos.id_producto
JOIN 
    categorias ON productos.id_categoria = categorias.id_categoria
WHERE 
    categorias.nombre = 'Deportes'
GROUP BY 
    productos.id_producto, productos.nombres;


        """

        # Ejecutar la consulta SQL
        cursor.execute(query)

        # Obtener el resultado de la consulta
        result = cursor.fetchall()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        # Devolver el resultado en formato JSON
        return jsonify(result)


    except Exception as e:
        return jsonify({'error': str(e)})

















@app.route('/api/data/crearmodelo', methods=['GET'])
def crearmodelo():
    try:
        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """

CREATE TABLE `paises` (
  `id_pais` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_pais`));
        """

        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()



        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
CREATE TABLE `categorias` (
  `id_categoria` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_categoria`));
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()









        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
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
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()









        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        CREATE TABLE `detalle_orden` (
        `id_detalle_orden` INT NOT NULL,
        `id_orden` INT NOT NULL,
        `linea_orden` INT NOT NULL,
        `id_vendedor` INT NOT NULL,
        `id_producto` INT NOT NULL,
        `cantidad` INT NOT NULL,

        PRIMARY KEY (`id_detalle_orden`));
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()










        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        CREATE TABLE `orden` (
        `id_orden` INT NOT NULL,
        `fecha_orden` DATE NOT NULL,
        `id_cliente` INT NOT NULL,
        
        PRIMARY KEY (`id_orden`));
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()









        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        CREATE TABLE `productos` (
        `id_producto` INT NOT NULL,
        `Nombres` VARCHAR(45) NOT NULL,
        `Precio` FLOAT NOT NULL,
        `id_categoria` INT NOT NULL,
        
        PRIMARY KEY (`id_producto`));
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()










        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        CREATE TABLE `vendedores` (
        `id_vendedor` INT NOT NULL,
        `nombre` VARCHAR(45) NOT NULL,
        `id_pais` INT NOT NULL,
        
        PRIMARY KEY (`id_vendedor`));
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()





        # Devolver el resultado en formato JSON
        return jsonify({'message': 'Modelo creado con éxito "'})

    except Exception as e:
        return jsonify({'error': str(e)})






@app.route('/api/data/eliminarmodelo', methods=['GET'])
def eliminarmodelo():
    try:
        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE paises;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()





        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE categorias;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()





        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE clientes;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()





        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE detalle_orden;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()
    


        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE orden;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()









    




        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE productos;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()




        # Establecer conexión a la base de datos
        connection = connect_to_database()
        # Crear un cursor para ejecutar consultas SQL
        cursor = connection.cursor(dictionary=True)
        # Definir la consulta SQL
        query = """
        DROP TABLE vendedores;
        """
        # Ejecutar la consulta SQL
        cursor.execute(query)
        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()








        # Devolver el resultado en formato JSON
        return jsonify({'message': 'Mpdelo eliminado con éxito "'})

    except Exception as e:
        return jsonify({'error': str(e)})




if __name__ == '__main__':
    app.run(debug=True)