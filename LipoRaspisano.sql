/* 
   -------------------------------
       Stvaranje baze podataka
   -------------------------------
*/

CREATE DATABASE Restoran;

/* 
   -------------------------
       Stvaranje tablica
   -------------------------
*/

CREATE TABLE Jelo (
    id                  SERIAL PRIMARY KEY NOT NULL,
    naziv               CHARACTER VARYING(30) NOT NULL,
    cijena              REAL NOT NULL
);

CREATE TABLE Racun (
    id                  SERIAL PRIMARY KEY NOT NULL,
    datum               TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE Namirnice (
    id                  SERIAL PRIMARY KEY NOT NULL,
    naziv               CHARACTER VARYING(30) NOT NULL,
    raspoloziva_kol     BIGINT,
    rok_trajanja        DATE,
    nabavna_cijena      REAL
);


CREATE TABLE DnevniMeni (
    id                  SERIAL PRIMARY KEY NOT NULL,
    datum               DATE NOT NULL
);

CREATE TABLE Meni (
    id                  SERIAL PRIMARY KEY NOT NULL,
    naziv               CHARACTER VARYING(30) NOT NULL
);


CREATE TABLE JeloRacun (
    id_jelo             BIGINT references Jelo(id) NOT NULL,
    id_racun            BIGINT references Racun(id) NOT NULL,
    kolicina            INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY         (id_jelo, id_racun)
);


CREATE TABLE JeloNamirnice (
    id_jelo             BIGINT references Jelo(id) NOT NULL,
    id_namirnice        BIGINT references Namirnice(id) NOT NULL,
    kolicina            INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY         (id_jelo, id_namirnice)
);

CREATE TABLE JeloDnevniMeni (
    id_jelo             BIGINT references Jelo(id) NOT NULL,
    id_dnevnimeni       BIGINT references DnevniMeni(id) NOT NULL,
    broj_porcija        INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY         (id_jelo, id_dnevnimeni)
);

CREATE TABLE JeloMeni (
    id_jelo             BIGINT references Jelo(id) NOT NULL,
    id_meni             BIGINT references Meni(id) NOT NULL,
    PRIMARY KEY         (id_jelo, id_meni)
);