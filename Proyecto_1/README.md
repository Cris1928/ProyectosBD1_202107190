# ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ MANUAL TECNICO

El siguiente proyecto despliega una api rest la cual genera diferentes tipo de consultas que se explicaran a continuacion.

## CREACION DE BASE DE DATOS
La base de datos fue creada en MySQL con las siguientes llaves 
```
db_config = {
    'user': 'root',
    'password': 'secret',
    'host': 'localhost',
    'database': 'bdmysql',
    'port': 3306,
}
```

estas permitiran la conexion con la base de datos, y la conexion se dará de la siguiente forma:
```
# Función para establecer una conexión a la base de datos
def connect_to_database():
    connection = mysql.connector.connect(**db_config)
    return connection
```

este metodo permitira hacer las query que se manejaran en la base de datos para sus consultas.

## CARGAR ARCHIVOS 
En la ruta "http://127.0.0.1:5000/api/data/cargarmodelo" podremos realizar una consulta GET que cargara todos los datos al modelo de la base de datos, esto es de la siguiente manera:

```
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

```


anteriormente se a mostrado y detallado cada parte del codigo para la carga en la informacion de la tabla "paises", esta informacion proviene del archivo "paises.csv", y esete lo envia a la base de datos.


# CARGA DE MODELO

```
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
```

Este endopint "http://127.0.0.1:5000/api/data/crearmodelo" es el que se encargara de hacer la peticion GET que creara todas las tablas de la base de datos, aqui un ejemplo de la qureacion de la tabla paises mediante el lenguaje sql, este hara la peticion query como antes se habia mencionado.

# Eliminar las tablas de la base de datos
Atravez del endpoint "http://127.0.0.1:5000/api/data/eliminarmodelo" realizaremos una peticion GET que eliminara todas las tablas de la base de datos, esta peticion se hará de la siguiente manera:
```
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
```

este hará un DROP para eliminar tabla por tabla, asi se podra eliminar el modelo por completo.

# Mostrar consulta 1 

esta consulta muestra el cliente que más ha comprado. Se debe de mostrar el id del cliente, nombre, apellido, país y monto total, este es realizado mediante una peticion query a la base de datos.

```
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


```
Utilizando el anterior metodo podemos realizar dicha consulta, el codigo está comentado respectivamente para explicar su funcionameiento.
```
JOIN orden ON clientes.id_cliente = orden.id_cliente
```
Esta línea realiza una operación de JOIN (unión) para combinar la tabla clientes con la tabla orden. Las tablas se unen utilizando la columna id_cliente que es común a ambas tablas.
```
JOIN detalle_orden ON orden.id_orden = detalle_orden.id_orden
```
Aquí se realiza otro JOIN para combinar la tabla orden con la tabla detalle_orden. Nuevamente, las tablas se unen utilizando la columna id_orden que es común a ambas tablas.
```
JOIN productos ON detalle_orden.id_producto = productos.id_producto
```
Esta línea realiza otro JOIN para combinar la tabla detalle_orden con la tabla productos. Las tablas se unen utilizando la columna id_producto que es común a ambas tablas.
```
JOIN paises ON clientes.id_pais = paises.id_pais
```
Aquí se realiza un último JOIN para combinar la tabla clientes con la tabla paises. Las tablas se unen utilizando la columna id_pais que es común a ambas tablas.
```
GROUP BY clientes.id_cliente, clientes.Nombre, clientes.Apellido, paises.nombre
```
En esta línea se especifica que los resultados se agrupen por las columnas id_cliente, Nombre, Apellido y nombre. Esto significa que se calcularán las sumas para cada combinación única de estos valores.
```
ORDER BY Monto_Total DESC
```
Aquí se ordenan los resultados en orden descendente según el valor de la columna Monto_Total. Esto significa que los resultados se mostrarán en orden decreciente de la suma total.

```
LIMIT 1;
```


# Mostrar consulta 2
 la consulta 2 mostrara el producto más y menos comprado. Se debe mostrar el id del producto,nombre del producto, categoría, cantidad de unidades y monto vendido.
esto en la direccion "http://127.0.0.1:5000/api/data/consulta2"
```
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
```


# Mostrar consulta 2
 la consulta 2 mostrara   a la persona que más ha vendido. Se debe mostrar el id del vendedor,nombre del vendedor, monto total vendido.

```

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

```
# Mostrar consulta 4
 Mostrara el país que más y menos ha vendido. Debe mostrar el nombre del país y elmonto. 
 
```


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


```

# Mostrar consulta 5

Mostrará el Top 5 de países que más han comprado en orden ascendente. Se le solicita mostrar el id del país, nombre y monto total. Esto en el http://127.0.0.1:5000/api/data/consulta5

```



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

```

# Mostrar consulta 6

Mostrara la categoría que más y menos se ha comprado. Debe de mostrar el nombre de la categoría y cantidad de unidades. esto en el http://127.0.0.1:5000/api/data/consulta6



```

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


```



# Mostrar consulta 7
esta consulta muestra la categoría más comprada por cada país. Se muestra el nombre del país, nombre de la categoría y cantidad de unidades, esto al realizar la peticion GET en "http://127.0.0.1:5000/api/data/consulta7".

```



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
```




