USE dsi_map;

-- =====================================================================
-- 1. Consultas clase (informes)

-- (v1) Informe de turnos asignados ocupados a un profesional en un rango de fechas
SELECT
    pr.idProfesional,
    pr.apellidoYNombre AS profesional,
    e.denominacion AS especialidad,
    pa.idPaciente,
    pa.apellidoYNombre AS paciente,
    os.denominacion AS obraSocial,
    t.fechaTurno,
    t.horaTurno
FROM Turno t
INNER JOIN Profesional pr ON t.idProfesional = pr.idProfesional
INNER JOIN Especialidad e ON pr.idEspecialidad = e.idEspecialidad
INNER JOIN Paciente pa ON t.idPaciente = pa.idPaciente
INNER JOIN ObraSocial os ON pa.idObraSocial = os.idObraSocial
WHERE t.idProfesional = 1
  AND t.estado = 'ocupado'
  AND t.fechaTurno BETWEEN '2026-10-13' AND '2026-10-16'
ORDER BY t.fechaTurno, t.horaTurno;

-- (v2) Informe de turnos asignados (ocupados) a un profesional en un rango de fechas
SELECT
    pr.idProfesional,
    pr.apellidoYNombre AS profesional,
    e.denominacion AS especialidad,
    pa.idPaciente,
    pa.apellidoYNombre AS paciente,
    os.denominacion AS obraSocial,
    t.fechaTurno,
    t.horaTurno
FROM Turno t
INNER JOIN Profesional pr ON t.idProfesional = pr.idProfesional
INNER JOIN Especialidad e ON pr.idEspecialidad = e.idEspecialidad
INNER JOIN PacienteObraSocial paos ON t.idPAOS = paos.idPAOS
INNER JOIN Paciente pa ON paos.idPaciente = pa.idPaciente
INNER JOIN ObraSocial os ON paos.idObraSocial = os.idObraSocial
WHERE t.idProfesional = 1
  AND t.estado = 'ocupado'
  AND t.fechaTurno BETWEEN '2026-10-13' AND '2026-10-16'
ORDER BY t.fechaTurno, t.horaTurno;

-- (v1) Para un paciente mostrar fechas de los turnos asignados y su profesional
SELECT
    t.idTurno,
    t.fechaTurno,
    t.horaTurno,
    pr.idProfesional,
    pr.apellidoYNombre AS profesional,
    e.denominacion AS especialidad
FROM Turno t
INNER JOIN Profesional pr ON t.idProfesional = pr.idProfesional
INNER JOIN Especialidad e ON pr.idEspecialidad = e.idEspecialidad
INNER JOIN Paciente pa ON t.idPaciente = pa.idPaciente
INNER JOIN ObraSocial os ON pa.idObraSocial = os.idObraSocial
WHERE t.idPaciente = 1
  AND t.estado = 'ocupado'
ORDER BY t.fechaTurno, t.horaTurno;

-- (v2) Para un paciente mostrar fechas de los turnos asignados y su profesional
SELECT
    t.idTurno,
    t.fechaTurno,
    t.horaTurno,
    pr.idProfesional,
    pr.apellidoYNombre AS profesional,
    e.denominacion AS especialidad
FROM Turno t
INNER JOIN Profesional pr ON t.idProfesional = pr.idProfesional
INNER JOIN Especialidad e ON pr.idEspecialidad = e.idEspecialidad
INNER JOIN PacienteObraSocial paos ON t.idPAOS = paos.idPAOS
WHERE paos.idPaciente = 1
  AND t.estado = 'ocupado'
ORDER BY t.fechaTurno, t.horaTurno;

