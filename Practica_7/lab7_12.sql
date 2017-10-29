/* 1. Conectarse a la base de datos student */
USE student 

/* 2. Crear un script de nombre lab7_12, que realice lo siguiente: */ 
/* a) Checar si la tabla titles12 existe en student, si es asi borrar la tabla titles 12 de student */
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'titles12' AND type = 'U')
BEGIN
DROP TABLE titles12
END

/* b) Crear una copia de la tabla pubs2.titles usando la sentencia select into a titles12 */
SELECT * INTO titles12 FROM pubs2.dbo.titles

/* c) Declarar una variable char(6) de nombre @title_id y asignarle el valor NULL */
DECLARE @title_id char(6)
SET @title_id = NULL
/* d) Si la variable @title_id es NULL, consultar todos los libros de la tabla titles12. 
      Incluir las siguientes columnas en la consulta: title_id, price, total_sales */
IF @title_id IS NULL 
BEGIN
	SELECT title_id, title, price, total_sales FROM titles12
END

/* e) Si la variable @titles_id no es NULL, consultar todos los libros de la tabla titles12
      que correspondan al valor de @title_id. Incluir las siguientes columnas en la consulta:
      title_id, price, total_sales */
IF @title_id IS NOT NULL 
BEGIN
	SELECT title_id, title, price, total_sales FROM titles12
	WHERE title_id = @title_id
END

/* 3. Modificar el scrip anterior para que realice ademas lo siguiente: */
/* a) Checar si existen datos para el title_id = 'MC2222' existe en la tabla titles12 */
/* b) Si el dato no existe, regresar un mensaje con un numero de error 40212 y un texto que diga
      "No existe un libro con ese identificador" */
/* c) Si el dato existe continuar obteniendo la informacion con el valor de title_id */
IF EXISTS (SELECT * FROM titles12 WHERE title_id = 'MC2222')
BEGIN
	SELECT * FROM titles12 WHERE title_id = 'MC2222'
END
ELSE
BEGIN
	RAISERROR 40212 "No existe un libro con ese identificador"
END