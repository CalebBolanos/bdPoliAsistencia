## views

drop view if exists vwPersonas;
create view vwPersonas as
select p.idPer 'idPersona',  p.idTipo, t.tipo, p.paterno,p.materno, p.nombre ,g.genero, p.fecha,p.correo from Personas p
	inner join genero g on g.idGenero = p.idGenero
    inner join tipopersona t on t.idTipo = p.idTipo
group by p.idPer;
select * from vwPersonas;

drop view if exists vwAlumnos;
create view vwAlumnos as
select vwP.*,a.boleta,e.estado, re.semestre from vwPersonas vwP
	inner join alumnos a on a.idPer = vwP.idPersona
    inner join estado e on e.idEstado = a.idEstado 
    inner join relacionalumnossemestre re on re.idAlumno = a.idPer
where vwP.idTipo = 2
group by vwP.idPersona;
select * from vwAlumnos;

drop view if exists vwAsistencia;
create view vwAsistencia as
select A.asistecia, concat(d.dia,'\t',Aa.dia) as dia, HE.hora as 'Hora de entrada',HS.hora as 'Hora de salida', aa.idAlumno,aa.idMes from asistenciaalumnos Aa
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join horaentrada HE on HE.idAsistencia = Aa.idAA
    inner join horasalida HS on HS.idAsistencia = Aa.idAA
    inner join dias d on d.idDia = aa.idDia
group by Aa.idAA
order by Aa.idAA;
use bdpoliasistencia;
select * from vwAsistencia;
drop view if exists vwAsistenciaMa;
create view vwAsistenciaMa as
select A.asistecia, concat(d.dia,'\t',Aa.dia) as dia, HE.hora as 'Hora de entrada',HS.hora as 'Hora de salida', aa.idProfesor,aa.idMes from asistenciaMaestros Aa
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join horaentradaMa HE on HE.idAsistencia = Aa.idAM
    inner join horaentradama HS on HS.idAsistencia = Aa.idAM
    inner join dias d on d.idDia = aa.idDia
group by Aa.idAM
order by Aa.idAM;

drop view if exists vwAlumnosConGrupo;
create view vwAlumnosConGrupo as
select vwP.*,a.boleta,e.estado, re.semestre, gr.grupo from vwPersonas vwP
	inner join alumnos a on a.idPer = vwP.idPersona
    inner join estado e on e.idEstado = a.idEstado
    inner join relacionalumnossemestre re on re.idAlumno = a.idPer
    inner join alumnosGrupo gru on gru.idPer = a.idPer
    inner join grupos gr on gr.idGrupo = gru.idGrupo
where vwP.idTipo = 2
group by vwP.idPersona;
select * from vwAlumnosConGrupo;

drop view if exists vwTrabajadores;
create view vwTrabajadores as
select vwP.*,p.numTrabajador from vwPersonas vwP
	inner join profesores p on p.idPer = vwP.idPersona
where vwP.idTipo = 3 or 4 or 5
group by vwP.idPersona;
select * from vwTrabajadores;


drop view if exists vwHuellasPersonas;
create view vwHuellasPersonas as
select vwP.idPersona,vwP.idTipo,vwP.nombre,h.idHuella,h.huella from vwPersonas vwP
	inner join perhuella ph on ph.idPer = vwP.idPersona
    inner join huellas h on h.idHuella = ph.idHuella
group by ph.idHuella;
select * from vwHuellasPersonas;
update personas set idTipo = 4 where idPer = 10;
drop view if exists vwUnidadesHorarios;
create view vwUnidadesHorarios as
select ua.idUnidad, hu.idHorarioUnidad, m.materia, m.semestre, pro.numTrabajador, concat(per.nombre, ' ', per.paterno, ' ', per.materno) as Nombre,
  ua.idProfesor, gru.grupo, ua.idGrupo, ua.cupo, hu.idHorarioI,hu.idHorarioF,hu.idDia from horariosunidad hu
	inner join unidadesaprendizaje ua on ua.idUnidad = hu.idUnidad
    inner join materias m on m.idMateria = ua.idMateria
    inner join profesores pro on pro.idPer = ua.idProfesor
    inner join grupos gru on gru.idGrupo = ua.idGrupo
    inner join personas per on per.idPer = ua.idProfesor
order by hu.idUnidad;
select * from vwunidadeshorarios;
select * from vwunidadeshorarios where idProfesor <0;
drop view if exists vwGrupos;
create view vwGrupos as
select g.idGrupo, g.grupo, t.turmo, tp.semestre, a.area, g.idTurno, tp.idArea from grupos g
	inner join turnos t on t.idTurno = g.idTurno
    inner join tipogrupo tp on tp.idTipoG = g.idTipoGrupo
    inner join areas a on a.idArea = tp.idArea
order by g.idGrupo;
select * from vwGrupos where semestre >= 3 and semestre <=5 order by semestre;
select * from vwunidadeshorarios;
drop view if exists vwGruposConCupo;
create view vwGruposConCupo as
select g.idGrupo, g.grupo, t.turmo, tp.semestre, a.area, g.idTurno, tp.idArea, gc.cupo from grupos g
	inner join turnos t on t.idTurno = g.idTurno
    inner join tipogrupo tp on tp.idTipoG = g.idTipoGrupo
    inner join areas a on a.idArea = tp.idArea
    inner join grupocupo gc on gc.idGrupo = g.idGrupo
order by g.idGrupo;
select * from vwGruposConCupo;
select * from grupocupo;
drop view if exists vwMaterias;
create view vwMaterias as select
m.idMateria, m.materia, m.semestre, a.area, m.idArea from materias m
	inner join areas a on a.idArea = m.idArea
order by m.semestre, m.idArea, m.materia;
select * from vwMaterias;

drop view if exists vwHorarioAlumnos;
create view vwHorarioAlumnos as
select vwUH.*, vwA.boleta from vwunidadeshorarios vwUH
    inner join vwalumnoscongrupo vwA on vwA.grupo = vwUH.grupo
    where vwA.grupo != 'Sin grupo'
    order by boleta;
select * from vwHorarioAlumnos;

## Functions
drop procedure if exists fGuardaHuella;
delimiter **
create procedure fGuardaHuella(idP int, hu blob)
begin
declare idHu,idPH,existe int;
declare msj nvarchar(100);
set existe = (select count(*) from perhuella where idPer = idP);
if existe = 0 then
	set idHu = (select ifnull(max(idHuella),0)+1 from huellas);
	set idPH = (select ifnull(max(idPerHuella),0)+1 from perhuella);
    insert into huellas values(idHu,hu);
    insert into perhuella values(idPH,idP, idHu);
    set msj = 'ok';
else 
	set msj='ya existe un registro';
end if;
select msj;
end; **
delimiter ;
drop procedure if exists spModificaHuella;
delimiter **
create procedure spModificaHuella(idP int, hu longblob)
begin
declare idHu,idPH,existe int;
declare msj nvarchar(100);
	set idHu = (select idHuella from perHuella);
    update huellas set huella = hu where idHuella = idHu;
    set msj = 'ok';
select msj;
end; **
delimiter ;
select * from vwHuellasPersonas;
drop function if exists fCambiaPsw;
delimiter **
create function fCambiaPsw(idP int, pswA nvarchar(200), psw nvarchar(200)) returns nvarchar(100)
begin
declare msj nvarchar(100);
declare existe int;
set existe = (select count(*)from contrasenas where idPer = idP and contra = md5(pswA));
	if existe = 1 then
		update contrasenas set contra = md5(psw) where idPer = idP;
		set msj = 'ok';
	else
		set msj = 'psw incorrecto';
    end if;
return msj;
end; **
delimiter ;

drop function if exists fEntrada;
delimiter **
create function fEntrada(idAl int)  returns nvarchar(200)
begin 
declare msj nvarchar(200);
declare ida int;

set ida = (select ifnull(max(idAA),0)+1 from asistenciaalumnos);
insert into asistenciaalumnos values(ida,idAl,1,day(now()),(month(now())),year(now()),(dayofweek(now()))-1);
insert into horaentrada values(ida,time(now()));
set msj = 'entrada ok';

