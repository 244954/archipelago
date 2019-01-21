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
CALL dodaj_losowe_rosliny(10, 1, 20);

truncate table odkrycie_zwierzecia;
truncate table zwierze;

call naukowiec_modyfikuje_zwierze('zwierze3','szczur',NULL,0,'login79');

call zwierzeta_pasujace_tagi('cecha18','wlasciwosc14',NULL,'cecha20','wlasciwosc24',NULL,'cecha3',NULL,12.8195,'cecha16','wlasciwosc1',NULL,NULL,NULL,NULL,NULL,NULL,NULL);

*/

DROP PROCEDURE IF EXISTS dodaj_naukowcow;

delimiter //

CREATE PROCEDURE `dodaj_naukowcow` ()
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

WHILE c <= 10000 DO

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

DROP PROCEDURE IF EXISTS dodaj_losowe_rosliny;
DELIMITER $$
CREATE PROCEDURE dodaj_losowe_rosliny(IN ilosc INT, IN min_tagow INT, IN maks_tagow INT)
    BEGIN
    
    declare l VARCHAR(255) default "login";
	declare ll VARCHAR(255) default "";
    declare d date default current_date();
	declare dd date default NULL;
    
    DECLARE i INT;
    DECLARE a VARCHAR(255);
    DECLARE b VARCHAR(255);
    DECLARE rodzaj INT;
    DECLARE nowa_nazwa_rosliny VARCHAR(255);
    DECLARE licznik_prob INT DEFAULT 0;
    
    DECLARE wartosc_string VARCHAR(255) DEFAULT NULL;
    DECLARE wartosc_int INT DEFAULT NULL;
    DECLARE liczba_cech INT;
    DECLARE wylosowana_cecha VARCHAR(255);
    
    DECLARE j INT;
    
    SET i = 0;
    START TRANSACTION;
    WHILE i < ilosc DO
		SET rodzaj = FLOOR(RAND() * 2);
        IF rodzaj = 0 THEN
			SET a = ELT(0.5 + RAND() * 179, 
			'aloes', 'ananas', 'anyż', 'arcydzięgiel', 'bagno', 'balsamowiec', 'barwinek', 'berberys', 'bez',
			'biedrzeniec', 'bieluń', 'bluszcz', 'bluszczyk', 'bobrek', 'bodziszek', 'buk', 'chaber', 'chinowiec', 'chmiel',
			'chrzan', 'ciemiernik', 'ciemiężyk', 'cis', 'cynamonowiec', 'cytryniec', 'cząber', 'czerniec', 'czosnaczek', 'czosnek',
			'czyściec', 'dąb', 'drapacz', 'driakiew', 'dyptam', 'dziewięćsił', 'dzięgiel', 'dziurawiec', 'farbownik', 'fiołek',
			'glistnik', 'głóg', 'gojnik', 'grążel', 'hakorośl', 'hyzop', 'imbir', 'jabłoń', 'jałowiec', 'janowiec',
			'jarząb', 'jastrzębiec', 'jesion', 'jęczmień', 'karbieniec', 'karczoch', 'kasztanowiec', 'kminek', 'kokornak', 'kokorycz',
			'konitrut', 'koper', 'kopytnik', 'kosaciec', 'kozłek', 'krokosz', 'krwawnik', 'krwiściąg', 'kuklik', 'kurzyślad',
			'len', 'lepiężnik', 'lnicznik', 'lulek', 'łopian', 'łyszczec', 'mak', 'marchew', 'miłek', 'miłorząb',
			'miodownik', 'mniszek', 'modrzew', 'morszczyn', 'muchotrzew', 'majeranek', 'nagietek', 'nawłoć', 'nawrot', 'nostrzyk',
			'ogórecznik', 'oman', 'orzech', 'ostropest', 'ostrożeń', 'ostryż', 'ostrzeń', 'owies', 'ostrokrzew', 'pełnik',
			'perz', 'pieprz', 'pierwiosnek', 'pięciornik', 'płesznik', 'podbiał', 'pokrzyk', 'połonicznik', 'por', 'powojnik',
			'poziewnik', 'prawoślaz', 'prosienniczek', 'przegorzan', 'przelot', 'przestęp', 'przetacznik', 'przęśl', 'przymiotno', 'przywrotnik',
			'pszczelnik', 'pszonak', 'rabarbar', 'rącznik', 'rdest', 'rojnik', 'rokitnik', 'rozchodnik', 'rozmaryn', 'różeniec',
			'rukiew', 'rumian', 'rumianek', 'rzepik', 'rzewień', 'rzodkiew', 'sadziec', 'sałatnik', 'serdecznik', 'sierpik',
			'skrytek', 'skrzyp', 'słonecznik', 'starzec', 'strączyniec', 'stulisz', 'szakłak', 'szczaw', 'szczeć', 'szczodrzyk',
			'szczypiorek', 'szczyr', 'szparag', 'szpinak', 'ślaz', 'świerk', 'świetlik', 'tasznik', 'tatarak', 'tłustosz',
			'tojad', 'traganek', 'trędownik', 'trojeść', 'tymianek', 'ukwap', 'wężymord', 'widlicz', 'widłak', 'wielosił',
			'wrotycz', 'zimowit', 'złoty', 'złotokap', 'żarnowiec', 'żankiel', 'żarnowiec', 'żeń-szeń', 'żywokost', 'żmijowiec');
			
			SET b = ELT(0.5 + RAND() * 251, 
			'uzbrojony', 'jadalny', 'gwiazdkowy', 'litwor', 'zwyczajny', 'pospolity', 'różowy', 'zwyczajny', 'czarny', 'hebd',
			'anyż', 'mniejszy', 'pospolity', 'kurdybanek', 'trójlistkowy', 'cuchnący', 'korzeniasty', 'zwyczajny', 'boży', 'estragon',
			'piołun', 'bławatek', 'kolący', 'soczystoczerwony', 'zwyczajny', 'pospolity', 'biały', 'zielony', 'białokwiatowy', 'pospolity',
			'podróżnik', 'cejloński', 'chiński', 'ogrodowy', 'gronkowy', 'pospolity', 'dęty', 'niedźwiedzi', 'pospolity', 'siatkowaty',
			'wężowy', 'zielonawy', 'storzyszek', 'lekarski', 'prosty', 'roczny', 'bezszypułkowy', 'szypułkowy', 'lekarski', 'jesionolistny',
			'bezłodygowy', 'litwor', 'czteroboczny', 'rozesłany', 'skrzydełkowaty', 'zwyczajny', 'lekarski', 'polny', 'trójbarwny', 'wonny',
			'jaskółczy', 'dwuszyjkowy', 'jednoszyjkowy', 'odgiętodziałkowy', 'drobnokwiatowy', 'drobny', 'żółty', 'biały', 'północny', 'lekarski',
			'pospolity', 'sabiński', 'barwierski', 'ciernisty', 'pospolity', 'kosmaczek', 'wyniosły', 'zwyczajny', 'rzepak', 'pospolity',
			'zwyczajny', 'piaskowy', 'powojnikowy', 'błotny', 'siewny', 'ogrodowy', 'włoski', 'pospolity', 'niemiecki', 'żółty',
			'bzowy', 'lekarski', 'wąskolistny', 'barwierski', 'kichawiec', 'pagórkowy', 'pospolity', 'szlachetny', 'lekarski', 'pospolity',
			'zwisły', 'polny', 'zwyczajny', 'różowy', 'złotogłów', 'siewny', 'czarny', 'mniejszy', 'pajęczynowaty', 'większy',
			'wiechowaty', 'tymianek', 'lekarski', 'piaskowy', 'polny', 'wątpliwy', 'polej', 'wiosenny', 'dwuklapowy', 'melisowaty',
			'hakowaty', 'lekarski', 'europejski', 'polski', 'pęcherzykowaty', 'polny', 'ogrodowy', 'lekarski', 'biały', 'wyniosły',
			'żółty', 'plamisty', 'wschodniy', 'lekarski', 'wielki', 'boldo', 'włoski', 'plamisty', 'warzywny', 'długi',
			'pospolity', 'zwyczajny', 'kolczasty', 'europejski', 'właściwy', 'czarny', 'metystynowy', 'lekarski', 'gęsi', 'kurzy',
			'czerwonkowy', 'pospolity', 'kosmaty', 'nagi', 'pnący', 'dwudzielny', 'piaskowy', 'polny', 'pstry', 'szorstki',
			'wąskolistny', 'lekarski', 'wysoki', 'szorstki', 'kulisty', 'pospolity', 'biały', 'dwupienny', 'leśny', 'kanadyjski',
			'pasterski', 'połyskujący', 'pospolity', 'słodkogórz', 'mołdawski', 'drobnokwiatowy', 'obłączasty', 'ogrodowy', 'zwyczajny', 'ostrogorzki',
			'ptasi', 'wężownik', 'murowy', 'zwyczajny', 'biały', 'ostry', 'lekarski', 'górski', 'psi', 'szlachetny',
			'bezpromieniowy', 'pospolity', 'wonny', 'chiński', 'konopiasty', 'leśny', 'pospolity', 'barwierski', 'polny', 'zimowy',
			'zwyczajny', 'jakubek', 'leśny', 'zwyczajny', 'ostrolistny', 'wąskolistny', 'lekarski', 'pospolity', 'tępolistny', 'zwyczajny',
			'miotlasty', 'roczny', 'trwały', 'lekarski', 'warzywny', 'dziki', 'zaniedbany', 'pospolity', 'łąkowy', 'wyprężony',
			'zwarty', 'przebiśnieg', 'pospolity', 'zwyczajny', 'pospolity', 'polny', 'przerosły', 'mocny', 'szerokolistny', 'bulwiasty',
			'pospolity', 'dwupienny', 'niski', 'stepowy', 'cyprysowaty', 'spłaszczony', 'goździsty', 'jałowcowaty', 'błękitny', 'pospolity',
			'szerokolistny', 'jesienny', 'wąs', 'zwyczajny', 'miotlasty', 'zwyczajny', 'miotlasty', 'pięciolistny', 'prawdziwy', 'lekarski',
			'zwyczajny');
		ELSE
			SET a = ELT(0.5 + RAND() * 131, 
			'alpinia', 'arnika', 'aronia', 'babka', 'bazylia', 'bergenia', 'bocznia', 'borówka', 'brzoza', 'bukwica',
			'bylica', 'cebula', 'centuria', 'cieciorka', 'ciemiężyca', 'cykoria', 'czarnuszka', 'czeremcha', 'czereśnia', 'czyścica',
			'dąbrówka', 'doględa', 'dymnica', 'dynia', 'dziewanna', 'fasola', 'głowienka', 'gorczyca', 'goryczka', 'grusza',
			'gryka', 'herbata', 'ipekakuana', 'jasnota', 'jemioła', 'jeżówka', 'jeżyna', 'jodła', 'kalina', 'kapusta',
			'kocimiętka', 'kokoryczka', 'kola', 'kolendra', 'komosa', 'koniczyna', 'konwalia', 'kozieradka', 'kruszyna', 'krzyżownica',
			'kukurydza', 'lawenda', 'lebiodka', 'lilia', 'lipa', 'lnica', 'lobelia', 'lukrecja', 'lulecznica', 'łoboda',
			'macierzanka', 'malina', 'marzanka', 'marzana', 'marzymięta', 'mąkla', 'melisa', 'męczennica', 'mierznica', 'mięta',
			'miodunka', 'morwa', 'mydlnica', 'naparstnica', 'nasturcja', 'nerecznica', 'oliwka', 'orcza', 'ostróżeczka', 'ożanka',
			'palma', 'paprotka', 'papryka', 'parietaria', 'paulinia', 'pępawa', 'pierwiosnka', 'pietruszka', 'pigwa', 'piwonia',
			'pluskwica', 'pokrzywa', 'porzeczka', 'poziomka', 'przylaszczka', 'przytulia', 'psianka', 'pszenica', 'rauwolfia', 'robinia',
			'rokietta', 'rosiczka', 'róża', 'rudbekia', 'ruta', 'rutwica', 'rzeżucha', 'sałata', 'sasanka', 'soja',
			'sosna', 'stokrotka', 'stroiczka', 'szałwia', 'szanta', 'śliwa', 'świerzbnica', 'śnieżyczka', 'tarczownica', 'tarczyca',
			'topola', 'turówka', 'turzyca', 'warzucha', 'werbena', 'wiązówka', 'wierzba', 'wierzbownica', 'wietlica', 'wilżyna',
			'wiśnia');
			
			SET b = ELT(0.5 + RAND() * 214, 
			'lekarska', 'górska', 'czarnoowocowa', 'lancetowata', 'piaskowa', 'zwyczajna', 'mirra', 'pospolita', 'grubolistna', 'dziędzierzawa',
			'pilkowana', 'brusznica', 'czarna', 'brodawkowata', 'omszona', 'lekarska', 'austriacka', 'polna', 'pontyjska', 'pospolita',
			'roczna', 'nadbrzeżna', 'trojeściowa', 'zwyczajna', 'pstra', 'biała', 'zielona', 'damasceńska', 'siewna', 'zwyczajna',
			'ptasia', 'szalotka', 'lekarska', 'kosmata', 'piramidalna', 'wielka', 'gołębia', 'żółtawa', 'pospolita', 'zwyczajna',
			'drobnokwiatowa', 'kutnerowata', 'wielkokwiatowa', 'zwyczajna', 'pospolita', 'wielkokwiatowa', 'biała', 'czarna', 'polna', 'sarepska',
			'kropkowana', 'krzyżowa', 'trojeściowa', 'wąskolistna', 'żółta', 'pospolita', 'zwyczajna', 'rozesłana', 'chińska', 'prawdziwa',
			'domowa', 'dzika', 'brekinia', 'biała', 'pospolita', 'purpurowa', 'wąskolistna', 'popielica', 'pospolita', 'pospolita',
			'hordowina', 'koralowa', 'czarna', 'polna', 'warzywna', 'wielkokwiatowa', 'właściwa', 'pełna', 'pusta', 'wielkokwiatowa',
			'wonna', 'błyszcząca', 'siewna', 'biała', 'piżmowa', 'strzałkowata', 'łąkowa', 'majowa', 'pospolita', 'pospolita',
			'gorzkawa', 'zwyczajna', 'lekarska', 'pospolita', 'bulwkowata', 'szerokolistna', 'pospolita', 'przylądkowa', 'gładka', 'ukraińska',
			'ogrodowa', 'piaskowa', 'zwyczajna', 'właściwa', 'zwyczajna', 'wonna', 'barwierska', 'orzęsiona', 'tarniowa', 'lekarska',
			'cielista', 'czarna', 'okrągłolistna', 'polna', 'zielona', 'ćma', 'plamista', 'czarna', 'lekarska', 'purpurowa',
			'wełnista', 'zwyczajna', 'większa', 'kanadyjska', 'pospolita', 'późna', 'samcza', 'europejska', 'szlachtawa', 'ogrodowa',
			'polna', 'czosnkowa', 'górska', 'nierównoząbkowa', 'pierzastosieczna', 'właściwa', 'piłkowana', 'zwyczajna', 'roczna', 'lekarska',
			'guarana', 'dwuletnia', 'wyniosła', 'zwyczajna', 'pospolita', 'lekarska', 'europejska', 'groniasta', 'wilcza', 'zwyczajna',
			'żegawka', 'czarna', 'czerwona', 'zwyczajna', 'pospolita', 'twardawa', 'wysoka', 'skrzypowata', 'pospolita', 'właściwa',
			'wonna', 'zwyczajna', 'żmijowa', 'akacjowa', 'siewna', 'okrągłolistna', 'dzika', 'kutnerowata', 'pomarszczona', 'sina',
			'naga', 'wodna', 'zwyczajna', 'lekarska', 'bagienna', 'gorzka', 'łąkowa', 'włochata', 'zwyczajna', 'jadowita',
			'kompasowa', 'siewna', 'łąkowa', 'otwarta', 'wiosenna', 'zwyczajna', 'zwyczajna', 'pospolita', 'rozdęta', 'lekarska',
			'zwyczajna', 'pospolita', 'afrykańska', 'domowa', 'tarnina', 'polna', 'islandzka', 'pospolita', 'wyniosła', 'czarna',
			'amerykańska', 'wonna', 'piaskowa', 'lekarska', 'błotna', 'bulwkowa', 'Zeillera', 'biała', 'purpurowa', 'drobnokwiatowa',
			'samicza', 'ciernista', 'zwyczajna', 'maruna');
		END IF;

		SET ll = CONCAT(l,FLOOR(RAND()*(999))+1);
		SET dd = date_add(date_sub(d,Interval FLOOR(RAND()*(8))+2 YEAR),INTERVAL FLOOR(RAND()*(365))+1 DAY);
        
        SET nowa_nazwa_rosliny = CONCAT(a, ' ', b);
        
        IF nowa_nazwa_rosliny NOT IN (SELECT nazwa FROM roslina) THEN
			CALL naukowiec_dodaje_rosline(nowa_nazwa_rosliny, '/image.png', ll, dd);
            SET licznik_prob = 0;
            SET i = i + 1;
		ELSE
			SET licznik_prob = licznik_prob + 1;
			IF licznik_prob > 1000 THEN
				SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = "nie udało się wylosować unikalnej nazwy rośliny";
			END IF;
		END IF;
        /*IN nazwarosliny varchar(255),
		IN etykietaa varchar (255),
		IN stringg varchar(255),
		IN numb float,
		IN log varchar(255)*/
        IF licznik_prob = 0 THEN
        
			SET liczba_cech = ROUND((RAND() * (maks_tagow - min_tagow)) + min_tagow);
			SET j = 0;
			
			WHILE j < liczba_cech DO
				SET wylosowana_cecha = ELT(0.5 + RAND() * 7, 'występowanie', 'budowa', 'użytkowość', 'wymagania do światła', 'kwasowość gleby', 'tolerancja na pierwiastki', 'zapotrzebowanie na wodę');
				CASE wylosowana_cecha
					WHEN 'występowanie' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 7, 'Afryka', 'Ameryka Południowa', 'Ameryka Północna', 'Antarktyda', 'Australia', 'Azja', 'Europa');
					WHEN 'budowa' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 6, 'drzewa', 'krzewy', 'krzewinki', 'jednoroczne', 'dwuletnie', 'byliny');
					WHEN 'użytkowość' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 16, 'cukrodajne', 'miododajne', 'oleiste', 'owocowe', 'warzywne', 'zbożowe', 'przyprawowe', 'używki', 'włókniste', 'garbnikodajne', 'kauczukodajne', 'lecznicze', 'olejkodajne', 'dostarczające surowca drzewnego', 'pastewne', 'ozdobne');
					WHEN 'wymagania do światła' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 3, 'światłolubne', 'cieniolubne', 'kompasowe');
					WHEN 'kwasowość gleby' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 2, 'zasadolubne', 'kwasolubne');
					WHEN 'tolerancja na pierwiastki' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 4, 'wapieniolubne', 'azotolubne', 'słonolubne', 'galmanowe');
					WHEN 'zapotrzebowanie na wodę' THEN
						SET wartosc_string = ELT(0.5 + RAND() * 6, 'hydrofity', 'hygrofity', 'mezofity', 'tropofity', 'halofity', 'kserofity');
				END CASE;
				IF wartosc_string NOT IN (SELECT roslinatag.stringvalue FROM project.roslinatag JOIN project.roslina ON roslinatag.roslina = roslina.id WHERE roslina.nazwa = nowa_nazwa_rosliny AND roslinatag.stringvalue = wartosc_string) THEN
					CALL naukowiec_dodaje_roslinatag(nowa_nazwa_rosliny, wylosowana_cecha, wartosc_string, wartosc_int, ll);
					SET j = j + 1;
				END IF;
			END WHILE;
            
        END IF;
    END WHILE;
    COMMIT;
END$$
DELIMITER ;
