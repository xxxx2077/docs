use library_info_db;
show tables;
desc reader_info;
desc reader_type;
desc book_info;

select *from reader_type;
insert into reader_type values(1,'教师',20,60);
insert into reader_type values(2,'职工',15,60);
insert into reader_type values(3,'学生',10,30);
select *from reader_type;

update reader_info set RPwd='1234' where SNo ='21311138';
select *from reader_info;

select*from book_typeinfo;
insert into book_typeinfo values(1,'A 马克思主义、列宁主义、毛泽东思想、邓小平理论');
insert into book_typeinfo values(2,'B 哲学、宗教');
insert into book_typeinfo values(3,'C 社会科学总论');
insert into book_typeinfo values(4,'D 政治、法律');
insert into book_typeinfo values(5,'E 军事');
insert into book_typeinfo values(6,'F 经济');
insert into book_typeinfo values(7,'G 文化、科学、教育、体育');
insert into book_typeinfo values(8,'H 语言、文字');
insert into book_typeinfo values(9,'I 文学');
insert into book_typeinfo values(10,'J 艺术');
insert into book_typeinfo values(11,'K 历史、地理');
insert into book_typeinfo values(12,'N 自然科学总论');
insert into book_typeinfo values(13,'O 数理科学和化学');
insert into book_typeinfo values(14,'P 天文学、地球科学');
insert into book_typeinfo values(15,'Q 生物科学');
insert into book_typeinfo values(16,'R 医药、卫生');
insert into book_typeinfo values(17,'S 农业科学');
insert into book_typeinfo values(18,'T 工业技术');
insert into book_typeinfo values(19,'U 交通运输');
insert into book_typeinfo values(20,'V 航空、航天');
insert into book_typeinfo values(21,'X 环境科学、安全科学');
insert into book_typeinfo values(22,'Z 综合性图书');

desc publisher_info;
select*from publisher_info;
alter table publisher_info modify Ptelephone char(12) null;
insert into publisher_info values(1,'人民文学出版社','石才','010-65241362',null,'北京市','东城区','朝阳门内大街166号');
insert into publisher_info values(2,'电子工业出版社','卢寒琼','010-88254888',null,'北京市','海淀区','万寿路27号');
insert into publisher_info values(3,'机械工业出版社','温韵华','010-88379033',null,'北京市','西城区','百万庄大街22号院3');
insert into publisher_info values(4,'三联书店','汤恬嫒','010-64002726',null,'北京市','东城区','美术馆东街22号');
insert into publisher_info values(5,'人民邮电出版社','彭萱莎','010-81055256',null,'北京市','东城区','夕照寺街14号');
insert into publisher_info values(6,'商务印书馆','林颉英','010-65219166',null,'北京市','东城区','王府井大街36号');

desc book_info;
select *from book_info;
delete from book_info where ISBN='7-111-11625-9';
insert into book_info values('7-02-000220-X',9,1,'红楼梦','曹雪芹',3,'1996-12',59.70,1,'《红楼梦》是一部百科全书式的长篇小说。以宝黛爱情悲剧为主线，以四大家族的荣辱兴衰为背景，描绘出18世纪中国封建社会的方方面面，以及封建专制下新兴资本主义民主思想的萌动。结构宏大、情节委婉、细节精致，人物形象栩栩如生，声口毕现，堪称中国古代小说中的经典。',1);
insert into book_info values('7-111-11625-9',13,3,'数据库系统概念','Abraham Silberschatz',7,'2003',56.90,3,'夯实数据库理论基础，修炼数据库技术内功的推荐之选。',3);

select ISBN, BName as '书名', BWriter as '作者',BTName as '图书类型', BEdition as '版次', PName as '出版社', BPDate as '出版日期',BPrice as '价格', BIntro as '简介', BExnum as '现在库数量', BTotal as '库存总量' from book_info,book_typeinfo,publisher_info where book_info.BTNo = book_typeinfo.BTNo and book_info.PID = publisher_info.PID;

show tables;
desc publisher_info;
desc borrow_info;
desc reader_info;
desc book_info;
desc book_typeinfo;
desc book_storeinfo;
desc reader_type;
desc return_info;