return msj;
end; **
delimiter ;
drop function if exists fSalida;
delimiter **
create function fSalida(idAl int, ida int)  returns nvarchar(200)
begin 
declare msj nvarchar(200);

insert into horasalida values(ida,time(now()));

set msj = 'salida ok';
return msj;
end; **
delimiter ;

drop function if exists fEntradaMa;
delimiter **
create function fEntradaMa(idMa int)  returns nvarchar(200)
begin 
declare msj nvarchar(200);
declare ida int;

set ida = (select ifnull(max(idMa),0)+1 from asistenciaMaestros);
insert into asistenciaMaestros values(ida,idMa,1,day(now()),(month(now())),year(now()),(dayofweek(now()))-1);
insert into horaentradaMa values(ida,time(now()));
set msj = 'entrada ok';

return msj;
end; **
delimiter ;
drop function if exists fSalidaMa;
delimiter **
create function fSalidaMa(idMa int, ida int)  returns nvarchar(200)
begin 
declare msj nvarchar(200);

insert into horasalidaMa values(ida,time(now()));

set msj = 'salida ok';
return msj;
end; **
delimiter ;


##select fGuardaHuella(1,'nlasdjkflaksdjgflakenlacjnasjkdnf');
##insert into personas values(idP,2,g,nom,pat,mat,fech,mail);
select * from personas;
drop procedure if exists spGuardaAlumnos;
delimiter **
create procedure spGuardaAlumnos(in g int, in pat nvarchar(250),in mat nvarchar(250), in nom nvarchar(250), in fech date, in mail nvarchar(250),in bol nvarchar(15),in edo int)
begin
declare existe,idP,idC int;
declare msj nvarchar(200);

set existe = (Select count(*) from alumnos where boleta = bol);
if (existe = 0) then 
	set idP = (Select ifnull(max(idPer),0) +1 from personas);
    set idC = (Select ifnull(max(idContra),0) +1 from contrasenas);
    insert into personas values(idP,2,g,nom,pat,mat,fech,mail);
    insert into alumnos values(bol,idP,edo);
    insert into contrasenas values(idC,idP,md5(pat));
    insert into relacionalumnossemestre value(idP, 1);
    insert into alumnosgrupo value(idP, -1);
    set msj = 'Ok';
else
	set msj = 'Ya existe un usuario con esa boleta';
    set idP = 0;
end if;
Select msj,idP;
end; **
delimiter ;
drop procedure if exists spGuardaDocente;
delimiter **
create procedure spGuardaDocente(in idT int,in g int, in pat nvarchar(250),in mat nvarchar(250), in nom nvarchar(250), in fech date, in mail nvarchar(250),in numT nvarchar(15))
begin
declare existe,idP,idC int;
declare msj nvarchar(200);

set existe = (Select count(*) from profesores where numTrabajador = numT);
if (existe = 0) then 
	set idP = (Select ifnull(max(idPer),0) +1 from personas);
    set idC = (Select ifnull(max(idContra),0) +1 from contrasenas);
    insert into personas values(idP,idT,g,nom,pat,mat,fech,mail);
    insert into profesores values(numT,idP);
    insert into contrasenas values(idC,idP,md5(pat));
else
	set msj = 'Ya existe un usuario con ese numero de trabajador';
    set idP = 0;
end if;
Select msj,idP;
end; **
delimiter ;
drop procedure if exists spValidaUsr;
delimiter **
create procedure spValidaUsr(in identificador nvarchar(40), in psw nvarchar(60)) 
begin 
declare existe,idP, idT int;
declare msj nvarchar(250);
set existe = (select count(*) from alumnos where boleta = identificador);
if existe = 1 then
	set idP = (select idPer from alumnos where boleta = identificador);
	set idT = (select idTipo from personas where idPer = idP);
	set existe = (select count(*) from contrasenas where idPer = idP and contra = md5(psw) );
	if existe = 1 then
		set msj = 'ok';
	else
		set idT = 0;
		set idP = 0;
		set msj = 'usuario o psw incorrecto';
	end if;
else
	set existe = (select count(*) from profesores where numTrabajador = identificador);
	if existe = 1 then
		set idP = (select idPer from profesores where numTrabajador = identificador );
		set idT = (select idTipo from personas where idPer = idP);
		set existe = (select count(*) from contrasenas where idPer = idP and contra = md5(psw) );
		if existe = 1 then
			set msj = 'ok';
		else
			set idT = 0;
			set idP = 0;
			set msj = 'usuario o psw incorrecto';
		end if;
	else
		set idT = 0;
		set idP = 0;
		set msj = 'usuario o psw incorrecto';
	end if;
end if;
select idP, msj, idT;
end; **
delimiter ;
drop procedure if exists sptraerDatos;
delimiter :v
create procedure sptraerDatos(in bolet nvarchar(20), in llave nvarchar(20))
begin
declare nom, pat, mat, bol, fec, gen, semest nvarchar(200);
declare existe int;
if(llave = 'Pol')
then
	set existe = (select count(*) from alumnos where boleta = bolet);
    if existe > 0
    then 
		set nom = (select nombre from vwalumnos where boleta = bolet);
        set pat = (select paterno from vwalumnos where boleta = bolet);
        set mat = (select materno from vwalumnos where boleta = bolet);
        set gen = (select genero from vwalumnos where boleta = bolet);
        set fec = (select fecha from vwalumnos where boleta = bolet);
        set bol = bolet;
        set semest = (select semestre from vwalumnos where boleta = bolet);
	end if;
else
	set existe = 0;
end if;

select nom, pat, mat, gen, bol, fec, existe, semest;
end; :v
delimiter ;
drop procedure if exists spTraerGrupoAlumno;
delimiter :v

create procedure spTraerGrupoAlumno(in bol nvarchar(200))
begin
	declare existe int;
    declare grup, turn, semes, are, msj nvarchar(200);
    set existe = (select count(*) from vwalumnos where boleta = bol);
    if existe >0 then
		set existe = (select count(*) from vwalumnoscongrupo where boleta = bol);
        if existe > 0 then
			set grup = (select grupo from vwalumnoscongrupo where boleta = bol);
            set turn = (select turmo from vwgrupos where grupo = grup);
            set semes = (select semestre from vwgrupos where grupo = grup);
            set are = (select area from vwgrupos where grupo = grup);
            set msj = 'Todo correcto';
        else
			set msj = 'No tiene grupo';
        end if;
    else
		set msj = 'No existe el alumno';
    end if;
    select grup, turn, semes, are, msj;
end; :v
delimiter ;

drop procedure if exists sptraerDatosProf;
delimiter :v
create procedure sptraerDatosProf(in bolet nvarchar(20), in llave nvarchar(20))
begin
declare nom, pat, mat, bol, fec, gen nvarchar(200);
declare existe int;
if(llave = 'Pol')
then
	set existe = (select count(*) from profesores where numTrabajador = bolet);
    if existe > 0
    then 
		set nom = (select nombre from vwtrabajadores where numTrabajador = bolet);
        set pat = (select paterno from vwtrabajadores where numTrabajador = bolet);
        set mat = (select materno from vwtrabajadores where numTrabajador = bolet);
        set gen = (select genero from vwtrabajadores where numTrabajador = bolet);
        set fec = (select fecha from vwtrabajadores where numTrabajador = bolet);
        set bol = bolet;
	end if;
else
	set existe = 0;
end if;

select nom, pat, mat, gen, bol, fec, existe;
end; :v
delimiter ;

