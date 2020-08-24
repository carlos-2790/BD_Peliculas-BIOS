USE master;
GO

IF exists(SELECT * FROM sysDataBases WHERE name='Obligatorio')
BEGIN
	DROP DATABASE Obligatorio 
END
GO

CREATE DATABASE Obligatorio
ON
(
NAME = Obligatorio,
FILENAME = 'C:\Obligatorio.mdf'
)
GO

USE Obligatorio
GO

SET NOCOUNT ON

CREATE TABLE Clientes
(
Nombre VARCHAR(20) not null,
Apellido VARCHAR(20) not null,
Direccion VARCHAR(50),
Telefono VARCHAR(20),
Cedula VARCHAR(10) PRIMARY KEY
)

CREATE TABLE ClientesRegistrados
(
Cedula VARCHAR(10) FOREIGN KEY REFERENCES Clientes(Cedula),
TarjCred VARCHAR(12) UNIQUE not null
)

CREATE TABLE ClientesEvaluacion
(
Cedula VARCHAR(10) FOREIGN KEY REFERENCES Clientes(Cedula),
FechCaducidad DATETIME not null
)

CREATE TABLE Peliculas
(
Titulo VARCHAR(50) not null,
Genero VARCHAR(20),
FechadEstreno DATETIME,
Pais VARCHAR(20),
Precio INT not null,
IdPelicula INT IDENTITY (1,1) PRIMARY KEY
)

CREATE TABLE Alquileres
(
IdAlquiler INT IDENTITY (1,1) PRIMARY KEY,
Cedula VARCHAR(10) FOREIGN KEY REFERENCES Clientes(Cedula),
IdPelicula INT FOREIGN KEY REFERENCES Peliculas(IdPelicula),
CostoTotal INT not null,
FechaAlquiler DATETIME not null,
FechaFin DATETIME not null
)

--                           * * * CLIENTES * * *

INSERT Clientes VALUES ('JulitoElUno', 'Pippa', 'Arkano y Bios', '1229', '111') 
INSERT Clientes VALUES ('Carlitos', 'Yaben', 'Pablo De Maria 3030', '9658', '222')
INSERT Clientes VALUES ('Gabole', 'Jorgito', 'Silicon Valley', '8893', '333')
INSERT Clientes VALUES ('Tonga', 'Reino', 'Cuadrilatero 789', '8849', '444')
INSERT Clientes VALUES ('Tinki', 'Winki', 'Tubipapia 1002', '1108', '555')
INSERT Clientes VALUES ('Dipsy', 'Lala', 'Saltadilla 7821', '9874', '666')
INSERT Clientes VALUES ('José María', 'Listortti', 'Jugoloco 2254', '4711', '777')
INSERT Clientes VALUES ('Tony', 'Montana', 'Sicilia 1515', '8874', '888')
INSERT Clientes VALUES ('Jack', 'Sparrow', 'Ñeristown 1038', '4852', '999')
INSERT Clientes VALUES ('Tony', 'Pacheco', 'Propios 124', '2147', '1010')
INSERT Clientes VALUES ('Tony', 'Presidio', 'Ruta 8 km 28', '3681', '1111')
INSERT Clientes VALUES ('Recoba', 'Pechofrio', 'Chicken 1038', '5574', '1212')
INSERT Clientes VALUES ('Laprofe', 'Deallado', 'Lupite 3037', '4887', '1313')
INSERT Clientes VALUES ('Rosita', 'Perez', 'Yaguaron 1515', '1711', '1414')
INSERT Clientes VALUES ('Mongo', 'Lopez', 'Paysandu 1212', '3363', '1515')
INSERT Clientes VALUES ('Luis', 'Suarez', 'El Pistolero 9', '4722', '1616')

--     * * * CLIENTES REGISTRADOS * * *

INSERT ClientesRegistrados VALUES('111', '11') 
INSERT ClientesRegistrados VALUES('222', '22')
INSERT ClientesRegistrados VALUES('333', '33')
INSERT ClientesRegistrados VALUES('444', '44')
INSERT ClientesRegistrados VALUES('555', '55')
INSERT ClientesRegistrados VALUES('666', '66')
INSERT ClientesRegistrados VALUES('777', '77')
INSERT ClientesRegistrados VALUES('888', '88')

--     * * * CLIENTES EVALUACIÓN * * *

INSERT ClientesEvaluacion VALUES('999', '31/08/2016') 
INSERT ClientesEvaluacion VALUES('1010', '11/11/2016')
INSERT ClientesEvaluacion VALUES('1111', '30/04/2014')
INSERT ClientesEvaluacion VALUES('1212', '04/01/2018')
INSERT ClientesEvaluacion VALUES('1313', '22/07/2015')
INSERT ClientesEvaluacion VALUES('1414', '14/06/2016')
INSERT ClientesEvaluacion VALUES('1515', '01/01/1900')
INSERT ClientesEvaluacion VALUES('1616', '07/05/2015')

--        * * * PELÍCULAS * * *

