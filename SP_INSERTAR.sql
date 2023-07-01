


/*													Procedimientos almacenados de Insertar						 */



/*    SP _INGRESAR_PACIENTE    */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INGRESAR_PACIENTE]
(
	@CEDULA_PACIENTE NVARCHAR(20),
	@NOMBRE_PACIENTE NVARCHAR(50),
	@APELLIDO_PACIENTE NVARCHAR(50),
	@CORREO_PACIENTE NVARCHAR(50),
	@PASSWORD_PACIENTE NVARCHAR(MAX),
	@NUMERO_VERIFICACION_PACIENTE NVARCHAR(MAX),
	@IDRETURN INT OUTPUT,
	@ERRORID INT OUTPUT,
	@ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM TB_PACIENTE WHERE CORREO_PACIENTE = @CORREO_PACIENTE) -- ¿El correo está registrado?
		BEGIN
			-- Sí, el correo ya está registrado. Devolver error.
			SET @IDRETURN = -1;
			SET @ERRORID = 1; -- Correo ya registrado
			SET @ERRORDESCRIPCION = 'ERROR DESDE BD: CORREO YA REGISTRADO';
		END
		ELSE
		BEGIN
			-- No, el correo no está registrado.
			-- ¡Todo bien! El correo no está registrado.
			BEGIN
				INSERT INTO [TB_PACIENTE]
				(
					[CEDULA_PACIENTE],
					[NOMBRE_PACIENTE],
					[APELLIDO_PACIENTE],
					[CORREO_PACIENTE],
					[PASSWORD_PACIENTE],
					[NUMERO_VERIFICACION_PACIENTE],
					[ESTADO_PACIENTE],
					[FECHA_REGISTRO_PACIENTE]
				)
				VALUES
				(
					@CEDULA_PACIENTE,
					@NOMBRE_PACIENTE,
					@APELLIDO_PACIENTE,
					@CORREO_PACIENTE,
					@PASSWORD_PACIENTE,
					@NUMERO_VERIFICACION_PACIENTE,
					0, -- ESTADO INACTIVO
					GETUTCDATE()
				);

				SET @IDRETURN = SCOPE_IDENTITY();
			END
		END
	END TRY
	BEGIN CATCH
		SET @IDRETURN = -1;
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();

		-- Bitácora de errores en la base de datos.
		INSERT INTO TB_ERROR_EN_BASE_DATOS
		(
			[SEVERIDAD],
			[STORE_PROCEDURE],
			[NUMERO],
			[DESCRIPCION],
			[LINEA],
			[FECHA_HORA]
		)
		SELECT	ERROR_SEVERITY(),
				ERROR_PROCEDURE(),
				ERROR_NUMBER(),
				ERROR_MESSAGE(),
				ERROR_LINE(),
				GETUTCDATE();
	END CATCH
END




