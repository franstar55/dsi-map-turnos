SET NAMES utf8mb4;

DROP DATABASE IF EXISTS dsi_map;
CREATE DATABASE dsi_map
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE dsi_map;

-- =====================================================================
--  1. ESTRUCTURA

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


-- =====================================================================
--  2. DATOS DE PRUEBA

--  Obras sociales
INSERT INTO ObraSocial (idObraSocial, denominacion) VALUES
    (1, 'Particular'),
    (2, 'OSDE'),
    (3, 'Swiss Medical'),
    (4, 'Galeno'),
    (5, 'IOMA'),
    (6, 'PAMI'),
    (7, 'Medifé');

--  Especialidades
INSERT INTO Especialidad (idEspecialidad, denominacion) VALUES
    (1, 'Clínica Médica'),
    (2, 'Pediatría'),
    (3, 'Cardiología'),
    (4, 'Dermatología'),
    (5, 'Traumatología'),
    (6, 'Ginecología'),
    (7, 'Oftalmología');

--  Profesionales
INSERT INTO Profesional (idProfesional, idEspecialidad, apellidoYNombre) VALUES
    (1, 1, 'Fernández, Laura'),
    (2, 1, 'Gómez, Martín'),
    (3, 2, 'Rodríguez, Sofía'),
    (4, 3, 'López, Diego'),
    (5, 4, 'Martínez, Valeria'),
    (6, 5, 'Pérez, Javier'),
    (7, 6, 'Sánchez, Carolina'),
    (8, 7, 'Romero, Pablo');

--  Obras sociales que atiende cada profesional
--  (todos atienden pacientes particulares)
INSERT INTO ProfesionalObraSocial (idPOS, idProfesional, idObraSocial) VALUES
    -- Fernández, Laura (Clínica Médica)
    ( 1, 1, 1), ( 2, 1, 2), ( 3, 1, 3), ( 4, 1, 6),
    -- Gómez, Martín (Clínica Médica)
    ( 5, 2, 1), ( 6, 2, 4), ( 7, 2, 5), ( 8, 2, 6),
    -- Rodríguez, Sofía (Pediatría)
    ( 9, 3, 1), (10, 3, 2), (11, 3, 3), (12, 3, 7),
    -- López, Diego (Cardiología)
    (13, 4, 1), (14, 4, 2), (15, 4, 4), (16, 4, 6),
    -- Martínez, Valeria (Dermatología)
    (17, 5, 1), (18, 5, 3), (19, 5, 7),
    -- Pérez, Javier (Traumatología)
    (20, 6, 1), (21, 6, 2), (22, 6, 5),
    -- Sánchez, Carolina (Ginecología)
    (23, 7, 1), (24, 7, 3), (25, 7, 4), (26, 7, 7),
    -- Romero, Pablo (Oftalmología)
    (27, 8, 1), (28, 8, 2), (29, 8, 6);

--  Pacientes
INSERT INTO Paciente (
    idPaciente, idObraSocial, apellidoYNombre, tipoDocumento, nroDocumento,
    sexo, fechaNacimiento, usuario, `contraseña`, mail, telefono
) VALUES
    ( 1, 2, 'García, Juan',      'DNI',       '30123456',  'Masculino', '1983-04-15', 'jgarcia',  'jgarcia123',  'juan.garcia@mail.com',      '1145678901'),
    ( 2, 3, 'Torres, María',     'DNI',       '35987654',  'Femenino',  '1990-09-22', 'mtorres',  'mtorres123',  'maria.torres@mail.com',     '1156789012'),
    ( 3, 1, 'Díaz, Lucas',       'DNI',       '40111222',  'Masculino', '1997-01-30', 'ldiaz',    'ldiaz123',    'lucas.diaz@mail.com',       '1167890123'),
    ( 4, 6, 'Álvarez, Rosa',     'DNI',       '8456789',   'Femenino',  '1948-06-10', 'ralvarez', 'ralvarez123', 'rosa.alvarez@mail.com',     '1178901234'),
    ( 5, 4, 'Ruiz, Tomás',       'DNI',       '45678123',  'Masculino', '2015-03-05', 'truiz',    'truiz123',    'tomas.ruiz@mail.com',       '1189012345'),
    ( 6, 5, 'Molina, Ana',       'DNI',       '33444555',  'Femenino',  '1988-11-18', 'amolina',  'amolina123',  'ana.molina@mail.com',       '2214567890'),
    ( 7, 7, 'Castro, Federico',  'DNI',       '38222333',  'Masculino', '1994-07-07', 'fcastro',  'fcastro123',  'federico.castro@mail.com',  '1123456789'),
    ( 8, 1, 'Herrera, Camila',   'DNI',       '42333444',  'Femenino',  '2000-12-01', 'cherrera', 'cherrera123', 'camila.herrera@mail.com',   '1134567890'),
    ( 9, 2, 'Suárez, Ricardo',   'DNI',       '25666777',  'Masculino', '1976-02-14', 'rsuarez',  'rsuarez123',  'ricardo.suarez@mail.com',   '1145670000'),
    (10, 3, 'Ortiz, Lucía',      'DNI',       '47888999',  'Femenino',  '2012-08-25', 'lortiz',   'lortiz123',   'lucia.ortiz@mail.com',      '1156780000'),
    (11, 1, 'Silva, Andrés',     'PASAPORTE', 'AAB123456', 'Masculino', '1985-05-20', 'asilva',   'asilva123',   'andres.silva@mail.com',     '1167800000'),
    (12, 6, 'Medina, Elena',     'DNI',       '6789012',   'Femenino',  '1945-10-03', 'emedina',  'emedina123',  'elena.medina@mail.com',     '1178900000');

