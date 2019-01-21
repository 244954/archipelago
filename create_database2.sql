/* do zrobienia:
-procedury powinny zwracac blad jesli wystapil jakis konflikt [DONE]
-nazwy zwierzat powinny byc unikalne [DONE]
-procedury dla roslin [DONE]
-widoki
-testy wydajnosci
-blad jesli wystepuje " ' " w nazwie lub linku
-trigger w updacie zwierze blad [DONE]
-id zwierzat i roslin moga rosnac nawet po nieudanych insertach (bo bylo wstawione a potem rollback)
-narzedzie do szukania po tagach?
*/

/* baza danych ///////////////////////////////////////*/

DROP SCHEMA IF EXISTS project;
CREATE SCHEMA project;
USE project;
ALTER DATABASE project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

/* tabele ////////////////////////////////////////////*/

CREATE TABLE IF NOT EXISTS naukowiec(
id int PRIMARY KEY auto_increment,
imie VARCHAR(255) NOT NULL,
nazwisko VARCHAR(255) NOT NULL,
data_urodzenia date NOT NULL,
kraj_pochodzenia VARCHAR(255) NOT NULL,
specjalizacja VARCHAR(255) NOT NULL,
pensja int NOT NULL,
ulubiony_napoj enum('kawa','herbata','kakao','sok_pomaranczowy','cola','woda_gazowana','mleko'),
liczba_odkrytych_gatunkow int
);