/*    SP _INGRESAR_MEDICO    */


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INGRESAR_MEDICO]
(
	@CEDULA_MEDICO NVARCHAR(20),
	@NOMBRE_MEDICO NVARCHAR(50),
	@APELLIDO_MEDICO NVARCHAR(50),
	@PASSWORD_MEDICO NVARCHAR(MAX),
	@ID_ESPECIALIDAD INT,
	@ID_CLINICA INT,
	@IDRETURN INT OUTPUT,
	@ERRORID INT OUTPUT,
	@ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM TB_ESPECIALIDAD WHERE ID_ESPECIALIDAD = @ID_ESPECIALIDAD) -- ¿La especialidad existe?
		BEGIN
			-- Sí, la especialidad existe. Preguntar por la clínica.
			IF EXISTS (SELECT * FROM TB_CLINICA WHERE ID_CLINICA = @ID_CLINICA) -- ¿La clínica existe?
			BEGIN
				-- Sí, la especialidad y la clínica existen. Insertar médico.
				BEGIN
					INSERT INTO [TB_MEDICO] 
					(
						[CEDULA_MEDICO],
						[NOMBRE_MEDICO],
						[APELLIDO_MEDICO],
						[PASSWORD_MEDICO],
						[ESTADO_MEDICO],
						[ID_ESPECIALIDAD],
						[ID_CLINICA]
					)
					VALUES
					(
						@CEDULA_MEDICO,
						@NOMBRE_MEDICO,
						@APELLIDO_MEDICO,
						@PASSWORD_MEDICO,
						1, -- Estado activo del médico
						@ID_ESPECIALIDAD,
						@ID_CLINICA
					);

					SET @IDRETURN = SCOPE_IDENTITY();
					SET @ERRORID = 0;
					SET @ERRORDESCRIPCION = '';
				END
			END
			ELSE
			BEGIN
				-- No, la clínica no existe. Devolver error.
				SET @IDRETURN = -1;
				SET @ERRORID = 3; -- Clínica no existe
				SET @ERRORDESCRIPCION = 'CLÍNICA NO EXISTE';
			END
		END
		ELSE
		BEGIN
			-- No, la especialidad no existe. Devolver error.
			SET @IDRETURN = -1;
			SET @ERRORID = 2; -- Especialidad no existe
			SET @ERRORDESCRIPCION = 'ESPECIALIDAD NO REGISTRADA';
		END
	END TRY
	BEGIN CATCH
		SET @IDRETURN = -1;
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();

		-- Bitácora de errores en la base de datos.
		INSERT INTO TB_ERROR_EN_BASE_DATOS
		(
			[SEVERIDAD],
			[STORE_PROCEDURE],
			[NUMERO],
			[DESCRIPCION],
			[LINEA],
			[FECHA_HORA]
		)
		SELECT	ERROR_SEVERITY(),
				ERROR_PROCEDURE(),
				ERROR_NUMBER(),
				ERROR_MESSAGE(),
				ERROR_LINE(),
				GETUTCDATE();
	END CATCH
END



