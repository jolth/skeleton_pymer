
-- sessiones web.py
CREATE TABLE sessions (  
 session_id char(128) UNIQUE NOT NULL,
 atime timestamp NOT NULL default current_timestamp,
 data text   
);

-- usuarios
CREATE TABLE users (
 id integer primary key asc,
 username varchar(10) UNIQUE NOT NULL,
 password varchar(10)
);

--** CLIENTES **--

-- Tipos de Documento:
CREATE TABLE tipo_documentos (
 id integer primary key asc,
 tipo varchar(50),
 descripcion text
);
CREATE INDEX index_tipo_documentos ON tipo_documentos (tipo);

-- INSER tipo_documentos:
INSERT INTO tipo_documentos (tipo, descripcion) VALUES ('CC', 'Cédula de Ciudadanía');
INSERT INTO tipo_documentos (tipo, descripcion) VALUES ('NIT', 'Número de Identificación Tributaria');
INSERT INTO tipo_documentos (tipo, descripcion) VALUES ('RUT', 'Registro Único Tributario');
INSERT INTO tipo_documentos (tipo, descripcion) VALUES ('TI', 'Tarjeta de Identidad');
INSERT INTO tipo_documentos (tipo, descripcion) VALUES ('CE', 'Cédula de Extranjería');

-- Tabla Clientes:
CREATE TABLE clientes (
 id integer asc,
 tipo_documento integer REFERENCES tipo_documentos ON UPDATE,
 documento integer primary key, -- Si es un NIT. No se muestran los nombres y apellidos.
 f_documento text, -- scanner de documento.
 nombre_p varchar(50),-- primer nombre
 nombre_s varchar(50),-- segundo nombre
 apellido_p varchar(50),-- primer apellido
 apellido_s varchar(50),-- segundo apellido
 razon_social varchar (50), -- si es una empresa.
 --direccion text,
);

-- Correo Clientes:
CREATE TABLE correo_clientes (
 cliente integer REFERENCES clientes(documento) ON UPDATE CASCADE ON DELETE CASCADE,
 correo text,
);
CREATE INDEX index_correo_clientes ON correo_clientes(cliente);

-- Tipos Telefonos:
CREATE TABLE tipos_telefonos (
 id integer primary key asc,
 tipo varchar(50)
);
CREATE INDEX index_tipos_telefonos ON tipos_telefonos (tipo);

-- INSERT tipos_telefonos:
INSERT INTO tipos_telefonos (tipo) VALUES ('celular');
INSERT INTO tipos_telefonos (tipo) VALUES ('celular privado');
INSERT INTO tipos_telefonos (tipo) VALUES ('teléfono fijo');
INSERT INTO tipos_telefonos (tipo) VALUES ('extensión');
INSERT INTO tipos_telefonos (tipo) VALUES ('pbx');
INSERT INTO tipos_telefonos (tipo) VALUES ('fax');

-- Telefonos Clientes:
CREATE TABLE telefonos_clientes (
 id_tipo_tel integer REFERENCES tipos_telefonos(id),  
 cliente integer REFERENCES clientes(documento) ON UPDATE CASCADE ON DELETE CASCADE,
 telefono text
);
CREATE INDEX index_telefonos_clientes ON telefonos_clientes (cliente);

-- Datos de Nacimiento Cliente:
--CREATE TABLE d_nacimineto_cliente (
--);

-- Paises:
CREATE TABLE paises (
 codigo integer primary key,
 nombre varchar(100) NOT NULL
);

-- Estados:
CREATE TABLE estados (
 codigo integer primary key,
 nombre varchar(100) NOT NULL
 pais integer REFERENCES paises(codigo) ON UPDATE CASCADE
);

-- Municipios:
CREATE TABLE municipios (
 codigo integer primary key,
 nombre varchar(100) NOT NULL,
 estado integer REFERENCES estados(codigo) ON UPDATE CASCADE
); 

-- Datos de Residencia Cliente:
CREATE TABLE datos_residencia_clientes (
 cliente integer REFERENCES clientes(documento) ON UPDATE CASCADE ON DELETE CASCADE,
 direccion text,
 pais integer REFERENCES paises(codigo) ON UPDATE CASCADE,
 estado integer REFERENCES estados(codigo) ON UPDATE CASCADE,
 municipio integer REFERENCES municipios(codigo) ON UPDATE CASCADE
);
CREATE INDEX index_datos_residencia_clientes ON datos_residencia_clientes(cliente);

-- cargos en Empresas:
CREATE TABLE cargos (
 id integer primary key asc,
 nombre varchar(100) NOT NULL
);
CREATE INDEX index_cargos ON cargos(nombre);

