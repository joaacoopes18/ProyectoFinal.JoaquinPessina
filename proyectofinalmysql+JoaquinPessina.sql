create schema proyectofinalmysql;

use proyectofinalmysql;

create table clasificacion
(id_clasificacion int primary key not null auto_increment,
clasificacion varchar(30) not null);

create table trabajo
(id_trabajo int primary key not null auto_increment,
trabajo varchar(50) not null);

create table provincia 
(id_provincia int primary key not null auto_increment,
nombre_provincia varchar(30) not null);

create table ciudad 
(id_ciudad int primary key not null auto_increment,
nombre_ciudad varchar(30) not null,
id_provincia int not null,
foreign key (id_provincia) references provincia(id_provincia));

create table genero
(id_genero int primary key not null auto_increment,
genero varchar(20) not null);

create table nivel_educativo
(id_nivel_educativo int primary key not null auto_increment,
nivel_educativo varchar(50) not null,
nivel_superior varchar(50));

create table familia
(id_titulardefamilia int primary key not null auto_increment,
residentes int not null,
domicilio varchar(30) not null,
cantidad_menores int not null);

create table estado_civil
(id_estadocivil int primary key not null auto_increment,
estadocivil varchar (20) not null);

create table identificacion 
(dni int primary key not null,
edad int not null,
ingresos int,
id_genero int not null,
id_ciudad int not null,
id_nivel_educativo int not null, 
id_trabajo int not null,
id_ingresos int not null,
id_titulardefamilia int not null,
id_estadocivil int not null,
id_clasificacion int not null,
foreign key (id_genero) references genero(id_genero),
foreign key (id_ciudad) references ciudad(id_ciudad),
foreign key (id_nivel_educativo) references nivel_educativo(id_nivel_educativo),
foreign key (id_trabajo) references trabajo(id_trabajo),
foreign key (id_titulardefamilia) references familia(id_titulardefamilia),
foreign key (id_estadocivil) references estado_civil(id_estadocivil),
foreign key (id_clasificacion) references clasificacion(id_clasificacion));

												/*insert datas*/

insert into clasificacion (clasificacion) values
('Trabajo formal'),
('Trabajo informal'),
('Trabajo independiente'),
('Desempleo'),
('Estudio');

insert into trabajo (trabajo) values
('Abogado'),
('Ingeniero'),
('Médico'),
('Docente'),
('Programador');

insert into provincia (nombre_provincia) values
('Buenos Aires'),
('Córdoba'),
('Santa Fe'),
('Mendoza'),
('Entre Ríos');

insert into ciudad (nombre_ciudad, id_provincia) values
('La Plata', 1),
('Rosario', 3),
('Mendoza', 4),
('Córdoba', 2),
('Paraná', 5);

insert into genero (genero) values
('Masculino'),
('Femenino'),
('Otro'),
('No especificado'),
('Prefiero no decirlo');

insert into nivel_educativo (nivel_educativo, nivel_superior) values
('Educación Primaria', NULL),
('Educación Secundaria', NULL),
('Carrera Técnica', NULL),
('Licenciatura', 'Maestría'),
('Posgrado', 'Doctorado');


insert into familia (residentes, domicilio, cantidad_menores) values
(4, 'Av. Siempreviva 1234', 2),
(2, 'Calle Falsa 123', 0),
(3, 'Av. Corrientes 2468', 1),
(5, 'San Martín 567', 3),
(1, 'La Rioja 321', 0);

insert into estado_civil (estadocivil) values
('Soltero/a'),
('Casado/a'),
('Viudo/a'),
('Divorciado/a'),
('Separado/a');

insert into identificacion (dni, edad, ingresos, id_genero, id_ciudad, id_nivel_educativo, id_trabajo, id_ingresos, id_titulardefamilia, id_estadocivil, id_clasificacion) values
(34567890, 25, 30000, 1, 1, 4, 2, 1, 1, 1, 1),
(40123456, 43, 50000, 2, 2, 5, 1, 2, 2, 2, 1),
(27123456, 32, 80000, 1, 3, 5, 3, 3, 3, 1, 2),
(35678901, 51, 120000, 1, 4, 5, 4, 4, 4, 2, 3),
(11223344, 19, 0, 2, 5, 2, 5, 5, 5, 3, 1);

													/*views*/

create view facts_ingresos as select edad, nivel_educativo, trabajo, ingresos from identificacion, trabajo, nivel_educativo;

-- La sentencia crea una vista llamada "facts_ingresos" que muestra la edad, nivel educativo, trabajo e ingresos de la tabla "identificacion, trabajo,
-- ingresos, nivel_educativo".

