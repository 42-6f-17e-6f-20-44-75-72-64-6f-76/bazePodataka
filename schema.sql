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
    id                  SERIAL PRIMARY KEY,
    naziv               CHARACTER VARYING(30) NOT NULL UNIQUE,
    cijena              REAL NOT NULL,
    CONSTRAINT POZITIVNA_VRIJEDNOST CHECK (cijena>0)
);

CREATE TABLE Racun (
    id                  SERIAL PRIMARY KEY,
    datum               TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE Namirnice (
    id                  SERIAL PRIMARY KEY,
    naziv               CHARACTER VARYING(30) NOT NULL UNIQUE,
    raspoloziva_kol     REAL,
    rok_trajanja        DATE,
    nabavna_cijena      REAL,
    CONSTRAINT POZITIVNA_VRIJEDNOST CHECK (raspoloziva_kol>=0 AND nabavna_cijena>0),
    CONSTRAINT DATUM_NAKON CHECK (rok_trajanja>now()::date)
);

CREATE TABLE DnevniMeni (
    id                  SERIAL PRIMARY KEY,
    datum               DATE NOT NULL UNIQUE,
    CONSTRAINT DATUM_NAKON CHECK (datum>=now()::date)
);

CREATE TABLE Meni (
    id                  SERIAL PRIMARY KEY,
    naziv               CHARACTER VARYING(30) NOT NULL UNIQUE
);

CREATE TABLE JeloRacun (
    id_jelo             BIGINT references Jelo(id),
    id_racun            BIGINT references Racun(id),
    kolicina            REAL NOT NULL DEFAULT 1,
    PRIMARY KEY         (id_jelo, id_racun),
    CONSTRAINT POZITIVNA_VRIJEDNOST CHECK (kolicina>0)
);

CREATE TABLE JeloNamirnice (
    id_jelo             BIGINT references Jelo(id),
    id_namirnice        BIGINT references Namirnice(id),
    kolicina            REAL NOT NULL DEFAULT 1,
    PRIMARY KEY         (id_jelo, id_namirnice),
    CONSTRAINT POZITIVNA_VRIJEDNOST CHECK (kolicina>0)
);

CREATE TABLE JeloDnevniMeni (
    id_jelo             BIGINT references Jelo(id),
    id_dnevnimeni       BIGINT references DnevniMeni(id),
    broj_porcija        INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY         (id_jelo, id_dnevnimeni),
    CONSTRAINT POZITIVNA_VRIJEDNOST CHECK (broj_porcija>0)
);

CREATE TABLE JeloMeni (
    id_jelo             BIGINT references Jelo(id),
    id_meni             BIGINT references Meni(id),
    PRIMARY KEY         (id_jelo, id_meni)
);

/*
   -------------------------------
       Unos podataka u tablice
   -------------------------------
*/


INSERT INTO Jelo(naziv, cijena)
VALUES
('Goveda juha', 15),
('Juha od rajcice', 15),
('Mijesana pizza', 40),
('Pizza margarita', 35),
('Cokoladna torta', 25),
('Palacinke', 20);

INSERT INTO DnevniMeni(datum)
VALUES 
('2021-10-01'::date),
('2021-10-02'::date),
('2021-10-03'::date),
('2021-10-04'::date),
('2021-10-05'::date),
('2021-10-06'::date),
('2021-10-07'::date),
('2021-10-08'::date),
('2021-10-09'::date),
('2021-10-10'::date);

INSERT INTO JeloDnevniMeni
VALUES
(1, 1, 30),
(4, 1, 30),
(5, 1, 25),
(1, 2, 40),
(3, 2, 45),
(6, 2, 40),
(2, 3, 50),
(3, 3, 55),
(5, 3, 45),
(1, 4, 60),
(3, 4, 65),
(6, 4, 60),
(1, 5, 50),
(3, 5, 50),
(5, 5, 45),
(2, 6, 30),
(4, 6, 35),
(6, 6, 30),
(1, 7, 35),
(3, 7, 40),
(5, 7, 35),
(1, 8, 60),
(3, 8, 65),
(5, 8, 55),
(1, 9, 40),
(4, 9, 45),
(5, 9, 45),
(2, 10, 50),
(4, 10, 55),
(5, 10, 60);

INSERT INTO Meni (naziv)
VALUES
('Juhe'),
('Pizze'),
('Deserti');

INSERT INTO JeloMeni
VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3);