drop procedure if exists spEditaAlumno;
delimiter $$
create procedure spEditaAlumno(in Nnombre nvarchar(250), in Npaterno nvarchar(250), in Nmaterno nvarchar(250), in Nfecha date, in Nboleta nvarchar(15), in Aboleta nvarchar(15))
begin
	declare idP, existe int;
    declare msj nvarchar(100);
    set existe= (select count(*) from alumnos where boleta=Aboleta);
    set idP = 0;
    if existe=1 then
		set existe=(select count(*) from alumnos where boleta=Nboleta);
        if (existe=0 or Aboleta = NBoleta)then
			set idP=(select idPer from alumnos where boleta=Aboleta);
			update personas set nombre=Nnombre, paterno=Npaterno, materno=Nmaterno, fecha=Nfecha where idPer = idP;
			update alumnos set boleta=Nboleta where idPer = idP;
			set msj='Datos del alumno actualizados';
		else
			set msj='Ya hay un alumno registrado con la nueva boleta';
        end if;
    else
		set msj='La boleta ingresada no corresponde a ningun alumno registrado';
    end if;
    select msj, idP;
end;$$
delimiter ;
drop procedure if exists spEditaProfesor;
delimiter **
create procedure spEditaProfesor(in idmal nvarchar(15),in idBien nvarchar(15),in nom nvarchar(200),in pat nvarchar(200),in mat nvarchar(200),in fech date)
begin
declare existe,idP int;
declare msj nvarchar(200);
set existe = (select count(*) from profesores where numTrabajador = idmal );
set idP = 0;
if existe = 1 then
	set existe = (select count(*) from profesores where numTrabajador = idBien);
    if(existe = 0 or idmal = idBien) then
		set idP = (select idPer from profesores where numTrabajador = idmal);
		update personas set nombre = nom, paterno = pat, materno = mat, fecha = fech where idPer = idP;
		update profesores set numTrabajador = idBien where idPer = idP;
		set msj = 'ok';
	else
		set msj = 'Ya existe un profesor con ese número de trabajador';
    end if;
else
		set msj = 'No se encuentra la persona';
end if;
select msj, idP;
end; **
delimiter ;
drop procedure if exists spEditaGrupo;
delimiter **
create procedure spEditaGrupo(in nomAnt nvarchar(15),in nomNue nvarchar(15),in semes int,in idAre int,in idTur int)
begin
declare existe,idP, idT int;
declare msj nvarchar(200);
set idP = 0;
set existe = (select count(*) from grupos where grupo = nomAnt);
if existe = 1 then
	set existe = (select count(*) from grupos where grupo = nomNue);
	if (existe = 0 or nomAnt = nomNue) then
		set idP = (select idGrupo from grupos where grupo = nomAnt);
        set existe = (select count(*) from tipoGrupo where (semestre = semes and idArea = idAre));
		if existe > 0 then
			set idT = (select idTipoG from tipoGrupo where (semestre = semes and idArea = idAre));
		else
			set idT = (select ifnull(max(idTipoG),0) +1 from tipogrupo);
			insert into tipogrupo value(idT, semes, idAre);
		end if;
		update grupos set grupo = nomNue, idTipoGrupo = idT, idTurno = idTur where idGrupo = idP;
		set msj = 'ok';
    else
		set msj = 'Ya existe un grupo con ese nombre';
    end if;
else
		set msj = 'No se encuentra el grupo';
end if;
select msj, idP;
end; **
delimiter ;
drop procedure if exists spEditaMateria;
delimiter **
create procedure spEditaMateria(in nomAnt nvarchar(15),in nomNue nvarchar(15),in semes int,in idAre int)
begin
declare existe,idP, idT int;
declare msj nvarchar(200);
set idP = 0;
set existe = (select count(*) from materias where materia = nomAnt);
if existe = 1 then
	set existe = (select count(*) from materia where materia = nomNue);
	if (existe = 0 or nomAnt = nomNue) then
		set idP = (select idMateria from materias where materia = nomAnt);
		update materias set materia = nomNue, idArea = idAre, semestre = semes where idMateria = idP;
		set msj = 'ok';
    else
		set msj = 'Ya existe una unidad con ese nombre';
    end if;
else
		set msj = 'No se encuentra la unidad';
end if;
select msj, idP;
end; **
delimiter ;
call spEditaGrupo('1234', '1234', 2, 1, 1);
drop procedure if exists spContrasenas;
delimiter **
create procedure spContrasenas(in T int,in identificador nvarchar(20),in pswA nvarchar(60),in pswN nvarchar(60))
begin
declare existe, idP int;
declare msj nvarchar(200);

case
	when T = 1 then
		set existe = (select count(*) from profesores where numTrabajador = identificador);
        if existe = 1 then
			set idP = (select idPer from profesores where numTrabajador = identificador );
			set msj = (select fCambiaPsw(idP,pswA, pswN));
        else
			set msj = 'Numero de trabajador invalido';
            set idP= 0;
        end if;
	when T = 2 then
		set existe= (select count(*) from alumnos where boleta= identificador);
		if existe = 1 then
			set idP = (select idPer from alumnos where boleta=identificador);
			set msj = (select fCambiaPsw(idP,pswA, pswN));
        else
			set msj = 'Numero de boleta invalido invalido';
            set idP= 0;
        end if;
	when T = 3 then
		set existe = (select count(*) from profesores where numTrabajador = identificador);
        if existe = 1 then
			set idP = (select idPer from profesores where numTrabajador = identificador );
			set msj = (select fCambiaPsw(idP,pswA, pswN));
        else
			set msj = 'Numero de trabajador invalido';
            set idP= 0;
        end if;
	when T = 4 then
		set existe = (select count(*) from profesores where numTrabajador = identificador);
        if existe = 1 then
			set idP = (select idPer from profesores where numTrabajador = identificador );
			set msj = (select fCambiaPsw(idP,pswA, pswN));
        else
			set msj = 'Numero de trabajador invalido';
            set idP= 0;
        end if;
	when T = 5 then
		set existe = (select count(*) from profesores where numTrabajador = identificador);
        if existe = 1 then
			set idP = (select idPer from profesores where numTrabajador = identificador );
			set msj = (select fCambiaPsw(idP,pswA, pswN));
        else
			set msj = 'Numero de trabajador invalido';
            set idP= 0;
        end if;
	else
		set msj = 'Tipo de persona invalido';
end case;

select msj;
end; **
delimiter ;


drop procedure if exists spMateriasProfesor;
delimiter **
create procedure spMateriasProfesor(in numT nvarchar(20),in sem int,in mat int,in lun int,in mar int,in mie int,in jue int,in vie int,in turn int,in h1 int,in h2 int,in h3 int,in h4 int,in h5 int,in hf1 int,in hf2 int,in hf3 int,in hf4 int,in hf5 int)
begin 
declare existe,idP,idU int;
declare msj nvarchar(200);

set existe = (select count(*) from profesores where numTrabajador = numT);

if existe = 1 then
	set idP = (select idPer from profesores where numTrabajador = numT);
    set idU = (select ifnull(max(idUnidad),0)+1 from unidadesaprendizaje);
    insert into unidadesaprendizaje values(idU,mat,0,idP,50);
    set existe = (select ifnull(max(idHorarioUnidad),0)+1 from horariosUnidad);
    if lun = 1 then
		insert into horariosunidad values((existe),idU,h1,hf1,1);
        set existe = (Select ifnull(max(idHorarioUnidad),0)+1 from horariosUnidad);
        set msj = 'ok';
    end if;
    
    if mar = 1 then
		insert into horariosunidad values((existe),idU,h2,hf2,2);
        set existe = (Select ifnull(max(idHorarioUnidad),0)+1 from horariosUnidad);
        set msj = 'ok';
    end if;
    
    if mie = 1 then
		insert into horariosunidad values((existe),idU,h3,hf3,3);
        set existe = (Select ifnull(max(idHorarioUnidad),0)+1 from horariosUnidad);
        set msj = 'ok';
    end if;
    
    if jue = 1 then
		insert into horariosunidad values((existe),idU,h4,hf4,4);
        set existe = (Select ifnull(max(idHorarioUnidad),0)+1 from horariosUnidad);
        set msj = 'ok';
    end if;
    
    if vie = 1 then
		insert into horariosunidad values((existe),idU,h5,hf5,5);
        set msj = 'ok';
    end if;
    
else
	set msj = 'No existe el profesor';
end if;

select msj;

end; **
delimiter ;

