
/* Creacion de la bd */

CREATE DATABASE bdClinica;

																				/* Creacion de las tablas */

/* Creacion de tabla administrador */

CREATE TABLE TB_ADMINISTRADOR (
    ID_ADMINISTRADOR INT IDENTITY(1,1) PRIMARY KEY,
    CEDULA_ADMINISTRADOR VARCHAR(20) NOT NULL,
    NOMBRE_ADMINISTRADOR VARCHAR(50) NOT NULL,
    APELLIDO_ADMINISTRADOR VARCHAR(50) NOT NULL,
    PASSWORD_ADMINISTRADOR VARCHAR(50) NOT NULL
);

/* Creacion de tabla ESPECIALIDAD */

CREATE TABLE TB_ESPECIALIDAD (
    ID_ESPECIALIDAD INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_ESPECIALIDAD VARCHAR(50) NOT NULL,
    DESCRIPCION_ESPECIALIDAD VARCHAR(100) NOT NULL,
);


/* Creacion de tabla CLINICA */

CREATE TABLE TB_CLINICA (
    ID_CLINICA INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_CLINICA VARCHAR(50) NOT NULL,
    TELEFONO_CLINICA VARCHAR(8) NOT NULL,
    UBICACION_CLINICA VARCHAR(50) NOT NULL,
);

/* Creacion de tabla paciente */

CREATE TABLE TB_PACIENTE (
    ID_PACIENTE INT IDENTITY(1,1) PRIMARY KEY,
    CEDULA_PACIENTE VARCHAR(20) NOT NULL,
    NOMBRE_PACIENTE VARCHAR(50) NOT NULL,
    APELLIDO_PACIENTE VARCHAR(50) NOT NULL,
    CORREO_PACIENTE VARCHAR(50) NOT NULL,
	PASSWORD_PACIENTE VARCHAR(MAX) NOT NULL,
	FECHA_REGISTRO_PACIENTE DATETIME NOT NULL,
	NUMERO_VERIFICACION_PACIENTE VARCHAR(MAX) NOT NULL,
	ESTADO_PACIENTE INT NOT NULL
);

/* Creacion de tabla MEDICO */

CREATE TABLE TB_MEDICO (
    ID_MEDICO INT IDENTITY(1,1) PRIMARY KEY,
    CEDULA_MEDICO VARCHAR(20) NOT NULL,
    NOMBRE_MEDICO VARCHAR(50) NOT NULL,
    APELLIDO_MEDICO VARCHAR(50) NOT NULL,
	PASSWORD_MEDICO VARCHAR(MAX) NOT NULL,
	ESTADO_MEDICO INT NOT NULL,
	ID_ESPECIALIDAD INT,
    ID_CLINICA INT,
	FOREIGN KEY (ID_ESPECIALIDAD) REFERENCES TB_ESPECIALIDAD(ID_ESPECIALIDAD),
    FOREIGN KEY (ID_CLINICA) REFERENCES TB_CLINICA(ID_CLINICA)
);

/* Creacion de tabla CITAS */

CREATE TABLE TB_CITAS (
    ID_CITAS INT IDENTITY(1,1) PRIMARY KEY,
	FECHA_CITAS DATE NOT NULL,
	HORA_INICIO_CITAS TIME NOT NULL,
	HORA_FIN_CITAS TIME NOT NULL,
	MOTIVO_CITAS VARCHAR(100) NOT NULL,
	ID_PACIENTE INT,
    ID_CLINICA INT,
    ESTADO_CITAS BIT NOT NULL DEFAULT 0,
	FOREIGN KEY (ID_PACIENTE) REFERENCES TB_PACIENTE(ID_PACIENTE),
    FOREIGN KEY (ID_CLINICA) REFERENCES TB_CLINICA(ID_CLINICA)
);

/* Creacion de tabla HISTORICO */
CREATE TABLE TB_HISTORICO (
    ID_HISTORICO INT IDENTITY(1,1) PRIMARY KEY,
    ID_MEDICO INT,
    ID_CITAS INT,
    FOREIGN KEY (ID_MEDICO) REFERENCES TB_MEDICO(ID_MEDICO),
    FOREIGN KEY (ID_CITAS) REFERENCES TB_CITAS(ID_CITAS)
);

/* Creacion de tabla bitacora */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_BITACORA](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CLASE] [nvarchar](100) NULL,
	[METODO] [nvarchar](100) NULL,
	[TIPO] [smallint] NOT NULL,
	[ERROR_ID] [smallint] NOT NULL,
	[DESCRIPCION] [nvarchar](max) NOT NULL,
	[REQUEST] [nvarchar](max) NOT NULL,
	[RESPONSE] [nvarchar](max) NOT NULL,
	[FECHA_REGISTRO] [datetime] NOT NULL,
 CONSTRAINT [PK_TB_BITACORA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Creacion de tabla error en base de datos */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_ERROR_EN_BASE_DATOS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SEVERIDAD] [int] NULL,
	[STORE_PROCEDURE] [nvarchar](50) NULL,
	[NUMERO] [int] NULL,
	[DESCRIPCION] [nvarchar](max) NULL,
	[LINEA] [int] NULL,
	[FECHA_HORA] [datetime] NULL,
 CONSTRAINT [PK_TB_ERROR_EN_BASE_DATOS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/* Creacion de tabla SESION */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_SESION](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SESION] [nvarchar](max) NOT NULL,
	[PACIENTE] [bigint] NOT NULL,
	[ORIGEN] [nvarchar](max) NOT NULL,
	[FECHA_INICIO] [datetime] NOT NULL,
	[FECHA_FINAL] [datetime] NULL,
	[ESTADO] [datetime] NOT NULL,
	[FECHA_ACTUALIZACION] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

