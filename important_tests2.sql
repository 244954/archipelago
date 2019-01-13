/* old methods
INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values ('Stephen','Cunnington','1976-4-27','Kanada','chemik',9000,1);
INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values ('Justyna','Slowik','2000-2-05','Polska','zoolog',6000,'kakao');
INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values ('Adam','Polanowski','1988-7-04','Polska','biolog',5000,5);

INSERT INTO naukowcylogs(id,login,pass)
values (1,'abcdefg','qwerty');
INSERT INTO naukowcylogs(id,login,pass)
values (2,'uniwe','1234');
INSERT INTO naukowcylogs(id,login,pass)
values (3,'hello','darn');
*/

DROP USER IF EXISTS  'unde'@'localhost'; /* ma sie usunac prz usunieciu naukowca */
call dodaj_naukowca('Justyna','Slowik','2000-2-05','Polska','biolog','kakao','unde','1234');
DROP USER IF EXISTS 'jaja'@'localhost'; /* ma sie usunac prz usunieciu naukowca */
call dodaj_naukowca('Hans','Muller','1985-12-13','Niemcy','student','mleko','jaja','1234'); /* to musi byc transakcja*/
DROP USER IF EXISTS  'henlo'@'localhost'; /* ma sie usunac prz usunieciu naukowca */
call dodaj_naukowca('Obi-wan','Kenobi','1980-12-15','Corruscant','mistrz jedi',3,'henlo','there');

call naukowiec_dodaje_zwierze('orzel jakistam','https://wally.com.pl/galerie/f/fototapeta-na-sciane-orzel-obserwujacy-swoje-terytorium-fp-2542_22340.jpg',NULL,'unde',current_date());
call naukowiec_dodaje_zwierze('mysz jakastam','http://www.drapiezniki.pl/Photos/min_mysz-domowa.jpg','orzel jakistam','unde',current_date());
call naukowiec_dodaje_zwierze('inna mysz','http://www.drapiezniki.pl/Photos/min_mysz-domowa.jpg','NULL','jaja','2018-2-05');
call naukowiec_dodaje_zwierze('szczur','http://www.obrazek.jpg','NULL','henlo','2031-2-05');

call naukowiec_dodaje_zwierzetag('orzel jakistam','masa',NULL,12.2,'unde');
call naukowiec_dodaje_zwierzetag('orzel jakistam','kszalt_dzioba','zakrzywiony',NULL,'jaja'); /* to nie jego zwierze */
call naukowiec_dodaje_zwierzetag('orzel jakistam','liczba_mlodych_w_miocie',NULL,6,'unde');

call naukowiec_modyfikuje_zwierze('orzel jakistam','orzel szczegolny',NULL,0,'unde');
call naukowiec_modyfikuje_zwierze('orzel szczegolny','orzel bledny',NULL,0,'jaja');

call naukowiec_usuwa_zwierze('orzel szczegolny','unde');

call naukowiec_modyfikuje_zwierzetag('orzel szczegolny','masa',NULL,13.5,'unde');
call naukowiec_usuwa_zwierzetag('orzel szczegolny','masa','unde');

/* old methods
insert into zwierze(nazwa,imagelink,naturalny_wrog)
values('orzel jakistam','https://wally.com.pl/galerie/f/fototapeta-na-sciane-orzel-obserwujacy-swoje-terytorium-fp-2542_22340.jpg',NULL);
insert into zwierze(nazwa,imagelink,naturalny_wrog)
values('mysz jakastam','http://www.drapiezniki.pl/Photos/min_mysz-domowa.jpg',1);
insert into odkrycie_zwierzecia(id_naukowca,id_zwierzecia,data_odkrycia)
values(1,2,NOW());
insert into odkrycie_zwierzecia(id_naukowca,id_zwierzecia,data_odkrycia)
values(2,1,NOW());
*/

call naukowiec_dodaje_rosline('bagienna kapusta','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQrZmm29mszCsbRAj8nvKjMgyCMcVKuju5JK0zP6m9XPf08c2p0A','unde',current_date());
call naukowiec_dodaje_rosline('stalowa brzoza','https://cdn.doz.pl/image/encyclopedia/165654','unde',current_date());
call naukowiec_dodaje_rosline('switezianka moczarowa','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGNr2PpGF6JmtyNeD9qjsE_u34BvtNdleLbjAUSEEmgS4_SQND','unde','2020-2-05');

call naukowiec_dodaje_roslinatag('bagienna kapusta','wysokosc',NULL,0.2,'unde');
call naukowiec_dodaje_roslinatag('bagienna kapusta','smak','gorzkawy',NULL,'jaja'); /* to nie jego zwierze */
call naukowiec_dodaje_roslinatag('bagienna kapusta','miesiac kwitnienia','czerwiec',NULL,'unde');

call naukowiec_modyfikuje_rosline('bagienna kapusta','moczarowa kapusta',NULL,'unde');
call naukowiec_modyfikuje_rosline('moczarowa kapusta','niedobra kapusta',NULL,'jaja');

call naukowiec_modyfikuje_roslinatag('moczarowa kapusta','wysokosc',NULL,0.5,'unde');
call naukowiec_usuwa_roslinatag('moczarowa kapusta','wysokosc','unde');

call naukowiec_usuwa_rosline('moczarowa kapusta','unde');


/*
insert into zwierzetag(zwierze,etykieta,numbervalue)
values(1,'masa',12.2);
insert into zwierzetag(zwierze,etykieta,stringvalue)
values(1,'ksztaltdzioba','zakrzywiony');
insert into zwierzetag(zwierze,etykieta,numbervalue)
values(2,'masa',0.08);
insert into zwierzetag(zwierze,etykieta,stringvalue)
values(2,'kolorsiersci','zoltawy');
insert into zwierzetag(zwierze,etykieta,numbervalue)
values(2,'mlodewmiocie',12.0);
*/

call delete_zwierze('orzel jakistam');

update zwierze
set naturalny_wrog=2
where naturalny_wrog=1;

delete from zwierze where nazwa='orzel jakistam';

call delete_zwierze('mysz jakastam');