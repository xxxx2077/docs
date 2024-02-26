drop database library_info_db;
create database library_info_db;
use library_info_db;
/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2023/12/11 20:58:21                          */
/*==============================================================*/


drop table if exists Book_Info;

drop table if exists Book_StoreInfo;

drop table if exists Book_TypeInfo;

drop table if exists Borrow_Info;

drop table if exists Damaged_Info;

drop table if exists Fines_Info;

drop table if exists Lost_Info;

drop table if exists Manager_Info;

drop table if exists Publisher_Info;

drop table if exists Reader_Info;

drop table if exists Reader_Type;

drop table if exists Retrun_Info;

/*==============================================================*/
/* Table: Book_Info                                             */
/*==============================================================*/
create table Book_Info
(
   ISBN                 varchar(13) not null,
   BTNo                 int not null,
   PID                  int,
   BName                varchar(255) not null,
   BWriter              varchar(30),
   BEdition             varchar(30),
   BPDate               date,
   BPrice               float(10,2) not null,
   BExnum               int not null,
   BIntro               text,
   BTotal               int not null,
   primary key (ISBN)
);

/*==============================================================*/
/* Table: Book_StoreInfo                                        */
/*==============================================================*/
create table Book_StoreInfo
(
   BSNo                 int not null auto_increment,
   ISBN                 varchar(13) not null,
   BSDate               date not null,
   BSStatus             tinyint(2) not null,
   primary key (BSNo)
);

/*==============================================================*/
/* Table: Book_TypeInfo                                         */
/*==============================================================*/
create table Book_TypeInfo
(
   BTNo                 int not null auto_increment,
   BTName               varchar(60) not null,
   primary key (BTNo)
);

/*==============================================================*/
/* Table: Borrow_Info                                           */
/*==============================================================*/
create table Borrow_Info
(
   BrNo                 int not null auto_increment,
   MID                  int not null,
   BSNo                 int not null,
   SNo                  char(8) not null,
   BrDtime              datetime not null,
   BgDTime              datetime not null,
   BrTimes              int not null,
   BrStatus 			bool not null default false,
   primary key (BrNo)
);

/*==============================================================*/
/* Table: Damaged_Info                                          */
/*==============================================================*/
create table Damaged_Info
(
   DNo                  int not null auto_increment,
   RtNo                 int not null,
   MID                  int not null,
   DFines               float(10,2) not null default 0,
   DFStatus             bool not null default false,
   DFDTime              datetime not null,
   DNotion              text,
   primary key (DNo)
);

/*==============================================================*/
/* Table: Fines_Info                                            */
/*==============================================================*/
create table Overdue_Info
(
   ONo                  int not null auto_increment,
   RtNo                 int not null,
   MID                  int not null,
   OFines               float(10,2) not null default 0,
   OFStatus             bool not null default false,
   OFDTime              datetime not null,
   ONotion              text,
   primary key (ONo)
);

/*==============================================================*/
/* Table: Lost_Info                                             */
/*==============================================================*/
create table Lost_Info
(
   LNo                  int not null auto_increment,
   RtNo                 int not null,
   MID                  int not null,
   LFines               float(10,2) not null default 0,
   LFStatus             bool not null default false,
   LFDTime              datetime not null,
   LNotion              text,
   primary key (LNo)
);

/*==============================================================*/
/* Table: Manager_Info                                          */
/*==============================================================*/
create table Manager_Info
(
   MID                  int not null auto_increment,
   MName                varchar(30) not null,
   MSex                 tinyint(1),
   MTelephone           char(11) not null,
   MJob                 varchar(30) not null,
   primary key (MID)
);

/*==============================================================*/
/* Table: Publisher_Info                                        */
/*==============================================================*/
create table Publisher_Info
(
   PID                  int not null auto_increment,
   PName                varchar(60) not null,
   PLinkman             varchar(30),
   Ptelephone           char(11),
   PFax                 char(8),
   PProvince            varchar(20),
   PCity                varchar(40),
   PAddr                varchar(60),
   primary key (PID)
);

