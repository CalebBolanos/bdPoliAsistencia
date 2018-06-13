SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET SQL_SAFE_UPDATES = 0;
drop database if exists BDPoliAsistencia;
create database BDPoliAsistencia;
use BDPoliAsistencia;
create table tipoPersona(
idTipo int not null primary key,
tipo nvarchar(200) not null
);
create table genero(
idGenero int not null primary key,
genero nvarchar(200) not null
);


create table personas(
idPer int not null primary key,
idTipo int not null,
idGenero int not null,
nombre nvarchar(250) not null,
paterno nvarchar(250),
materno nvarchar(250),
fecha date,
constraint idTipo_FK foreign key (idTipo)references tipoPersona(idTipo),
constraint idGenero_FK foreign key (idGenero)references genero (idGenero)
);

create table correoPersonas(
	idCorreo int not null primary key,
    correo nvarchar(300) not null,
    idPer int not null,
	foreign key(idPer) references personas(idPer)
);


create table huellas(
idHuella int not null primary key,
huella blob
);
create table perHuella(
idPerHuella int not null primary key,
idPer int not null,
idHuella int,
constraint perHuella_fk foreign key(idPer)references personas(idPer),
constraint huella_fk foreign key(idHuella)references huellas(idHuella)
);
create table contrasenas(
idContra int not null primary key,
idPer int not null,
contra nvarchar(200) not null,
constraint perContra_fk foreign key(idPer)references personas (idPer) 
);
create table turnos(
idTurno int not null primary key,
turmo nvarchar(200)
);
create table areas(
idArea int not null primary key,
area nvarchar(200) not null
);
create table Materias(
idMateria int not null primary key,
idArea int not null,
materia nvarchar(300) not null,
semestre int not null,
constraint area_fk foreign key(idArea)references areas(idArea)
);
create table estado(
idEstado int not null primary key,
estado nvarchar(200) not null
);
create table dictamen(
idDictamen int not null primary key,
valor nvarchar(50)
);
create table tipoGrupo(
idTipoG int not null primary key,
semestre int not null,
idArea int not null,
constraint areaG_fk foreign key(idArea)references areas(idArea)
);
create table MateriasTipoGrupo(
idMateriasGrupo int not null primary key,
idTipoG int not null,
idMateria int not null,
constraint materiasTIPOGp_fk foreign key(idTipoG)references tipoGrupo(idTipoG),
constraint materias_fk foreign key(idMateria)references materias(idMateria)
);
create table grupos(
idGrupo int not null primary key,
grupo nvarchar(10) not null,
idTipoGrupo int not null,
idTurno int not null,
foreign key(idTipoGrupo)references tipoGrupo(idTipoG),
foreign key(idTurno)references turnos(idTurno)
);
create table alumnos(
boleta nvarchar(15) not null,
idPer int not null,
idEstado int not null,
constraint alumnosPer_fk foreign key(idPer)references personas(idPer)
);
create table relacionAlumnosSemestre(
	idAlumno int not null,
	semestre int not null,
	constraint alumnosSemes_fk foreign key(idAlumno) references alumnos(idPer)
);
create table profesores(
numTrabajador nvarchar(40),
idPer int not null,
constraint profesoresPer_fk foreign key(idPer)references personas(idPer)
);

create table unidadesAprendizaje(
	idUnidad int not null primary key,
    idMateria int not null,
    idGrupo int not null,
    idProfesor int not null,
    cupo int,
    foreign key(idMateria) references materias(idMateria),
    foreign key(idGrupo) references grupos(idGrupo),
    foreign key(idProfesor) references personas(idPer)
);

create table grupoCupo(
	idGrupo int not null,
    cupo int not null, 
    foreign key (idGrupo) references grupos(idGrupo)
);

create table horario(
	idHorario int not null primary key,
    hora time
);

create table dias(
	idDia int not null primary key,
    dia nvarchar(20)
);

create table horariosUnidad(
	idHorarioUnidad int not null primary key,
    idUnidad int not null,
    idHorarioI int not null,
    idHorarioF int not null,
    idDia int not null,
    foreign key(idUnidad) references unidadesAprendizaje(idUnidad),
    foreign key(idHorarioI) references horario(idHorario),
    foreign key(idHorarioF) references horario(idHorario),
    foreign key(idDia) references dias(idDia)
);

create table años(
	idAño int not null primary key,
    año int
);

create table asistencia(
	idAsistencia int not null primary key,
    asistecia nvarchar(15)
);

create table mes(
	idMes int not null primary key,
    mes nvarchar(40)
);
create table unidadAlumno(
idPer int not null,
idUnidad int not null,
foreign key(idPer)references alumnos(idPer),
foreign key(idUnidad)references unidadesaprendizaje (idUnidad)
);

create table alumnosGrupo(
idPer int not null,
idGrupo int not null,
foreign key(idPer)references alumnos(idPer),
foreign key(idGrupo)references grupos(idGrupo)
);
create table asistenciaAlumnos(
	idAA int not null primary key,
	idAlumno int not null,
    idAsistencia int not null,
    dia int not null,
    idMes int not null,
    Año int not null,
    idDia int not null,
    foreign key(idAlumno) references personas(idPer),
    foreign key(idAsistencia) references asistencia(idAsistencia),
    foreign key(idMes) references mes(idMes),
    foreign key(idDia) references dias(idDia)
);

create table HoraEntrada(
idAsistencia int not null,
hora time,
foreign key (idAsistencia)references asistenciaalumnos(idAa)
);
create table HoraSalida(
idAsistencia int not null,
hora time,
foreign key (idAsistencia)references asistenciaalumnos(idAa)
);

create table Imagenes(
idImg int not null primary key,
img nvarchar(200) not null
);

create table relImg(
idImg int not null,
idPer int not null
);
create table asistenciaMaestros(
	idAM int not null primary key,
	idProfesor int not null,
    idAsistencia int not null,
    dia int not null,
    idMes int not null,
    Año int not null,
    idDia int not null,
    foreign key(idProfesor) references personas(idPer),
    foreign key(idAsistencia) references asistencia(idAsistencia),
    foreign key(idMes) references mes(idMes),
    foreign key(idDia) references dias(idDia)
);
create table HoraEntradaMa(
idAsistencia int not null,
hora time,
foreign key (idAsistencia)references asistenciaMaestros(idAM)
);
create table HoraSalidaMa(
idAsistencia int not null,
hora time,
foreign key (idAsistencia)references asistenciaMaestros(idAM)
);

create table TipoNotificacion(
idTipoN int not null primary key,
tipoN nvarchar(100)
);

create table imgNotificaciones(
idImg int not null primary key,
Img nvarchar(200) not null
);

drop table if exists notificaciones;
create table notificaciones(
idNoti int not null primary key,
idTipoN int not null,
idPer int not null,
titulo nvarchar(100),
info nvarchar(250),
fecha date,
url nvarchar(300),
foreign key(idTipoN) references TipoNotificacion(idTipoN),
foreign key(idPer) references personas(idPer)
);

create table relImgNot(
idImg int not null,
idNot int not null
);
## getion; jefe de academia;

create table correoValidado(
	idPersona int,
	validado int, ##0 no registrado, 1 registrado pero no validado, 2 registrado y validado
    foreign key (idPersona) references personas(idPer)
);


create table codigoCorreoValidacion	(
	idCorreo int not null,
    validacion nvarchar(16),
    foreign key(idCorreo) references correoPersonas(idCorreo)
);
