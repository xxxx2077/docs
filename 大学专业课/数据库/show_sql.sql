use library_info_db;

--  1. 测试登录功能
select *from reader_info;
desc reader_info;
alter table reader_info modify RPwd varchar(16) not null;
-- 1.1 注册功能
-- 姓名：测试
-- 身份：学生
-- 性别：男
-- 学号：123
-- 手机号码：12312345678	
-- 密码：123
-- 确认密码：123 

-- 1.2 读者添加功能
-- 读者编号：测试
-- 读者类别：学生
-- 性别：男
-- 学号：123
-- 手机号码：12312345678	
-- 密码：123
-- 确认密码：123 

select*from borrow_info;
select*from return_info;
select*from overdue_info;
select*from lost_info;
select*from damaged_info;
select ISBN,BExnum,BTotal from book_info;
update book_info set BExnum = 1 where ISBN = '7-04-014704-1';

-- 超期处理 
update borrow_info set BrDtime='2023-01-23 10:30:52' where BrNo=28;
update borrow_info set BgDtime='2023-02-22 10:30:52' where BrNo=28;

select *from reader_info;
update reader_info set Rreads=0,RTreads=0,RFTimes =0 where SNo='21311138';
delete from borrow_info where BrNo =26;
delete from return_info where RtNo =11;
delete from damaged_info where DNo =2 ;
delete from lost_info where LNo = 5;