-- Informe de TODA LA CLINICA de turnos totales y ocupados agrupados por mes y año
SELECT
    YEAR(t.fechaTurno) AS anio,
    MONTH(t.fechaTurno) AS mes,
    COUNT(*) AS totalTurnos,
    SUM(CASE WHEN t.estado = 'ocupado' THEN 1 ELSE 0 END) AS turnosOcupados,
    ROUND(
        SUM(CASE WHEN t.estado = 'ocupado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS porcentajeOcupacion
FROM Turno t
GROUP BY YEAR(t.fechaTurno), MONTH(t.fechaTurno)
ORDER BY anio, mes;

-- idem anterior, pero calculado en base al profesional
SELECT
    pr.idProfesional,
    pr.apellidoYNombre AS profesional,
    YEAR(t.fechaTurno) AS anio,
    MONTH(t.fechaTurno) AS mes,
    COUNT(*) AS totalTurnos,
    SUM(CASE WHEN t.estado = 'ocupado' THEN 1 ELSE 0 END) AS turnosOcupados,
    ROUND(
        SUM(CASE WHEN t.estado = 'ocupado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS porcentajeOcupacion
FROM Turno t
INNER JOIN Profesional pr ON t.idProfesional = pr.idProfesional
-- WHERE t.idProfesional = 1
GROUP BY pr.idProfesional, pr.apellidoYNombre, YEAR(t.fechaTurno), MONTH(t.fechaTurno)
ORDER BY pr.apellidoYNombre, anio, mes;


-- =====================================================================
-- 2: Traducción a SQL del caso de uso solicitar turno

-- El usuario se logea
-- (v1) Valida credenciales y obtiene el paciente junto con su única obra social
SELECT
    idPaciente,
    idObraSocial,
    apellidoYNombre,
    usuario
FROM Paciente
WHERE usuario = 'jgarcia'
  AND `contraseña` = 'jgarcia123';

-- (v2) Valida credenciales y obtiene los datos del paciente
SELECT
    idPaciente,
    apellidoYNombre,
    usuario
FROM Paciente
WHERE usuario = 'jgarcia'
  AND `contraseña` = 'jgarcia123';


-- PASO 1: El sistema muestra todas las especialidades
-- (GetAll de Especialidad)
SELECT
    idEspecialidad,
    denominacion
FROM Especialidad;


-- PASO 2: El usuario selecciona una especialidad por su id
-- (GetOne de Especialidad)
SELECT
    idEspecialidad,
    denominacion
FROM Especialidad
WHERE idEspecialidad = 1;

-- PASO v2:1: El sistema muestra todas las obras sociales del paciente
SELECT
    os.idObraSocial,
    os.denominacion
FROM PacienteObraSocial paos
INNER JOIN ObraSocial os ON paos.idObraSocial = os.idObraSocial
WHERE paos.idPaciente = 1;

-- PASO v2:2: El paciente selecciona una obra social por su id
SELECT
    paos.idPAOS,
    os.idObraSocial,
    os.denominacion
FROM PacienteObraSocial paos
INNER JOIN ObraSocial os ON paos.idObraSocial = os.idObraSocial
WHERE paos.idPaciente = 1
  AND os.idObraSocial = 1;


-- PASO 2: El sistema muestra id y nombre de los profesionales de esa especialidad
-- 2.v1: Filtrando por la única obra social que tiene el paciente
SELECT
    pr.idProfesional,
    pr.apellidoYNombre
FROM Profesional pr
INNER JOIN ProfesionalObraSocial pos ON pr.idProfesional = pos.idProfesional
INNER JOIN Paciente pa ON pos.idObraSocial = pa.idObraSocial
WHERE pr.idEspecialidad = 1
  AND pa.idPaciente = 1;

-- 2.v2: Filtrando por la obra social que el paciente eligió en el paso v2.2
SELECT
    pr.idProfesional,
    pr.apellidoYNombre
FROM Profesional pr
INNER JOIN ProfesionalObraSocial pos ON pr.idProfesional = pos.idProfesional
WHERE pr.idEspecialidad = 1
  AND pos.idObraSocial = 1;


-- PASO 3: El usuario selecciona un profesional por su id
-- (GetOne de Profesional)
SELECT
    pr.idProfesional,
    pr.apellidoYNombre,
    e.idEspecialidad,
    e.denominacion AS especialidad
FROM Profesional pr
INNER JOIN Especialidad e ON pr.idEspecialidad = e.idEspecialidad
WHERE pr.idProfesional = 1;


-- PASO 3: Traducción del JPQL y filtro por año y mes actual
-- ---------------------------------
-- JPQL:
--   SELECT t FROM Turno t WHERE t.miProfesional = ?1 AND t.estado = 'disponible'
-- ---------------------------------
-- Traducción directa del JPQL (v1):
SELECT
    t.idTurno,
    t.idProfesional,
    t.idPaciente,
    t.fechaTurno,
    t.horaTurno,
    t.estado
FROM Turno t
WHERE t.idProfesional = 1
  AND t.estado = 'disponible';

-- Traducción directa del JPQL (v2):
SELECT
    t.idTurno,
    t.idProfesional,
    t.idPAOS,
    t.fechaTurno,
    t.horaTurno,
    t.estado
FROM Turno t
WHERE t.idProfesional = 1
  AND t.estado = 'disponible';

-- el sistema filtra por año y mes actual y muestra id y fecha
SELECT
    t.idTurno,
    t.fechaTurno
FROM Turno t
WHERE t.idProfesional = 1
  AND t.estado = 'disponible'
  AND YEAR(t.fechaTurno) = YEAR(CURDATE())
  AND MONTH(t.fechaTurno) = MONTH(CURDATE())
ORDER BY t.fechaTurno;


-- PASO 4: El usuario selecciona una de las fechas disponibles y el sist. muestra horarios
SELECT
    t.idTurno,
    t.horaTurno
FROM Turno t
WHERE t.idProfesional = 1
  AND t.fechaTurno = '2026-10-13'
  AND t.estado = 'disponible'
ORDER BY t.horaTurno;


-- PASO 5: El usuario selecciona uno de los turnos por su id
-- (GetOne de Turno)
SELECT
    t.idTurno,
    t.idProfesional,
    t.fechaTurno,
    t.horaTurno,
    t.estado
FROM Turno t
WHERE t.idTurno = 3
  AND t.estado = 'disponible';


-- PASO 5: El sistema le asigna el turno seleccionado al paciente (Save de Turno)
-- 5.v1: Le carga el id del paciente el id del profesional que seleccionó y pasa a 'ocupado'
UPDATE Turno
SET idPaciente = 1,
    idProfesional = 1,
    estado = 'ocupado'
WHERE idTurno = 3
  AND estado = 'disponible';

-- 5.v2: Le carga el idPAOS el id del profesional que seleccionó y pasa a 'ocupado'
UPDATE Turno
SET idPAOS = (
        SELECT idPAOS
        FROM PacienteObraSocial
        WHERE idPaciente = 1
          AND idObraSocial = 1
    ),
    idProfesional = 1,
    estado = 'ocupado'
WHERE idTurno = 3
  AND estado = 'disponible';
