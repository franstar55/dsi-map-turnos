SET NAMES utf8mb4;

DROP DATABASE IF EXISTS dsi_map;
CREATE DATABASE dsi_map
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE dsi_map;

--  Especialidad
CREATE TABLE Especialidad (
    idEspecialidad  INT          NOT NULL AUTO_INCREMENT,
    denominacion    VARCHAR(100) NOT NULL,
    CONSTRAINT pk_especialidad PRIMARY KEY (idEspecialidad),
    CONSTRAINT uq_especialidad_denominacion UNIQUE (denominacion)
) ENGINE = InnoDB;

--  ObraSocial
CREATE TABLE ObraSocial (
    idObraSocial    INT          NOT NULL AUTO_INCREMENT,
    denominacion    VARCHAR(100) NOT NULL,
    CONSTRAINT pk_obrasocial PRIMARY KEY (idObraSocial),
    CONSTRAINT uq_obrasocial_denominacion UNIQUE (denominacion)
) ENGINE = InnoDB;

--  Profesional
CREATE TABLE Profesional (
    idProfesional   INT          NOT NULL AUTO_INCREMENT,
    idEspecialidad  INT          NOT NULL,
    apellidoYNombre VARCHAR(150) NOT NULL,
    CONSTRAINT pk_profesional PRIMARY KEY (idProfesional),
    CONSTRAINT fk_profesional_especialidad
        FOREIGN KEY (idEspecialidad) REFERENCES Especialidad (idEspecialidad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

--  Paciente
CREATE TABLE Paciente (
    idPaciente      INT          NOT NULL AUTO_INCREMENT,
    idObraSocial    INT          NOT NULL,
    apellidoYNombre VARCHAR(150) NOT NULL,
    tipoDocumento   VARCHAR(20)  NOT NULL,
    nroDocumento    VARCHAR(20)  NOT NULL,
    sexo            VARCHAR(20)  NULL,
    fechaNacimiento DATE         NULL,
    usuario         VARCHAR(50)  NOT NULL,
    `contraseña`    VARCHAR(255) NOT NULL,
    mail            VARCHAR(100) NULL,
    telefono        VARCHAR(30)  NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (idPaciente),
    CONSTRAINT uq_paciente_documento UNIQUE (tipoDocumento, nroDocumento),
    CONSTRAINT uq_paciente_usuario   UNIQUE (usuario),
    CONSTRAINT uq_paciente_mail      UNIQUE (mail),
    CONSTRAINT fk_paciente_obrasocial
        FOREIGN KEY (idObraSocial) REFERENCES ObraSocial (idObraSocial)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

--  ProfesionalObraSocial
CREATE TABLE ProfesionalObraSocial (
    idPOS           INT NOT NULL AUTO_INCREMENT,
    idProfesional   INT NOT NULL,
    idObraSocial    INT NOT NULL,
    CONSTRAINT pk_profesionalobrasocial PRIMARY KEY (idPOS),
    CONSTRAINT uq_profesional_obrasocial UNIQUE (idProfesional, idObraSocial),
    CONSTRAINT fk_pos_profesional
        FOREIGN KEY (idProfesional) REFERENCES Profesional (idProfesional)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_pos_obrasocial
        FOREIGN KEY (idObraSocial) REFERENCES ObraSocial (idObraSocial)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

--  Turno
--  el CHECK mantiene coherentes 'estado' e 'idPaciente'
CREATE TABLE Turno (
    idTurno         INT                            NOT NULL AUTO_INCREMENT,
    idProfesional   INT                            NOT NULL,
    idPaciente      INT                            NULL,
    fechaTurno      DATE                           NOT NULL,
    horaTurno       TIME                           NOT NULL,
    estado          ENUM('ocupado', 'disponible')  NOT NULL DEFAULT 'disponible',
    CONSTRAINT pk_turno PRIMARY KEY (idTurno),
    CONSTRAINT uq_turno_profesional_fecha_hora
        UNIQUE (idProfesional, fechaTurno, horaTurno),
    CONSTRAINT chk_turno_estado_paciente CHECK (
        (estado = 'disponible' AND idPaciente IS NULL) OR
        (estado = 'ocupado'    AND idPaciente IS NOT NULL)
    ),
    CONSTRAINT fk_turno_profesional
        FOREIGN KEY (idProfesional) REFERENCES Profesional (idProfesional)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_turno_paciente
        FOREIGN KEY (idPaciente) REFERENCES Paciente (idPaciente)
) ENGINE = InnoDB;

