--  requiere haber ejecutado antes 01_schema.sql
SET NAMES utf8mb4;

USE dsi_map;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Turno;
TRUNCATE TABLE ProfesionalObraSocial;
TRUNCATE TABLE Paciente;
TRUNCATE TABLE Profesional;
TRUNCATE TABLE Especialidad;
TRUNCATE TABLE ObraSocial;
SET FOREIGN_KEY_CHECKS = 1;


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
--  (todos atienden pacientes particulares)
INSERT INTO ProfesionalObraSocial (idPOS, idProfesional, idObraSocial) VALUES
    -- Fernández, Laura (Clínica Médica)
    ( 1,  1, 1), ( 2,  1, 2), ( 3,  1, 3), ( 4,  1, 6),
    -- Gómez, Martín (Clínica Médica)
    ( 5,  2, 1), ( 6,  2, 4), ( 7,  2, 5), ( 8,  2, 6),
    -- Rodríguez, Sofía (Pediatría)
    ( 9,  3, 1), (10,  3, 2), (11,  3, 3), (12,  3, 7),
    -- López, Diego (Cardiología)
    (13,  4, 1), (14,  4, 2), (15,  4, 4), (16,  4, 6),
    -- Martínez, Valeria (Dermatología)
    (17,  5, 1), (18,  5, 3), (19,  5, 7),
    -- Pérez, Javier (Traumatología)
    (20,  6, 1), (21,  6, 2), (22,  6, 5),
    -- Sánchez, Carolina (Ginecología)
    (23,  7, 1), (24,  7, 3), (25,  7, 4), (26,  7, 7),
    -- Romero, Pablo (Oftalmología)
    (27,  8, 1), (28,  8, 2), (29,  8, 6),
    -- Acosta, Mariana (Clínica Médica)
    (30,  9, 1), (31,  9, 2), (32,  9, 4), (33,  9, 7),
    -- Benítez, Nicolás (Pediatría)
    (34, 10, 1), (35, 10, 4), (36, 10, 5),
    -- Cabrera, Julieta (Pediatría)
    (37, 11, 1), (38, 11, 2), (39, 11, 3), (40, 11, 6),
    -- Domínguez, Hernán (Cardiología)
    (41, 12, 1), (42, 12, 3), (43, 12, 5), (44, 12, 7),
    -- Peralta, Agustina (Cardiología)
    (45, 13, 1), (46, 13, 2), (47, 13, 3), (48, 13, 6),
    -- Ríos, Esteban (Dermatología)
    (49, 14, 1), (50, 14, 2), (51, 14, 4), (52, 14, 5),
    -- Vega, Natalia (Traumatología)
    (53, 15, 1), (54, 15, 3), (55, 15, 4), (56, 15, 6),
    -- Navarro, Gonzalo (Traumatología)
    (57, 16, 1), (58, 16, 2), (59, 16, 7),
    -- Morales, Florencia (Ginecología)
    (60, 17, 1), (61, 17, 2), (62, 17, 5), (63, 17, 6),
    -- Giménez, Sebastián (Oftalmología)
    (64, 18, 1), (65, 18, 3), (66, 18, 4), (67, 18, 7);

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
    -- =================================================================
    -- OCTUBRE 2026

    -- Fernández, Laura (Clínica Médica)
    ( 1,    1, '2026-10-13', '09:00:00', 'ocupado'),
    ( 1,    4, '2026-10-13', '09:30:00', 'ocupado'),
    ( 1, NULL, '2026-10-13', '10:00:00', 'disponible'),
    ( 1,    3, '2026-10-13', '10:30:00', 'ocupado'),
    ( 1, NULL, '2026-10-15', '09:00:00', 'disponible'),
    ( 1, NULL, '2026-10-15', '09:30:00', 'disponible'),
    -- Gómez, Martín (Clínica Médica)
    ( 2,    6, '2026-10-13', '14:00:00', 'ocupado'),
    ( 2,   12, '2026-10-13', '14:30:00', 'ocupado'),
    ( 2, NULL, '2026-10-13', '15:00:00', 'disponible'),
    ( 2, NULL, '2026-10-14', '14:00:00', 'disponible'),
    ( 2,    8, '2026-10-14', '14:30:00', 'ocupado'),
    -- Rodríguez, Sofía (Pediatría)
    ( 3,   10, '2026-10-14', '08:00:00', 'ocupado'),
    ( 3, NULL, '2026-10-14', '08:30:00', 'disponible'),
    ( 3, NULL, '2026-10-14', '09:00:00', 'disponible'),
    ( 3, NULL, '2026-10-14', '09:30:00', 'disponible'),
    -- López, Diego (Cardiología)
    ( 4,    9, '2026-10-14', '10:00:00', 'ocupado'),
    ( 4,    4, '2026-10-14', '10:30:00', 'ocupado'),
    ( 4, NULL, '2026-10-14', '11:00:00', 'disponible'),
    ( 4, NULL, '2026-10-16', '10:00:00', 'disponible'),
    ( 4,   12, '2026-10-16', '10:30:00', 'ocupado'),
    -- Martínez, Valeria (Dermatología)
    ( 5,    7, '2026-10-15', '16:00:00', 'ocupado'),
    ( 5,    2, '2026-10-15', '16:30:00', 'ocupado'),
    ( 5, NULL, '2026-10-15', '17:00:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    ( 6,   11, '2026-10-15', '11:00:00', 'ocupado'),
    ( 6, NULL, '2026-10-15', '11:30:00', 'disponible'),
    ( 6,    6, '2026-10-15', '12:00:00', 'ocupado'),
    -- Sánchez, Carolina (Ginecología)
    ( 7,    2, '2026-10-16', '09:00:00', 'ocupado'),
    ( 7, NULL, '2026-10-16', '09:30:00', 'disponible'),
    ( 7,    8, '2026-10-16', '10:00:00', 'ocupado'),
    -- Romero, Pablo (Oftalmología)
    ( 8,    1, '2026-10-16', '15:00:00', 'ocupado'),
    ( 8, NULL, '2026-10-16', '15:30:00', 'disponible'),
    ( 8, NULL, '2026-10-16', '16:00:00', 'disponible'),

    -- Acosta, Mariana (Clínica Médica)
    ( 9,    1, '2026-10-19', '08:30:00', 'ocupado'),
    ( 9,    7, '2026-10-19', '09:00:00', 'ocupado'),
    ( 9, NULL, '2026-10-19', '09:30:00', 'disponible'),
    ( 9,    5, '2026-10-21', '08:30:00', 'ocupado'),
    ( 9, NULL, '2026-10-21', '09:00:00', 'disponible'),
    -- Benítez, Nicolás (Pediatría)
    (10,    5, '2026-10-20', '10:00:00', 'ocupado'),
    (10, NULL, '2026-10-20', '10:30:00', 'disponible'),
    (10,    6, '2026-10-20', '11:00:00', 'ocupado'),
    (10, NULL, '2026-10-22', '10:00:00', 'disponible'),
    -- Cabrera, Julieta (Pediatría)
    (11,   10, '2026-10-21', '14:00:00', 'ocupado'),
    (11,    3, '2026-10-21', '14:30:00', 'ocupado'),
    (11, NULL, '2026-10-21', '15:00:00', 'disponible'),
    (11, NULL, '2026-10-23', '14:00:00', 'disponible'),
    -- Domínguez, Hernán (Cardiología)
    (12,    2, '2026-10-20', '15:00:00', 'ocupado'),
    (12,    7, '2026-10-20', '15:30:00', 'ocupado'),
    (12, NULL, '2026-10-20', '16:00:00', 'disponible'),
    (12,    6, '2026-10-22', '15:00:00', 'ocupado'),
    -- Peralta, Agustina (Cardiología)
    (13,    4, '2026-10-21', '09:00:00', 'ocupado'),
    (13, NULL, '2026-10-21', '09:30:00', 'disponible'),
    (13,    9, '2026-10-23', '09:00:00', 'ocupado'),
    (13, NULL, '2026-10-23', '09:30:00', 'disponible'),
    -- Ríos, Esteban (Dermatología)
    (14,    1, '2026-10-22', '11:00:00', 'ocupado'),
    (14, NULL, '2026-10-22', '11:30:00', 'disponible'),
    (14,    6, '2026-10-22', '12:00:00', 'ocupado'),
    (14, NULL, '2026-10-27', '11:00:00', 'disponible'),
    -- Vega, Natalia (Traumatología)
    (15,   12, '2026-10-20', '09:00:00', 'ocupado'),
    (15,    2, '2026-10-20', '09:30:00', 'ocupado'),
    (15, NULL, '2026-10-20', '10:00:00', 'disponible'),
    (15, NULL, '2026-10-27', '09:00:00', 'disponible'),
    -- Navarro, Gonzalo (Traumatología)
    (16,    9, '2026-10-22', '16:00:00', 'ocupado'),
    (16, NULL, '2026-10-22', '16:30:00', 'disponible'),
    (16,    7, '2026-10-22', '17:00:00', 'ocupado'),
    (16, NULL, '2026-10-29', '16:00:00', 'disponible'),
    -- Morales, Florencia (Ginecología)
    (17,    4, '2026-10-23', '10:30:00', 'ocupado'),
    (17,    6, '2026-10-23', '11:00:00', 'ocupado'),
    (17, NULL, '2026-10-23', '11:30:00', 'disponible'),
    (17, NULL, '2026-10-30', '10:30:00', 'disponible'),
    -- Giménez, Sebastián (Oftalmología)
    (18,    2, '2026-10-23', '15:00:00', 'ocupado'),
    (18, NULL, '2026-10-23', '15:30:00', 'disponible'),
    (18,    7, '2026-10-23', '16:00:00', 'ocupado'),
    (18, NULL, '2026-10-30', '15:00:00', 'disponible'),

    -- =================================================================
    -- NOVIEMBRE 2026 

    -- Fernández, Laura (Clínica Médica)
    ( 1,    1, '2026-11-03', '09:00:00', 'ocupado'),
    ( 1,    2, '2026-11-03', '09:30:00', 'ocupado'),
    ( 1, NULL, '2026-11-03', '10:00:00', 'disponible'),
    ( 1, NULL, '2026-11-10', '09:00:00', 'disponible'),
    ( 1,   12, '2026-11-10', '09:30:00', 'ocupado'),
    -- Gómez, Martín (Clínica Médica)
    ( 2,    5, '2026-11-03', '14:00:00', 'ocupado'),
    ( 2, NULL, '2026-11-03', '14:30:00', 'disponible'),
    ( 2,    6, '2026-11-10', '14:00:00', 'ocupado'),
    ( 2, NULL, '2026-11-10', '14:30:00', 'disponible'),
    -- Rodríguez, Sofía (Pediatría)
    ( 3,    7, '2026-11-04', '08:00:00', 'ocupado'),
    ( 3,   10, '2026-11-04', '08:30:00', 'ocupado'),
    ( 3, NULL, '2026-11-04', '09:00:00', 'disponible'),
    ( 3, NULL, '2026-11-11', '08:00:00', 'disponible'),
    -- López, Diego (Cardiología)
    ( 4,    1, '2026-11-04', '10:00:00', 'ocupado'),
    ( 4, NULL, '2026-11-04', '10:30:00', 'disponible'),
    ( 4,    4, '2026-11-11', '10:00:00', 'ocupado'),
    ( 4, NULL, '2026-11-11', '10:30:00', 'disponible'),
    -- Martínez, Valeria (Dermatología)
    ( 5,    2, '2026-11-05', '16:00:00', 'ocupado'),
    ( 5, NULL, '2026-11-05', '16:30:00', 'disponible'),
    ( 5,    8, '2026-11-12', '16:00:00', 'ocupado'),
    ( 5, NULL, '2026-11-12', '16:30:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    ( 6,    9, '2026-11-05', '11:00:00', 'ocupado'),
    ( 6, NULL, '2026-11-05', '11:30:00', 'disponible'),
    ( 6,    6, '2026-11-12', '11:00:00', 'ocupado'),
    ( 6, NULL, '2026-11-12', '11:30:00', 'disponible'),
    -- Sánchez, Carolina (Ginecología)
    ( 7,   10, '2026-11-06', '09:00:00', 'ocupado'),
    ( 7, NULL, '2026-11-06', '09:30:00', 'disponible'),
    ( 7,    2, '2026-11-13', '09:00:00', 'ocupado'),
    ( 7, NULL, '2026-11-13', '09:30:00', 'disponible'),
    -- Romero, Pablo (Oftalmología)
    ( 8,    4, '2026-11-06', '15:00:00', 'ocupado'),
    ( 8, NULL, '2026-11-06', '15:30:00', 'disponible'),
    ( 8,    9, '2026-11-13', '15:00:00', 'ocupado'),
    ( 8, NULL, '2026-11-13', '15:30:00', 'disponible'),
    -- Acosta, Mariana (Clínica Médica)
    ( 9,    9, '2026-11-09', '08:30:00', 'ocupado'),
    ( 9, NULL, '2026-11-09', '09:00:00', 'disponible'),
    ( 9,    3, '2026-11-16', '08:30:00', 'ocupado'),
    ( 9, NULL, '2026-11-16', '09:00:00', 'disponible'),
    -- Benítez, Nicolás (Pediatría)
    (10,    5, '2026-11-10', '10:00:00', 'ocupado'),
    (10, NULL, '2026-11-10', '10:30:00', 'disponible'),
    (10,    8, '2026-11-17', '10:00:00', 'ocupado'),
    (10, NULL, '2026-11-17', '10:30:00', 'disponible'),
    -- Cabrera, Julieta (Pediatría)
    (11,    1, '2026-11-11', '14:00:00', 'ocupado'),
    (11, NULL, '2026-11-11', '14:30:00', 'disponible'),
    (11,   10, '2026-11-18', '14:00:00', 'ocupado'),
    (11, NULL, '2026-11-18', '14:30:00', 'disponible'),
    -- Domínguez, Hernán (Cardiología)
    (12,   11, '2026-11-10', '15:00:00', 'ocupado'),
    (12, NULL, '2026-11-10', '15:30:00', 'disponible'),
    (12,    2, '2026-11-17', '15:00:00', 'ocupado'),
    (12, NULL, '2026-11-17', '15:30:00', 'disponible'),
    -- Peralta, Agustina (Cardiología)
    (13,   12, '2026-11-11', '09:00:00', 'ocupado'),
    (13, NULL, '2026-11-11', '09:30:00', 'disponible'),
    (13,    1, '2026-11-18', '09:00:00', 'ocupado'),
    (13, NULL, '2026-11-18', '09:30:00', 'disponible'),
    -- Ríos, Esteban (Dermatología)
    (14,    9, '2026-11-12', '11:00:00', 'ocupado'),
    (14, NULL, '2026-11-12', '11:30:00', 'disponible'),
    (14,    5, '2026-11-19', '11:00:00', 'ocupado'),
    (14, NULL, '2026-11-19', '11:30:00', 'disponible'),
    -- Vega, Natalia (Traumatología)
    (15,    4, '2026-11-10', '09:00:00', 'ocupado'),
    (15, NULL, '2026-11-10', '09:30:00', 'disponible'),
    (15,    3, '2026-11-17', '09:00:00', 'ocupado'),
    (15, NULL, '2026-11-17', '09:30:00', 'disponible'),
    -- Navarro, Gonzalo (Traumatología)
    (16,    1, '2026-11-12', '16:00:00', 'ocupado'),
    (16, NULL, '2026-11-12', '16:30:00', 'disponible'),
    (16,   11, '2026-11-19', '16:00:00', 'ocupado'),
    (16, NULL, '2026-11-19', '16:30:00', 'disponible'),
    -- Morales, Florencia (Ginecología)
    (17,    8, '2026-11-13', '10:30:00', 'ocupado'),
    (17, NULL, '2026-11-13', '11:00:00', 'disponible'),
    (17,   12, '2026-11-20', '10:30:00', 'ocupado'),
    (17, NULL, '2026-11-20', '11:00:00', 'disponible'),
    -- Giménez, Sebastián (Oftalmología)
    (18,    7, '2026-11-13', '15:00:00', 'ocupado'),
    (18, NULL, '2026-11-13', '15:30:00', 'disponible'),
    (18,    5, '2026-11-20', '15:00:00', 'ocupado'),
    (18, NULL, '2026-11-20', '15:30:00', 'disponible'),

    -- =================================================================
    -- DICIEMBRE 2026

    -- Fernández, Laura (Clínica Médica)
    ( 1,    4, '2026-12-01', '09:00:00', 'ocupado'),
    ( 1, NULL, '2026-12-01', '09:30:00', 'disponible'),
    ( 1,    3, '2026-12-15', '09:00:00', 'ocupado'),
    ( 1, NULL, '2026-12-15', '09:30:00', 'disponible'),
    -- Gómez, Martín (Clínica Médica)
    ( 2,   12, '2026-12-01', '14:00:00', 'ocupado'),
    ( 2, NULL, '2026-12-01', '14:30:00', 'disponible'),
    ( 2,    8, '2026-12-15', '14:00:00', 'ocupado'),
    ( 2, NULL, '2026-12-15', '14:30:00', 'disponible'),
    -- Rodríguez, Sofía (Pediatría)
    ( 3,    2, '2026-12-02', '08:00:00', 'ocupado'),
    ( 3, NULL, '2026-12-02', '08:30:00', 'disponible'),
    ( 3,   10, '2026-12-16', '08:00:00', 'ocupado'),
    ( 3, NULL, '2026-12-16', '08:30:00', 'disponible'),
    -- López, Diego (Cardiología)
    ( 4,    9, '2026-12-02', '10:00:00', 'ocupado'),
    ( 4, NULL, '2026-12-02', '10:30:00', 'disponible'),
    ( 4,    5, '2026-12-16', '10:00:00', 'ocupado'),
    ( 4, NULL, '2026-12-16', '10:30:00', 'disponible'),
    -- Martínez, Valeria (Dermatología)
    ( 5,    7, '2026-12-03', '16:00:00', 'ocupado'),
    ( 5, NULL, '2026-12-03', '16:30:00', 'disponible'),
    ( 5,    3, '2026-12-17', '16:00:00', 'ocupado'),
    ( 5, NULL, '2026-12-17', '16:30:00', 'disponible'),
    -- Pérez, Javier (Traumatología)
    ( 6,    1, '2026-12-03', '11:00:00', 'ocupado'),
    ( 6, NULL, '2026-12-03', '11:30:00', 'disponible'),
    ( 6,   11, '2026-12-17', '11:00:00', 'ocupado'),
    ( 6, NULL, '2026-12-17', '11:30:00', 'disponible'),
    -- Sánchez, Carolina (Ginecología)
    ( 7,    8, '2026-12-04', '09:00:00', 'ocupado'),
    ( 7, NULL, '2026-12-04', '09:30:00', 'disponible'),
    ( 7,    2, '2026-12-18', '09:00:00', 'ocupado'),
    ( 7, NULL, '2026-12-18', '09:30:00', 'disponible'),
    -- Romero, Pablo (Oftalmología)
    ( 8,   12, '2026-12-04', '15:00:00', 'ocupado'),
    ( 8, NULL, '2026-12-04', '15:30:00', 'disponible'),
    ( 8,    1, '2026-12-18', '15:00:00', 'ocupado'),
    ( 8, NULL, '2026-12-18', '15:30:00', 'disponible'),
    -- Acosta, Mariana (Clínica Médica)
    ( 9,    7, '2026-12-07', '08:30:00', 'ocupado'),
    ( 9, NULL, '2026-12-07', '09:00:00', 'disponible'),
    ( 9,    1, '2026-12-14', '08:30:00', 'ocupado'),
    ( 9, NULL, '2026-12-14', '09:00:00', 'disponible'),
    -- Benítez, Nicolás (Pediatría)
    (10,    6, '2026-12-09', '10:00:00', 'ocupado'),
    (10, NULL, '2026-12-09', '10:30:00', 'disponible'),
    (10,    5, '2026-12-16', '10:00:00', 'ocupado'),
    (10, NULL, '2026-12-16', '10:30:00', 'disponible'),
    -- Cabrera, Julieta (Pediatría)
    (11,    4, '2026-12-09', '14:00:00', 'ocupado'),
    (11, NULL, '2026-12-09', '14:30:00', 'disponible'),
    (11,    2, '2026-12-16', '14:00:00', 'ocupado'),
    (11, NULL, '2026-12-16', '14:30:00', 'disponible'),
    -- Domínguez, Hernán (Cardiología)
    (12,    7, '2026-12-10', '15:00:00', 'ocupado'),
    (12, NULL, '2026-12-10', '15:30:00', 'disponible'),
    (12,    6, '2026-12-17', '15:00:00', 'ocupado'),
    (12, NULL, '2026-12-17', '15:30:00', 'disponible'),
    -- Peralta, Agustina (Cardiología)
    (13,    9, '2026-12-10', '09:00:00', 'ocupado'),
    (13, NULL, '2026-12-10', '09:30:00', 'disponible'),
    (13,    4, '2026-12-17', '09:00:00', 'ocupado'),
    (13, NULL, '2026-12-17', '09:30:00', 'disponible'),
    -- Ríos, Esteban (Dermatología)
    (14,    6, '2026-12-11', '11:00:00', 'ocupado'),
    (14, NULL, '2026-12-11', '11:30:00', 'disponible'),
    (14,    1, '2026-12-18', '11:00:00', 'ocupado'),
    (14, NULL, '2026-12-18', '11:30:00', 'disponible'),
    -- Vega, Natalia (Traumatología)
    (15,    5, '2026-12-11', '09:00:00', 'ocupado'),
    (15, NULL, '2026-12-11', '09:30:00', 'disponible'),
    (15,   12, '2026-12-18', '09:00:00', 'ocupado'),
    (15, NULL, '2026-12-18', '09:30:00', 'disponible'),
    -- Navarro, Gonzalo (Traumatología)
    (16,    7, '2026-12-11', '16:00:00', 'ocupado'),
    (16, NULL, '2026-12-11', '16:30:00', 'disponible'),
    (16,    9, '2026-12-18', '16:00:00', 'ocupado'),
    (16, NULL, '2026-12-18', '16:30:00', 'disponible'),
    -- Morales, Florencia (Ginecología)
    (17,    4, '2026-12-11', '10:30:00', 'ocupado'),
    (17, NULL, '2026-12-11', '11:00:00', 'disponible'),
    (17,    6, '2026-12-18', '10:30:00', 'ocupado'),
    (17, NULL, '2026-12-18', '11:00:00', 'disponible'),
    -- Giménez, Sebastián (Oftalmología)
    (18,    2, '2026-12-11', '15:00:00', 'ocupado'),
    (18, NULL, '2026-12-11', '15:30:00', 'disponible'),
    (18,    8, '2026-12-18', '15:00:00', 'ocupado'),
    (18, NULL, '2026-12-18', '15:30:00', 'disponible');
