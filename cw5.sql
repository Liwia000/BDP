--1
CREATE TABLE obiekty (id int PRIMARY KEY, nazwa varchar(50), geometria geometry);

INSERT INTO obiekty (id, nazwa, geometria) 
VALUES (1, 'obiekt1', ST_GeomFromText('COMPOUNDCURVE((0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1),(5 1, 6 1))')),
		(2, 'obiekt2', ST_GeomFromText('GEOMETRYCOLLECTION(COMPOUNDCURVE((10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2),CIRCULARSTRING(14 2, 12 0, 10 2),(10 2, 10 6)),CIRCULARSTRING(11 2, 12 3, 13 2, 12 1, 11 2))')),
		(3, 'obiekt3', ST_GeomFromText('POLYGON((10 17, 12 13, 7 15, 10 17))')),
		(4, 'obiekt4', ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')),
		(5, 'obiekt5', ST_GeomFromText('LINESTRING Z(30 30 59, 38 32 234)')),
		(6, 'obiekt6', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))'));
--2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(o1.geometria, o2.geometria),5))
FROM obiekty o1, obiekty o2
WHERE o1.nazwa = 'obiekt3' AND o2.nazwa = 'obiekt4'

--3 (obiekt musi być zamknięty)
UPDATE obiekty
SET geometria = ST_MakePolygon(ST_AddPoint(geometria, ST_StartPoint(geometria)))
WHERE nazwa = 'obiekt4'

--4
INSERT INTO obiekty (id, nazwa, geometria)
SELECT 7, 'obiekt7', ST_Union(o1.geometria, o2.geometria)
FROM obiekty o1, obiekty o2
WHERE o1.nazwa = 'obiekt3' AND o2.nazwa = 'obiekt4';

SELECT * FROM obiekty;

--5
SELECT SUM(ST_Area(ST_Buffer(geometria, 5))) AS calkowite_pole
FROM obiekty WHERE NOT ST_HasArc(geometria)
