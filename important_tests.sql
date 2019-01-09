INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values ('Stephen','Cunnington','1976-4-27','Kanada','chemik',9000,1);
INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values ('Justyna','Slowik','2000-2-05','Polska','zoolog',6000,'kakao');
INSERT INTO naukowiec(imie,nazwisko,data_urodzenia,kraj_pochodzenia,specjalizacja,pensja,ulubiony_napoj)
values ('Adam','Polanowski','1988-7-04','Polska','biolog',5000,5);

/*
update naukowiec
set pensja=-3
where imie='Stephen';
*/

insert into zwierze(nazwa,gromada,masa,liczba_odnozy,naturalny_wrog)
values('orzel jakistam','ptaki',5.3,2,NULL);

insert into zwierze(nazwa,gromada,masa,liczba_odnozy,naturalny_wrog)
values('mysz jakastam','ssaki',0.1,4,1);

call delete_zwierze('orzel jakistam');

update zwierze
set naturalny_wrog=2
where naturalny_wrog=1;

delete from zwierze where nazwa='orzel jakistam';

insert into odkrycie_zwierzecia(id_naukowca,id_zwierzecia,data_odkrycia)
values(1,2,NOW());
insert into odkrycie_zwierzecia(id_naukowca,id_zwierzecia,data_odkrycia)
values(2,1,NOW());

call delete_zwierze('mysz jakastam');