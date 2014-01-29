--****************************************--
-- SQLite 3.0
-- ERP - Pymer v0.1
-- Author: Jorge A. Toro Hoyos
-- Dev Microsystem S.A.S.
--****************************************--

--**** Systems:

-- sessiones web.py
--CREATE TABLE sessions (  
-- session_id CHAR(128) UNIQUE NOT NULL, 
-- atime TIMESTAMP NOT NULL default current_timestamp,
-- data text   
--);

-- sessiones web.py
CREATE TABLE sessions (
 session_id CHAR(128) UNIQUE NOT NULL,
 atime DATETIME NOT NULL default current_timestamp,
 data TEXT
);

-- usuarios
CREATE TABLE users (
 id integer primary key asc,
 photo TEXT,
 name VARCHAR(100) NOT NULL,
 email VARCHAR(100) UNIQUE NOT NULL,
 password VARCHAR(10),
 active SMALLINT -- 0 (false) and 1 (true).
);

-- User connections App
CREATE TABLE user_connections (
 id integer primary key asc,
 user integer,
 added_on TIMESTAMP NOT NULL DEFAULT current_timestamp,
 FOREIGN KEY (user) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX index_user_connections ON user_connections (user);


--**** Others:

CREATE TABLE countries ();

CREATE TABLE provinces ();

CREATE TABLE cities ();



--**** Companies:

CREATE TABLE companies (
);

