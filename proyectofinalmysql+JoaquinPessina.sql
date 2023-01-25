use proyectofinalmysql;

create table identificacion
(DNI int primary key not null,
genero varchar(9) not null ,
edad int not null,
localidad varchar(25) primary key not null,
estado_civil varchar(8) not null)

create table educacion
(DNI int primary key not null,
nivel_educactivo varchar(14) not null,
instituto varchar(20))

create table ingresos_vivienda
(DNI int primary key not null, 
localidad varchar(25) not null,
domicilio varchar(30) not null,
sueldo_total int not null,
tipo_trabajo varchar(25) )

create table tamaño_familia
(domicilio varchar(30) not null,
residentes int not null,
DNI int primary key not null,
edades int not null)

														
#estas tablas son las que analizan de manera individual los datos ingresados, luego, 
#en un futuro, creare tablas funcionales que saquen el promedio de los datos como una forma de medicion automatica

create table costo_vida
(localidad varchar(25) primary key not null,
canasta_basica int not null,
canasta_indigencia int not null,
impuestos_alimentos varchar(6),
manutencionxhijo int not null,
servicios int not null,
alquiler int)

create table nivel_de_vida
(localidad, tasa_indigencia, tasa_pobreza, tasa_media, tasa_alta)

create table promedio_educativo
(localidad,
habitantes_localidad, #menganito(10000)
promedio_nivelprimariocompleto, #80%(8000)
promedio_nivelsecundariocompleto #50%(4000)
promedio_nivelterciariocompleto) #15%(600)





