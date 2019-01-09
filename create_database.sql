/* nie robic deletow do tabeli zwierzeta!
/* od tego bedzie osobna procedura // yup
/* kaskadowy delete nie wywoluje triggera w odkrycie_zwierzecia-> problem // solved
/* problem jak usune czyjegos naturalnego wroga // nope

/* baza danych ///////////////////////////////////////*/

DROP SCHEMA IF EXISTS project;
CREATE SCHEMA project;
USE project;

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

CREATE TABLE IF NOT EXISTS zwierze(
id int PRIMARY KEY auto_increment,
nazwa VARCHAR(255) NOT NULL,
gromada enum('ssaki','gady','plazy','ptaki','owady','pajeczaki','ryby','slimaki','pijawki','koralowce'),
masa float NOT NULL,
liczba_odnozy int NOT NULL,
naturalny_wrog int,

FOREIGN KEY (naturalny_wrog) REFERENCES zwierze(id)
);

CREATE TABLE IF NOT EXISTS roslina(
id int PRIMARY KEY auto_increment,
nazwa VARCHAR(255) NOT NULL,
wysokosc float NOT NULL,
zabarwienie VARCHAR(255) NOT NULL,
trujacy boolean NOT NULL,
zastosowanie_kulinarne boolean NOT NULL
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
DROP TRIGGER IF EXISTS insert_zwierze_trigger;
DROP TRIGGER IF EXISTS insert_roslina_trigger;
DROP TRIGGER IF EXISTS update_naukowiec_trigger;
DROP TRIGGER IF EXISTS update_zwierze_trigger;
DROP TRIGGER IF EXISTS update_roslina_trigger;
DROP TRIGGER IF EXISTS delete_naukowiec_trigger;
/*DROP TRIGGER IF EXISTS delete_zwierze_trigger;*/

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
CREATE TRIGGER insert_zwierze_trigger BEFORE INSERT ON zwierze
for each row
BEGIN

IF(NEW.masa<0.0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Ujemna masa przeczy prawom fizyki';
END IF;

IF(NEW.liczba_odnozy<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Ujemna masa odnozy; plz no';
END IF;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_roslina_trigger BEFORE INSERT ON roslina
for each row
BEGIN

IF(NEW.wysokosc<0.0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Ujemna wysokosc';
END IF;

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
CREATE TRIGGER update_zwierze_trigger BEFORE UPDATE ON zwierze
for each row
BEGIN

IF(NEW.masa<0.0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Ujemna masa przeczy prawom fizyki';
END IF;

IF(NEW.liczba_odnozy<0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Ujemna masa odnozy; plz no';
END IF;

END;$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_roslina_trigger BEFORE UPDATE ON roslina
for each row
BEGIN

IF(NEW.wysokosc<0.0)
THEN
SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Ujemna wysokosc';
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

/*
DELIMITER $$
CREATE TRIGGER delete_zwierze_trigger BEFORE delete ON zwierze
for each row
BEGIN

UPDATE zwierze
SET naturalny_wrog=NULL
WHERE naturalny_wrog=OLD.naturalny_wrog;

END;$$
DELIMITER ;
*/

/*procedury//////////////////////////////////////////*/

DROP PROCEDURE IF EXISTS delete_zwierze;

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