drop procedure if exists spGuardaAlumnosUnidades;
delimiter **
create procedure spGuardaAlumnosUnidades(in bol nvarchar(20), in unidad int)
begin
declare existe,idP, getSemes int;
declare msj nvarchar(200);

set existe = (select count(*) from alumnos where boleta = bol);

if existe = 1 then
	set idP = (select idPer from alumnos where boleta = bol);
    set getSemes = (select semestre from vwunidadeshorarios where idUnidad = unidad);
    insert into unidadAlumno values(idP,unidad);
    update alumnos set estado = 2 where idPer = idP;
    update relacionalumnossemestre set semestre = getSemes where idAlumno = idP;    
    set msj = 'ok';
else
	set msj = 'no se encuetra la boleta';
end if;

select msj;
end ; **
delimiter ;

drop procedure if exists spGuardaAlumnosGrupo;
delimiter **
create procedure spGuardaAlumnosGrupo(in bol nvarchar(20), in nom nvarchar(10))
begin
declare existe,idP, getSemes, resta, gru int;
declare msj nvarchar(200);
set gru = (select idGrupo from grupos where grupo = nom);
set existe = (select count(*) from alumnos where boleta = bol);

if existe = 1 then
	set idP = (select idPer from alumnos where boleta = bol);
    set getSemes = (select semestre from vwgrupos where grupo = nom);
    set resta = (select cupo from grupocupo where idGrupo = gru)-1;
    set existe = (select count(*) from alumnosgrupo where idPer = idP);
    if existe = 0 then
		insert into alumnosGrupo values(idP,gru);
	else
		update alumnosgrupo set idGrupo = gru where idPer = idP;
    end if;
    update relacionalumnossemestre set semestre = getSemes where idAlumno = idP; 
    update alumnos set idEstado = 1 where idPer = idP;
    update grupocupo set cupo = resta where idGrupo = gru;
    set msj = 'ok';
else
	set msj = 'no se encuetra la boleta';
end if;

select msj;
end ; **
delimiter ;
call spGuardaAlumnosGrupo('2016090484','1IM3');
drop procedure if exists spNuevoGrupo;
delimiter :v
create procedure spNuevoGrupo(in nombreGrupo nvarchar(10), in semes int, in idAr int, in idTur int)
begin
declare existe, idN, idTi int;
declare msj nvarchar(100);
set existe = (select count(*) from grupos where grupo = nombreGrupo);
set idN = 0;
if existe = 0 then
	set existe = (select count(*) from tipoGrupo where (semestre = semes and idArea = idAr));
    if existe > 0 then
		set idTi = (select idTipoG from tipoGrupo where (semestre = semes and idArea = idAr));
    else
		set idTi = (select ifnull(max(idTipoG),0) +1 from tipogrupo);
        insert into tipogrupo value(idTi, semes, idAr);
    end if;
    set idN = (select ifnull(max(idGrupo),0)+1 from grupos);
    insert into grupos value(idN, nombreGrupo, idTi, idTur);
else
	set msj = 'Grupo existente';
end if;
select idN, msj;
end; :v
delimiter ;
drop procedure if exists spNuevaUnidad;
delimiter :v
create procedure spNuevaUnidad(in mat nvarchar(200), in cup int)
begin
declare existe, idN, idMat int;
declare msj nvarchar(100);
set idN = 0;
set existe = (select count(*) from materias where materia = mat);
if existe > 0 then 
	if (cup>0 or cup<300) then
		set idMat = (select idMateria from materias where materia = mat);
        set idN = (select ifnull(max(idUnidad),0)+1 from unidadesaprendizaje);
        insert into unidadesaprendizaje value(idN, idMat,-1,-1, cup);
        set msj = 'Todo bien';
	else
		set msj = 'Introduzca un cupo positivo no excedente de 300';
    end if;
else
	set msj ='No existe la materia';
end if;
select idN, msj;
end;:v
delimiter ;
drop procedure if exists spUnidadHorario;
delimiter :v
create procedure spUnidadHorario(in idUnid int, in idHorI int, in idHorF int, in idDi int)
begin
declare existe, idN, idMat int;
declare msj nvarchar(100);
set idN = 0;
set existe = (select count(*) from unidadesaprendizaje where idUnidad = idUnid);
if existe > 0 then 
	if idHorI < idHorF then
        set idN = (select ifnull(max(idHorarioUnidad),0)+1 from horariosUnidad);
        insert into horariosunidad value(idN, idUnid, idHorI, idHorF, idDi);
        set msj = 'Registro con exito';
    else
		set msj = 'No se puede seleccionar una hota de inicio depues de la final';
    end if;
else 
	set msj = 'No existe la unidad';
end if;
select idN, msj;
end; :v
delimiter ;
drop procedure if exists spNuevaMateria;
describe materias;
delimiter :v
create procedure spNuevaMateria(in idAr int, in nomMat nvarchar(300), in semes int(11))
begin
declare existe, idN int;
declare msj nvarchar(199);
set idN = 0;
set existe = (select count(*) from materias where materia = nomMat);
if existe = 0 then
	set existe = (select count(*) from areas where idArea = idAr);
    if existe > 0 then
		set idN = (select ifnull(max(idMateria),0)+1 from materias);
        insert into materias value(idN, idAr, nomMat, semes);
        set msj = 'Registro con exito';
    else
		set msj = 'No existe el área';
    end if;
else
	set msj = 'Ya existe una unidad con el mismo nombre';
end if;
select idN, msj;
end; :v
delimiter ;

drop procedure if exists spGuardaUnidadesProfesor;
delimiter **
create procedure spGuardaUnidadesProfesor(in unidad int, in profesor nvarchar(200))
begin
declare existe, idPr int;
declare msj nvarchar(200);

set existe = (select count(*) from unidadesaprendizaje where idUnidad = unidad);

if existe = 1 then
	set idPr = (select idPer from profesores where numTrabajador = profesor);
	update unidadesaprendizaje set idProfesor = idPr where idUnidad = unidad;
    set msj = 'ok';
else
	set msj = 'no se encuetra el grupo';
end if;

select msj;
end ; **
delimiter ;
drop procedure if exists spGuardaUnidadesGrupo;
delimiter **
create procedure spGuardaUnidadesGrupo(in unidad int, in profesor nvarchar(100))
begin
declare existe, idPr, cupG, cupU int;
declare msj nvarchar(200);

set existe = (select count(*) from unidadesaprendizaje where idUnidad = unidad);

if existe = 1 then
	set idPr = (select idGrupo from grupos where grupo = profesor);
    set cupU = (select cupo from unidadesaprendizaje where idUnidad = unidad);
    set existe = (select count(*) from grupocupo where idGrupo = idPr);
    if existe = 0 then
		insert into grupocupo value (idPr, cupU);
    end if;
    set cupG = (select cupo from grupocupo where idGrupo = idPr);
    if cupU < cupG then
		update grupoCupo set cupo = cupU where idGrupo = idPr;
    end if;
	update unidadesaprendizaje set idGrupo = idPr where idUnidad = unidad;
    set msj = 'ok';
else
	set msj = 'no se encuetra el grupo';
end if;

select msj;
end ; **
delimiter ;

drop procedure if exists spBorraProfesorHorario;
delimiter :v
create procedure spBorraProfesorHorario(in idUni int, in numTrab nvarchar(200))
begin
declare existe, idPr int;
declare msj nvarchar(199);
set existe = (select count(*) from unidadesaprendizaje where idUnidad = idUni);
if existe >0 then 
	set idPr = (select idPer from profesores where numTrabajador = numTrab);
	update unidadesaprendizaje set idProfesor = -1 where (idProfesor = idPr and idUnidad = idUni);
    set msj = 'ok';
else
	set msj = 'No se pudo quitar el profesor de su horario';
end if;
select msj;
end; :v
delimiter ;
drop procedure if exists spDarDeBaja;
delimiter :v
create procedure spDarDeBaja(in bol nvarchar(200))
begin
declare existe int;
declare msj nvarchar(200);
set existe = (select count(*) from alumnos where boleta = bol);
if existe >0 then
	update alumnos set idEstado = 3 where boleta = bol;
    set msj = 'OK';