create view mayores_edad_edu as select edad, nivel_educativo from identificacion, nivel_educativo where edad>"18";

-- La sentencia crea una vista llamada "mayores_edad_edu" que muestra la edad y nivel educativo de la tabla "identificacion, ingresos, nivel_educativo" 
-- donde la edad es mayor a "18".

create view promedio_hijos_por_domicilio as
select f.domicilio, avg(f.residentes - f.cantidad_menores) as promedio_hijos
from familia f
group by f.domicilio;

-- la vista promidio_hijos_por_domicilio la funcion que tiene es mostrar el promedio de hijos por domicilio, sabiendo asi cuando 
-- hijos hay por domicilio

create view vista_identificacion_info as
select identificacion.dni, identificacion.edad, genero.genero, ciudad.nombre_ciudad, provincia.nombre_provincia, trabajo.trabajo, identificacion.ingresos
from identificacion
join genero on identificacion.id_genero = genero.id_genero
join ciudad on identificacion.id_ciudad = ciudad.id_ciudad
join provincia on ciudad.id_provincia = provincia.id_provincia
join trabajo on identificacion.id_trabajo = trabajo.id_trabajo;

-- Esta vista combina información de las tablas identificacion, genero, ciudad, provincia y trabajo para mostrar información 
-- detallada de la identificación, incluyendo el DNI, la edad, el género, la ciudad y la provincia donde vive la persona, el 
-- trabajo que desempeña y los ingresos que recibe.

create view promedio_ingresos_por_nivel_educativo as
select ne.nivel_educativo, avg(i.ingresos) as promedio_ingresos
from identificacion i
join nivel_educativo ne on i.id_nivel_educativo = ne.id_nivel_educativo
group by ne.nivel_educativo;

-- La vista "promedio_ingresos_por_nivel_educativo" es una vista que realiza una operación de agregación de la tabla 
-- "identificacion" y "nivel_educativo". En particular, se une la tabla "identificacion" con la tabla "nivel_educativo" 
-- utilizando la cláusula "join" y luego se agrupa por el nivel educativo utilizando la cláusula "group by". La vista calcula 													
-- el promedio de los ingresos de las personas agrupados por su nivel educativo.

/*triggers*/

create table log_identificacion 
(dni int,
edad int,
provincia varchar(30),
fecha_hora datetime);

DELIMITER $$
create trigger guardar_log_identificacion 
before insert on identificacion 
for each row 
begin
  declare v_provincia varchar(30);
  set v_provincia = (select nombre_provincia from provincia where id_provincia = (select id_provincia from ciudad where id_ciudad = new.id_ciudad));
  if v_provincia is null then
    set v_provincia = '';
  end if;
  insert into log_identificacion (dni, edad, provincia, fecha_hora) 
    values (new.dni, new.edad, v_provincia, NOW());
end$$
DELIMITER ;


-- En este trigger, se crea una variable para almacenar los valores de provincia, obtenidos de las tablas correspondientes 
-- utilizando las claves foráneas. Luego, se verifica si alguno de estos valores es nulo y, en caso afirmativo, se cambia el valor 
-- a una cadena vacía. Finalmente, se insertan los valores de dni, edad, provincia y fecha_hora en la tabla registro_identificacion.

#----------------------------------------------------------------------------#

create table log_novedad_educacion 
(DNI int not null,
edad int not null,
nivel_educactivo varchar(30) not null,
fecha_ingreso varchar (50),
hora_ingreso varchar (50));

create trigger registro_edu
after insert on identificacion
for each row
insert into log_novedad_educacion (DNI, edad, fecha_ingreso, hora_ingreso)
values (new.DNI, new.edad, current_date, current_time);

create trigger registro_nivel_educativo
after insert on nivel_educativo
for each row
insert into log_novedad_educacion (nivel_educativo, fecha_ingreso, hora_ingreso)
values (new.nivel_educativo, current_date, current_time);

#en este trigger mi objetivo es actualizar las novedades de la tabla "educacion" mediante un trigger de after que 
#tiene en cuenta cada nuevo valor ingresado

													/*funciones*/
DELIMITER $$                                                   
create function ingresos_dolarizados (dolar float , id int) returns float
reads SQL data
begin
declare resultado float;
 set resultado = (select ingresos from ingresos where id = id_ingresos)/dolar;
  return resultado;
end $$
DELIMITER ;                                             

#mi objetivo con la creacion de esta funcion es poder transformar un ingreso especifico a dolar mediante una variable inicial declarada como "dolar"
#y asi poder tener una forma de saber el poder adquisitivo en dolares
######

