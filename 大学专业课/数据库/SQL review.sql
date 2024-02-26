-- database review

-- 数据库操作
create database review_db; 
show databases;
drop database review_db;
use review_db;

-- SQL模式操作
 create schema test;-- 等价于create database test; 
 drop schema test;-- 等价于drop database test; 
show databases;

-- 表操作
create table Student_Info
(
	SNo varchar(10) not null primary key,
    SName varchar(30) not null,
    Sex int null default 1,
    Birthday datetime null,
    Major int null,
    Scores float null default 0,
    Remark text null
) ;

CREATE TABLE Course_Info
(
	CID int NOT NULL auto_increment primary key,
	CName varchar(30) NOT NULL,
	Term int NULL DEFAULT 1,
	CTime int NULL,
	CScore float NOT NULL
);

CREATE TABLE Score_Info
(
	SNo varchar(10) not null,
    CID int not null,
    Score float null,
    primary key(SNo,CID),
    foreign key(SNo) references Student_Info(SNo),
    foreign key(CID) references Course_Info(CID)
);

CREATE TABLE test
(
	SNo varchar(10) not null,
    CID int not null,
    Score float null,
    foreign key(SNo) references Student_Info(SNo),
    foreign key(CID) references Course_Info(CID)
);

show tables;

desc Student_info;
desc Score_Info;
desc Course_Info;
desc test;

alter table Student_info add hobby text null;
alter table Student_info drop hobby;
alter table Student_Info modify hobby varchar(50);

alter table test add primary key(SNo,CID);

drop table test;

-- 表的增删改查
insert Student_Info (SNo,SName,Sex) values ('1',"test1",1); 
insert Student_Info (SNo,SName,Scores) values ('2',"test2",100); 
insert Student_Info (SNo,SName,Sex,Scores) values ('3',"test3",0,default); 

update Student_Info set SNo='3',SName='test9' where SNo='4';

select *from Student_Info;

delete from Student_Info where SNo='3';