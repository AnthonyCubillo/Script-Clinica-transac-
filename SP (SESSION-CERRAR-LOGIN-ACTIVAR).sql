
/*															Creacion de Procedimientos almacenados						 */


/* SP SESION */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_ABRIR_SESION]
(
	@SESION nvarchar(max),
	@PACIENTE BIGINT,
	@ORIGEN nvarchar(max),
	
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	
	
				INSERT INTO [TB_SESION] 
					(
						[SESION],
						[PACIENTE],
						[ORIGEN],
						[FECHA_INICIO],
						[ESTADO],
						[FECHA_ACTUALIZACION]
					)
				VALUES
					(
						@SESION,
						@PACIENTE,
						@ORIGEN,
						GETUTCDATE(),
						1,
						GETUTCDATE()
					);

					set @idReturn = scope_identity();
	
					SET @IDRETURN = @idReturn
					SET @ERRORID = 0;
					SET @ERRORDESCRIPCION = '';
	
END
GO

/* SP SESION activar (paciente)*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_ACTIVAR_PACIENTE]
(
	@CORREO_PACIENTE nvarchar(max),
	@NUMERO_VERIFICACION_PACIENTE nvarchar(max),
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output,
	@FILASACTUALIZADAS int output
)
AS
BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT * FROM TB_PACIENTE WHERE [CORREO_PACIENTE] = @CORREO_PACIENTE AND [NUMERO_VERIFICACION_PACIENTE] = @NUMERO_VERIFICACION_PACIENTE AND [ESTADO_PACIENTE] = 0) --¿el correo está registrada?
		-- Si, el correo si está registrada. Devolver error.
		BEGIN
			SET @IDRETURN = -1;
			SET @ERRORID = 1; --correo ya registrada
			SET @ERRORDESCRIPCION = 'PACIENTE YA VERIFICADO O NO EXISTENTE';
		END
	ELSE
		-- No, la el correo no está registrada.
		--¡TODO BIEN! El correo no está registrados
				BEGIN
					
					UPDATE 
						[TB_PACIENTE] 
					SET
						
						[ESTADO_PACIENTE] = 1
				WHERE
					[CORREO_PACIENTE] = @CORREO_PACIENTE
					AND [NUMERO_VERIFICACION_PACIENTE] = @NUMERO_VERIFICACION_PACIENTE
					AND [ESTADO_PACIENTE] = 0


					SET @FILASACTUALIZADAS = @@ROWCOUNT
			END
		

	END TRY
	
	BEGIN CATCH
		set @idReturn = -1;
		set @errorId = ERROR_NUMBER();
		set @errorDescripcion = ERROR_MESSAGE();
		
	END CATCH
END
GO

/* SP CERRAR SESSION (paciente)*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_CERRAR_SESION]
(
	@SESION nvarchar(max)
)
AS
BEGIN

				UPDATE [TB_SESION] 
					SET
					ESTADO = 0,
					FECHA_FINAL = GETUTCDATE(),
					FECHA_ACTUALIZACION= GETUTCDATE()
				WHERE
					SESION = @SESION

END
GO




/* SP login*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LOGIN]
    @CEDULA NVARCHAR(50),
    @PASSWORD NVARCHAR(MAX),
    @TIPO INT OUTPUT,
    @ID INT OUTPUT
AS
BEGIN
    SET @TIPO = 0; -- Inicializar el tipo en cero
    SET @ID = 0; -- Inicializar el ID en cero
    
    -- Buscar en la tabla Administrador
    IF EXISTS (
        SELECT ID_ADMINISTRADOR
        FROM TB_ADMINISTRADOR
        WHERE CEDULA_ADMINISTRADOR = @CEDULA
            AND PASSWORD_ADMINISTRADOR = @PASSWORD
    )
    BEGIN
        SET @TIPO = 1; -- Tipo Administrador
        SELECT @ID = ID_ADMINISTRADOR
        FROM TB_ADMINISTRADOR
        WHERE CEDULA_ADMINISTRADOR = @CEDULA
            AND PASSWORD_ADMINISTRADOR = @PASSWORD;
        RETURN;
    END
    
    -- Buscar en la tabla Medico
    IF EXISTS (
        SELECT ID_MEDICO
        FROM TB_MEDICO
        WHERE CEDULA_MEDICO = @CEDULA
            AND PASSWORD_MEDICO = @PASSWORD
    )
    BEGIN
        SET @TIPO = 2; -- Tipo Medico
        SELECT @ID = ID_MEDICO
        FROM TB_MEDICO
        WHERE CEDULA_MEDICO = @CEDULA
            AND PASSWORD_MEDICO = @PASSWORD;
        RETURN;
    END
    
    -- Buscar en la tabla Paciente
    IF EXISTS (
        SELECT ID_PACIENTE
        FROM TB_PACIENTE
        WHERE CEDULA_PACIENTE = @CEDULA
            AND PASSWORD_PACIENTE = @PASSWORD
    )
    BEGIN
        SET @TIPO = 3; -- Tipo Paciente
        SELECT @ID = ID_PACIENTE
        FROM TB_PACIENTE
        WHERE CEDULA_PACIENTE = @CEDULA
            AND PASSWORD_PACIENTE = @PASSWORD;
        RETURN;
    END
END;
GO

