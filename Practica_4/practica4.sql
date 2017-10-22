# sp_helpconstraint <nombre_tabla>
# sp_helpindex <nombre_tabla>
alter table CURSA_12 drop constraint fk_cursa12
alter table CURSA_12 drop constraint pk_cursa12
alter table ALUMNO_12 drop constraint pk_alumno12
alter table MATERIA_12 drop constraint pk_materia12
go

# Primary key = unique clustered index

# Indice para relacion alumno12 en campo no_cta
create index index_alumno12
	on student.basedat12.ALUMNO_12 (NO_CTA)

# Indice para relacion materia12 en campo claveM
create index index_materia12
	on student.basedat12.MATERIA_12 (CLAVE_MAT)

# Indice para relacion cursa12
create index index_cursa12
	on student.basedat12.CURSA_12 (NO_CTA, CLAVE_MAT)

# Cuando borre en alumno, que borre en cursa (CASCADA)
create trigger basedat12.tgr_borrarAlumno 
	on basedat12.ALUMNO_12 
	for delete as 
	begin
		# Borrar la tupla correspondiente al alumno en la tabla cursa
		delete CURSA_12 from CURSA_12, deleted where deleted.NO_CTA = CURSA_12.NO_CTA
		delete ALUMNO_12 from ALUMNO_12, deleted where deleted.NO_CTA = ALUMNO_12.NO_CTA
	end

# Ejercicio d

create trigger basedat12.insertaCursa
	on basedat12.CURSA_12
	for insert as
	if( select count(*) from ALUMNO_12, MATERIA_12, inserted
		where ALUMNO_12.NO_CTA = inserted.NO_CTA and MATERIA_12.CLAVE_MAT = inserted.CLAVE_MAT
	) != @@rowcount
	begin
	rollback transaction
	print "Error: Verifica que no_cta y claveM existan previamente en alumno12 y materia12"
	end
	else if ( select count(*) from CURSA_12, inserted 
        where CURSA_12.NO_CTA = inserted.NO_CTA and CURSA_12.CLAVE_MAT = inserted.CLAVE_MAT
        ) = 2
        begin   
        rollback transaction
		print "Error: No puede haber valores duplicados de no_cta y claveM"
        end
	else 
		print "Tupla agregada con exito"

# Ejercicio e
create trigger basedat12.insertaMateria
	on basedat12.MATERIA_12
	for insert as
	if( select count(*) from MATERIA_12, inserted
		where MATERIA_12.CLAVE_MAT = inserted.CLAVE_MAT) != @@rowcount
	begin
	rollback transaction
	print "Error: No puede haber valores repetidos de claveM"
	end
	else if( select CLAVE_MAT from inserted ) is NULL
	begin
	rollback transaction
	print "Error: El valor de claveM no puede ser nulo"
	end
	else
		print "Tupla agregada con exito"