/*==============================================================*/
/* Table: Reader_Info                                           */
/*==============================================================*/
create table Reader_Info
(
   RID                  int not null auto_increment,
   RTNo                 int(4),
   SNo                  char(8) not null,
   RName                varchar(40) not null,
   Sex                  tinyint(1),
   Rtelephone           char(11),
   RDTime               datetime not null,
   RVDTime              datetime not null,
   Rreads               int not null,
   RTreads              int not null,
   RLStatus             tinyint(1) not null default 0,
   RFTimes              int not null default 0,
   RNotion              text,
   RPwd                 varchar(16),
   primary key (RID)
);

/*==============================================================*/
/* Table: Reader_Type                                           */
/*==============================================================*/
create table Reader_Type
(
   RTNo                 int(4) not null auto_increment,
   RTName               varchar(40) not null,
   RAreads              int not null,
   RAdays               int not null,
   primary key (RTNo)
);

/*==============================================================*/
/* Table: Retrun_Info                                           */
/*==============================================================*/
create table Return_Info
(
   RtNo                 int not null auto_increment,
   BrNo                 int not null,
   SNo                  char(8) not null,
   MID                  int not null,
   RtDTime              datetime not null,
   RtOverdue            bool not null default false,
   RtDamaged            bool not null default false,
   RtLost               bool not null default false,
   primary key (RtNo)
);

alter table Book_Info add constraint FK_Reference_2 foreign key (BTNo)
      references Book_TypeInfo (BTNo) on delete restrict on update restrict;

alter table Book_Info add constraint FK_Reference_3 foreign key (PID)
      references Publisher_Info (PID) on delete restrict on update restrict;

alter table Book_StoreInfo add constraint FK_Reference_4 foreign key (ISBN)
      references Book_Info (ISBN) on delete restrict on update restrict;

alter table Borrow_Info add constraint FK_Reference_5 foreign key (MID)
      references Manager_Info (MID) on delete restrict on update restrict;

alter table Borrow_Info add constraint FK_Reference_6 foreign key (BSNo)
      references Book_StoreInfo (BSNo) on delete restrict on update restrict;

alter table Borrow_Info add constraint FK_Reference_7 foreign key (SNo)
      references Reader_Info (SNo) on delete restrict on update restrict;

alter table Damaged_Info add constraint FK_Reference_15 foreign key (RtNo)
      references Return_Info (RtNo) on delete restrict on update restrict;

alter table Damaged_Info add constraint FK_Reference_16 foreign key (MID)
      references Manager_Info (MID) on delete restrict on update restrict;

alter table Overdue_Info add constraint FK_Reference_11 foreign key (RtNo)
      references Return_Info (RtNo) on delete restrict on update restrict;

alter table Overdue_Info add constraint FK_Reference_12 foreign key (MID)
      references Manager_Info (MID) on delete restrict on update restrict;

alter table Lost_Info add constraint FK_Reference_13 foreign key (RtNo)
      references Return_Info (RtNo) on delete restrict on update restrict;

alter table Lost_Info add constraint FK_Reference_14 foreign key (MID)
      references Manager_Info (MID) on delete restrict on update restrict;

alter table Reader_Info add constraint FK_Reference_1 foreign key (RTNo)
      references Reader_Type (RTNo) on delete restrict on update restrict;

alter table Return_Info add constraint FK_Reference_10 foreign key (MID)
      references Manager_Info (MID) on delete restrict on update restrict;

alter table Return_Info add constraint FK_Reference_8 foreign key (BrNo)
      references Borrow_Info (BrNo) on delete restrict on update restrict;

alter table Return_Info add constraint FK_Reference_9 foreign key (SNo)
      references Reader_Info (SNo) on delete restrict on update restrict;

alter table reader_info add unique index(SNo);
insert into reader_type values(1,'教师',20,60);
insert into reader_type values(2,'职工',15,60);
insert into reader_type values(3,'学生',10,30);

