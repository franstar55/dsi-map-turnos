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
    -- Clínica Médica
    ( 1, 1, 'Fernández, Laura'),
    ( 2, 1, 'Gómez, Martín'),
    ( 9, 1, 'Acosta, Mariana'),
    -- Pediatría
    ( 3, 2, 'Rodríguez, Sofía'),
    (10, 2, 'Benítez, Nicolás'),
    (11, 2, 'Cabrera, Julieta'),
    -- Cardiología
    ( 4, 3, 'López, Diego'),
    (12, 3, 'Domínguez, Hernán'),
    (13, 3, 'Peralta, Agustina'),
    -- Dermatología
    ( 5, 4, 'Martínez, Valeria'),
    (14, 4, 'Ríos, Esteban'),
    -- Traumatología
    ( 6, 5, 'Pérez, Javier'),
    (15, 5, 'Vega, Natalia'),
    (16, 5, 'Navarro, Gonzalo'),
    -- Ginecología
    ( 7, 6, 'Sánchez, Carolina'),
    (17, 6, 'Morales, Florencia'),
    -- Oftalmología
    ( 8, 7, 'Romero, Pablo'),
    (18, 7, 'Giménez, Sebastián');

--  Obras sociales que atiende cada profesional
INSERT INTO ProfesionalObraSocial (idPOS, idProfesional, idObraSocial) VALUES
    -- Fernández, Laura (Clínica Médica): OSDE, Swiss Medical, PAMI
    ( 1,  1, 1), ( 2,  1, 2), ( 3,  1, 5),
    -- Gómez, Martín (Clínica Médica): Galeno, IOMA, PAMI, Sancor Salud
    ( 4,  2, 3), ( 5,  2, 4), ( 6,  2, 5), ( 7,  2, 7),
    -- Rodríguez, Sofía (Pediatría): OSDE, Swiss Medical, Medifé
    ( 8,  3, 1), ( 9,  3, 2), (10,  3, 6),
    -- López, Diego (Cardiología): OSDE, Galeno, PAMI
    (11,  4, 1), (12,  4, 3), (13,  4, 5),
    -- Martínez, Valeria (Dermatología): Swiss Medical, Medifé, Sancor Salud
    (14,  5, 2), (15,  5, 6), (16,  5, 7),
    -- Pérez, Javier (Traumatología): OSDE, IOMA, Sancor Salud
    (17,  6, 1), (18,  6, 4), (19,  6, 7),
    -- Sánchez, Carolina (Ginecología): Swiss Medical, Galeno, Medifé
    (20,  7, 2), (21,  7, 3), (22,  7, 6),
    -- Romero, Pablo (Oftalmología): OSDE, PAMI, Sancor Salud
    (23,  8, 1), (24,  8, 5), (25,  8, 7),
    -- Acosta, Mariana (Clínica Médica): OSDE, Galeno, Medifé
    (26,  9, 1), (27,  9, 3), (28,  9, 6),
    -- Benítez, Nicolás (Pediatría): Galeno, IOMA, Sancor Salud
    (29, 10, 3), (30, 10, 4), (31, 10, 7),
    -- Cabrera, Julieta (Pediatría): OSDE, Swiss Medical, PAMI
    (32, 11, 1), (33, 11, 2), (34, 11, 5),
    -- Domínguez, Hernán (Cardiología): Swiss Medical, IOMA, Medifé
    (35, 12, 2), (36, 12, 4), (37, 12, 6),
    -- Peralta, Agustina (Cardiología): OSDE, Swiss Medical, PAMI
    (38, 13, 1), (39, 13, 2), (40, 13, 5),
    -- Ríos, Esteban (Dermatología): OSDE, Galeno, IOMA
    (41, 14, 1), (42, 14, 3), (43, 14, 4),
    -- Vega, Natalia (Traumatología): Swiss Medical, Galeno, PAMI
    (44, 15, 2), (45, 15, 3), (46, 15, 5),
    -- Navarro, Gonzalo (Traumatología): OSDE, Medifé, Sancor Salud
    (47, 16, 1), (48, 16, 6), (49, 16, 7),
    -- Morales, Florencia (Ginecología): OSDE, IOMA, PAMI
    (50, 17, 1), (51, 17, 4), (52, 17, 5),
    -- Giménez, Sebastián (Oftalmología): Swiss Medical, Galeno, Medifé
    (53, 18, 2), (54, 18, 3), (55, 18, 6);

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
    -- =================================================================
    -- OCTUBRE 2026

    -- Fernández, Laura (Clínica Médica)
    ( 1,    1, '2026-10-13', '09:00:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 1,    5, '2026-10-13', '09:30:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    ( 1, NULL, '2026-10-13', '10:00:00', 'disponible'),
    ( 1,   10, '2026-10-13', '10:30:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    ( 1, NULL, '2026-10-15', '09:00:00', 'disponible'),
    ( 1, NULL, '2026-10-15', '09:30:00', 'disponible'),
    -- Gómez, Martín (Clínica Médica)
    ( 2,    8, '2026-10-13', '14:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    ( 2,   15, '2026-10-13', '14:30:00', 'ocupado'),     -- Medina, Elena (PAMI)
    ( 2, NULL, '2026-10-13', '15:00:00', 'disponible'),
    ( 2, NULL, '2026-10-14', '14:00:00', 'disponible'),
    ( 2,    4, '2026-10-14', '14:30:00', 'ocupado'),     -- Díaz, Lucas (Sancor Salud)
    -- Rodríguez, Sofía (Pediatría)
    ( 3,   13, '2026-10-14', '08:00:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    ( 3,    7, '2026-10-14', '08:30:00', 'ocupado'),     -- Ruiz, Tomás (OSDE)
    ( 3, NULL, '2026-10-14', '09:00:00', 'disponible'),
    ( 3, NULL, '2026-10-14', '09:30:00', 'disponible'),
    -- López, Diego (Cardiología)
    ( 4,   12, '2026-10-14', '10:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    ( 4,    5, '2026-10-14', '10:30:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    ( 4, NULL, '2026-10-14', '11:00:00', 'disponible'),
    ( 4, NULL, '2026-10-16', '10:00:00', 'disponible'),
    ( 4,   16, '2026-10-16', '10:30:00', 'ocupado'),     -- Medina, Elena (Galeno)
    -- Martínez, Valeria (Dermatología)
    ( 5,    9, '2026-10-15', '16:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    ( 5,    3, '2026-10-15', '16:30:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    ( 5, NULL, '2026-10-15', '17:00:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    ( 6,   14, '2026-10-15', '11:00:00', 'ocupado'),     -- Silva, Andrés (IOMA)
    ( 6, NULL, '2026-10-15', '11:30:00', 'disponible'),
    ( 6,    8, '2026-10-15', '12:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    -- Sánchez, Carolina (Ginecología)
    ( 7,    3, '2026-10-16', '09:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    ( 7, NULL, '2026-10-16', '09:30:00', 'disponible'),
    ( 7,   10, '2026-10-16', '10:00:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    -- Romero, Pablo (Oftalmología)
    ( 8,    1, '2026-10-16', '15:00:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 8,   11, '2026-10-16', '15:30:00', 'ocupado'),     -- Herrera, Camila (Sancor Salud)
    ( 8, NULL, '2026-10-16', '16:00:00', 'disponible'),

    -- =================================================================
    -- OCTUBRE 2026 

    -- Acosta, Mariana (Clínica Médica)
    ( 9,    1, '2026-10-19', '08:30:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 9,    9, '2026-10-19', '09:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    ( 9, NULL, '2026-10-19', '09:30:00', 'disponible'),
    ( 9,    6, '2026-10-21', '08:30:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    ( 9, NULL, '2026-10-21', '09:00:00', 'disponible'),
    -- Benítez, Nicolás (Pediatría)
    (10,    6, '2026-10-20', '10:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    (10, NULL, '2026-10-20', '10:30:00', 'disponible'),
    (10,    8, '2026-10-20', '11:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (10, NULL, '2026-10-22', '10:00:00', 'disponible'),
    -- Cabrera, Julieta (Pediatría)
    (11,   13, '2026-10-21', '14:00:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    (11,    7, '2026-10-21', '14:30:00', 'ocupado'),     -- Ruiz, Tomás (OSDE)
    (11, NULL, '2026-10-21', '15:00:00', 'disponible'),
    (11, NULL, '2026-10-23', '14:00:00', 'disponible'),
    -- Domínguez, Hernán (Cardiología)
    (12,    3, '2026-10-20', '15:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (12,    9, '2026-10-20', '15:30:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (12, NULL, '2026-10-20', '16:00:00', 'disponible'),
    (12,    8, '2026-10-22', '15:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    -- Peralta, Agustina (Cardiología)
    (13,    5, '2026-10-21', '09:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (13, NULL, '2026-10-21', '09:30:00', 'disponible'),
    (13,   12, '2026-10-23', '09:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    (13, NULL, '2026-10-23', '09:30:00', 'disponible'),
    -- Ríos, Esteban (Dermatología)
    (14,    1, '2026-10-22', '11:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (14, NULL, '2026-10-22', '11:30:00', 'disponible'),
    (14,    8, '2026-10-22', '12:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (14, NULL, '2026-10-27', '11:00:00', 'disponible'),
    -- Vega, Natalia (Traumatología)
    (15,   15, '2026-10-20', '09:00:00', 'ocupado'),     -- Medina, Elena (PAMI)
    (15,    3, '2026-10-20', '09:30:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (15, NULL, '2026-10-20', '10:00:00', 'disponible'),
    (15, NULL, '2026-10-27', '09:00:00', 'disponible'),
    -- Navarro, Gonzalo (Traumatología)
    (16,   12, '2026-10-22', '16:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    (16, NULL, '2026-10-22', '16:30:00', 'disponible'),
    (16,    9, '2026-10-22', '17:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (16, NULL, '2026-10-29', '16:00:00', 'disponible'),
    -- Morales, Florencia (Ginecología)
    (17,    5, '2026-10-23', '10:30:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (17,    8, '2026-10-23', '11:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (17, NULL, '2026-10-23', '11:30:00', 'disponible'),
    (17, NULL, '2026-10-30', '10:30:00', 'disponible'),
    -- Giménez, Sebastián (Oftalmología)
    (18,    3, '2026-10-23', '15:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (18, NULL, '2026-10-23', '15:30:00', 'disponible'),
    (18,    9, '2026-10-23', '16:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (18, NULL, '2026-10-30', '15:00:00', 'disponible'),

    -- =================================================================
    -- NOVIEMBRE 2026 

    -- Fernández, Laura (Clínica Médica)
    ( 1,    1, '2026-11-03', '09:00:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 1,    3, '2026-11-03', '09:30:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    ( 1, NULL, '2026-11-03', '10:00:00', 'disponible'),
    ( 1, NULL, '2026-11-10', '09:00:00', 'disponible'),
    ( 1,   15, '2026-11-10', '09:30:00', 'ocupado'),     -- Medina, Elena (PAMI)
    -- Gómez, Martín (Clínica Médica)
    ( 2,    6, '2026-11-03', '14:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    ( 2, NULL, '2026-11-03', '14:30:00', 'disponible'),
    ( 2,    8, '2026-11-10', '14:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    ( 2, NULL, '2026-11-10', '14:30:00', 'disponible'),
    -- Rodríguez, Sofía (Pediatría)
    ( 3,    9, '2026-11-04', '08:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    ( 3,   13, '2026-11-04', '08:30:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    ( 3, NULL, '2026-11-04', '09:00:00', 'disponible'),
    ( 3, NULL, '2026-11-11', '08:00:00', 'disponible'),
    -- López, Diego (Cardiología)
    ( 4,    1, '2026-11-04', '10:00:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 4, NULL, '2026-11-04', '10:30:00', 'disponible'),
    ( 4,    5, '2026-11-11', '10:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    ( 4, NULL, '2026-11-11', '10:30:00', 'disponible'),
    -- Martínez, Valeria (Dermatología)
    ( 5,    3, '2026-11-05', '16:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    ( 5, NULL, '2026-11-05', '16:30:00', 'disponible'),
    ( 5,   11, '2026-11-12', '16:00:00', 'ocupado'),     -- Herrera, Camila (Sancor Salud)
    ( 5, NULL, '2026-11-12', '16:30:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    ( 6,   12, '2026-11-05', '11:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    ( 6, NULL, '2026-11-05', '11:30:00', 'disponible'),
    ( 6,    8, '2026-11-12', '11:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    ( 6, NULL, '2026-11-12', '11:30:00', 'disponible'),
    -- Sánchez, Carolina (Ginecología)
    ( 7,   13, '2026-11-06', '09:00:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    ( 7, NULL, '2026-11-06', '09:30:00', 'disponible'),
    ( 7,   16, '2026-11-13', '09:00:00', 'ocupado'),     -- Medina, Elena (Galeno)
    ( 7, NULL, '2026-11-13', '09:30:00', 'disponible'),
    -- Romero, Pablo (Oftalmología)
    ( 8,    5, '2026-11-06', '15:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    ( 8, NULL, '2026-11-06', '15:30:00', 'disponible'),
    ( 8,   12, '2026-11-13', '15:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    ( 8, NULL, '2026-11-13', '15:30:00', 'disponible'),
    -- Acosta, Mariana (Clínica Médica)
    ( 9,   12, '2026-11-09', '08:30:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    ( 9, NULL, '2026-11-09', '09:00:00', 'disponible'),
    ( 9,    2, '2026-11-16', '08:30:00', 'ocupado'),     -- García, Juan (Galeno)
    ( 9, NULL, '2026-11-16', '09:00:00', 'disponible'),
    -- Benítez, Nicolás (Pediatría)
    (10,    6, '2026-11-10', '10:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    (10, NULL, '2026-11-10', '10:30:00', 'disponible'),
    (10,   11, '2026-11-17', '10:00:00', 'ocupado'),     -- Herrera, Camila (Sancor Salud)
    (10, NULL, '2026-11-17', '10:30:00', 'disponible'),
    -- Cabrera, Julieta (Pediatría)
    (11,    1, '2026-11-11', '14:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (11, NULL, '2026-11-11', '14:30:00', 'disponible'),
    (11,   13, '2026-11-18', '14:00:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    (11, NULL, '2026-11-18', '14:30:00', 'disponible'),
    -- Domínguez, Hernán (Cardiología)
    (12,   14, '2026-11-10', '15:00:00', 'ocupado'),     -- Silva, Andrés (IOMA)
    (12, NULL, '2026-11-10', '15:30:00', 'disponible'),
    (12,    3, '2026-11-17', '15:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (12, NULL, '2026-11-17', '15:30:00', 'disponible'),
    -- Peralta, Agustina (Cardiología)
    (13,   15, '2026-11-11', '09:00:00', 'ocupado'),     -- Medina, Elena (PAMI)
    (13, NULL, '2026-11-11', '09:30:00', 'disponible'),
    (13,    1, '2026-11-18', '09:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (13, NULL, '2026-11-18', '09:30:00', 'disponible'),
    -- Ríos, Esteban (Dermatología)
    (14,   12, '2026-11-12', '11:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    (14, NULL, '2026-11-12', '11:30:00', 'disponible'),
    (14,    6, '2026-11-19', '11:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    (14, NULL, '2026-11-19', '11:30:00', 'disponible'),
    -- Vega, Natalia (Traumatología)
    (15,    5, '2026-11-10', '09:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (15, NULL, '2026-11-10', '09:30:00', 'disponible'),
    (15,   16, '2026-11-17', '09:00:00', 'ocupado'),     -- Medina, Elena (Galeno)
    (15, NULL, '2026-11-17', '09:30:00', 'disponible'),
    -- Navarro, Gonzalo (Traumatología)
    (16,    1, '2026-11-12', '16:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (16, NULL, '2026-11-12', '16:30:00', 'disponible'),
    (16,    4, '2026-11-19', '16:00:00', 'ocupado'),     -- Díaz, Lucas (Sancor Salud)
    (16, NULL, '2026-11-19', '16:30:00', 'disponible'),
    -- Morales, Florencia (Ginecología)
    (17,    8, '2026-11-13', '10:30:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (17, NULL, '2026-11-13', '11:00:00', 'disponible'),
    (17,   15, '2026-11-20', '10:30:00', 'ocupado'),     -- Medina, Elena (PAMI)
    (17, NULL, '2026-11-20', '11:00:00', 'disponible'),
    -- Giménez, Sebastián (Oftalmología)
    (18,    9, '2026-11-13', '15:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (18, NULL, '2026-11-13', '15:30:00', 'disponible'),
    (18,    6, '2026-11-20', '15:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    (18, NULL, '2026-11-20', '15:30:00', 'disponible'),

    -- =================================================================
    -- DICIEMBRE 2026 
    
    -- Fernández, Laura (Clínica Médica)
    ( 1,    5, '2026-12-01', '09:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    ( 1, NULL, '2026-12-01', '09:30:00', 'disponible'),
    ( 1,   10, '2026-12-15', '09:00:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    ( 1, NULL, '2026-12-15', '09:30:00', 'disponible'),
    -- Gómez, Martín (Clínica Médica)
    ( 2,   15, '2026-12-01', '14:00:00', 'ocupado'),     -- Medina, Elena (PAMI)
    ( 2, NULL, '2026-12-01', '14:30:00', 'disponible'),
    ( 2,    4, '2026-12-15', '14:00:00', 'ocupado'),     -- Díaz, Lucas (Sancor Salud)
    ( 2, NULL, '2026-12-15', '14:30:00', 'disponible'),
    -- Rodríguez, Sofía (Pediatría)
    ( 3,    3, '2026-12-02', '08:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    ( 3, NULL, '2026-12-02', '08:30:00', 'disponible'),
    ( 3,   13, '2026-12-16', '08:00:00', 'ocupado'),     -- Ortiz, Lucía (Swiss Medical)
    ( 3, NULL, '2026-12-16', '08:30:00', 'disponible'),
    -- López, Diego (Cardiología)
    ( 4,   12, '2026-12-02', '10:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    ( 4, NULL, '2026-12-02', '10:30:00', 'disponible'),
    ( 4,    6, '2026-12-16', '10:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    ( 4, NULL, '2026-12-16', '10:30:00', 'disponible'),
    -- Martínez, Valeria (Dermatología)
    ( 5,    9, '2026-12-03', '16:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    ( 5, NULL, '2026-12-03', '16:30:00', 'disponible'),
    ( 5,    4, '2026-12-17', '16:00:00', 'ocupado'),     -- Díaz, Lucas (Sancor Salud)
    ( 5, NULL, '2026-12-17', '16:30:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    ( 6,    1, '2026-12-03', '11:00:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 6, NULL, '2026-12-03', '11:30:00', 'disponible'),
    ( 6,   14, '2026-12-17', '11:00:00', 'ocupado'),     -- Silva, Andrés (IOMA)
    ( 6, NULL, '2026-12-17', '11:30:00', 'disponible'),
    -- Sánchez, Carolina (Ginecología)
    ( 7,   10, '2026-12-04', '09:00:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    ( 7, NULL, '2026-12-04', '09:30:00', 'disponible'),
    ( 7,    3, '2026-12-18', '09:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    ( 7, NULL, '2026-12-18', '09:30:00', 'disponible'),
    -- Romero, Pablo (Oftalmología)
    ( 8,   15, '2026-12-04', '15:00:00', 'ocupado'),     -- Medina, Elena (PAMI)
    ( 8, NULL, '2026-12-04', '15:30:00', 'disponible'),
    ( 8,    1, '2026-12-18', '15:00:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 8, NULL, '2026-12-18', '15:30:00', 'disponible'),
    -- Acosta, Mariana (Clínica Médica)
    ( 9,    9, '2026-12-07', '08:30:00', 'ocupado'),     -- Castro, Federico (Medifé)
    ( 9, NULL, '2026-12-07', '09:00:00', 'disponible'),
    ( 9,    1, '2026-12-14', '08:30:00', 'ocupado'),     -- García, Juan (OSDE)
    ( 9, NULL, '2026-12-14', '09:00:00', 'disponible'),
    -- Benítez, Nicolás (Pediatría)
    (10,    8, '2026-12-09', '10:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (10, NULL, '2026-12-09', '10:30:00', 'disponible'),
    (10,    6, '2026-12-16', '10:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    (10, NULL, '2026-12-16', '10:30:00', 'disponible'),
    -- Cabrera, Julieta (Pediatría)
    (11,    5, '2026-12-09', '14:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (11, NULL, '2026-12-09', '14:30:00', 'disponible'),
    (11,    3, '2026-12-16', '14:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (11, NULL, '2026-12-16', '14:30:00', 'disponible'),
    -- Domínguez, Hernán (Cardiología)
    (12,    9, '2026-12-10', '15:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (12, NULL, '2026-12-10', '15:30:00', 'disponible'),
    (12,    8, '2026-12-17', '15:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (12, NULL, '2026-12-17', '15:30:00', 'disponible'),
    -- Peralta, Agustina (Cardiología)
    (13,   12, '2026-12-10', '09:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    (13, NULL, '2026-12-10', '09:30:00', 'disponible'),
    (13,    5, '2026-12-17', '09:00:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (13, NULL, '2026-12-17', '09:30:00', 'disponible'),
    -- Ríos, Esteban (Dermatología)
    (14,    8, '2026-12-11', '11:00:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (14, NULL, '2026-12-11', '11:30:00', 'disponible'),
    (14,    1, '2026-12-18', '11:00:00', 'ocupado'),     -- García, Juan (OSDE)
    (14, NULL, '2026-12-18', '11:30:00', 'disponible'),
    -- Vega, Natalia (Traumatología)
    (15,    6, '2026-12-11', '09:00:00', 'ocupado'),     -- Ruiz, Tomás (Galeno)
    (15, NULL, '2026-12-11', '09:30:00', 'disponible'),
    (15,   15, '2026-12-18', '09:00:00', 'ocupado'),     -- Medina, Elena (PAMI)
    (15, NULL, '2026-12-18', '09:30:00', 'disponible'),
    -- Navarro, Gonzalo (Traumatología)
    (16,    9, '2026-12-11', '16:00:00', 'ocupado'),     -- Castro, Federico (Medifé)
    (16, NULL, '2026-12-11', '16:30:00', 'disponible'),
    (16,   12, '2026-12-18', '16:00:00', 'ocupado'),     -- Suárez, Ricardo (OSDE)
    (16, NULL, '2026-12-18', '16:30:00', 'disponible'),
    -- Morales, Florencia (Ginecología)
    (17,    5, '2026-12-11', '10:30:00', 'ocupado'),     -- Álvarez, Rosa (PAMI)
    (17, NULL, '2026-12-11', '11:00:00', 'disponible'),
    (17,    8, '2026-12-18', '10:30:00', 'ocupado'),     -- Molina, Ana (IOMA)
    (17, NULL, '2026-12-18', '11:00:00', 'disponible'),
    -- Giménez, Sebastián (Oftalmología)
    (18,    3, '2026-12-11', '15:00:00', 'ocupado'),     -- Torres, María (Swiss Medical)
    (18, NULL, '2026-12-11', '15:30:00', 'disponible'),
    (18,   10, '2026-12-18', '15:00:00', 'ocupado'),     -- Herrera, Camila (Swiss Medical)
    (18, NULL, '2026-12-18', '15:30:00', 'disponible');
