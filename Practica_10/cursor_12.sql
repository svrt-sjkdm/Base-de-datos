if object_id('authorIndex') is null
    drop index Authors_12.authorIndex
go

create unique clustered index authorIndex 
	on Authors_12(au_id)
go

declare au_id_update cursor for
    select city, state, postalcode from Authors_12 
    for update of city, state, postalcode
go

declare @cityAu varchar(40)
declare @stateAu char(2)
declare @postalcodeAu varchar(4)

begin tran
open au_id_update

fetch au_id_update into @cityAu, @stateAu, @postalcodeAu
while (@@sqlstatus != 2)
begin
    -- Si el estado es California, modificarlo
    if (@stateAu = "CA") 
    begin                                      
    	-- Cambiar el valor de la variable CA a un valor aleatorio de la tabla Authors_12
    	select @stateAu = state from Authors_12 where state not in ("CA") order by newid()

    	-- Actualizar el valor en la tabla
    	update Authors_12
    	set state = @stateAu
    	where current of au_id_update 
        print "El estado fue actualizado"

    	-- Cambiar el valor del codigo postal a un valor aleatorio
    	select @postalcodeAu =  convert(varchar, convert(integer, round(((9999-1111-1)*rand()+1111), 0)))
    	update Authors_12 
    	set postalcode = @postalcodeAu
    	where current of au_id_update
        print "El codigo postal fue modificado"

    	-- Cambiar el valor de la ciudad, con un valor aleatorio de city
    	select @cityAu = city from Authors_12 where city != @cityAu order by newid()
    	update Authors_12
    	set city = @cityAu 
    	where current of au_id_update
        print "La ciudad fue modificada"
    end
    else 
    begin
        print "Registo no modificado"
    end
    fetch au_id_update into @cityAu, @stateAu,  @postalcodeAu
end 

if (@@sqlstatus = 1)
begin
    print "Error"
    return
end

commit tran
go

close au_id_update
go

deallocate cursor au_id_update
go