INSERT Peliculas VALUES('Que Paso Ayer 2','Comedia','25/12/2015','Estados Unidos', 10)	 --1
INSERT Peliculas VALUES('Lets be cops','Comedia','25/11/2015','Estados Unidos', 10)		 --2
INSERT Peliculas VALUES('Tarzan','Romantica','25/09/2015','Argentina',10)				 --3
INSERT Peliculas VALUES('Big Hero','Animada','26/08/2016','Estados Unidos', 10)			 --4
INSERT Peliculas VALUES('Que Paso Ayer 3','Comedia','20/11/2015','Estados Unidos', 10)	 --5
INSERT Peliculas VALUES('Cantinflas','Comedia clásica','25/09/2015','Uruguay', 10)		 --6
INSERT Peliculas VALUES('Ted 2','Comedia','22/12/2015','Mexico', 10)					 --7
INSERT Peliculas VALUES('Un Amor en tiempos de selfie','Drama','25/01/2016','Espana', 10)--8
INSERT Peliculas VALUES('Manya Campeon del Siglo','Documental','23/02/2014','Uruguay',10)--9

--        * * * ALQUILERES * * *

INSERT Alquileres VALUES('333', 8, 60, '22/02/2014', '28/02/2014')
INSERT Alquileres VALUES('444', 5, 10, '22/02/2014', '23/02/2014')
INSERT Alquileres VALUES('555', 9, 20, '25/05/2015', '27/05/2015')
INSERT Alquileres VALUES('666', 7, 50, '01/01/2014', '06/01/2014')
INSERT Alquileres VALUES('777', 9, 10, '08/08/2014', '09/08/2014')
INSERT Alquileres VALUES('888', 1, 20, '01/11/2015', '03/11/2015')
INSERT Alquileres VALUES('1111', 6, 0, '02/11/2015', '05/11/2015')
INSERT Alquileres VALUES('1616', 4, 0, '01/07/2015', '08/07/2015')



                        ---- *** TOTAL PELICULA POR PERIODO *** ----
GO
CREATE PROCEDURE TOTAL_PELICULA_POR_PERIODO 
--ALTER PROCEDURE TOTAL_PELICULA_POR_PERIODO
@fechaAlquiler DATETIME,
@fechaFin DATETIME
AS 
BEGIN
	SELECT Titulo, SUM(A.CostoTotal) as Ganancia
	FROM Peliculas P inner join Alquileres A ON P.IdPelicula = A.IdPelicula
	WHERE A.FechaAlquiler BETWEEN @fechaAlquiler and @fechaFin 
	GROUP BY Titulo 
	ORDER BY Ganancia DESC
END

--EXECUTE Total_Pelicula_Por_Periodo '01/01/1753', '09/09/9999'



--               ---- *** STREAM MAS RENTABLE *** ----

GO
CREATE PROCEDURE [STREAM MAS RENTABLE]
--ALTER PROCEDURE [STREAM MAS RENTABLE]
AS 
BEGIN
	SELECT TOP 1 P.Titulo, P.IdPelicula, SUM(CostoTotal) as Ganancia 
	FROM Alquileres A inner join Peliculas P ON a.IdPelicula = p.IdPelicula
	GROUP BY P.Titulo, P.IdPelicula 
	ORDER BY Ganancia DESC
END

--EXEC [STREAM MAS RENTABLE]

             ----- *** ELIMINAR UNA PELÍCULA *** -----
 
 GO
 CREATE PROC EliminarPelicula
 --Alter proc EliminarPelicula
 @IdPelicula INT
 AS
 BEGIN
	DECLARE @errores INT
	IF not exists (SELECT * FROM Peliculas WHERE IdPelicula = @IdPelicula)
		RETURN -1
	BEGIN TRANSACTION
	IF exists(SELECT * FROM Alquileres WHERE IdPelicula=@IdPelicula)
	BEGIN
		DELETE Alquileres WHERE IdPelicula =@IdPelicula
		SET @errores = @@error
		DELETE Peliculas WHERE IdPelicula = @IdPelicula
		SET @errores = @errores + @@error
		IF (@errores = 0)
		BEGIN
			COMMIT TRAN
			RETURN 1
		END
		ELSE
		BEGIN
			ROLLBACK TRAN
			RETURN -404
		END
	END
	IF exists(SELECT * FROM Alquileres WHERE IdPelicula=@IdPelicula)
		RETURN -2
END

/*
RETORNA 1 Se EIMINÓ correctamente

DECLARE @resp INT
EXEC @resp = EliminarPelicula '5'
PRINT @resp
-------------------------------------
RETORNA -1 La PELÍCULA NO EXISTE
  
DECLARE @resp INT
EXEC @resp = EliminarPelicula '900'
PRINT @resp
------------------------------------- 
ATENCIÓN!!! NUNCA LLEGARÍA A RETORNAR -2, YA QUE SI LA PELICULA ESTÁ ALQUILADA SE ELIMINA EL ALQUILER.
*/


 --         -- *** REGISTRAR UN CLIENTE DE EVALUACIÓN *** --
 
