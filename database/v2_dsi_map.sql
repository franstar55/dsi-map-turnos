SET NAMES utf8mb4;

DROP DATABASE IF EXISTS dsi_map_v2;
CREATE DATABASE dsi_map_v2
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE dsi_map_v2;

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
    CONSTRAINT uq_paciente_mail      UNIQUE (mail)
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

--  PacienteObraSocial
CREATE TABLE PacienteObraSocial (
    idPAOS          INT NOT NULL AUTO_INCREMENT,
    idPaciente      INT NOT NULL,
    idObraSocial    INT NOT NULL,
    CONSTRAINT pk_pacienteobrasocial PRIMARY KEY (idPAOS),
    CONSTRAINT uq_paciente_obrasocial UNIQUE (idPaciente, idObraSocial),
    CONSTRAINT fk_paos_paciente
        FOREIGN KEY (idPaciente) REFERENCES Paciente (idPaciente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_paos_obrasocial
        FOREIGN KEY (idObraSocial) REFERENCES ObraSocial (idObraSocial)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

--  Turno
--  el CHECK mantiene coherentes 'estado' e 'idPAOS'
--  mysql no admite ON DELETE/ON UPDATE en columnas usadas en un CHECK
CREATE TABLE Turno (
    idTurno         INT                            NOT NULL AUTO_INCREMENT,
    idProfesional   INT                            NOT NULL,
    idPAOS          INT                            NULL,
    fechaTurno      DATE                           NOT NULL,
    horaTurno       TIME                           NOT NULL,
    estado          ENUM('ocupado', 'disponible')  NOT NULL DEFAULT 'disponible',
    CONSTRAINT pk_turno PRIMARY KEY (idTurno),
    CONSTRAINT uq_turno_profesional_fecha_hora
        UNIQUE (idProfesional, fechaTurno, horaTurno),
    CONSTRAINT chk_turno_estado_paos CHECK (
        (estado = 'disponible' AND idPAOS IS NULL) OR
        (estado = 'ocupado'    AND idPAOS IS NOT NULL)
    ),
    CONSTRAINT fk_turno_profesional
        FOREIGN KEY (idProfesional) REFERENCES Profesional (idProfesional)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_turno_paos
        FOREIGN KEY (idPAOS) REFERENCES PacienteObraSocial (idPAOS)
) ENGINE = InnoDB;


-- =====================================================================
--  2. DATOS DE PRUEBA

--  Obras sociales
INSERT INTO ObraSocial (idObraSocial, denominacion) VALUES
    (1, 'OSDE'),
    (2, 'Swiss Medical'),
    (3, 'Galeno'),
    (4, 'IOMA'),
    (5, 'PAMI'),
    (6, 'Medifé'),
    (7, 'Sancor Salud');

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
INSERT INTO ProfesionalObraSocial (idPOS, idProfesional, idObraSocial) VALUES
    -- Fernández, Laura (Clínica Médica): OSDE, Swiss Medical, PAMI
    ( 1, 1, 1), ( 2, 1, 2), ( 3, 1, 5),
    -- Gómez, Martín (Clínica Médica): Galeno, IOMA, PAMI, Sancor Salud
    ( 4, 2, 3), ( 5, 2, 4), ( 6, 2, 5), ( 7, 2, 7),
    -- Rodríguez, Sofía (Pediatría): OSDE, Swiss Medical, Medifé
    ( 8, 3, 1), ( 9, 3, 2), (10, 3, 6),
    -- López, Diego (Cardiología): OSDE, Galeno, PAMI
    (11, 4, 1), (12, 4, 3), (13, 4, 5),
    -- Martínez, Valeria (Dermatología): Swiss Medical, Medifé, Sancor Salud
    (14, 5, 2), (15, 5, 6), (16, 5, 7),
    -- Pérez, Javier (Traumatología): OSDE, IOMA, Sancor Salud
    (17, 6, 1), (18, 6, 4), (19, 6, 7),
    -- Sánchez, Carolina (Ginecología): Swiss Medical, Galeno, Medifé
    (20, 7, 2), (21, 7, 3), (22, 7, 6),
    -- Romero, Pablo (Oftalmología): OSDE, PAMI, Sancor Salud
    (23, 8, 1), (24, 8, 5), (25, 8, 7);

--  Pacientes
INSERT INTO Paciente (
    idPaciente, apellidoYNombre, tipoDocumento, nroDocumento,
    sexo, fechaNacimiento, usuario, `contraseña`, mail, telefono
) VALUES
    ( 1, 'García, Juan',      'DNI',       '30123456',  'Masculino', '1983-04-15', 'jgarcia',  'jgarcia123',  'juan.garcia@mail.com',      '1145678901'),
    ( 2, 'Torres, María',     'DNI',       '35987654',  'Femenino',  '1990-09-22', 'mtorres',  'mtorres123',  'maria.torres@mail.com',     '1156789012'),
    ( 3, 'Díaz, Lucas',       'DNI',       '40111222',  'Masculino', '1997-01-30', 'ldiaz',    'ldiaz123',    'lucas.diaz@mail.com',       '1167890123'),
    ( 4, 'Álvarez, Rosa',     'DNI',       '8456789',   'Femenino',  '1948-06-10', 'ralvarez', 'ralvarez123', 'rosa.alvarez@mail.com',     '1178901234'),
    ( 5, 'Ruiz, Tomás',       'DNI',       '45678123',  'Masculino', '2015-03-05', 'truiz',    'truiz123',    'tomas.ruiz@mail.com',       '1189012345'),
    ( 6, 'Molina, Ana',       'DNI',       '33444555',  'Femenino',  '1988-11-18', 'amolina',  'amolina123',  'ana.molina@mail.com',       '2214567890'),
    ( 7, 'Castro, Federico',  'DNI',       '38222333',  'Masculino', '1994-07-07', 'fcastro',  'fcastro123',  'federico.castro@mail.com',  '1123456789'),
    ( 8, 'Herrera, Camila',   'DNI',       '42333444',  'Femenino',  '2000-12-01', 'cherrera', 'cherrera123', 'camila.herrera@mail.com',   '1134567890'),
    ( 9, 'Suárez, Ricardo',   'DNI',       '25666777',  'Masculino', '1976-02-14', 'rsuarez',  'rsuarez123',  'ricardo.suarez@mail.com',   '1145670000'),
    (10, 'Ortiz, Lucía',      'DNI',       '47888999',  'Femenino',  '2012-08-25', 'lortiz',   'lortiz123',   'lucia.ortiz@mail.com',      '1156780000'),
    (11, 'Silva, Andrés',     'PASAPORTE', 'AAB123456', 'Masculino', '1985-05-20', 'asilva',   'asilva123',   'andres.silva@mail.com',     '1167800000'),
    (12, 'Medina, Elena',     'DNI',       '6789012',   'Femenino',  '1945-10-03', 'emedina',  'emedina123',  'elena.medina@mail.com',     '1178900000');

--  Obras sociales de cada paciente
INSERT INTO PacienteObraSocial (idPAOS, idPaciente, idObraSocial) VALUES
    ( 1,  1, 1),   -- García, Juan: OSDE
    ( 2,  1, 3),   -- García, Juan: Galeno
    ( 3,  2, 2),   -- Torres, María: Swiss Medical
    ( 4,  3, 7),   -- Díaz, Lucas: Sancor Salud
    ( 5,  4, 5),   -- Álvarez, Rosa: PAMI
    ( 6,  5, 3),   -- Ruiz, Tomás: Galeno
    ( 7,  5, 1),   -- Ruiz, Tomás: OSDE
    ( 8,  6, 4),   -- Molina, Ana: IOMA
    ( 9,  7, 6),   -- Castro, Federico: Medifé
    (10,  8, 2),   -- Herrera, Camila: Swiss Medical
    (11,  8, 7),   -- Herrera, Camila: Sancor Salud
    (12,  9, 1),   -- Suárez, Ricardo: OSDE
    (13, 10, 2),   -- Ortiz, Lucía: Swiss Medical
    (14, 11, 4),   -- Silva, Andrés: IOMA
    (15, 12, 5),   -- Medina, Elena: PAMI
    (16, 12, 3);   -- Medina, Elena: Galeno

--  Turnos
--  Cada turno ocupado usa una obra social del paciente que el profesional atiende
INSERT INTO Turno (idProfesional, idPAOS, fechaTurno, horaTurno, estado) VALUES
    -- Fernández, Laura (Clínica Médica)
    (1,    1, '2026-10-13', '09:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (1,    5, '2026-10-13', '09:30:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (1, NULL, '2026-10-13', '10:00:00', 'disponible'),
    (1,   10, '2026-10-13', '10:30:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    (1, NULL, '2026-10-15', '09:00:00', 'disponible'),
    (1, NULL, '2026-10-15', '09:30:00', 'disponible'),
    -- Gómez, Martín (Clínica Médica)
    (2,    8, '2026-10-13', '14:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (2,   15, '2026-10-13', '14:30:00', 'ocupado'),     -- Medina, Elena (PAMI)
    (2, NULL, '2026-10-13', '15:00:00', 'disponible'),
    (2, NULL, '2026-10-14', '14:00:00', 'disponible'),
    (2,    4, '2026-10-14', '14:30:00', 'ocupado'),     -- Díaz, Lucas (Sancor Salud)
    -- Rodríguez, Sofía (Pediatría)
    (3,   13, '2026-10-14', '08:00:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    (3,    7, '2026-10-14', '08:30:00', 'ocupado'),     -- Ruiz, Tomás (OSDE)
    (3, NULL, '2026-10-14', '09:00:00', 'disponible'),
    (3, NULL, '2026-10-14', '09:30:00', 'disponible'),
    -- López, Diego (Cardiología)
    (4,   12, '2026-10-14', '10:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    (4,    5, '2026-10-14', '10:30:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (4, NULL, '2026-10-14', '11:00:00', 'disponible'),
    (4, NULL, '2026-10-16', '10:00:00', 'disponible'),
    (4,   16, '2026-10-16', '10:30:00', 'ocupado'),     -- Medina, Elena (Galeno)
    -- Martínez, Valeria (Dermatología)
    (5,    9, '2026-10-15', '16:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (5,    3, '2026-10-15', '16:30:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (5, NULL, '2026-10-15', '17:00:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    (6,   14, '2026-10-15', '11:00:00', 'ocupado'),     -- Silva, Andrés (IOMA)
    (6, NULL, '2026-10-15', '11:30:00', 'disponible'),
    (6,    8, '2026-10-15', '12:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    -- Sánchez, Carolina (Ginecología)
    (7,    3, '2026-10-16', '09:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (7, NULL, '2026-10-16', '09:30:00', 'disponible'),
    (7,   10, '2026-10-16', '10:00:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    -- Romero, Pablo (Oftalmología)
    (8,    1, '2026-10-16', '15:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (8,   11, '2026-10-16', '15:30:00', 'ocupado'),     -- Herrera, Camila (Sancor Salud)
    (8, NULL, '2026-10-16', '16:00:00', 'disponible');