INSERT INTO Racun (id)
VALUES
(1),
(2),
(3),
(4);

INSERT INTO Namirnice (naziv, rok_trajanja, nabavna_cijena, raspoloziva_kol)
VALUES
('brasno', '2022-10-03'::date, 4.35, 50),
('ulje', '2022-01-30'::date, 8, 40),
('sunka', '2021-07-15'::date, 23.45, 0),
('sir', '2021-07-01'::date, 20.56, 5.5),
('gljive', '2021-06-25'::date, 15.59, 10),
('cokolada', '2021-08-23'::date, 7.5, 5),
('jaja', '2021-06-15'::date, 1.2, 60),
('margarin', '2021-11-24'::date, 8.75, 10);

INSERT INTO JeloRacun
VALUES
(1, 1, 1),
(3, 1, 1),
(2, 2, 2),
(4, 2, 2),
(6, 3, 4),
(1, 4, 4),
(4, 4, 4),
(5, 4, 4);

INSERT INTO JeloNamirnice
VALUES
(3, 1, 0.25),
(3, 2, 0.01),
(3, 3, 0.015),
(3, 4, 0.015),
(3, 5, 0.1),
(4, 1, 0.25),
(4, 2, 0.01),
(4, 4, 0.015),
(5, 2, 0.1),
(5, 6, 0.15),
(5, 7, 0.5),
(5, 8, 0.1),
(5, 1, 0.1),
(6, 1, 0.15),
(6, 2, 0.1),
(6, 6, 0.1),
(6, 7, 0.5),
(6, 8, 0.1);

/*
   -------------------------------
       Upiti (zadani)
   -------------------------------
*/

-> izvještaj o sastojcima koji odlaze u pripravu pojedinog jela i njihovoj trenutnoj
raspoloživosti

SELECT namirnice.naziv, namirnice.raspoloziva_kol FROM jelo
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON namirnice.id = jelonamirnice.id_namirnice
WHERE jelo.naziv = 'Mijesana pizza';

-> izvještaj o sastojcima koje je bilo/će biti potrebno nabaviti unutar zadanog vremenskog perioda

SELECT namirnice.naziv, SUM(jelonamirnice.kolicina * jelodnevnimeni.broj_porcija) AS potrebna_kolicina 
FROM jelo
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON jelonamirnice.id_namirnice = namirnice.id
JOIN jelodnevnimeni ON jelo.id = jelodnevnimeni.id_jelo
JOIN dnevnimeni ON jelodnevnimeni.id_dnevnimeni = dnevnimeni.id
WHERE dnevnimeni.datum > '2021-10-01'::date AND dnevnimeni.datum < '2021-10-05'::date
GROUP BY namirnice.naziv;

-> izvještaj o svim jelima u kojima se koristi određena namirnica

SELECT jelo.naziv 
FROM jelo
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON namirnice.id = jelonamirnice.id_namirnice
WHERE namirnice.naziv = 'ulje';

-> popis svih namirnica kojih nema u dovoljnim količinama za pripravu određenog jela

SELECT namirnice.naziv, namirnice.raspoloziva_kol AS dostupno, 
jelonamirnice.kolicina AS potrebno, 
(jelonamirnice.kolicina - namirnice.raspoloziva_kol) AS nedostaje 
FROM jelo
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON jelonamirnice.id_namirnice = namirnice.id
WHERE namirnice.raspoloziva_kol < jelonamirnice.kolicina AND jelo.naziv = 'Mijesana pizza';

-> popis svih jela koja se mogu pripraviti od raspoloživih namirnica

