-- 2. Cree un indice unico usando la columna que le corresponde a su llave primaria
create unique clustered index authorIndex 
	on Authors_12(au_id)
go
-- 3. Escriba un script con el nombre cursor_12
-- a. Crear un cursor para actualizacion llamado au_id_update sobre la tabla correspondiente para procesar hasta tres
-- columnas de la tabla de su preferencia que no sean llave primaria.
declare au_id_update cursor 
for select city, state, country from Authors_12 
for update of city, state, country 
go
-- b. Declarar las variables que se requieran para leer y actualizar los datos
declare @cityAu varchar(40)
declare @stateAu char(2)
declare @postalcodeAu 
go
-- c. Iniciar una transaccion
begin tran

-- d.Por cada registro leerlo y decidir si aplica modificar algun dato, segun sea el caso que ustedes decidan.
open au_id_update
fetch au_id_update into @cityAu, @stateAu, @countryAu

while (@@sqlstatus != 2)
begin

    if (@@sqlstatus = 1)
    begin
        print "Error"
        return
    end
    -- Si el estado es California, modificarlo
    if (@stateAu == "CA") 
    begin                                      
    	-- Cambiar el valor de la variable CA a un valor aleatorio de la tabla Authors_12
    	set @stateAu = select top 1 state from Authors_12 where state not in ("CA") order by newid()
    	-- Actualizar el valor en la tabla
    	update Authors_12
    	set state = @stateAu
    	where current of au_id_update 
    	-- Cambiar el valor del codigo postal a un valor aleatorio
    	set @postalcodeAu = select convert(integer, rand()*10000)
    	update Authors_12 
    	set postalcode = @postalcodeAu
    	where current of au_id_update
    	-- Cambiar el valor de la ciudad, con un valor aleatorio de city
    	set @cityAu = select top 1 city from Authors_12 where city != @cityAu order by newid()
    	update Authors_12
    	set city = @cityAu 
    	where current of au_id_update
    end

end 

-- e. Cheque cualquier posibilidad de error y mande mensaje segun corresponda.

-- f. Si todo se ejecuta como es debido termine la transaccion exitosamente.
commit tran
go
-- g. Cierre el cursor
close au_id_update
go
-- h. Desaloje el cursor de memoria
deallocate cursor au_id_update
go
-- 4. Compruebe la ejecucion correcta del script.