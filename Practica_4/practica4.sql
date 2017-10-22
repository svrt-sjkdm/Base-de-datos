# Primary key = unique clustered index

# Indice para relacion alumno12 en campo no_cta
CREATE INDEX index_alumno12
	ON student.basedat12.ALUMNO_12 (NO_CTA)

# Indice para relacion materia12 en campo claveM
CREATE INDEX index_materia12
	ON student.basedat12.MATERIA_12 (CLAVE_MAT)

# Indice para relacion cursa12
CREATE INDEX index_cursa12
	ON student.basedat12.CURSA_12 (NO_CTA, CLAVE_MAT)

# Cuando borre en alumno, que borre en cursa (CASCADA)
CREATE TRIGGER basedat12.tgr_borrarAlumno 
	ON basedat12.ALUMNO_12 
	FOR DELETE AS
	BEGIN
		# Borrar la tupla correspondiente al alumno en la tabla cursa
		DELETE CURSA_12 FROM CURSA_12, deleted WHERE deleted.NO_CTA = CURSA_12.NO_CTA
		DELETE ALUMNO_12 FROM ALUMNO_12, deleted WHERE deleted.NO_CTA = ALUMNO_12.NO_CTA
	END

# Ejercicio d

CREATE TRIGGER basedat12.insertaCursa
	ON basedat12.CURSA_12
	FOR INSERT AS
	IF( SELECT COUNT(*) FROM ALUMNO_12, MATERIA_12, INSERTED
		where ALUMNO_12.NO_CTA = INSERTED.NO_CTA AND MATERIA_12.CLAVE_MAT = INSERTED.CLAVE_MAT
	) != @@rowcount
	BEGIN
	ROLLBACK TRANSACTION
	print "Error: Verifica que no_cta y claveM existan previamente en alumno12 y materia12"
	END
	ELSE IF ( SELECT COUNT(*) FROM CURSA_12, INSERTED
        WHERE CURSA_12.NO_CTA = INSERTED.NO_CTA AND CURSA_12.CLAVE_MAT = INSERTED.CLAVE_MAT
        ) = 2
        BEGIN  
        ROLLBACK TRANSACTION
		print "Error: No puede haber valores duplicados de no_cta y claveM"
        END
	ELSE
		print "Tupla agregada con exito"

# Ejercicio e
CREATE TRIGGER basedat12.insertaMateria
	ON basedat12.MATERIA_12
	FOR INSERT AS
	IF( SELECT COUNT(*) FROM MATERIA_12, INSERTED
	    WHERE MATERIA_12.CLAVE_MAT = INSERTED.CLAVE_MAT) != @@rowcount
	BEGIN
	ROLLBACK TRANSACTION
	print "Error: No puede haber valores repetidos de claveM"
	END
	ELSE IF( SELECT CLAVE_MAT FROM INSERTED ) IS NULL
        BEGIN  
        ROLLBACK TRANSACTION
	print "Error: El valor de claveM no puede ser nulo"
        END
	ELSE
		print "Tupla agregada con exito"