SELECT DISTINCT jelo.naziv 
FROM jelo 
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON namirnice.id = jelonamirnice.id_namirnice
WHERE  (jelo.naziv) <>  ALL (
	SELECT DISTINCT jelo.naziv 
	FROM jelo
	JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
	JOIN namirnice ON namirnice.id = jelonamirnice.id_namirnice
	WHERE jelonamirnice.kolicina > namirnice.raspoloziva_kol 
);

-> pregled svih jela pripravljenih u određenom vremenskom periodu

SELECT jelo.naziv, SUM(jeloracun.kolicina) AS broj_pripravljenih_jela 
FROM jelo
JOIN jeloracun ON jelo.id = jeloracun.id_jelo
JOIN racun ON racun.id = jeloracun.id_racun
WHERE racun.datum >= '2021-05-25'::date
GROUP BY jelo.naziv;

/*
   -------------------------------
       Upiti (dodatni)
   -------------------------------
*/

-> pregled ukupne zarade u određenom periodu

SELECT SUM(jelo.cijena * jeloracun.kolicina) AS ukupna_zarada 
FROM jelo
JOIN jeloracun ON jelo.id = jeloracun.id_jelo
JOIN racun ON racun.id = jeloracun.id_racun
WHERE racun.datum BETWEEN '2021-05-28'::date AND now()::date;

-> izvještaj o količini iskorištenih namirnica u određenom periodu

SELECT DISTINCT namirnice.naziv, 
SUM(jelonamirnice.kolicina * jeloracun.kolicina) AS iskorisena_kolicina 
FROM jelo
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON jelonamirnice.id_namirnice = namirnice.id
JOIN jeloracun ON jelo.id = jeloracun.id_jelo
JOIN racun ON racun.id = jeloracun.id_racun
WHERE racun.datum BETWEEN '2021-05-28'::date AND now()::date
GROUP BY namirnice.naziv;

-> popis svih namirnica čiji rok trajanja ističe do određenog datuma

SELECT namirnice.naziv, namirnice.rok_trajanja FROM namirnice
WHERE namirnice.rok_trajanja < '2022-03-01'::date;

-> vlasnik restorana zeli dobiti prioritetna jela za dnevni meni obzirom na datum isteka roka namirnica u odredenom broju dana

SELECT * FROM (
	SELECT DISTINCT ON(distinct_datum.prioritetna_jela) * FROM (
		SELECT jelo.naziv AS prioritetna_jela, namirnice.naziv AS namirnica_u_pripravi, namirnice. rok_trajanja from jelo
		JOIN JeloNamirnice ON jelo.id = JeloNamirnice.id_jelo
		JOIN namirnice ON namirnice.id = JeloNamirnice.id_namirnice
		WHERE namirnice.rok_trajanja BETWEEN now()::date AND now()::date+50 
		ORDER BY (namirnice.rok_trajanja)
	)distinct_datum
)distinct_jela
ORDER BY (distinct_jela.rok_trajanja);

-> vlasnik restorana želi imati uvid u količinu namirnica koja će ostati raspoloživa nakon pripravljanja određenog jela s dnevnog menija u navedenom broju porcija

SELECT namirnice.naziv, SUM (namirnice.raspoloziva_kol - jelonamirnice.kolicina * jelodnevnimeni.broj_porcija) AS ostaje
FROM jelo
JOIN jelonamirnice ON jelo.id = jelonamirnice.id_jelo
JOIN namirnice ON jelonamirnice.id_namirnice = namirnice.id
JOIN jelodnevnimeni ON jelo.id = jelodnevnimeni.id_jelo
JOIN dnevnimeni ON dnevnimeni.id = jelodnevnimeni.id_dnevnimeni
WHERE dnevnimeni.datum = '2021-10-05'::date AND jelo.naziv = 'Mijesana pizza'
GROUP BY namirnice.naziv;

/*
   -------------------------------
       View
   -------------------------------
*/

-> vlasnik restorana želi imati uvid u ukupnu dnevnu zaradu za pojedini mjesec u godini