/*    SP _INGRESAR_ESPECIALIDAD    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_INGRESAR_ESPECIALIDAD]
(
	@NOMBRE_ESPECIALIDAD nvarchar(50),
	@DESCRIPCION_ESPECIALIDAD nvarchar(100),
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
	IF EXISTS (SELECT * FROM TB_ESPECIALIDAD WHERE NOMBRE_ESPECIALIDAD !=@NOMBRE_ESPECIALIDAD) --¿En especialidad hay un nombre igual registrado? 
		-- Si, si no hay un nombre igual a especialdiad de los que  están registrados. Registrar especialidad.
		BEGIN
				INSERT INTO [TB_ESPECIALIDAD] 
					(
						[NOMBRE_ESPECIALIDAD],
						[DESCRIPCION_ESPECIALIDAD]
					)
				VALUES
					(
						@NOMBRE_ESPECIALIDAD,
						@DESCRIPCION_ESPECIALIDAD
					);

					set @idReturn = scope_identity();
		END
	ELSE
		-- ESPECIALIDAD YA REGISTRADA
		--¡
				BEGIN
					SET @IDRETURN = -1;
					SET @ERRORID = 2; --ESPECIALIDAD YA REGISTRADA
					SET @ERRORDESCRIPCION = 'ESPECIALIDAD YA REGISTRADA';
	
				END
	END TRY
	
	BEGIN CATCH
		set @idReturn = -1;
		set @errorId = ERROR_NUMBER();
		set @errorDescripcion = ERROR_MESSAGE();

		
		--Bitacorear error en BD.
		INSERT INTO TB_ERROR_EN_BASE_DATOS 
			(
				[SEVERIDAD],
				[STORE_PROCEDURE],
				[NUMERO],
				[DESCRIPCION],
				[LINEA],
				[FECHA_HORA]
			) 

			select ERROR_SEVERITY(),
					ERROR_PROCEDURE(),
					ERROR_NUMBER(),
					ERROR_MESSAGE(),
					ERROR_LINE(),
					GETUTCDATE()
		
	END CATCH
END


/*    SP_INGRESAR_HISTORICO    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INGRESAR_HISTORICO]
(
    @ID_MEDICO INT,
    @ID_CITAS INT,
    @IDRETURN INT OUTPUT,
    @ERRORID INT OUTPUT,
    @ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        
        -- Verificar si el médico existe
        IF NOT EXISTS (SELECT * FROM TB_MEDICO WHERE ID_MEDICO = @ID_MEDICO)
        BEGIN
            SET @IDRETURN = -1;
            SET @ERRORID = 3; -- El médico no existe
            SET @ERRORDESCRIPCION = 'ERROR DESDE BD: MEDICO NO EXISTE';
        END
        -- Verificar si la cita existe
        ELSE IF NOT EXISTS (SELECT * FROM TB_CITAS WHERE ID_CITAS = @ID_CITAS)
        BEGIN
            SET @IDRETURN = -1;
            SET @ERRORID = 4; -- La cita no existe
            SET @ERRORDESCRIPCION = 'ERROR DESDE BD: CITA NO EXISTE';
        END
        ELSE
        BEGIN
            -- Insertar el registro en TB_HISTORICO
            INSERT INTO TB_HISTORICO
            (
                ID_MEDICO,
                ID_CITAS
            )
            VALUES
            (
                @ID_MEDICO,
                @ID_CITAS
            );

            SET @IDRETURN = SCOPE_IDENTITY();
            SET @ERRORID = 0;
            SET @ERRORDESCRIPCION = '';
        END
    END TRY
    
    BEGIN CATCH
        SET @IDRETURN = -1;
        SET @ERRORID = ERROR_NUMBER();
        SET @ERRORDESCRIPCION = ERROR_MESSAGE();

        -- Bitacorear error en la tabla TB_ERROR_EN_BASE_DATOS
        INSERT INTO TB_ERROR_EN_BASE_DATOS
        (
            [SEVERIDAD],
            [STORE_PROCEDURE],
            [NUMERO],
            [DESCRIPCION],
            [LINEA],
            [FECHA_HORA]
        ) 
        SELECT
            ERROR_SEVERITY(),
            ERROR_PROCEDURE(),
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_LINE(),
            GETUTCDATE();
    END CATCH
END


/*    SP_INGRESAR_CITA    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INGRESAR_CITA]
(
    @FECHA_CITAS DATE,
    @HORA_INICIO_CITAS TIME,
    @HORA_FIN_CITAS TIME,
    @MOTIVO_CITAS NVARCHAR(100),
    @ID_PACIENTE INT,
    @ID_CLINICA INT,
    @IDRETURN INT OUTPUT,
    @ERRORID INT OUTPUT,
    @ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        DECLARE @CANTIDAD_CITAS INT;
        DECLARE @HORA_INICIO_LIMITE TIME = '08:00:00';
        DECLARE @HORA_FIN_LIMITE TIME = '17:00:00';

        IF EXISTS (SELECT * FROM TB_PACIENTE WHERE ID_PACIENTE = @ID_PACIENTE)
        BEGIN
            IF EXISTS (SELECT * FROM TB_CLINICA WHERE ID_CLINICA = @ID_CLINICA)
            BEGIN
                IF (@HORA_INICIO_CITAS >= @HORA_INICIO_LIMITE AND @HORA_FIN_CITAS <= @HORA_FIN_LIMITE)
                BEGIN
                    -- Validar si las horas son completas
                    DECLARE @HORA_INICIO_COMPLETA TIME = DATEADD(MINUTE, -DATEPART(MINUTE, @HORA_INICIO_CITAS), @HORA_INICIO_CITAS);
                    DECLARE @HORA_FIN_COMPLETA TIME = DATEADD(MINUTE, -DATEPART(MINUTE, @HORA_FIN_CITAS), @HORA_FIN_CITAS);
                    
                    IF @HORA_INICIO_CITAS = @HORA_INICIO_COMPLETA AND @HORA_FIN_CITAS = @HORA_FIN_COMPLETA
                    BEGIN
                        SELECT @CANTIDAD_CITAS = COUNT(*)
                        FROM TB_CITAS
                        WHERE CONVERT(DATE, FECHA_CITAS) = @FECHA_CITAS
                            AND ID_CLINICA = @ID_CLINICA
                            AND ((HORA_INICIO_CITAS >= @HORA_INICIO_CITAS AND HORA_INICIO_CITAS < @HORA_FIN_CITAS)
                                OR (HORA_FIN_CITAS > @HORA_INICIO_CITAS AND HORA_FIN_CITAS <= @HORA_FIN_CITAS)
                                OR (HORA_INICIO_CITAS <= @HORA_INICIO_CITAS AND HORA_FIN_CITAS >= @HORA_FIN_CITAS));

                        IF @CANTIDAD_CITAS = 0
                        BEGIN
                            INSERT INTO [TB_CITAS] 
                            (
                                [FECHA_CITAS],
                                [HORA_INICIO_CITAS],
                                [HORA_FIN_CITAS],
                                [MOTIVO_CITAS],
                                [ID_PACIENTE],
                                [ID_CLINICA]
                            )
                            VALUES
                            (
                                @FECHA_CITAS,
                                @HORA_INICIO_CITAS,
                                @HORA_FIN_CITAS,
                                @MOTIVO_CITAS,
                                @ID_PACIENTE,
                                @ID_CLINICA
                            );

                            SET @IDRETURN = SCOPE_IDENTITY();
                            SET @ERRORID = 0;
                            SET @ERRORDESCRIPCION = '';
                        END
                        ELSE
                        BEGIN
                            SET @IDRETURN = -1;
                            SET @ERRORID = 4; -- Error de citas superpuestas
                            SET @ERRORDESCRIPCION = 'Ya hay una cita en el mismo horario.';
                        END
                    END
                    ELSE
                    BEGIN
                        SET @IDRETURN = -1;
                        SET @ERRORID = 5; -- Error de horas no completas
                        SET @ERRORDESCRIPCION = 'El horario de la cita debe ser en horas completas.';
                    END
                END
                ELSE
                BEGIN
                    SET @IDRETURN = -1;
                    SET @ERRORID = 3; -- Error de horario no válido
                    SET @ERRORDESCRIPCION = 'El horario seleccionado debe estar entre las 8 AM y las 5 PM.';
                END
            END
            ELSE
            BEGIN
                SET @IDRETURN = -1;
                SET @ERRORID = 2; -- Error de clínica no existente
                SET @ERRORDESCRIPCION = 'La clínica seleccionada no existe.';
            END
        END
        ELSE
        BEGIN
            SET @IDRETURN = -1;
            SET @ERRORID = 1; -- Error de paciente no existente
            SET @ERRORDESCRIPCION = 'El paciente seleccionado no existe.';
        END
    END TRY
    
    BEGIN CATCH
        SET @IDRETURN = -1;
        SET @ERRORID = ERROR_NUMBER();
        SET @ERRORDESCRIPCION = ERROR_MESSAGE();

       -- Bitacorear error en la tabla TB_ERROR_EN_BASE_DATOS
        INSERT INTO TB_ERROR_EN_BASE_DATOS
        (
            [SEVERIDAD],
            [STORE_PROCEDURE],
            [NUMERO],
            [DESCRIPCION],
            [LINEA],
            [FECHA_HORA]
        ) 
        SELECT
            ERROR_SEVERITY(),
            ERROR_PROCEDURE(),
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_LINE(),
            GETUTCDATE();
    END CATCH
END



/*    SP_INGRESAR_CLINICA    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INGRESAR_CLINICA]
(
    @NOMBRE_CLINICA VARCHAR(50),
    @TELEFONO_CLINICA VARCHAR(8),
    @UBICACION_CLINICA VARCHAR(50),
    @IDRETURN INT OUTPUT,
    @ERRORID INT OUTPUT,
    @ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        INSERT INTO TB_CLINICA (NOMBRE_CLINICA, TELEFONO_CLINICA, UBICACION_CLINICA)
        VALUES (@NOMBRE_CLINICA, @TELEFONO_CLINICA, @UBICACION_CLINICA);

        SET @IDRETURN = SCOPE_IDENTITY();
        SET @ERRORID = 0;
        SET @ERRORDESCRIPCION = '';
    END TRY
    
    BEGIN CATCH
        SET @IDRETURN = -1;
        SET @ERRORID = ERROR_NUMBER();
        SET @ERRORDESCRIPCION = ERROR_MESSAGE();

        -- Insertar error en la tabla TB_ERROR_EN_BASE_DATOS
        INSERT INTO TB_ERROR_EN_BASE_DATOS 
		(
				[SEVERIDAD],
				[STORE_PROCEDURE],
				[NUMERO],
				[DESCRIPCION],
				[LINEA],
				[FECHA_HORA]
		)
        SELECT	ERROR_SEVERITY(),
				ERROR_PROCEDURE(),
				ERROR_NUMBER(),
				ERROR_MESSAGE(),
				ERROR_LINE(),
				GETUTCDATE();
    END CATCH
END