else
	set msj = 'No existe';
end if;
select msj;
end; :v
delimiter ;
drop procedure if exists spBorraGrupoHorario;
delimiter :v
create procedure spBorraGrupoHorario(in idUni int, in numTrab nvarchar(100))
begin
declare existe, idPr int;
declare msj nvarchar(199);
set existe = (select count(*) from unidadesaprendizaje where idUnidad = idUni);
if existe >0 then 
	set idPr = (select idGrupo from grupos where grupo = numTrab);
	update unidadesaprendizaje set idGrupo = -1 where (idGrupo = idPr and idUnidad = idUni);
    set msj = 'ok';
else
	set msj = 'No se pudo quitar el profesor de su horario';
end if;
select msj;
end; :v
delimiter ;

drop procedure if exists spGruposPorAlumno;
delimiter :v
create procedure spGruposPorAlumno(in bol nvarchar(100))
begin
declare existe, idPr, sem, contador int;
declare msj nvarchar(199);
set idPr = (select idPer from alumnos where boleta = bol);
set sem = (select semestre from relacionalumnossemestre where idAlumno = idPr);
select * from vwgruposconcupo where semestre >= sem and cupo>0 order by semestre; 
end; :v
delimiter ;

drop procedure if exists spAsistencia;
delimiter **
create procedure spAsistencia(in idP int)
begin
declare msj nvarchar(200);
declare idT,existe,existee int;
set existe = (select count(*) from alumnos where idPer = idP);
if existe = 1 then
	set existee = (select count(*)from asistenciaalumnos where idAlumno= idP and dia = DAY(NOW()) and idmes= month(now()) );
    if existee = 0 then
		set msj = (select fEntrada(idP));
    else
		set idT = (select max(idAA) from asistenciaalumnos where idAlumno = idP and dia = DAY(NOW()) and idmes= month(now()));
		set existee = (select count(*) from horasalida where idAsistencia = idT);
        if existee = 1 then
			set msj = (select fEntrada(idP));
        else
			set msj = (select fsalida (idP,idT));
        end if;
    end if;
else
	set existe = (select count(*) from profesores where idPer = idP);
    if existe = 1 then
		set existee = (select count(*)from asistenciamaestros where idProfesor= idP and dia = DAY(NOW()) and idmes= month(now()) );
		if existee = 0 then
			set msj = (select fEntradaMa(idP));
		else
			set idT = (select max(idAM) from asistenciamaestros where idProfesor = idP and dia = DAY(NOW()) and idmes= month(now()));
			set existee = (select count(*) from horasalidaMa where idAsistencia = idT);
            if existee = 1 then
				set msj = (select fEntradaMa(idP));
			else
				set msj = (select fsalidaMa(idP,idT));
			end if;
        end if;
	else
		set msj = 'no se encuentra el registro';
    end  if;
end if;

select msj;
end;**
delimiter ;

drop procedure if exists spConsultaA;
delimiter **
create procedure spConsultaA(in idAl int, in mes int)
begin

select * from vwasistencia where idalumno = idAl and idMes = mes;

end; **
delimiter;

drop procedure if exists spConsultaAM;
delimiter **
create procedure spConsultaAM(in idMa int, in mes int)
begin

select * from vwasistenciama where idProfesor = idMa and idMes = mes;

end;**
delimiter;

drop procedure if exists spConsultaAT;
delimiter ** 
create procedure spConsultaAT(in idP int)
begin
select count(*) as 'dias asistidos' from asistenciaAlumnos where idAlumno = idP and idAsistencia = 1;

end;**
delimiter ;

drop procedure if exists spConsultaATM;
delimiter ** 
create procedure spConsultaATM(in idP int)
begin
select count(*) as 'dias asistidos' from asistenciamaestros where idProfesor = idP and idAsistencia = 1;

end;**
delimiter ;

drop procedure if exists spGuardaImg;
delimiter **
create procedure spGuardaImg(in idP int,in i nvarchar(200))
begin 
declare msj nvarchar(200);
declare existe int;

set existe = (select count(*) from personas where idPer = idP);

if existe = 0 then
	set msj = 'el usr no existe';
else 
	set existe = (select count(*) from  relimg where idPer = idP);
    if existe = 0 then
		set existe = (select ifnull(max(idImg),0)+1 from imagenes);
		insert into imagenes values(existe,i);
		insert into relimg values(existe,idP);
		set msj = 'ok';
	else
		set existe = (Select idImg from relimg where idPer = idP);
        update imagenes set img = i where idImg = existe;
        set msj = 'ok';
	end if;
end if;
select msj;
end;**
delimiter ;



select * from materias;
select * from horariosunidad;
##spGuardaAlumnos(in g int, in pat nvarchar(250),in mat nvarchar(250), in nom nvarchar(250), in fech date, in mail nvarchar(250),in bol nvarchar(15),in edo int,in hu longblob)
call spGuardaAlumnos(1,'islas','ortigoza','obed','97.09.19','obedisor@gmail.com','pm2016928',1);
call spguardaAlumnosGrupo('pm2016928','1im1');
select * from alumnosGrupo;
CALL spValidaUsr('pm2016928', 'islas');
select * from profesores;
call spValidaUsr('12', 'Olvera');
##create procedure spGuardaDocente(in idT int,in g int, in pat nvarchar(250),in mat nvarchar(250), in nom nvarchar(250), in fech date, in mail nvarchar(250),in numT nvarchar(15),in hu longblob)
call spGuardaDocente(3, 1, 'profesor', 'profesor', 'profesor', '2000-02-17', 'profesor', 'profesor');
call spGuardaDocente(4, 1, 'jefe', 'Mendoza', 'Alexis', '2000-02-17', 'alexis.ol.me@gmail.com', 'jefe');
call spGuardaDocente(1, 1, 'gest', 'Mendoza', 'Alexis', '2000-02-17', 'alexis.ol.me@gmail.com', 'gest');
call spGuardaDocente(1, 1, 'Olvera', 'Mendoza', 'Alexis', '2000-02-17', 'alexis.ol.me@gmail.com', '12');
call spGuardaDocente(2, 1, '', '', 'Sin asignar', '2000-02-17', '', '1');
call spTraerDatos('pm2016928', 'Pol');
select * from vwTrabajadores;
select * from vwalumnos;
call spContrasenas(1,'1234','Olvera','nueva');
call spUnidadHorario(1, 1, 2, 1);
call spNuevoGrupo('Hola', 2, 2, 1);
select * from vwtrabajadores;
insert into asistenciaalumnos values(1,1,1,1,12,2017,1);
insert into asistenciaalumnos values(2,1,1,day (now()),month (now()),year (now()),dayofweek(now()));
insert into horaentrada values(1,time(now()));
insert into horasalida values(1,(DATE_ADD(NOW(),INTERVAL 30 MINUTE)));
insert into horaentrada values(2,time(now()));
insert into horasalida values(2,time(now()));

insert into asistenciaalumnos values(3,1,1,7,8,year (now()),1);
insert into horaentrada values(3,'07:12:00');
insert into horasalida values(3,'12:12:12');
insert into asistenciaalumnos values(4,1,1,8,8,year (now()),2);
insert into horaentrada values(4,'07:12:00');
insert into horasalida values(4,'12:12:12');
insert into asistenciaalumnos values(5,1,1,9,8,year (now()),3);
insert into horaentrada values(5,'07:12:00');
insert into horasalida values(5,'12:12:12');
insert into asistenciaalumnos values(6,1,1,8,8,year (now()),4);
insert into horaentrada values(6,'07:12:00');
insert into horasalida values(6,'12:12:12');