CREATE VIEW dnevna_zarada AS
SELECT SUM (jelo.cijena * jeloracun.kolicina) AS zarada, date_part('day', racun.datum) AS dan
FROM racun
JOIN  jeloracun ON jeloracun.id_racun = racun.id
JOIN jelo ON jeloracun.id_racun = jelo.id
WHERE date_part('month', racun.datum) = 05
GROUP BY date_part('day', racun.datum);

-> vlasnik restorana želi imati uvid u jela koja se nalaze na dnevnom meniju odredeni dan

CREATE VIEW jela_na_dnevnom_meniju AS
SELECT jelo.naziv, jelodnevnimeni.broj_porcija AS porcije 
FROM jelo
JOIN jelodnevnimeni ON jelo.id = jelodnevnimeni.id_jelo
JOIN dnevnimeni ON jelodnevnimeni.id_dnevnimeni = dnevnimeni.id
WHERE dnevnimeni.datum = '2021-10-05'::date;

-> Gost želi imati uvid u današnji dnevni meni

CREATE VIEW NaDnevnomMeniu AS
SELECT jelo.naziv, jelo.cijena, jelodnevnimeni.broj_porcija
FROM dnevnimeni
JOIN jelodnevnimeni ON dnevnimeni.id = jelodnevnimeni.id_dnevnimeni
JOIN jelo ON jelodnevnimeni.id_jelo = jelo.id
WHERE dnevnimeni.datum = now()::date;

-> Gost želi imati uvid u meni koja jela su juhe

CREATE VIEW MeniJuhe AS
SELECT jelo.naziv, jelo.cijena
FROM meni
JOIN jelomeni ON meni.id = jelomeni.id_meni
JOIN jelo ON jelomeni.id_jelo = jelo.id
WHERE meni.naziv = ('Juhe');

-> Vlasnica/vlasnik restorana želi imati uvid samo u pregled prometa po danima

CREATE VIEW DnevniPromet AS
SELECT SUM(jelo.cijena * jeloracun.kolicina) AS promet, 
make_date(date_part('year', racun.datum)::int, date_part('month', racun.datum)::int, date_part('day', racun.datum)::int)
AS datum
FROM racun
JOIN jeloracun ON racun.id = jeloracun.id_racun
JOIN jelo ON jeloracun.id_jelo = jelo.id
GROUP BY date_part('day', racun.datum), date_part('month', racun.datum), date_part('year', racun.datum);

/*
   ----------------------------------------------------------------------
       Alternativni način kreiranja novog računa/menia/dnevnog menia
   ----------------------------------------------------------------------
*/

-> Konobar želi kreirati novi račun navodeći samo jela i njihove količine

BEGIN; 
with rows as (
INSERT INTO racun DEFAULT VALUES RETURNING id
)
INSERT INTO jeloracun(id_jelo,id_racun,kolicina) 
VALUES
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Goveda juha'),(SELECT id FROM rows),1),
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Juha od rajcice'),(SELECT id FROM rows),3),
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Mijesana pizza'),(SELECT id FROM rows),4),
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Pizza margarita'),(SELECT id FROM rows),2);
COMMIT;

-> Kuhar želi kreirati novi dnevni meni navodeći samo nazive jela i broj porcija

BEGIN; 
with rows as (
INSERT INTO dnevnimeni(datum) VALUES (now()::date) RETURNING id
)
INSERT INTO jelodnevnimeni(id_jelo,id_dnevnimeni,broj_porcija) 
VALUES
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Goveda juha'),(SELECT id FROM rows),10),
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Mijesana pizza'),(SELECT id FROM rows),10),
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Cokoladna torta'),(SELECT id FROM rows),10);
COMMIT; 

-> Kuhar želi kreirati novi meni navodeći samo naziv menia i jela

BEGIN; 
with rows as (
INSERT INTO meni(naziv) VALUES ('Juhe2') RETURNING id
)
INSERT INTO jelomeni(id_jelo,id_meni) 
VALUES
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Juha od rajcice'),(SELECT id FROM rows)),
((SELECT jelo.id FROM jelo WHERE jelo.naziv='Goveda juha'),(SELECT id FROM rows));
COMMIT; 