-- Contacto Empresas (Debe existir almenos uno "Gerente" o Quien se hace cargo):
CREATE TABLE contactos_empresas (
 id integer primary key asc,
 empresa integer,
 cargo varchar REFERENCES cargos(nombre) ON UPDATE CASCADE,
 nombre_p varchar(50), NOT NULL-- primer nombre
 nombre_s varchar(50),-- segundo nombre
 apellido_p varchar(50), NOT NULL-- primer apellido
 apellido_s varchar(50),-- segundo apellido
 FOREIGN KEY (empresa) REFERENCES clientes(documento) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX index_contacto_empresas ON contactos_empresas(empresa);

-- Telefonos contactos_empresas:
CREATE TABLE telefonos_contactos_empresas (
 id_tipo_tel integer REFERENCES tipos_telefonos(id),  
 id_contacto integer REFERENCES contactos_empresas(id) ON UPDATE CASCADE ON DELETE CASCADE,
 telefono text
);
CREATE INDEX index_telefonos_contactos_empresas ON telefonos_contactos_empresas (id_contacto);

-- Correos Contactos_empresas:
CREATE TABLE correos_contactos_empresas (
 id_contacto integer REFERENCES contactos_empresas(id) ON UPDATE CASCADE ON DELETE CASCADE,
 correo text,
);
CREATE INDEX index_correos_contactos_empresas ON correos_contactos_empresas(id_contacto);


--** ACTIVOS: Cualquier tipo de activo al cual se le preste el servicio **--

-- Tipo de Activos:
CREATE TABLE tipo_activos (
 id integer primary key ASC,
 nombre varchar(100) NOT NULL, -- nombre: Vehículo, Moto, Casa, Mascotas, etc.
);

-- Activos: se usa para saber cuantos y que tipo de activos tiene el cliente
CREATE TABLE activos (
 id integer primary key ASC,
 tipo integer REFERENCES tipo_activos(id) ON UPDATE CASCADE, -- Tipo: Vehículo, Moto, Casa, etc.
 cliente integer REFERENCES clientes(documento) ON UPDATE CASCADE ON DELETE CASCADE,
);
CREATE INDEX index_activos ON activos(cliente);

-- Vehículos:
CREATE TABLE activos_vehiculos (
 id integer primary key ASC,
 activo REFERENCES activos(id) ON UPDATE CASCADE ON DELETE CASCADE,
 placa varchar(10) NOT NULL,
 observacion text 
);
CREATE INDEX index_activos_vehiculos ON activos_vehiculos(activo);


--CREATE TABLE activos_motos (
--);


--** DISPOSITIVO **--
CREATE TABLE tipo_dispositivo (
 id integer primary key ASC,
 nombre varchar(100) NOT NULL, -- nombre: AVL, Cámara Web, etc.
);

-- Solo es usada para saber cuantos y que tipo de dispositivos tiene un cliente.
CREATE TABLE dispositivos (
 id integer primary key ASC,
 tipo integer REFERENCES tipo_dispositivo(id) ON UPDATE CASCADE, -- Tipo: AVL, Cámara Web, etc.
 cliente integer REFERENCES clientes(documento) ON UPDATE CASCADE ON DELETE CASCADE,
);
CREATE INDEX index_dispositivos ON dispositivos(cliente);

-- Fabricantes dispositivos AVL's: Skypatrol, Antares, etc.
CREATE TABLE fabricantes_avls (
 id integer primary key ASC,
 nombre varchar(100) NOT NULL
);

-- Referencia de dispositivos AVL's: TT9500, TT8750, etc.
CREATE TABLE referencias_avls (
 id integer primary key ASC,
 fabricante integer REFERENCES fabricantes_avls(id) ON UPDATE CASCADE,
 referencia varchar (100) NOT NULL 
);

CREATE TABLE dispositovos_avl (
 id varchar(10) primary key,
 dispositivo REFERENCES dispositivos(id) ON UPDATE CASCADE ON DELETE CASCADE,
 fabricante integer REFERENCES fabricantes_avls(id) ON UPDATE CASCADE, 
 referencia integer REFERENCES referencias_avls(id) ON UPDATE CASCADE,  
 serial varchar(100) NOT NULL, 
 imei varchar(100) NOT NULL
 activo REFERENCES activos(id) ON UPDATE CASCADE ON DELETE CASCADE, -- En el activo donde esta instalado el AVL.
);
CREATE INDEX index_dispositovos_avl ON dispositovos_avl(dispositivo);


--** CONTRATOS **--

-- Contratos: 
CREATE TABLE contratos (
 id integer primary key asc,
 cliente integer FK--------------------------------------------- 
 cotrato varchar(50) NOT NULL, -- Número de contrato.
 file text, -- NOT NULL
 observacion text,
);
CREATE INDEX index_contatos ON contratos (contrato);



