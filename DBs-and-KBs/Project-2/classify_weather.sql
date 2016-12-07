-- split data into training and testing
select * from weather order by rand();
create table training like weather;
alter table training add column id INTEGER not null with default 1;
alter table test2 alter column id set generated always as identity;
select count(*)*0.75 from weather; -- 10.50 -> 11
insert into training (select * from weather fetch first 11 rows only);
create table testing like weather;
insert into testing (select * from weather);
delete from testing where exists (select * from training where testing.outlook=training.outlook and testing.temp=training.temp and testing.humidity=training.humidity and testing.wind=training.wind and testing.play=training.play);

-- verticalization
create table vert (col INTEGER, val VARCHAR(10), res VARCHAR(3), cnt INTEGER);
insert into vert (select distinct '1', T1.outlook, T2.play, '0' from training T1, training T2);
insert into vert (select distinct '2', T1.temp, T2.play, '0' from training T1, training T2);
insert into vert (select distinct '3', T1.humidity, T2.play, '0' from training T1, training T2);
insert into vert (select distinct '4', T1.wind, T2.play, '0' from training T1, training T2);
insert into vert (select distinct '5', 'All', play, '0' from training);

update vert set cnt = (select count(*) from training where training.play=vert.res);
update vert set cnt = (select count(*) from training where (training.outlook=vert.val and training.play=vert.res) or (training.temp=vert.val and training.play=vert.res) or (training.humidity=vert.val and training.play=vert.res) or (training.wind=vert.val and training.play=vert.res) or (vert.val='All' and training.play=vert.res));
update vert set cnt = cnt+1;

-- testing data
create table prob_vert (outlook_y FLOAT, temp_y FLOAT, humidity_y FLOAT, wind_y FLOAT, play_y FLOAT, res_y FLOAT, outlook_n FLOAT, temp_n FLOAT, humidity_n FLOAT, wind_n FLOAT, play_n FLOAT, res_n FLOAT);
create table prob_play (res VARCHAR(3));

insert into prob_vert (select log(T1.cnt) as A, log(T2.cnt) as B, log(T3.cnt) as C, log(T4.cnt) as D, log(T5.cnt) as E, 0, log(T6.cnt) as F, log(T7.cnt) as G, log(T8.cnt) as H, log(T9.cnt) as I, log(T10.cnt) as J, 0 from vert T1, vert T2, vert T3, vert T4, vert T5, vert T6, vert T7, vert T8, vert T9, vert T10, testing where (testing.outlook=T1.val and T1.res='Yes') and (testing.temp=T2.val and T2.res='Yes') and (testing.humidity=T3.val and T3.res='Yes') and (testing.wind=T4.val and T4.res='Yes') and (T5.val='All' and T5.res='Yes') and (testing.outlook=T6.val and T6.res='No') and (testing.temp=T7.val and T7.res='No') and (testing.humidity=T8.val and T8.res='No') and (testing.wind=T9.val and T9.res='No') and (T10.val='All' and T10.res='No'));

update prob_vert set res_y = (outlook_y-play_y) + (temp_y-play_y) + (humidity_y-play_y) + (wind_y-play_y) + play_y, res_n = (outlook_n-play_n) + (temp_n-play_n) + (humidity_n-play_n) + (wind_n-play_n) + play_n;

insert into prob_play (select case when res_y >= res_n then 'Yes' when res_y < res_n then 'No' end as "Play" from prob_vert);

-- 1R classification
-- it follows the same procedure to create a verticalized table, and then...
select col, sum(errors) from (select col, val, min(cnt) as errors from vert group by (col, val)) group by col;

-- Then we know it is 1 (outlook)
select testing.id, case when (select count(*) from vert, testing where vert.res='Yes' and vert.col=1 and vert.val=testing.outlook) >= (select count(*) from vert, testing where vert.res='No' and vert.col=1 and vert.val=testing.outlook) then 'Yes' else 'No' end from testing, vert;
