-- 2. Cree un indice unico usando la columna que le corresponde a su llave primaria
drop index AAAuthors12.authorIndex 
create unique clustered index authorIndex 
	on AAAuthors12(au_id)
go
-- 3. Escriba un script con el nombre cursor_12
-- a. Crear un cursor para actualizacion llamado au_id_update sobre la tabla correspondiente para procesar hasta tres
-- columnas de la tabla de su preferencia que no sean llave primaria.
declare au_id_update_1 cursor for 
    select city, state, postalcode from AAAuthors12 
    for update of city, state, postalcode 
go
-- b. Declarar las variables que se requieran para leer y actualizar los datos
declare @cityAu varchar(40)
declare @stateAu char(2)
declare @postalcodeAu varchar(4)
go
-- c. Iniciar una transaccion
begin tran

-- d.Por cada registro leerlo y decidir si aplica modificar algun dato, segun sea el caso que ustedes decidan.
open au_id_update_1
go
fetch au_id_update_1 into @cityAu, @stateAu, @postalcodeAu
go

while (@@sqlstatus != 2)
begin

    -- Si el estado es California, modificarlo
    if (@stateAu = "CA") 
    begin                                      
    	-- Cambiar el valor de la variable CA a un valor aleatorio de la tabla Authors_12
    	select @stateAu = state from AAAuthors12 where state not in ("CA") order by newid()
    	-- Actualizar el valor en la tabla
    	update AAAuthors12
    	set state = @stateAu
    	where current of au_id_update_1 
        print "El estado fue actualizado"
    	-- Cambiar el valor del codigo postal a un valor aleatorio
    	select @postalcodeAu = convert(varchar, convert(integer, rand()*10000))
    	update AAAuthors12
    	set postalcode = @postalcodeAu
    	where current of au_id_update_1
        print "El codigo postal fue modificado"
    	-- Cambiar el valor de la ciudad, con un valor aleatorio de city
    	--select @cityAu = select top 1 city from AAAuthors12 where city != @cityAu order by newid()
        select @cityAu = city from AAAuthors12 where city != @cityAu order by newid()
    	update AAAuthors12
    	set city = @cityAu 
    	where current of au_id_update_1
        print "La ciudad fue modificada"
    end
    else 
        print "Registro no modificado"
    go
    fetch au_id_update_1 into @cityAu, @stateAu, @postalcodeAu
    go
end 

-- e. Cheque cualquier posibilidad de error y mande mensaje segun corresponda.
if (@@sqlstatus = 1)
begin
    print "Error"
    return
end

-- f. Si todo se ejecuta como es debido termine la transaccion exitosamente.
commit tran
go
-- g. Cierre el cursor
close au_id_update_1
go
-- h. Desaloje el cursor de memoria
deallocate cursor au_id_update_1
go
-- 4. Compruebe la ejecucion correcta del script