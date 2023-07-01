
/*													Procedimientos almacenados de ELIMINAR						 */

/*    SP_ELMINAR_MEDICO    */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_ELIMINAR_MEDICO]
(
	@ID_MEDICO int,
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM TB_MEDICO WHERE ID_MEDICO = @ID_MEDICO) -- �Existe el MEDICO?
		BEGIN
			SET @IDRETURN = -1;
			SET @ERRORID = 1; -- MEDICO ya eliminado
			SET @ERRORDESCRIPCION = 'ERROR DESDE BD: MEDICO NO EXISTE';
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION;

			-- Eliminar el registro del m�dico en TB_HISTORICO
			DELETE FROM TB_HISTORICO WHERE ID_MEDICO = @ID_MEDICO;

			-- Eliminar el m�dico
			DELETE FROM TB_MEDICO WHERE ID_MEDICO = @ID_MEDICO;

			COMMIT TRANSACTION;
			SET @IDRETURN = 1;
		END
	END TRY
	
	BEGIN CATCH
		SET @IDRETURN = -1;
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();
		
		ROLLBACK TRANSACTION;
	END CATCH
END

/*    SP_ELMINAR_PACIENTE    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_ELIMINAR_PACIENTE]
(
	@ID_PACIENTE int,
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM TB_PACIENTE WHERE ID_PACIENTE = @ID_PACIENTE)
		BEGIN
			SET @IDRETURN = -1;
			SET @ERRORID = 1; -- PACIENTE ya eliminado
			SET @ERRORDESCRIPCION = 'ERROR DESDE BD: PACIENTE NO EXISTE';
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION;

			-- Eliminar registros de citas asociados al paciente
			DELETE FROM TB_CITAS WHERE ID_PACIENTE = @ID_PACIENTE;
			-- Eliminar el paciente
			DELETE FROM TB_PACIENTE WHERE ID_PACIENTE = @ID_PACIENTE;

			COMMIT TRANSACTION;
			SET @IDRETURN = 1;
		END
	END TRY
	
	BEGIN CATCH
		SET @IDRETURN = -1;
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();
		
		ROLLBACK TRANSACTION;
	END CATCH
END


/*    SP_ELMINAR_ESPECIALIDAD    */


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_ELIMINAR_ESPECIALIDAD]
(
	@ID_ESPECIALIDAD int,
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM TB_ESPECIALIDAD WHERE ID_ESPECIALIDAD = @ID_ESPECIALIDAD)
		BEGIN
			SET @IDRETURN = -1;
			SET @ERRORID = 1; -- ESPECIALIDAD ya eliminado
			SET @ERRORDESCRIPCION = 'ERROR DESDE BD: ESPECIALIDAD NO EXISTE';
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION;

			-- Eliminar los m�dicos asociados a la especialidad
			DELETE FROM TB_MEDICO WHERE ID_ESPECIALIDAD = @ID_ESPECIALIDAD;

			-- Eliminar la especialidad
			DELETE FROM TB_ESPECIALIDAD WHERE ID_ESPECIALIDAD = @ID_ESPECIALIDAD;

			COMMIT TRANSACTION;
			SET @IDRETURN = 1;
		END
	END TRY
	
	BEGIN CATCH
		SET @IDRETURN = -1;
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();
		
		ROLLBACK TRANSACTION;
	END CATCH
END

/*    SP_ELMINAR_CLINICA    */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ELIMINAR_CLINICA]
(
    @ID_CLINICA INT,
    @IDRETURN INT OUTPUT,
    @ERRORID INT OUTPUT,
    @ERRORDESCRIPCION NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        -- Verificar si la cl�nica existe
        IF NOT EXISTS (SELECT * FROM TB_CLINICA WHERE ID_CLINICA = @ID_CLINICA)
        BEGIN
            SET @IDRETURN = -1;
            SET @ERRORID = 1; -- La cl�nica no existe
            SET @ERRORDESCRIPCION = 'ERROR DESDE BD: CLINICA NO EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION;

            -- Eliminar el historial de citas del m�dico asociado a la cl�nica
            DELETE FROM TB_HISTORICO WHERE ID_MEDICO IN (SELECT ID_MEDICO FROM TB_MEDICO WHERE ID_CLINICA = @ID_CLINICA);

            -- Eliminar los registros de citas del m�dico asociado a la cl�nica
            DELETE FROM TB_CITAS WHERE ID_CLINICA = @ID_CLINICA;

            -- Eliminar los m�dicos asociados a la cl�nica
            DELETE FROM TB_MEDICO WHERE ID_CLINICA = @ID_CLINICA;

            -- Eliminar la cl�nica
            DELETE FROM TB_CLINICA WHERE ID_CLINICA = @ID_CLINICA;

            COMMIT TRANSACTION;

            SET @IDRETURN = 1;
            SET @ERRORID = 0;
            SET @ERRORDESCRIPCION = '';
        END
    END TRY
    
    BEGIN CATCH
        SET @IDRETURN = -1;
        SET @ERRORID = ERROR_NUMBER();
        SET @ERRORDESCRIPCION = ERROR_MESSAGE();
        
        ROLLBACK TRANSACTION;
    END CATCH
END



/*    SP_ELMINAR_CITA    */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ELIMINAR_CITA]
(
	@ID_CITAS int,
	@IDRETURN int output,
	@ERRORID int output,
	@ERRORDESCRIPCION nvarchar(max) output
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM TB_CITAS WHERE ID_CITAS = @ID_CITAS) -- �Existe LA CITA?
		BEGIN
			SET @IDRETURN = -1;
			SET @ERRORID = 1; -- CITA ya eliminada
			SET @ERRORDESCRIPCION = 'ERROR DESDE BD: CITA NO EXISTE';
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION;

			-- Eliminar registros relacionados en TB_HISTORICO
			DELETE FROM TB_HISTORICO WHERE ID_CITAS = @ID_CITAS;

			-- Eliminar la CITA
			DELETE FROM TB_CITAS WHERE ID_CITAS = @ID_CITAS;

			COMMIT TRANSACTION;

			SET @IDRETURN = @ID_CITAS;
		END
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @IDRETURN = -1;
		SET @ERRORID = ERROR_NUMBER();
		SET @ERRORDESCRIPCION = ERROR_MESSAGE();
	END CATCH
END