/*
SELECT date_add(date_sub(current_date(),Interval FLOOR(RAND()*(8))+2 YEAR),INTERVAL FLOOR(RAND()*(365))+1 DAY);
SELECT User, Host FROM mysql.user;

SET FOREIGN_KEY_CHECKS=0;
truncate table odkrycie_zwierzecia;
truncate table zwierze;
SET FOREIGN_KEY_CHECKS=1;

call dodaj_naukowcow();
call usun_konta_naukowcow();
call dodaj_zwierzeta();

truncate table odkrycie_zwierzecia;
truncate table zwierze;

call naukowiec_modyfikuje_zwierze('zwierze3','szczur',NULL,0,'login79');
*/

DROP PROCEDURE IF EXISTS dodaj_naukowcow;

delimiter //

CREATE PROCEDURE `dodaj_naukowcow` (in numb int)
BEGIN
declare c INT default 1;
declare i VARCHAR(255) default "imie";
declare ii VARCHAR(255) default "";
declare n VARCHAR(255) default "nazwisko";
declare nn VARCHAR(255) default "";
declare d date default current_date();
declare dd date default NULL;
declare k VARCHAR(255) default "kraj";
declare kk VARCHAR(255) default "";
declare z VARCHAR(255) default "zawod";
declare zz VARCHAR(255) default "";
declare pp int default 1;
declare l VARCHAR(255) default "login";
declare ll VARCHAR(255) default "";
declare h VARCHAR(255) default "haslo";
declare hh VARCHAR(255) default "";

WHILE c <= 1000 DO

SET ii = CONCAT(i,c);
SET nn = CONCAT(n,c);
SET dd = date_add(date_sub(d,Interval FLOOR(RAND()*(60))+21 YEAR),INTERVAL FLOOR(RAND()*(365))+1 DAY);
SET kk = CONCAT(k,FLOOR(RAND()*(30))+1);
SET zz = CONCAT(z,FLOOR(RAND()*(50))+1);
SET pp = FLOOR(RAND()*(6))+1;
SET ll = CONCAT(l,c);
SET hh = CONCAT(h,c);

call dodaj_naukowca(ii,nn,dd,kk,zz,pp,ll,hh);


SET c = c + 1;
END WHILE;


END //

delimiter ;

DROP PROCEDURE IF EXISTS usun_konta_naukowcow;

delimiter //

CREATE PROCEDURE `usun_konta_naukowcow` ()
BEGIN
declare c INT default 1;
declare l VARCHAR(255) default "login";
declare ll VARCHAR(255) default "";

WHILE c <= 1000 DO

SET ll = CONCAT(l,c);

SET @query1 = CONCAT('
        DROP USER"',ll,'"@"localhost"'
        );
PREPARE stmt FROM @query1; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET c = c + 1;
END WHILE;


END //

delimiter ;

DROP PROCEDURE IF EXISTS dodaj_zwierzeta;

delimiter //

CREATE PROCEDURE `dodaj_zwierzeta` ()
BEGIN
declare c INT default 1;
declare i VARCHAR(255) default "zwierze";
declare ii VARCHAR(255) default "";
declare n VARCHAR(255) default "link";
declare nn VARCHAR(255) default "";
declare kk VARCHAR(255) default NULL;
declare l VARCHAR(255) default "login";
declare ll VARCHAR(255) default "";
declare h VARCHAR(255) default "haslo";
declare hh VARCHAR(255) default "";
declare d date default current_date();
declare dd date default NULL;
declare w VARCHAR(255) default "cecha";
declare ww VARCHAR(255);
declare RAND int;
declare s VARCHAR(255) default "wlasciwosc";
declare ss VARCHAR(255);
declare li float;

WHILE c <= 100 DO

SET ii = CONCAT(i,c);
SET nn = CONCAT(n,c);
IF (c%2=0) THEN SET kk = CONCAT(i,FLOOR(RAND()*(c-1))+1); ELSE SET kk=NULL; END IF;
SET ll = CONCAT(l,FLOOR(RAND()*(999))+1);
SET dd = date_add(date_sub(d,Interval FLOOR(RAND()*(8))+2 YEAR),INTERVAL FLOOR(RAND()*(365))+1 DAY);

call naukowiec_dodaje_zwierze(ii,nn,kk,ll,dd);

SET ss=NULL,li=NULL,ww=NULL;

SET RAND = FLOOR(RAND()*(20))+1;
SET ww = CONCAT(w,RAND);
IF (RAND%2=0) THEN SET ss = concat(s,FLOOR(RAND()*(50))+1); ELSE SET li=RAND()*(50); END IF;

call naukowiec_dodaje_zwierzetag(ii,ww,ss,li,ll);
SET ss=NULL,li=NULL,ww=NULL;

SET RAND = FLOOR(RAND()*(20))+1;
SET ww = CONCAT(w,RAND);
IF (RAND%2=0) THEN SET ss = concat(s,FLOOR(RAND()*(50))+1); ELSE SET li=RAND()*(50); END IF;

call naukowiec_dodaje_zwierzetag(ii,ww,ss,li,ll);


SET c = c + 1;
END WHILE;


END //

delimiter ;
