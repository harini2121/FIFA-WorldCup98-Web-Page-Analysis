create database worldcup;

Use worldcup;

 
create table splitdata(clid int,r1 string,r2 string,Tstamp string,r3 string,req string,url string,port string,status string,bytes int) row format delimited fields terminated by ‘ ’ ;
 

Show tables;

 

create table data1(clid int,logdate bigint,url string,status string) ;

 

Show tables;

 

LOAD DATA LOCAL INPATH '/resource/sample/sample_data.txt' INTO TABLE splitdata;

 

INSERT INTO data1 (clid, logdate, url, status) SELECT clid,unix_timestamp(substr(Tstamp,2,21),'dd/MMM/yyyy:HH:mm:ss'),url, status FROM splitdata where url rlike '/(english|french).*(.htm|.html)';

 
--1) Total page visits

select count(*) from data1 :

--2) Total unique page visits by client

select count(distinct(clid)) as total_unique_visits from data1 ; 
 

--3)Average total page visits per day

select avg(cnt) from(select count(*) cnt from data1 group by concat(concat(year(from_unixtime(logdate)) , month(from_unixtime(logdate))) , day(from_unixtime(logdate)))) as q1;


 

--4)Histogram of number of total page visits & unique page visits by client per hour of day (1 to 24) 

select count(*) cntvisits, hour(from_unixtime(logdate)) from data1 group by hour(from_unixtime(logdate));

 

select count(*) cntuniq, dayhour from (select hour(from_unixtime(logdate)) as dayhour from data1 group by clid, url, hour(from_unixtime(logdate))) as output group by dayhour;

 

--5)Histogram of number of users(clients) visited the site per day

select concat(year(from_unixtime(logdate)),'-', month(from_unixtime(logdate)),'-', day(from_unixtime(logdate))) as ddate, count(distinct clid) from data1 group by year(from_unixtime(logdate)), month(from_unixtime(logdate)), day(from_unixtime(logdate)); 

 

--6)Top 10 users(clients) by page views

select clid, count(url) as urlcount from data1 group by clid order by urlcount desc  limit 10;

 

--7)Top 10 pages by views

select url, count(clid ) as view_count from data1 group by url order by view_count desc  limit 10;

 

--8)Percentage of web page view by languages (E.g English, French)

Select sum(IF(url rlike '/(english).*',1,0))/COUNT(*) * 100 as english, sum(IF(url rlike '/(french).*',1,0))/COUNT(*) * 100 as french from data1;

 

 

--9)Web page errors percentage during match hours

select sum(case when (status >=400 AND status <600) and

((FROM_UNIXTIME(logdate) BETWEEN '1998-06-13 13:30:00'  AND '1998-06-13 15:15:00')

OR

(FROM_UNIXTIME(logdate) BETWEEN '1998-06-13 16:30:00'  AND '1998-06-13 18:15:00')

OR

(FROM_UNIXTIME(logdate) BETWEEN '1998-06-13 20:00:00'  AND '1998-06-13 21:45:00')

)

then 1.0 else 0 end)/sum(case when

((FROM_UNIXTIME(logdate) BETWEEN '1998-06-16 16:30:00'  AND '1998-06-16 18:15:00')

OR

(FROM_UNIXTIME(logdate) BETWEEN '1998-06-16 20:00:00'  AND '1998-06-16 21:45:00')


)

then 1.0 else 0 end) *100 as page_error from data1;


--10)Percentage of avg web page views per hour during match time and other time

Select count(url) as totalhours  data1;


select count(url) as total_request_hour
from data1 where
(FROM_UNIXTIME(logdate) BETWEEN '1998-06-13 13:30:00'  AND '1998-06-13 15:15:00')
OR
(FROM_UNIXTIME(logdate) BETWEEN '1998-06-13 16:30:00'  AND '1998-06-13 18:15:00')
OR
(FROM_UNIXTIME(logdate) BETWEEN '1998-06-13 20:00:00'  AND '1998-06-13 21:45:00')
OR
(FROM_UNIXTIME(logdate) BETWEEN BETWEEN '1998-06-16 16:30:00'  AND '1998-06-16 18:15:00')
OR
(FROM_UNIXTIME(logdate) BETWEEN BETWEEN '1998-06-16 20:00:00'  AND '1998-06-16 21:45:00');