GO
CREATE PROCEDURE RegistrarEvaluacion
--ALTER PROCEDURE RegistrarEvaluacion
@Cedula VARCHAR(10),
@TarjetaCredito VARCHAR(12)
AS																					
BEGIN
	DECLARE @errores INT
	SET @errores = 0
	IF not exists (SELECT * FROM Clientes WHERE Cedula = @Cedula)
		RETURN -1
	IF exists (SELECT * FROM ClientesRegistrados WHERE Cedula = @Cedula)
		RETURN -2
	IF (exists(SELECT*FROM ClientesEvaluacion WHERE Cedula = @Cedula and FechCaducidad > GETDATE()))
	RETURN -3 
	IF EXISTS (SELECT*FROM ClientesRegistrados WHERE TarjCred =@TarjetaCredito )
	RETURN -4
	
	BEGIN TRANSACTION
	DELETE FROM ClientesEvaluacion 
	WHERE Cedula = @Cedula
	SET @errores = @@error
	IF (@errores = 0)
	BEGIN
		INSERT INTO ClientesRegistrados VALUES(@Cedula, @TarjetaCredito)
	END
	SET @errores = @errores + @@ERROR
	IF (@errores = 0)
		BEGIN
			COMMIT TRANSACTION
			RETURN 1
		END
		ELSE
		BEGIN
			ROLLBACK TRAN
			RETURN -404
		END
END		

/*
RETORNA 1 Registro EXITOSO

DECLARE @resp INT
EXEC @resp = RegistrarEvaluacion '1111', '753'
PRINT @resp
------------------------------------------------------
RETORNA -1 La Cédula NO pertenece a ningun cliente

DECLARE @resp INT
EXEC @resp = RegistrarEvaluacion '789456123', '369'
PRINT @resp
------------------------------------------------------
RETORNA -2 EL Cliente YA ES Registrado

DECLARE @resp INT
EXEC @resp = RegistrarEvaluacion '111', '159'
PRINT @resp
------------------------------------------------------
RETORNA -3 El Cliente todavía está en su período de Evaluación

DECLARE @resp INT
EXEC @resp = RegistrarEvaluacion '1010', '858'
PRINT @resp
------------------------------------------------------
RETORNA -4 Tarjeta de Crédito YA registrada

DECLARE @resp INT
EXEC @resp = RegistrarEvaluacion '1313', '11'
PRINT @resp
------------------------------------------------------
*/


--          ---- *** AGREGAR ALQUILER *** ----

GO
CREATE PROCEDURE AgregarAlquiler
--ALTER PROCEDURE AgregarAlquiler
@Cedula INT, 
@IdPelicula INT, 
@fechaInicio DATETIME,
@fechaFin DATETIME
AS
BEGIN
	declare @CostoTotal INT
	IF not exists (SELECT * FROM Clientes WHERE Cedula = @Cedula)
		RETURN -1
	ELSE IF not exists (SELECT * FROM Peliculas WHERE IdPelicula = @IdPelicula) 
		RETURN -2
	ELSE IF (@fechaInicio > @fechaFin)
		RETURN -3
	IF exists (SELECT * FROM ClientesRegistrados WHERE Cedula = @Cedula)
	BEGIN
		SELECT @CostoTotal = Precio *(DATEDIFF (DAY, @fechaInicio, @fechaFin ))
		FROM Peliculas
		INSERT Alquileres VALUES(@Cedula, @IdPelicula, @CostoTotal, @fechaInicio, @fechaFin)
		RETURN 1
	END
	IF exists (SELECT * FROM ClientesEvaluacion WHERE Cedula = @Cedula)
	BEGIN	
		INSERT Alquileres VALUES(@Cedula, @IdPelicula, 0, @fechaInicio, @fechaFin)
		RETURN 1
	END
END

exec [STREAM MAS RENTABLE]
/*
RETORNA 1 Alquiler Agregado

------------------ALQUILER DE CLIENTE REGISTRADO-----------------
DECLARE @resp INT
EXEC @resp = AgregarAlquiler '222', 3, '01/01/2015', '02/01/2015'
PRINT @resp

------ALQUILER DE CLIENTE DE EVALUACIÓN, GENERA GANANCIA 0-------
DECLARE @resp INT
EXEC @resp = AgregarAlquiler '1212', 2, '02/02/2015', '03/02/2015'
PRINT @resp
-----------------------------------------------------------------
RETORNA -1 Cédula inexistente en el sistema

DECLARE @resp INT
EXEC @resp = AgregarAlquiler '789456123', 6, '01/01/2015', '02/01/2015'
PRINT @resp
-----------------------------------------------------------------
RETORNA -2 Id de Película inexistente

DECLARE @resp INT
EXEC @resp = AgregarAlquiler '777', 999999, '01/01/2015', '02/01/2015'
PRINT @resp
-----------------------------------------------------------------
RETORNA -3 Fecha de alquiler es posterior a la fecha de finalización

DECLARE @resp INT
EXEC @resp = AgregarAlquiler '444', 3, '06/08/2015', '02/08/2015'
PRINT @resp
*/