--  Turnos
INSERT INTO Turno (idProfesional, idPaciente, fechaTurno, horaTurno, estado) VALUES
    -- Fernández, Laura (Clínica Médica)
    (1,    1, '2026-10-13', '09:00:00', 'ocupado'),
    (1,    4, '2026-10-13', '09:30:00', 'ocupado'),
    (1, NULL, '2026-10-13', '10:00:00', 'disponible'),
    (1,    3, '2026-10-13', '10:30:00', 'ocupado'),
    (1, NULL, '2026-10-15', '09:00:00', 'disponible'),
    (1, NULL, '2026-10-15', '09:30:00', 'disponible'),
    -- Gómez, Martín (Clínica Médica)
    (2,    6, '2026-10-13', '14:00:00', 'ocupado'),
    (2,   12, '2026-10-13', '14:30:00', 'ocupado'),
    (2, NULL, '2026-10-13', '15:00:00', 'disponible'),
    (2, NULL, '2026-10-14', '14:00:00', 'disponible'),
    (2,    8, '2026-10-14', '14:30:00', 'ocupado'),
    -- Rodríguez, Sofía (Pediatría)
    (3,   10, '2026-10-14', '08:00:00', 'ocupado'),
    (3, NULL, '2026-10-14', '08:30:00', 'disponible'),
    (3, NULL, '2026-10-14', '09:00:00', 'disponible'),
    (3, NULL, '2026-10-14', '09:30:00', 'disponible'),
    -- López, Diego (Cardiología)
    (4,    9, '2026-10-14', '10:00:00', 'ocupado'),
    (4,    4, '2026-10-14', '10:30:00', 'ocupado'),
    (4, NULL, '2026-10-14', '11:00:00', 'disponible'),
    (4, NULL, '2026-10-16', '10:00:00', 'disponible'),
    (4,   12, '2026-10-16', '10:30:00', 'ocupado'),
    -- Martínez, Valeria (Dermatología)
    (5,    7, '2026-10-15', '16:00:00', 'ocupado'),
    (5,    2, '2026-10-15', '16:30:00', 'ocupado'),
    (5, NULL, '2026-10-15', '17:00:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    (6,   11, '2026-10-15', '11:00:00', 'ocupado'),
    (6, NULL, '2026-10-15', '11:30:00', 'disponible'),
    (6,    6, '2026-10-15', '12:00:00', 'ocupado'),
    -- Sánchez, Carolina (Ginecología)
    (7,    2, '2026-10-16', '09:00:00', 'ocupado'),
    (7, NULL, '2026-10-16', '09:30:00', 'disponible'),
    (7,    8, '2026-10-16', '10:00:00', 'ocupado'),
    -- Romero, Pablo (Oftalmología)
    (8,    1, '2026-10-16', '15:00:00', 'ocupado'),
    (8, NULL, '2026-10-16', '15:30:00', 'disponible'),
    (8, NULL, '2026-10-16', '16:00:00', 'disponible');

