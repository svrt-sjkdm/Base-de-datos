-- Lista todos los titulos con el respectivo nombre de su editorial
SELECT title, pub_name FROM titles 
JOIN publishers ON titles.pub_id = publishers.pub_id

-- Lista todos los titulos y el nombre completo de sus autores
SELECT title, au_fname, au_lname FROM titles 
JOIN titleauthor ON titles.title_id = titleauthor.title_id
JOIN authors ON titleauthor.au_id = authors.au_id

-- Lista todos los identificadores de autor y el nombre de los libros vendidos por cada autor. 
SELECT au_id, SUM(qty) FROM titleauthor
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN salesdetail ON salesdetail.title_id = titles.title_id
GROUP BY au_id

-- Cuales editoriales han publicado libros de tipo negocio
SELECT pub_name FROM publishers WHERE pub_id IN (SELECT pub_id FROM titles WHERE type = "business")

-- Que editorial vende el libro mas caro
SELECT pub_name FROM publishers WHERE pub_id IN ( SELECT pub_id FROM titles HAVING price = MAX(price) )

-- Que libros piden un anticipo mas grande que el anticipo mas grande de los libros de la editorial Algodata Infosystems
SELECT title, advance FROM titles WHERE advance > ( 
    SELECT MAX(advance) FROM titles
    JOIN publishers ON publishers.pub_id = titles.pub_id 
    WHERE pub_name = "Algodata Infosystems");

-- Cual editorial tiene el libro mas recientemente publicado
SELECT pub_name FROM publishers WHERE pub_id IN (
	SELECT pub_id FROM titles HAVING pubdate = MAX(pubdate))