insert into asistenciaalumnos values(7,1,1,4,9,year (now()),1);
insert into horaentrada values(7,'07:12:00');
insert into horasalida values(7,'12:12:12');
insert into asistenciaalumnos values(8,1,1,5,9,year (now()),2);
insert into horaentrada values(8,'06:49:00');
insert into horasalida values(8,'12:58:12');
insert into asistenciaalumnos values(9,1,1,6,9,year (now()),3);
insert into horaentrada values(9,'07:40:00');
insert into horasalida values(9,'14:20:12');
insert into asistenciaalumnos values(10,1,1,7,9,year (now()),4);
insert into horaentrada values(10,'07:11:00');
insert into horasalida values(10,'12:12:12');
insert into asistenciaalumnos values(11,1,1,8,9,year (now()),5);
insert into horaentrada values(11,'07:12:00');
insert into horasalida values(11,'12:12:12');
insert into asistenciaalumnos values(12,1,1,2,10,year (now()),1);
insert into horaentrada values(12,'07:01:00');
insert into horasalida values(12,'12:12:12');
insert into asistenciaalumnos values(13,1,1,3,10,year (now()),2);
insert into horaentrada values(13,'07:00:00');
insert into horasalida values(13,'12:30:12');
insert into asistenciaalumnos values(14,1,1,4,10,year (now()),3);
insert into horaentrada values(14,'07:00:00');
insert into horasalida values(14,'12:30:12');
insert into asistenciaalumnos values(15,1,1,5,10,year (now()),4);
insert into horaentrada values(15,'07:00:00');
insert into horasalida values(15,'12:12:12');
insert into asistenciaalumnos values(16,1,1,6,10,year (now()),5);
insert into horaentrada values(16,'07:00:00');
insert into horasalida values(16,'12:30:12');
insert into asistenciaalumnos values(17,1,1,6,11,year (now()),1);
insert into horaentrada values(17,'07:01:00');
insert into horasalida values(17,'12:12:12');
insert into asistenciaalumnos values(18,1,1,7,11,year (now()),2);
insert into horaentrada values(18,'07:00:00');
insert into horasalida values(18,'12:30:12');
insert into asistenciaalumnos values(19,1,1,4,12,year (now()),1);
insert into horaentrada values(19,'07:55:00');
insert into horasalida values(19,'13:20:12');
insert into asistenciaalumnos values(20,1,1,8,11,year (now()),3);
insert into horaentrada values(20,'07:00:00');
insert into horasalida values(20,'14:28:12');
insert into asistenciaalumnos values(21,1,1,9,11,year (now()),4);
insert into horaentrada values(21,'07:00:00');
insert into horasalida values(21,'12:30:12');
insert into asistenciaalumnos values(22,1,1,10,11,year (now()),5);
insert into horaentrada values(22,'13:59:00');
insert into horasalida values(22,'17:30:12');

call spConsultaA(1,12);
select * from asistenciaalumnos;
select * from horaentradaMA;
select * from horasalidaMA;
select * from vwasistencia;
call spConsultaAT(8);
call spAsistencia(1);
select fEntradaMa(2);
call spAsistencia(2);
call spConsultaA('6','1');

drop view if exists vwTraeUnidades;
create view vwTraeUnidades as
select ua.idUnidad,ua.idProfesor, m.materia, g.grupo from unidadesaprendizaje ua
	inner join materias m on m.idMateria = ua.idMateria
    inner join grupos g on g.idGrupo = ua.idGrupo
group by ua.idUnidad
order by ua.idUnidad;

drop procedure if exists spTraeUnidades;
delimiter **
create procedure spTraeUnidades(in idMa int)
begin
declare msj nvarchar(200);
declare existe int;

select * from vwTraeUnidades where idProfesor = idMa;

end;**
delimiter ;

call spConsultaAT(1);
##create procedure spUnidadHorario(in idUnid int, in idHorI int, in idHorF int, in idDi int)
##create procedure spNuevaUnidad(in mat nvarchar(200), in cup int)

call spNuevaUnidad('BIOLOGIA BASICA', 50);
call spUnidadHorario(1, 1,2,3);
call spUnidadHorario(1, 4,5,1);
call spUnidadHorario(1, 2,4,5);
call spNuevaUnidad('FISICA I', 40);
call spUnidadHorario(2, 2,5,1);
call spUnidadHorario(2, 1,2,1);
call spUnidadHorario(2, 3,4,5);
call spNuevaUnidad('ALGEBRA', 40);
call spUnidadHorario(3, 1,2,1);
call spUnidadHorario(3, 1,2,2);
call spUnidadHorario(3, 1,2,3);
call spUnidadHorario(3, 1,2,4);
call spUnidadHorario(3, 1,2,5);
call spGuardaDocente(2, 2, 'Mendoza', 'Medina', 'Zyanya', '1990-05-17', 'sinAsiganr@gmail.com', '666');
call spGuardaDocente(2, 1, 'Cruz', 'Morales', 'Pedrikis', '1997-02-17', 'sinAsiganr@gmail.com', '1111');
call spGuardaAlumnos(1,'Vargas','Correa','Lalin bolin','2000-12-07','obedisor@gmail.com','2016090713',1);
call spGuardaAlumnos(1,'Osiris','Osisrisx2','Osisrisx3','2000-12-12','singasingar@gmail.com','2010090713',1);

drop procedure if exists spTraeImg;
delimiter **
create procedure spTraeImg(in idP int)
begin
declare id int;
set id = (select idImg from relimg where idPer = idP);
select img from imagenes where idImg = id;

end; **
delimiter ;
call spTraeImg(11);
call spGuardaImg(1, 'prueba2');

drop view if exists vwasistenciaTurnosDia;
create view vwasistenciaTurnosDia as 
select A.asistecia,Aa.dia,ag.idGrupo,g.idTurno,aa.idMes from asistenciaalumnos Aa
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join alumnosgrupo ag on ag.idPer = Aa.idAlumno
    inner join grupos g on g.idGrupo = ag.idGrupo
group by Aa.idAA;
drop procedure if exists spConsultaAXT;
delimiter **
create procedure spConsultaAXT(in T int,in mes int)
begin
	select count(*) from vwasistenciaTurnosDia where idturno = T and idmes = mes;
end; **
delimiter ;
call spConsultaAXT(1,10);##turno por mes //falta que regrese faltas

drop procedure if exists spConsultaAXTD ;
delimiter %%
create procedure spConsultaAXTD(in T int,in mes int,in d int)
begin
declare asistencias,faltas int;
	set asistencias = (select count(*) from vwasistenciaTurnosDia where asistecia = 'si' and idturno = T and idmes = mes and dia = d);
    set faltas = (select count(*) from vwasistenciaTurnosDia where asistecia = 'no' and idturno = T and idmes = mes and dia = d);
select asistencias,faltas;
end; %%
delimiter %%
delimiter ;
select * from vwasistenciaTurnosDia;
call spConsultaAXTD(1,12,7);##turno por dia //falta que regrese faltas
call sptraerDatos('pm2016928', 'Pol');
call spTraeUnidades(-1);
##call spConsultaUnidad; y dependen de dos sp's //spAsistenciaUnidadHoy; y spAsistenciaUnidadmes;
select * from vwTrabajadores;
select * from vwalumnos;


drop view if exists vwAUD;
create view vwAUD as
select count(*) idPer,idGrupo from alumnosgrupo
group by idGrupo;
select * from vwAUD;

drop view if exists vwTraeDatosUnidad;
create view vwTraeDatosUnidad as
select u.idUnidad,m.materia,g.grupo,g.idTurno 'Truno',g.idTipoGrupo,tg.idArea,a.area 'especialidad',tg.semestre, vwAUD.idPer 'inscritos', vwAUD.idGrupo from unidadesaprendizaje u
	inner join grupos g on g.idGrupo = u.idGrupo
    inner join materias m on m.idMateria = u.idMateria
    inner join tipogrupo tg on tg.idTipoG = g.idTipoGrupo
    inner join areas a on a.idArea = tg.idArea
    inner join vwAUD on vwAUD.idGrupo = u.idGrupo
group by u.idUnidad;
select * from vwTraeDatosUnidad;
drop procedure if exists spDatosUnidad;
delimiter **
create procedure spDatosUnidad(in g nvarchar(20), in idM int)
begin
declare existe int;

set existe = (select count(*) from grupos where grupo = g);
if existe = 1 then
	set existe =(select idGrupo from grupos where grupo = g);
    select * from vwTraeDatosUnidad where idGrupo = existe and idunidad = idM;