CREATE TABLE IF NOT EXISTS naukowcylogs(
id int PRIMARY KEY NOT NULL,
login VARCHAR(255) NOT NULL,
pass VARCHAR(255) NOT NULL,

FOREIGN KEY (id) REFERENCES naukowiec(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS zwierze(
id int PRIMARY KEY auto_increment,
nazwa VARCHAR(255) NOT NULL,
imagelink VARCHAR(500) NOT NULL,
naturalny_wrog int,

FOREIGN KEY (naturalny_wrog) REFERENCES zwierze(id)
);

CREATE TABLE IF NOT EXISTS zwierzetag(
id int PRIMARY KEY auto_increment,
zwierze int NOT NULL,
etykieta VARCHAR (255) NOT NULL,
stringvalue VARCHAR (255),
numbervalue float,

FOREIGN KEY (zwierze) REFERENCES zwierze(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS roslina(
id int PRIMARY KEY auto_increment,
nazwa VARCHAR(255) NOT NULL,
imagelink VARCHAR(500) NOT NULL
);

CREATE TABLE IF NOT EXISTS roslinatag(
id int PRIMARY KEY auto_increment,
roslina int NOT NULL,
etykieta VARCHAR (255) NOT NULL,
stringvalue VARCHAR (255),
numbervalue float,

FOREIGN KEY (roslina) REFERENCES roslina(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS odkrycie_zwierzecia(
id int PRIMARY KEY auto_increment,
id_naukowca int NOT NULL,
id_zwierzecia int NOT NULL,
data_odkrycia date,

FOREIGN KEY (id_naukowca) REFERENCES naukowiec(id),
FOREIGN KEY (id_zwierzecia) REFERENCES zwierze(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS odkrycie_rosliny(
id int PRIMARY KEY auto_increment,
id_naukowca int NOT NULL,
id_rosliny int NOT NULL,
data_odkrycia date,

FOREIGN KEY (id_naukowca) REFERENCES naukowiec(id),
FOREIGN KEY (id_rosliny) REFERENCES roslina(id) ON DELETE CASCADE
);

/* triggery //////////////////////////////////////////*/

DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger1;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger2;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger3;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger4;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger5;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger6;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger7;
DROP TRIGGER IF EXISTS liczba_odkrytych_gatunkow_trigger8;
DROP TRIGGER IF EXISTS insert_naukowiec_trigger;
DROP TRIGGER IF EXISTS update_naukowiec_trigger;
DROP TRIGGER IF EXISTS delete_naukowiec_trigger;
/*DROP TRIGGER IF EXISTS delete_zwierze_trigger;*/
DROP TRIGGER IF EXISTS insert_zwierze_trigger;
DROP TRIGGER IF EXISTS update_zwierze_trigger;

DROP TRIGGER IF EXISTS insert_roslina_trigger;
DROP TRIGGER IF EXISTS update_roslina_trigger;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger1 AFTER INSERT ON odkrycie_zwierzecia
for each row
BEGIN

IF(DATEDIFF(NOW(),NEW.data_odkrycia)<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie aprobujemy podrozy w czasie';
END IF;

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow+1
WHERE id=NEW.id_naukowca;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger2 AFTER INSERT ON odkrycie_rosliny
for each row
BEGIN

IF(DATEDIFF(NOW(),NEW.data_odkrycia)<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie aprobujemy podrozy w czasie';
END IF;

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow+1
WHERE id=NEW.id_naukowca;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger3 AFTER DELETE ON odkrycie_zwierzecia
for each row
BEGIN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=OLD.id_naukowca;

/* on delete cascade powinno wykasowac dane zwierze */

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger4 AFTER DELETE ON odkrycie_rosliny
for each row
BEGIN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=OLD.id_naukowca;

/* on delete cascade powinno wykasowac dana rosline */

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger5 AFTER  UPDATE ON odkrycie_zwierzecia
for each row
BEGIN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=OLD.id_naukowca;

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow+1
WHERE id=NEW.id_naukowca;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger6 AFTER UPDATE ON odkrycie_rosliny
for each row
BEGIN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=OLD.id_naukowca;

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow+1
WHERE id=NEW.id_naukowca;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger7 BEFORE UPDATE ON odkrycie_zwierzecia
for each row
BEGIN

IF(DATEDIFF(NOW(),NEW.data_odkrycia)<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie aprobujemy podrozy w czasie';
END IF;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER liczba_odkrytych_gatunkow_trigger8 BEFORE UPDATE ON odkrycie_rosliny
for each row
BEGIN

IF(DATEDIFF(NOW(),NEW.data_odkrycia)<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie aprobujemy podrozy w czasie';
END IF;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_naukowiec_trigger BEFORE INSERT ON naukowiec
for each row
BEGIN

IF(FLOOR(DATEDIFF(NOW(),NEW.data_urodzenia)/365)<18)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Wiek naukowca nie moze byc mniejszy niz 18';
END IF;

IF(FLOOR(DATEDIFF(NOW(),NEW.data_urodzenia)/365)>100)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Zaleca sie przejscie na emeryture';
END IF;

IF(NEW.pensja<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Pensja nie powinna byc ujemna';
END IF;

SET NEW.liczba_odkrytych_gatunkow=0;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_naukowiec_trigger BEFORE UPDATE ON naukowiec
for each row
BEGIN

IF(FLOOR(DATEDIFF(NOW(),NEW.data_urodzenia)/365)<18)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Wiek naukowca nie moze byc mniejszy niz 18';
END IF;

IF(FLOOR(DATEDIFF(NOW(),NEW.data_urodzenia)/365)>100)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Zaleca sie przejscie na emeryture';
END IF;

IF(NEW.pensja<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Pensja nie powinna byc ujemna';
END IF;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER delete_naukowiec_trigger BEFORE delete ON naukowiec
for each row
BEGIN

/* cos trzeba zrobic z odkrytymi gatunkami */
UPDATE odkrycie_zwierzecia
SET id_naukowca=NULL
WHERE OLD.id=odkrycie_zwierzecia.id_naukowca;

UPDATE odkrycie_rosliny
SET id_naukowca=NULL
WHERE OLD.id=odkrycie_rosliny.id_naukowca;

END;$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER insert_zwierze_trigger BEFORE INSERT ON zwierze
for each row
BEGIN

SET @ij=(SELECT id FROM zwierze WHERE nazwa=NEW.nazwa);


IF(@ij IS NOT NULL)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Takie zwierze juz istnieje';
END IF;

END;$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_zwierze_trigger BEFORE UPDATE ON zwierze
for each row
BEGIN

SET @ij=(SELECT id FROM zwierze WHERE nazwa=NEW.nazwa);


IF(@ij IS NOT NULL AND OLD.nazwa<>NEW.nazwa) /* drugi warunek konieczny */
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Takie zwierze juz istnieje';
END IF;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_roslina_trigger BEFORE INSERT ON roslina
for each row
BEGIN

SET @ij=(SELECT id FROM roslina WHERE nazwa=NEW.nazwa);


IF(@ij IS NOT NULL)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Taka roslina juz istnieje';
END IF;

END;$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_roslina_trigger BEFORE UPDATE ON roslina
for each row
BEGIN

SET @ij=(SELECT id FROM roslina WHERE nazwa=NEW.nazwa);


IF(@ij IS NOT NULL)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Taka roslina juz istnieje';
END IF;

END;$$
DELIMITER ;


/*procedury//////////////////////////////////////////*/

DROP PROCEDURE IF EXISTS delete_zwierze;
DROP PROCEDURE IF EXISTS dodaj_naukowca;

DROP PROCEDURE IF EXISTS naukowiec_dodaje_zwierze;
DROP PROCEDURE IF EXISTS naukowiec_dodaje_zwierzetag;
DROP PROCEDURE IF EXISTS naukowiec_modyfikuje_zwierze;
DROP PROCEDURE IF EXISTS naukowiec_usuwa_zwierze;
DROP PROCEDURE IF EXISTS naukowiec_modyfikuje_zwierzetag;
DROP PROCEDURE IF EXISTS naukowiec_usuwa_zwierzetag;

DROP PROCEDURE IF EXISTS naukowiec_dodaje_rosline;
DROP PROCEDURE IF EXISTS naukowiec_dodaje_roslinatag;
DROP PROCEDURE IF EXISTS naukowiec_modyfikuje_rosline;
DROP PROCEDURE IF EXISTS naukowiec_usuwa_rosline;
DROP PROCEDURE IF EXISTS naukowiec_modyfikuje_roslinatag;
DROP PROCEDURE IF EXISTS naukowiec_usuwa_roslinatag;

DROP PROCEDURE IF EXISTS zwierzeta_pasujace_tagi;
DROP PROCEDURE IF EXISTS rosliny_pasujace_tagi;

delimiter //

CREATE PROCEDURE `delete_zwierze` (
IN nazwazwierzecia varchar(255)
)
BEGIN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=(SELECT s.id_naukowca FROM (select odkrycie_zwierzecia.id_naukowca,zwierze.nazwa from odkrycie_zwierzecia JOIN zwierze ON odkrycie_zwierzecia.id_zwierzecia=zwierze.id) as s WHERE s.nazwa=nazwazwierzecia limit 1);

UPDATE zwierze
SET naturalny_wrog=null
WHERE naturalny_wrog=(SELECT id from (select * from zwierze) as s where nazwa=nazwazwierzecia limit 1);
        
delete from zwierze where nazwa=nazwazwierzecia limit 1; /* limit na wszelki wypadek */

END //

delimiter ;


delimiter //

CREATE PROCEDURE `dodaj_naukowca` (
IN imiee varchar(255),
IN nazwiskoo varchar(255),
IN data_ur date,
IN kraj VARCHAR(255),
IN spec VARCHAR(255),
IN napoj enum('kawa','herbata','kakao','sok_pomaranczowy','cola','woda_gazowana','mleko'),
IN log VARCHAR(255),
IN pas VARCHAR(255)
)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
ROLLBACK;
END;

SET AUTOCOMMIT=0;

START TRANSACTION;

INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values (imiee,nazwiskoo,data_ur,kraj,spec,5000,napoj);

INSERT INTO naukowcylogs(id,login,pass)
values (last_insert_id(),log,pas);


SET @query1 = CONCAT('
        CREATE USER"',log,'"@"localhost" IDENTIFIED BY "',pas,'" '
        );
PREPARE stmt FROM @query1; EXECUTE stmt; DEALLOCATE PREPARE stmt;

COMMIT;

SET @user = CONCAT('
		"',log,'"@"localhost" '
        );
SET @query2 = CONCAT('GRANT UPDATE ON project.zwierze TO ', @user);
PREPARE stmt FROM @query2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query3 = CONCAT('GRANT SELECT,UPDATE,INSERT,DELETE ON project.zwierze TO ', @user);
PREPARE stmt FROM @query3;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query4 = CONCAT('GRANT SELECT,UPDATE,INSERT,DELETE ON project.roslina TO ', @user);
PREPARE stmt FROM @query4;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query5 = CONCAT('GRANT SELECT,UPDATE,INSERT,DELETE ON project.odkrycie_zwierzecia TO ', @user);
PREPARE stmt FROM @query5;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query6 = CONCAT('GRANT SELECT,UPDATE,INSERT,DELETE ON project.odkrycie_rosliny TO ', @user);
PREPARE stmt FROM @query6;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query7 = CONCAT('GRANT SELECT,UPDATE,INSERT,DELETE ON project.zwierzetag TO ', @user);
PREPARE stmt FROM @query7;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @query8 = CONCAT('GRANT SELECT,UPDATE,INSERT,DELETE ON project.roslinatag TO ', @user);
PREPARE stmt FROM @query8;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_dodaje_zwierze` (
IN nazwazwierzecia varchar(255),
IN imagelinkk varchar(500),
IN naturalny_wrog varchar(255),
IN log varchar(255),
IN dataod date
)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
ROLLBACK;
END;

START transaction;

SET @i=(SELECT id FROM zwierze WHERE zwierze.nazwa=naturalny_wrog LIMIT 1);

INSERT INTO zwierze(nazwa,imagelink,naturalny_wrog)
VALUES(nazwazwierzecia,imagelinkk,@i);

SET @ii=(SELECT id FROM naukowcylogs WHERE log=naukowcylogs.login);

INSERT INTO odkrycie_zwierzecia(id_naukowca,id_zwierzecia,data_odkrycia)
VALUES(@ii,last_insert_id(),dataod);

COMMIT;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_dodaje_zwierzetag` (
IN nazwazwierzecia varchar(255),
IN etykietaa varchar (255),
IN stringg varchar(255),
IN numb float,
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM zwierze WHERE zwierze.nazwa=nazwazwierzecia LIMIT 1);
/* sprawdz czy to jego zwierze */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_zwierzecia ON naukowcylogs.id=odkrycie_zwierzecia.id_naukowca WHERE odkrycie_zwierzecia.id_zwierzecia=@i LIMIT 1);

IF (@l=log)
THEN
INSERT INTO zwierzetag(zwierze,etykieta,stringvalue,numbervalue)
values(@i,etykietaa,stringg,numb);
else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub zwierze nie istnieje';
END IF;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_modyfikuje_zwierze` (
IN oldzwierze varchar(255),
IN nazwazwierzecia varchar(255), /* NULL dla bez zmiany*/
IN imagelinkk varchar(500), /* NULL dla bez zmiany*/
IN naturalny_wrogg varchar(255), /* 0 dla bez zmiany*/
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM zwierze WHERE zwierze.nazwa=oldzwierze LIMIT 1);
/* sprawdz czy to jego zwierze */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_zwierzecia ON naukowcylogs.id=odkrycie_zwierzecia.id_naukowca WHERE odkrycie_zwierzecia.id_zwierzecia=@i LIMIT 1);

IF (@l=log)
THEN

IF (nazwazwierzecia IS NOT NULL) THEN
UPDATE zwierze
SET nazwa=nazwazwierzecia
WHERE id=@i; END IF;

IF (imagelinkk IS NOT NULL) THEN
UPDATE zwierze
SET imagelink=imagelinkk
WHERE id=@i; END IF;

IF (naturalny_wrogg <> 0) THEN
UPDATE zwierze
SET naturalny_wrog=naturalny_wrogg
WHERE id=@i; END IF;

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub zwierze nie istnieje';
END IF;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_usuwa_zwierze` (
IN nazwazwierzecia varchar(255),
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM zwierze WHERE zwierze.nazwa=nazwazwierzecia LIMIT 1);
/* sprawdz czy to jego zwierze */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_zwierzecia ON naukowcylogs.id=odkrycie_zwierzecia.id_naukowca WHERE odkrycie_zwierzecia.id_zwierzecia=@i LIMIT 1);

IF (@l=log)
THEN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=(SELECT s.id_naukowca FROM (select odkrycie_zwierzecia.id_naukowca,zwierze.nazwa from odkrycie_zwierzecia JOIN zwierze ON odkrycie_zwierzecia.id_zwierzecia=zwierze.id) as s WHERE s.nazwa=nazwazwierzecia limit 1);

UPDATE zwierze
SET naturalny_wrog=null
WHERE naturalny_wrog=(SELECT id from (select * from zwierze) as s where nazwa=nazwazwierzecia limit 1);
        
delete from zwierze where nazwa=nazwazwierzecia limit 1; /* limit na wszelki wypadek */

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub zwierze nie istnieje';
END IF;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_modyfikuje_zwierzetag` (
IN nazwazwierzecia varchar(255),
IN etykietaa varchar (255),
IN stringg varchar(255),
IN numb float,
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM zwierze WHERE zwierze.nazwa=nazwazwierzecia LIMIT 1);
/* sprawdz czy to jego zwierze */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_zwierzecia ON naukowcylogs.id=odkrycie_zwierzecia.id_naukowca WHERE odkrycie_zwierzecia.id_zwierzecia=@i LIMIT 1);


IF (@l=log)
THEN
UPDATE zwierzetag
SET stringvalue=stringg
WHERE zwierze=@i AND etykieta=etykietaa;

UPDATE zwierzetag
SET numbervalue=numb
WHERE zwierze=@i AND etykieta=etykietaa;

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub zwierze nie istnieje';
END IF;

END //

delimiter ;

delimiter //

CREATE PROCEDURE `naukowiec_usuwa_zwierzetag` (
IN nazwazwierzecia varchar(255),
IN etykietaa varchar(255),
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM zwierze WHERE zwierze.nazwa=nazwazwierzecia LIMIT 1);
/* sprawdz czy to jego zwierze */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_zwierzecia ON naukowcylogs.id=odkrycie_zwierzecia.id_naukowca WHERE odkrycie_zwierzecia.id_zwierzecia=@i LIMIT 1);


IF (@l=log)
THEN

DELETE FROM zwierzetag
WHERE zwierze=@i AND etykieta=etykietaa;

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub zwierze nie istnieje';
END IF;

END //

delimiter ;

/*/////////////////////////////////////////////////////////////////*/

delimiter //

CREATE PROCEDURE `naukowiec_dodaje_rosline` (
IN nazwarosliny varchar(255),
IN imagelinkk varchar(500),
IN log varchar(255),
IN dataod date
)
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
ROLLBACK;
END;

START transaction;

INSERT INTO roslina(nazwa,imagelink)
VALUES(nazwarosliny,imagelinkk);

SET @ii=(SELECT id FROM naukowcylogs WHERE log=naukowcylogs.login);

INSERT INTO odkrycie_rosliny(id_naukowca,id_rosliny,data_odkrycia)
VALUES(@ii,last_insert_id(),dataod);


COMMIT;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_dodaje_roslinatag` (
IN nazwarosliny varchar(255),
IN etykietaa varchar (255),
IN stringg varchar(255),
IN numb float,
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM roslina WHERE roslina.nazwa=nazwarosliny LIMIT 1);
/* sprawdz czy to jego roslina */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_rosliny ON naukowcylogs.id=odkrycie_rosliny.id_naukowca WHERE odkrycie_rosliny.id_rosliny=@i LIMIT 1);

IF (@l=log)
THEN
INSERT INTO roslinatag(roslina,etykieta,stringvalue,numbervalue)
values(@i,etykietaa,stringg,numb);

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub roslina nie istnieje';
END IF;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_modyfikuje_rosline` (
IN oldroslina varchar(255),
IN nazwarosliny varchar(255), /* NULL dla bez zmiany*/
IN imagelinkk varchar(500), /* NULL dla bez zmiany*/
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM roslina WHERE roslina.nazwa=oldroslina LIMIT 1);
/* sprawdz czy to jego roslina */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_rosliny ON naukowcylogs.id=odkrycie_rosliny.id_naukowca WHERE odkrycie_rosliny.id_rosliny=@i LIMIT 1);

SELECT @i,@l;

IF (@l=log)
THEN

IF (nazwarosliny IS NOT NULL) THEN
UPDATE roslina
SET nazwa=nazwarosliny
WHERE id=@i; END IF;

IF (imagelinkk IS NOT NULL) THEN
UPDATE roslina
SET imagelink=imagelinkk
WHERE id=@i; END IF;

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub roslina nie istnieje';
END IF;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_usuwa_rosline` (
IN nazwarosliny varchar(255),
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM roslina WHERE roslina.nazwa=nazwarosliny LIMIT 1);
/* sprawdz czy to jego roslina */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_rosliny ON naukowcylogs.id=odkrycie_rosliny.id_naukowca WHERE odkrycie_rosliny.id_rosliny=@i LIMIT 1);

IF (@l=log)
THEN

UPDATE naukowiec
SET liczba_odkrytych_gatunkow=liczba_odkrytych_gatunkow-1
WHERE id=(SELECT s.id_naukowca FROM (select odkrycie_rosliny.id_naukowca,roslina.nazwa from odkrycie_rosliny JOIN roslina ON odkrycie_rosliny.id_rosliny=roslina.id) as s WHERE s.nazwa=nazwarosliny limit 1);
      
delete from roslina where nazwa=nazwarosliny limit 1; /* limit na wszelki wypadek */

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub roslina nie istnieje';
END IF;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `naukowiec_modyfikuje_roslinatag` (
IN nazwarosliny varchar(255),
IN etykietaa varchar (255),
IN stringg varchar(255),
IN numb float,
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM roslina WHERE roslina.nazwa=nazwarosliny LIMIT 1);
/* sprawdz czy to jego roslina */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_rosliny ON naukowcylogs.id=odkrycie_rosliny.id_naukowca WHERE odkrycie_rosliny.id_rosliny=@i LIMIT 1);


IF (@l=log)
THEN
UPDATE roslinatag
SET stringvalue=stringg
WHERE roslina=@i AND etykieta=etykietaa;

UPDATE roslinatag
SET numbervalue=numb
WHERE roslina=@i AND etykieta=etykietaa;

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub roslina nie istnieje';
END IF;

END //

delimiter ;

delimiter //

CREATE PROCEDURE `naukowiec_usuwa_roslinatag` (
IN nazwarosliny varchar(255),
IN etykietaa varchar(255),
IN log varchar(255)
)
BEGIN

SET @i=(SELECT id FROM roslina WHERE roslina.nazwa=nazwarosliny LIMIT 1);
/* sprawdz czy to jego roslina */
SET @l=(SELECT login FROM naukowcylogs JOIN odkrycie_rosliny ON naukowcylogs.id=odkrycie_rosliny.id_naukowca WHERE odkrycie_rosliny.id_rosliny=@i LIMIT 1);


IF (@l=log)
THEN

DELETE FROM roslinatag
WHERE roslina=@i AND etykieta=etykietaa;

else
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Nie masz uprawnien lub roslina nie istnieje';
END IF;

END //

delimiter ;

/*//////////////////////////////////////////////////////////////////*/

delimiter //

CREATE PROCEDURE `zwierzeta_pasujace_tagi` (
IN e1 varchar(255),IN s1 varchar(255),IN n1 float,
IN e2 varchar(255),IN s2 varchar(255),IN n2 float,
IN e3 varchar(255),IN s3 varchar(255),IN n3 float,
IN e4 varchar(255),IN s4 varchar(255),IN n4 float,
IN e5 varchar(255),IN s5 varchar(255),IN n5 float,
IN e6 varchar(255),IN s6 varchar(255),IN n6 float
)
BEGIN



SELECT zwierze.nazwa,t.c FROM zwierze JOIN
(SELECT zwierze,COUNT(id) as c
FROM zwierzetag
WHERE (e1 IS NOT NULL AND etykieta=e1 AND ( (s1 IS NOT NULL AND stringvalue=s1) OR (n1 IS NOT NULL AND numbervalue=n1) ) ) OR
(e2 IS NOT NULL AND etykieta=e2 AND ( (s2 IS NOT NULL AND stringvalue=s2) OR (n2 IS NOT NULL AND numbervalue=n2) ) ) OR
(e3 IS NOT NULL AND etykieta=e3 AND ( (s3 IS NOT NULL AND stringvalue=s3) OR (n3 IS NOT NULL AND numbervalue=n3) ) ) OR
(e4 IS NOT NULL AND etykieta=e4 AND ( (s4 IS NOT NULL AND stringvalue=s4) OR (n4 IS NOT NULL AND numbervalue=n4) ) ) OR
(e5 IS NOT NULL AND etykieta=e5 AND ( (s5 IS NOT NULL AND stringvalue=s5) OR (n5 IS NOT NULL AND numbervalue=n5) ) ) OR
(e6 IS NOT NULL AND etykieta=e6 AND ( (s6 IS NOT NULL AND stringvalue=s6) OR (n6 IS NOT NULL AND numbervalue=n6) ) )
GROUP BY zwierze
ORDER BY c DESC) as t
ON zwierze.id=t.zwierze;

END //

delimiter ;


delimiter //

CREATE PROCEDURE `rosliny_pasujace_tagi` (
IN e1 varchar(255),IN s1 varchar(255),IN n1 float,
IN e2 varchar(255),IN s2 varchar(255),IN n2 float,
IN e3 varchar(255),IN s3 varchar(255),IN n3 float,
IN e4 varchar(255),IN s4 varchar(255),IN n4 float,
IN e5 varchar(255),IN s5 varchar(255),IN n5 float,
IN e6 varchar(255),IN s6 varchar(255),IN n6 float
)
BEGIN



SELECT roslina.nazwa,t.c FROM roslina JOIN
(SELECT roslina,COUNT(id) as c
FROM roslinatag
WHERE (e1 IS NOT NULL AND etykieta=e1 AND ( (s1 IS NOT NULL AND stringvalue=s1) OR (n1 IS NOT NULL AND numbervalue=n1) ) ) OR
(e2 IS NOT NULL AND etykieta=e2 AND ( (s2 IS NOT NULL AND stringvalue=s2) OR (n2 IS NOT NULL AND numbervalue=n2) ) ) OR
(e3 IS NOT NULL AND etykieta=e3 AND ( (s3 IS NOT NULL AND stringvalue=s3) OR (n3 IS NOT NULL AND numbervalue=n3) ) ) OR
(e4 IS NOT NULL AND etykieta=e4 AND ( (s4 IS NOT NULL AND stringvalue=s4) OR (n4 IS NOT NULL AND numbervalue=n4) ) ) OR
(e5 IS NOT NULL AND etykieta=e5 AND ( (s5 IS NOT NULL AND stringvalue=s5) OR (n5 IS NOT NULL AND numbervalue=n5) ) ) OR
(e6 IS NOT NULL AND etykieta=e6 AND ( (s6 IS NOT NULL AND stringvalue=s6) OR (n6 IS NOT NULL AND numbervalue=n6) ) )
GROUP BY roslina
ORDER BY c DESC) as t
ON roslina.id=t.roslina;

END //

delimiter ;

/*widoki//////////////////////////////////////////////////////////////*/

DROP VIEW IF EXISTS narodowsci_naukowcow;
DROP VIEW IF EXISTS data_odkryc;
DROP VIEW IF EXISTS popularnetagizwierzat;
DROP VIEW IF EXISTS popularnetagiroslin;
DROP VIEW IF EXISTS roslinyztagami;

CREATE VIEW narodowosci_naukowcow
AS
SELECT kraj_pochodzenia,COUNT(id) as jakwiele FROM naukowiec GROUP BY kraj_pochodzenia;

CREATE VIEW data_odkryc
AS
SELECT COUNT(s.data_odkrycia) as ile_odkryc,s.data_odkrycia FROM((SELECT data_odkrycia FROM odkrycie_rosliny) UNION (SELECT data_odkrycia FROM odkrycie_zwierzecia)) as s GROUP BY s.data_odkrycia;

CREATE VIEW popularnetagizwierzat
AS
SELECT etykieta,count(id) as c FROM zwierzetag group by etykieta order by c desc;

CREATE VIEW popularnetagiroslin
AS
SELECT etykieta,count(id) as c FROM roslinatag group by etykieta order by c desc;

CREATE VIEW roslinyztagami
AS
SELECT roslina.nazwa, roslinatag.etykieta, roslinatag.stringvalue FROM project.roslinatag JOIN project.roslina ON roslinatag.roslina = roslina.id;
