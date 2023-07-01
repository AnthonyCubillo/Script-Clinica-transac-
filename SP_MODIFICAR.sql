

/*													Procedimientos almacenados de MODIFICAR						 */


/*    SP_MODIFICAR_MEDICO    */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MODIFICAR_MEDICO]
(
	@ID_MEDICO INT,
	@CEDULA_MEDICO NVARCHAR(20),
	@NOMBRE_MEDICO NVARCHAR(50),
	@APELLIDO_MEDICO NVARCHAR(50),
	@PASSWORD_MEDICO NVARCHAR(MAX),
	@ID_ESPECIALIDAD INT,
	@ID_CLINICA INT,
	@ESTADO_MEDICO INT,
	@ERRORID INT OUTPUT,
	@ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM TB_ESPECIALIDAD WHERE ID_ESPECIALIDAD = @ID_ESPECIALIDAD) -- �La especialidad existe?
		BEGIN
			IF EXISTS (SELECT * FROM TB_CLINICA WHERE ID_CLINICA = @ID_CLINICA) -- �La cl�nica existe?
			BEGIN
				IF EXISTS (SELECT * FROM TB_MEDICO WHERE ID_MEDICO = @ID_MEDICO) -- �El m�dico existe?
				BEGIN
					UPDATE TB_MEDICO
					SET
						CEDULA_MEDICO = @CEDULA_MEDICO,
						NOMBRE_MEDICO = @NOMBRE_MEDICO,
						APELLIDO_MEDICO = @APELLIDO_MEDICO,
						PASSWORD_MEDICO = @PASSWORD_MEDICO,
						ID_ESPECIALIDAD = @ID_ESPECIALIDAD,
						ID_CLINICA = @ID_CLINICA,
						ESTADO_MEDICO = @ESTADO_MEDICO
					WHERE
						ID_MEDICO = @ID_MEDICO;

					SET @ERRORID = 0;
					SET @ERRORDESCRIPCION = '';
				END
				ELSE
				BEGIN
					SET @ERRORID = 3; -- M�dico no encontrado
					SET @ERRORDESCRIPCION = 'M�DICO NO ENCONTRADO';
				END
			END
			ELSE
			BEGIN
				SET @ERRORID = 4; -- Cl�nica no existente
				SET @ERRORDESCRIPCION = 'CL�NICA NO EXISTE';
			END
		END
		ELSE
		BEGIN
			SET @ERRORID = 2; -- Especialidad no existente
			SET @ERRORDESCRIPCION = 'ESPECIALIDAD NO REGISTRADA';
		END
	END TRY
	BEGIN CATCH
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();

		-- Registrar error en la tabla TB_ERROR_EN_BASE_DATOS.
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


/*    SP_MODIFICAR_PACIENTE    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MODIFICAR_PACIENTE]
(
	@ID_PACIENTE INT,
	@CEDULA_PACIENTE nvarchar(20),
	@NOMBRE_PACIENTE nvarchar(50),
	@APELLIDO_PACIENTE nvarchar(50),
	@CORREO_PACIENTE nvarchar(50),
	@PASSWORD_PACIENTE nvarchar(max),
	@ESTADO_PACIENTE INT,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM TB_PACIENTE WHERE ID_PACIENTE = @ID_PACIENTE)
		BEGIN
			UPDATE TB_PACIENTE
			SET
				CEDULA_PACIENTE = @CEDULA_PACIENTE,
				NOMBRE_PACIENTE = @NOMBRE_PACIENTE,
				APELLIDO_PACIENTE = @APELLIDO_PACIENTE,
				CORREO_PACIENTE = @CORREO_PACIENTE,
				PASSWORD_PACIENTE = @PASSWORD_PACIENTE,
				ESTADO_PACIENTE = @ESTADO_PACIENTE
			WHERE
				ID_PACIENTE = @ID_PACIENTE;
		END
		ELSE
		BEGIN
			SET @ERRORID = 3; -- PACIENTE no encontrado
			SET @ERRORDESCRIPCION = 'PACIENTE NO ENCONTRADO';
		END
	END TRY
	BEGIN CATCH
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();

		-- Registrar error en la tabla TB_ERROR_EN_BASE_DATOS.
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

/*    SP_MODIFICAR_ESPECIALIDADES    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MODIFICAR_ESPECIALIDADES]
(
	@ID_ESPECIALIDAD INT,
	@NOMBRE_ESPECIALIDAD nvarchar(50),
	@DESCRIPCION_ESPECIALIDAD nvarchar(100),
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM TB_ESPECIALIDAD WHERE ID_ESPECIALIDAD = @ID_ESPECIALIDAD)
		BEGIN
			UPDATE TB_ESPECIALIDAD
			SET
				NOMBRE_ESPECIALIDAD = @NOMBRE_ESPECIALIDAD,
				DESCRIPCION_ESPECIALIDAD = @DESCRIPCION_ESPECIALIDAD
		
			WHERE
				ID_ESPECIALIDAD = @ID_ESPECIALIDAD;
		END
		ELSE
		BEGIN
			SET @ERRORID = 3; -- ESPECIALIDAD no encontrado
			SET @ERRORDESCRIPCION = 'ESPECIALIDAD NO ENCONTRADO';
		END
	END TRY
	BEGIN CATCH
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();

		-- Registrar error en la tabla TB_ERROR_EN_BASE_DATOS.
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



/*    SP_MODIFICAR_CLINICA    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MODIFICAR_CLINICA]
(
	@ID_CLINICA INT,
	@NOMBRE_CLINICA VARCHAR(50),
	@TELEFONO_CLINICA VARCHAR(8),
	@UBICACION_CLINICA VARCHAR(50),
	@ERRORID INT OUTPUT,
	@ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM TB_CLINICA WHERE ID_CLINICA = @ID_CLINICA)
		BEGIN
			UPDATE TB_CLINICA
			SET
				NOMBRE_CLINICA = @NOMBRE_CLINICA,
				TELEFONO_CLINICA = @TELEFONO_CLINICA,
				UBICACION_CLINICA = @UBICACION_CLINICA
			WHERE
				ID_CLINICA = @ID_CLINICA;

			SET @ERRORID = 0;
			SET @ERRORDESCRIPCION = '';
		END
		ELSE
		BEGIN
			SET @ERRORID = 3; -- Cl�nica no encontrada
			SET @ERRORDESCRIPCION = 'CL�NICA NO ENCONTRADA';
		END
	END TRY
	BEGIN CATCH
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();

		-- Registrar error en la tabla TB_ERROR_EN_BASE_DATOS.
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


/*    SP_MODIFICAR_CITA    */


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MODIFICAR_CITA]
(
    @ID_CITA INT,
    @ESTADO_CITA BIT,
    @ERRORID INT OUTPUT,
    @ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM TB_CITAS WHERE ID_CITAS = @ID_CITA) -- �La cita existe?
        BEGIN
            UPDATE TB_CITAS
            SET
                ESTADO_CITAS = @ESTADO_CITA
            WHERE
                ID_CITAS = @ID_CITA;

            SET @ERRORID = 0;
            SET @ERRORDESCRIPCION = '';
        END
        ELSE
        BEGIN
            SET @ERRORID = 1; -- Cita no encontrada
            SET @ERRORDESCRIPCION = 'CITA NO ENCONTRADA';
        END
    END TRY
    BEGIN CATCH
        SET @ERRORID = ERROR_NUMBER();
        SET @ERRORDESCRIPCION = ERROR_MESSAGE();

        -- Registrar error en la tabla TB_ERROR_EN_BASE_DATOS.
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