alter table manager_info add unique index(Mtelephone); 
alter table book_storeinfo modify BSDate datetime not null;
drop table Lost_Info,Fines_Info,Damaged_Info,Retrun_Info,Borrow_Info;

select*from  manager_info;
insert into manager_info values(1,'王乐球',1,'13712345678','图书借阅管理');
update manager_info set MPwd = '123' where MID=1;
alter table manager_info add MPwd varchar(16) not null;

alter table publisher_info add unique index(PName);
select*from book_typeinfo;

insert into book_info (ISBN,BTNo,PID,BName,BWriter,BEdition,BPDate,BPrice,BExnum,BIntro,BTotal) values('5',5,4,'1','2','4','3',6,1,'123',1);
select *from book_info;
delete from book_info where ISBN='5';
insert into book_storeinfo (ISBN,BSDate) values('5','{1}');

select *from book_storeinfo;
delete from book_storeinfo where ISBN='5';

update book_info set BName='红楼梦',BTNo=9,PID=1,BWriter='曹雪芹',BEdition='3',BPdate='1996',BPrice=59.7 where ISBN = '7-02-000220-X';

alter table borrow_info add BrtStatus bool not null default false;
alter table book_storeinfo modify BSStatus tinyint(2) not null default 0;
alter table borrow_info modify MID tinyint(2) null default 0;

select BSNo,ri.RTNo,RAdays,RAreads,Rreads from book_storeinfo bs,reader_info ri,reader_type rt where ri.SNo='21311138' and rt.RTNo=ri.RTNo and BSStatus=0 and ISBN='7-02-000220-X';

select ri.RTNo,RAdays,RAreads,Rreads from reader_info ri,reader_type rt where ri.SNo='21311138' and rt.RTNo=ri.RTNo;
select BSNo from book_storeinfo where BSStatus=0 and ISBN='7-02-000220-X';
select BSNo,ri.RTNo,RAdays,RAreads,Rreads from book_storeinfo bs,reader_info ri,reader_type rt where ri.SNo='21311138' and rt.RTNo=ri.RTNo and BSStatus=0 and ISBN='7-04-014704-1';
insert into borrow_info (BSNo,SNo,MID,BrDtime,BgDTime) values(8,'21311138',1,'2024-01-15 12:40:59','2024-03-15 12:40:59');
insert into borrow_info (BSNo,SNo,MID,BrDtime,BgDTime) values(8,'21311138',1,'2024-01-15 12:56:10','2024-03-15 12:56:10');
select *from borrow_info;
delete from borrow_info where BrNo=8;

select*from manager_info;
delete from manager_info where MID=1;
update manager_info set MTelephone='00000000000' where MID=1;
insert into manager_info values(2,'王乐球',1,'13712345678','图书借阅管理','123');
alter table borrow_info modify BrTimes int not null default 0;

alter table return_info modify MID int not null default 1;
select *from return_info;
desc return_info;
alter table return_info add BtStatus bool not null default false; 

select RtNo as '还书序号',bri.BrNo as '借阅编号',bi.BName as '书名',bri.SNo as '读者编号',ri.MID as '管理员工号',MName as '管理员姓名',RtDTime as '归还时间',BtStatus as '办理状态',RtOverdue as '是否超期',RtDamaged as '是否损坏', RtLost as '是否丢失' from return_info ri,borrow_info bri,manager_info mi,book_storeinfo bsi,book_info bi where ri.MID=mi.MID and ri.BrNo=bri.BrNo and bsi.BSNo = bri.BSNo and bsi.ISBN=bi.ISBN;

alter table return_info add OverdueDays int not null default 0;
desc overdue_info;
desc damaged_info;
desc lost_info;

select*from book_info;
delete from book_info where ISBN='7-02-000220-X';

select *from return_info;
update book_info set BExnum = 1 where ISBN ='7-02-000220-X';
delete from borrow_info where brno = 13 ;
delete from return_info where RtNo =3;
update return_info set RtLost=false where RtNo=4;

select *from reader_info;
select *from reader_type;
select *from borrow_info;
desc reader_info;
alter table reader_info modify Rreads int not null default 0;
alter table reader_info modify RTreads int not null default 0;

select *from overdue_info;