USE dsi_map;

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

-- idem 3, pero calculado en base al profesional
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



-- 2. traducir a SQL consultas del caso de uso solicitar turno

-- GetAll de Especialidad (paso 1)
SELECT
    idEspecialidad,
    denominacion
FROM Especialidad;

-- GetOne de Especialidad (paso 2)
SELECT
    idEspecialidad,
    denominacion
FROM Especialidad
WHERE idEspecialidad = 1;

-- todos los profesionales de una especialidad (paso 2)???
SELECT
    idProfesional,
    apellidoYNombre
FROM Profesional
WHERE idEspecialidad = 1;

-- GetOne de Profesional (paso 3)
SELECT
    pr.idProfesional,
    pr.apellidoYNombre,
    e.idEspecialidad,
    e.denominacion AS especialidad
FROM Profesional pr
INNER JOIN Especialidad e ON pr.idEspecialidad = e.idEspecialidad
WHERE pr.idProfesional = 1;

-- ---------------------------------------------------------------------
-- Traducir JPQL:
--     SELECT t FROM turno t WHERE t.miProfesional = ?1 AND t.estado = 'disponible'
-- ---------------------------------------------------------------------
-- (v1)
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

-- (v2)
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

-- Save de Turno (paso 4) (v1)
UPDATE Turno
SET idPaciente = 3,
    estado = 'ocupado'
WHERE idProfesional = 1
  AND fechaTurno = '2026-10-13'
  AND horaTurno = '10:00:00'
  AND estado = 'disponible';

-- Save de Turno (paso 4) (v2)
UPDATE Turno
SET idPAOS = 4,
    estado = 'ocupado'
WHERE idProfesional = 1
  AND fechaTurno = '2026-10-13'
  AND horaTurno = '10:00:00'
  AND estado = 'disponible';
