-- creamos la secuencia para los id de los clubes que sube de 4 en 4
create sequence seq_club_futbol
    start with 703
    increment by 4;

-- creamos las tablas empezando por las que no dependen de otras

-- tabla region
create table region (
    id_region number(5) not null,
    nombre    varchar2(50) not null
);
alter table region add constraint region_pk primary key (id_region);

-- tabla comuna con su llave foranea apuntando a region
create table comuna (
    id_comuna  number(5) not null,
    id_region  number(5) not null,
    nombre     varchar2(50) not null
);
alter table comuna add constraint comuna_pk primary key (id_comuna);
alter table comuna add constraint comuna_region_fk foreign key (id_region) references region(id_region);

-- tabla asociacion con las validaciones de fecha y tipo
create table asociacion (
    id_asociacion     number(5) not null,
    nombre_asociacion varchar2(100) not null,
    fecha_creacion    date not null,
    tipo_asociacion   char(1) not null
);
alter table asociacion add constraint asociacion_pk primary key (id_asociacion);
alter table asociacion add constraint asociacion_fec_ck check (fecha_creacion >= to_date('1980-12-31', 'YYYY-MM-DD'));
alter table asociacion add constraint asociacion_tipo_ck check (tipo_asociacion in ('P', 'A'));

-- tabla nacionalidad con el identity automatico
create table nacionalidad (
    id_nacion   number(5) generated always as identity (start with 210 increment by 2) not null,
    descripcion varchar2(50) not null
);
alter table nacionalidad add constraint nacionalidad_pk primary key (id_nacion);

-- tabla de clubes de futbol
create table club_futbol (
    id_club         number(5) not null,
    nombre_club     varchar2(100) not null,
    patrimonio      number(12) not null,
    ubicacion_calle varchar2(100) not null,
    tipo_club       varchar2(30) not null
);
alter table club_futbol add constraint club_futbol_pk primary key (id_club);
alter table club_futbol add constraint club_nombre_un unique (nombre_club);


-- metemos los datos de prueba con los inserts

-- insertamos primero las regiones para que las comunas no tiren error
insert into region values (1, 'ARICA Y PARINACOTA Y TARAPACA');
insert into region values (2, 'ANTOFAGASTA');
insert into region values (3, 'ATACAMA Y COQUIMBO');
insert into region values (5, 'VALPARAISO');
insert into region values (8, 'BIOBIO');
insert into region values (13, 'METROPOLITANA');
insert into region values (16, 'ÑUBLE');

-- insertamos las comunas en sus respectivas regiones
insert into comuna values (101, 13, 'Santiago');
insert into comuna values (102, 5, 'Valparaíso');
insert into comuna values (103, 8, 'Concepción');
insert into comuna values (104, 2, 'Antofagasta');
insert into comuna values (105, 16, 'Chillán');

-- insertamos las asociaciones
insert into asociacion values (25, 'Asociación de Fútbol de Santiago', to_date('15-05-2001', 'DD-MM-YYYY'), 'P');
insert into asociacion values (26, 'Asociación Nacional de Fútbol Amateur', to_date('10-03-1998', 'DD-MM-YYYY'), 'A');
insert into asociacion values (27, 'Asociación de Fútbol de Valparaíso', to_date('21-07-1987', 'DD-MM-YYYY'), 'P');
insert into asociacion values (28, 'Asociación de Fútbol de Concepción', to_date('30-11-1995', 'DD-MM-YYYY'), 'A');
insert into asociacion values (29, 'Asociación de Fútbol de Antofagasta', to_date('25-06-2003', 'DD-MM-YYYY'), 'P');
insert into asociacion values (30, 'Asociación de Fútbol de Temuco', to_date('12-01-2010', 'DD-MM-YYYY'), 'A');
insert into asociacion values (31, 'Asociación de Fútbol de Rancagua', to_date('08-09-1999', 'DD-MM-YYYY'), 'P');
insert into asociacion values (32, 'Asociación de Fútbol de Puerto Montt', to_date('20-04-2005', 'DD-MM-YYYY'), 'A');
insert into asociacion values (33, 'Asociación de Fútbol de La Serena', to_date('14-08-2012', 'DD-MM-YYYY'), 'P');
insert into asociacion values (34, 'Asociación de Fútbol de Chillán', to_date('01-12-2018', 'DD-MM-YYYY'), 'A');

-- insertamos las nacionalidades
insert into nacionalidad (descripcion) values ('Chilena');
insert into nacionalidad (descripcion) values ('Argentina');
insert into nacionalidad (descripcion) values ('Peruana');
insert into nacionalidad (descripcion) values ('Boliviana');
insert into nacionalidad (descripcion) values ('Brasileña');

-- insertamos los clubes usando la secuencia en el id
insert into club_futbol values (seq_club_futbol.nextval, 'Colo-Colo', 500000000, 'Av. Marathon 5300', 'Profesional');
insert into club_futbol values (seq_club_futbol.nextval, 'Universidad de Chile', 450000000, 'Av. El Parrón 0931', 'Profesional');
insert into club_futbol values (seq_club_futbol.nextval, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606', 'Profesional');
insert into club_futbol values (seq_club_futbol.nextval, 'Huachipato', 220000000, 'Avenida Desiderio García 909', 'Profesional');
insert into club_futbol values (seq_club_futbol.nextval, 'Ñublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

commit;


-- informe 1 asociaciones de futbol profesional
select 
    'ID:' || id_asociacion || ' * ' || nombre_asociacion as asociacion,
    to_char(fecha_creacion, 'DD-MM-YYYY') as creada,
    tipo_asociacion as tipo
from 
    asociacion
where 
    tipo_asociacion = 'P'
    and extract(year from fecha_creacion) > 2000
order by 
    fecha_creacion desc;


-- informe 2 patrimonio de clubes de futbol profesionales que tienen la letra a y mas de 200 millones
select 
    id_club as club,
    nombre_club as nombre_club,
    patrimonio as patrimonio_en_pesos,
    (patrimonio / 955) as patrimonio_en_dolares
from 
    club_futbol
where 
    lower(nombre_club) like '%a%'
    and patrimonio > 200000000
    and tipo_club = 'Profesional'
order by 
    id_club desc;