DELIMITER $$
create function cant_nivel_edu (nivel varchar(20)) returns varchar(40) charset utf8mb4
reads SQL data
begin
declare resultado int;
if nivel = incompleto then
	set resultado = (select count(nivel_educativo) from identificacion where nivel_educativo = (1));
elseif nivel = primario then
	set resultado = (select count(nivel_educativo) from identificacion where nivel_educativo = (2 , 3 , 4));
elseif nivel = secundario then
  set resultado = (select count(nivel_educativo) from identificacion where nivel_educativo = (3, 4));
elseif nivel = superior then
  set resultado = (select count(nivel_educativo) from identificacion where nivel_educativo = (4));
else
	set resultado = ("Ingresa un nivel educativo");
  end if;
return resultado;
end $$
DELIMITER ;

-- La función "cant_nivel_edu" recibe como parámetro una cadena de caracteres que representa el nivel educativo. Dependiendo del nivel recibido, cuenta 
-- el número de registros en una tabla llamada "identificacion" y almacena el resultado en una variable llamada "resultado". Si el nivel no coincide
-- con ninguna de las opciones especificadas, la función devuelve un mensaje indicando que se debe ingresar un nivel educativo válido. Finalmente, la
-- función devuelve el valor de la variable "resultado".

/*stores procedures*/

DELIMITER $$
create procedure order_by_dependiendo_del_campo(in tabla varchar(50), in campo char(20), in orden char(20))
begin
if campo <> '' and orden = 'ascendente' then
	set @orden = concat('order by ', campo, ' asc'); 
elseif campo <> '' and orden = 'descendente' then
	set @orden = concat('order by ', campo, ' desc');
elseif campo = '' and orden = 'ascendente' then
	set @orden = 'order by dni asc'; 
elseif campo = '' and orden = 'descendente' then
	set @orden = 'order by dni desc';
else
	set @orden = 'error: campos incorrectos';
end if;

set @clausula = concat('select * from ', tabla, ' ', @orden);
prepare ejecutarSQL from @clausula;
execute ejecutarSQL;
deallocate prepare ejecutarSQL;
end $$
DELIMITER ;


#Con este if hago que se revise que campo se eligio para ordenar , si esta dentro de la tabla
#lo ordena segun asc o desc (dependiendo de lo que se eligio en el orden) y si no se encuentra tira un error con un mensaje o si se
#se deja en blanco se ordena segun el campo elegido. La variable del orden siempre tirara error si se deja vacio

DELIMITER $$
create procedure eliminar_nulos(in tabla varchar(50),in columna varchar(50))
begin
    set @sql = concat('delete from ', log_novedad_identificacion, ' where ',DNI, ' is null or',genero,' is null or',edad,' is null or',localidad,' is null or',provincia,' is null');
    prepare stmt FROM @sql;
    execute stmt;
    deallocate prepare stmt;
end $$
DELIMITER ;

-- en este stored procedure, mi objetivo es eliminar los valores nulos de la tabla de log_novedad_identificacion.

/*SENTENCIAS*/

-- Crear el usuario con el nombre "ejemplo2"
create user ejemplo2@localhost;

-- Dar permisos de lectura, inserción y modificación de datos en todas las tablas de la base de datos "ejemplos2"
grant select, insert, update on *.* to ejemplo2@localhost;

-- Crear el usuario con el nombre "ejemplo1"
create user ejemplo1@localhost;

-- Dar permisos de solo lectura en todas las tablas de la base de datos "ejemplo1"
grant select on *.* to ejemplo1@localhost;

-- Para eliminar un usuario por completo, borrando todas las conexiones con las bases de datos se usa la sintaxis "drop user"
drop user ejemplo1@localhost;
drop user ejemplo2@localhost;

/*TCL*/

start transaction;

-- insertar los registros en la tabla "trabajo"
insert into trabajo (trabajo) values
('Enfermera'),
('Ingeniero Informatico'),
('Cirujano'),
('Maestro'),
('instructor de boxeo');

-- insertar los registros en la tabla "provincia"
insert into provincia (nombre_provincia) values 
('Buenos Aires'),
('Buenos Aires'),
('Mendoza');

-- Crear un punto de guardado (checkpoint1) para poder volver si es necesario
savepoint checkpoint1;
insert into provincia (nombre_provincia) values 
('Santa Fe'),
('Buenos Aires'),
('Cordoba');

-- Si ocurre algún error, deshacer todas las modificaciones hasta el savepoint indicado con rollback
rollback to checkpoint1;

-- Si no hay errores, confirmar los cambios en ambas tablas con commit
commit;