else
	set existe = 0;	
end if;

end; **
delimiter ;
call spDatosUnidad('sin grupo',1);
call spDatosUnidad('sin grupo',5);
##call spGuardaAlumnos('');
call spGuardaAlumnosGrupo('pm2016928','sin grupo');
select * from vwalumnos where boleta = '2010090713';
call spAsistencia(10);
drop view if exists vwGruposUnidad;
create view vwGruposUnidad as
select u.idUnidad,m.materia, u.idGrupo,g.grupo,ag.idPer from unidadesaprendizaje u
	inner join grupos g on g.idGrupo = u.idGrupo
    inner join alumnosgrupo ag on ag.idGrupo = g.idGrupo
    inner join materias m on m.idMateria = u.idMateria
group by ag.idPer;

select * from vwGruposUnidad;
drop view if exists vwAsistenciaXUnidades;
create view vwAsistenciaXUnidades as
select Aa.idAA, Aa.dia,Aa.idMes, vwal.boleta,concat (vwal.Paterno,' ',vwal.materno,' ',vwal.nombre)'nombre',a.asistecia,vwGU.idUnidad from asistenciaalumnos Aa
	inner join vwalumnos vwAl on vwAl.idPersona = Aa.idAlumno
    inner join vwgruposunidad vwGU on vwGU.idPer = vwAl.idPersona
    inner join asistencia a on a.idAsistencia = Aa.idAsistencia
group by Aa.idAA;

##sp para alumnos con grupo y semestre 
##sp para grupos 

select * from vwAsistenciaXUnidades;

drop procedure if exists spAsistenciaUnidad;
delimiter **
create procedure spAsistenciaUnidad(in u nvarchar(20))
begin
declare existe int;

set existe = (select count(*) from unidadesaprendizaje where idUnidad = u);
if existe = 1 then
	set existe =(select idUnidad from unidadesaprendizaje where idUnidad = u);
    select * from vwAsistenciaXUnidades where idunidad = existe and dia = day(now()) and idMes = month(now());
else
	set existe = 0;	
end if;


end; **
delimiter ;
call spAsistenciaUnidad(1);




drop view if exists vwTraeDatosGrupo;
create view vwTraeDatosGrupo as
select g.grupo,tg.semestre,t.turmo,a.area 'especialidad' from grupos g
    inner join tipogrupo tg on tg.idTipoG = g.idTipoGrupo
    inner join areas a on a.idArea = tg.idArea
    inner join turnos t on t.idTurno = g.idTurno
group by g.idGrupo;
select * from vwTraeDatosGrupo;
drop procedure if exists spDatosGrupo;
delimiter **
create procedure spDatosGrupo()
begin

	select * from vwTraeDatosGrupo;

end; **

delimiter ;
call spDatosGrupo();

drop procedure if exists spTraeMail;
delimiter **
create procedure spTraeMail(in idP int)
begin
declare existe int;
declare msj nvarchar(200);

set existe = (select count(*) from personas where idPer = idP);
if existe = 1 then
	set msj = (select correo from personas where idPer = idP);
else
    set msj = 'no existe el USR';
end if;

select existe,msj;
end;**
delimiter ;

drop procedure if exists spCambiaMail;
delimiter **
create procedure spCambiaMail(in idP int,in ncorreo nvarchar(100))
begin
declare existe int;
declare msj nvarchar(200);
set existe = (select count(*) from personas where idPer = idP);
if existe = 1 then
	update personas set correo = ncorreo where idPer = idP;
    set msj = 'ok';
else
	set msj = 'USR no encontrado';
end if;
select existe,msj;
end;**
delimiter ;

select * from vwalumnos;
select * from vwalumnoscongrupo;
call spDatosGrupo();
call spCambiaMail(1,'obedislas@ymail.com');
call spTraeMail(12);

drop procedure if exists spModificaUnidad;
delimiter :v
create procedure spModificaUnidad(in idUnid int, in mat nvarchar(200), in cup int)
begin
declare existe, idN, idMat int;
declare msj nvarchar(100);
set idN = 0;
set existe = (select count(*) from unidadesaprendizaje where idUnidad = idUnid);
if existe > 0 then
	set existe = (select count(*) from materias where materia = mat);
	if existe > 0 then 
		if (cup>0 or cup<300) then
			set idMat = (select idMateria from materias where materia = mat);
			update unidadesaprendizaje set idMateria = idMat, cupo = cup, idGrupo = -1, idProfesor = -1 where idUnidad = idUnid;
            delete from horariosunidad where idUnidad = idUnid;
			set msj = 'Todo bien';
            set idN = idUnid;
		else
			set msj = 'Introduzca un cupo positivo no excedente de 300';
		end if;
	else
		set msj ='No existe la materia';
	end if;
else
	set msj = 'No existe la unidad';
end if;
select idN, msj;
end;:v
delimiter ;
select * from imagenes;
drop view if exists vwCuentaA;
create view vwCuentaA as
select count(*),idGrupo from alumnosgrupo
group by idGrupo;
select * from vwasistenciaxunidades;

drop procedure if exists spAsistenciaMesUnidad;
delimiter **
create procedure spAsistenciaMesUnidad(in g nvarchar(10),in idU int,in m int)
begin
declare existe int;



end; **
delimiter ;

select * from imagenes;

call spGuardaAlumnos(1,'lugo','contreras','ayax','2000-11-13', 'ayax@gmail.com','2016090123',1);
call spGuardaAlumnosGrupo('2016090123','Sin grupo');
call spAsistencia(11);
call spAsistencia(10);
select * from vwasistenciaxunidades;

drop view if exists vwAsistenciaTotalUnidades;
create view vwAsistenciaTotalUnidades as
select vwGU.idUnidad,vwal.boleta,concat (vwal.Paterno,' ',vwal.materno,' ',vwal.nombre)'nombre',(select count(a.asistecia))as 'asistidos',aa.idmes as Mes from asistenciaalumnos Aa
	inner join vwalumnos vwAl on vwAl.idPersona = Aa.idAlumno
    inner join vwgruposunidad vwGU on vwGU.idPer = vwAl.idPersona
    inner join asistencia a on a.idAsistencia = Aa.idAsistencia
group by vwal.boleta;

call spAsistencia(11);
call spAsistencia(10);

select * from vwAsistenciaTotalUnidades;
select * from asistenciaalumnos;

drop procedure if exists spAsistenciaUnidadMes;
delimiter **
create procedure spAsistenciaUnidadMes(in idu int,in m int)
begin

select * from vwAsistenciaTotalUnidades where idUnidad = idu and Mes = m;

end; **
delimiter ;

drop procedure if exists spATotal;
delimiter **
create procedure spATotal(in idu int,in m int)
begin

select max(asistidos) as 'Total' from vwAsistenciaTotalUnidades where idUnidad = idu and Mes = m;

end; **
delimiter ;

call spAsistenciaUnidadMes(1,1);
call spATotal(1,12);

drop procedure if exists spDatosGrupoEspecifico;

delimiter **

CREATE PROCEDURE spDatosGrupoEspecifico (in g nvarchar(20))
begin
declare existe int;

set existe = (select count(*) from grupos where grupo = g);
if existe = 1 then
    select * from vwTraeDatosUnidad where  grupo = g;
else
	set existe = 0;	
end if;

end; **

delimiter ;

call spDatosgrupoEspecifico('sin grupo');

drop view if exists vwAsistenciaGXM;
drop procedure if exists spAsistenciaGrupo;
delimiter %%
create procedure spAsistenciaGrupo(in m int, in g nvarchar(20))
begin
select (select count(A.asistecia) where a.asistecia ='si')'asistidos',(select count(A.asistecia) where a.asistecia ='no')'faltados',aa.idMes,ag.Grupo,concat(ag.paterno,' ',ag.materno,' ',ag.nombre) nombre,ag.boleta from asistenciaalumnos Aa 
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join vwalumnoscongrupo ag on ag.idPersona = Aa.idAlumno
    where ag.grupo = g and Aa.idMes = m
group by Aa.idAlumno;

end; %%
delimiter ;
call spAsistenciaGrupo(12,'sin grupo');

drop procedure if exists spAsistenciaGrupoDia
delimiter %%
create procedure spAsistenciaGrupoDia(in m int,in d int, in g nvarchar(20))
begin
select A.asistecia,aa.idMes,aa.dia,ag.Grupo,concat(ag.paterno,' ',ag.materno,' ',ag.nombre) nombre,ag.boleta from asistenciaalumnos Aa 
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join vwalumnoscongrupo ag on ag.idPersona = Aa.idAlumno
    where ag.grupo = g and Aa.idMes = m and Aa.dia=d
group by Aa.idAlumno;

end; %%
delimiter ;
call spAsistenciaGrupoDia(1,21,'sin grupo');

drop view if exists vwasistenciaGrupoDia;
create view vwasistenciaGrupoDia as 
select A.asistecia,Aa.idAlumno,Aa.dia,aa.idMes,g.grupo from asistenciaalumnos Aa
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join alumnosgrupo ag on ag.idPer = Aa.idAlumno
    inner join grupos g on g.idGrupo = ag.idGrupo;
select * from vwasistenciaGrupoDia;

drop procedure if exists spATotalGrupo ;
delimiter %%
create procedure spATotalGrupo(in mes int,in g nvarchar(20))
begin
declare asistencias,faltas int;
	set asistencias = (select count(*) from vwasistenciaGrupoDia where asistecia = 'si' and grupo = g and idmes = mes);
    set faltas = (select count(*) from vwasistenciaGrupoDia where asistecia = 'no' and grupo = g and idmes = mes );
select asistencias,faltas;
end; %%
delimiter ;
call spATotalGrupo(1,'sin grupo');


drop procedure if exists spAsistenciaTurnoDia;
delimiter %%
create procedure spAsistenciaTurnoDia(in m int,in d int, in t int)
begin
select A.asistecia,aa.idMes,aa.dia,g.idTurno,concat(ag.paterno,' ',ag.materno,' ',ag.nombre) nombre,ag.boleta from asistenciaalumnos Aa 
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join vwalumnoscongrupo ag on ag.idPersona = Aa.idAlumno
     inner join grupos g on g.Grupo = ag.Grupo
	where g.idTurno = t and Aa.idMes = m and Aa.dia=d
group by Aa.idAlumno;

end; %%
delimiter ;
call spAsistenciaturnoDia(1,21,1);

drop view if exists vwAsistenciaTotalTurno;
create view vwAsistenciaTotalTurno as 
select (select count(a.asistecia) where a.asistecia = 'si')'Asistidos',aa.idMes,g.idTurno,concat(ag.paterno,' ',ag.materno,' ',ag.nombre) nombre,ag.boleta,ag.Grupo from asistenciaalumnos Aa 
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join vwalumnoscongrupo ag on ag.idPersona = Aa.idAlumno
     inner join grupos g on g.Grupo = ag.Grupo
group by ag.boleta;
select * from vwAsistenciaTotalTurno;
drop procedure if exists spAsistenciaTurnoMes;
delimiter %%
create procedure spAsistenciaTurnoMes(in m int,in t int)
begin

select (select count(a.asistecia) where a.asistecia = 'si')'Asistidos',(select count(a.asistecia) where a.asistecia = 'no')'faltas',aa.idMes,g.idTurno,concat(ag.paterno,' ',ag.materno,' ',ag.nombre) nombre,ag.boleta,ag.Grupo from asistenciaalumnos Aa 
	inner join asistencia a on a.idAsistencia = Aa.idAsistencia
    inner join vwalumnoscongrupo ag on ag.idPersona = Aa.idAlumno
     inner join grupos g on g.Grupo = ag.Grupo
	where g.idTurno = t and Aa.idMes = m
group by ag.boleta;

end; %%
delimiter ;
call spAsistenciaturnomes(1,1);

drop procedure if exists spHorarioAlumno;
delimiter :v
create procedure spHorarioAlumno(in bol nvarchar(20))
begin
	declare existe int;
	set existe = (select count(*) from vwalumnos where boleta = bol);
	if existe = 1 then
		select * from vwhorarioalumnos where boleta = bol;
	end if;
end; :v

delimiter ;
/*=======
>>>>>>> 2a8e73df5ff5777a32b4154d074974a55711e6a3
*/
drop procedure if exists spGuardaNotificacion;
delimiter **
create procedure spGuardaNotificacion(in tipoN int,in T nvarchar(100),in des nvarchar(250),in link nvarchar(300),in imagen nvarchar(200))
begin
declare id,im int;
declare msj nvarchar(100);

set id = (select ifnull(max(idNoti),0)+1 from notificaciones);

insert into notificaciones values(id,tipoN,T,des,link);
if imagen = '' then
	set im =(select ifnull(max(idImg),0)+1 from imgNotificaciones);
    insert into imgnotificaciones values(im,' ');
    insert into relImgNot values(im,id);
    set msj = 'ok';
else
	set im =(select ifnull(max(idImg),0)+1 from imgNotificaciones);
    insert into imgnotificaciones values(im,imagen);
    insert into relImgNot values(im,id);
    set msj = 'ok';
end if;
select msj;
end; **
delimiter ;

drop function if exists fBorraImgN;
delimiter **
create function fBorraImgN(id int) returns nvarchar(100)
begin
declare msj nvarchar(100);
declare existe int;
set existe = (select count(*)from imgnotificaciones where idImg = id);
	if existe = 1 then
		delete from imgnotificaciones where idImg = id;
		set msj = 'ok';
	else
		set msj = 'id incorrecto';
    end if;
return msj;
end; **
delimiter ;

drop view if exists vwNotificaciones;
create view vwNotificaciones as
select n.*,tn.tipoN,im.img from Notificaciones n
	inner join tiponotificacion tn on tn.idTipoN = n.idTipoN
	inner join relImgNot ri on ri.idNot = n.idNoti
    inner join imgNotificaciones im on im.idImg = ri.idImg
group by n.idNoti;

drop procedure if exists spBorraNotificacion;
delimiter **
create procedure spBorraNotificacion(in idN int)
begin
declare msj nvarchar(100);
declare id int;

set id = (select idImg from relimgnot where idNot = idN);
    delete from relimgnot where idNot = idN;
    set msj = (select fBorraImgN(id)); 
    delete from notificaciones where idNoti = idN;

select msj;
end;**

delimiter ;
SET SQL_SAFE_UPDATES = 0;
call spGuardaNotificacion(1,'prueba2','wspero que no crashée','algo.com','n');

drop procedure if exists spNotificaciones;
delimiter **
create PROCEDURE spNotificaciones(in t int)
begin
select * from vwnotificaciones where idTipoN = t;

end;**
delimiter ;
call spNotificaciones(2);

drop procedure if exists spTraeNoti;
delimiter **
create procedure spTraeNoti(in id int)
begin

select * from vwnotificaciones where idNoti = id;

end; **
delimiter ;
call spTraeNoti(1);

drop procedure if exists spEditaNoti;
delimiter **
create procedure spEditaNoti(in id int,in tipoN int,in T nvarchar(100),in des nvarchar(250),in link nvarchar(300),in imagen nvarchar(200))
begin
declare msj nvarchar(100);
declare idi int;
set idi = (select idimg from relimgnot where idNot = id);
update imgnotificaciones set Img =imagen where idImg = idi;
update notificaciones set titulo = T, info = des, url = link where idNoti = id and idTipoN = tipoN;
set msj = 'ok';
end;**
delimiter ;
call spEditaNoti(1,1,'Nuevo','OTRO','ALGO.COMX2','SINIMG');

drop procedure if exists spHorarioProfesor;
delimiter :v
create procedure spHorarioProfesor(in bol nvarchar(20))
begin
	declare existe int;
	set existe = (select count(*) from vwtrabajadores where numTrabajador = bol);
	if existe = 1 then
		select * from vwhorarioalumnos where numTrabajador = bol;
	end if;
end; :v

delimiter ;