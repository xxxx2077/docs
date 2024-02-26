## 如何更新外键约束

### 方法1

```sql
set foreign_key_checks=0;//禁用外键约束

执行操作的sql语句块

set foreign_key_checks=1;//恢复外键约束
```

### 方法2

```sql
//首先查询外键约束名
show create table 引用表名

//更改外键约束
alter table 引用表 drop foreign key 约束名;

执行操作的sql语句块

//添加外键约束
alter table 引用表 add foreign key 列名 references 被引用表(列名);
```

我们还可以使用级联更新——更新外键引用的属性时，同时更新外键

- 在创建表时添加级联更新

  ```
  create table student
  (
  	SNo int not null auto_increment,
  	SName varchar(30) not null,
  	Phone char(11) not null,
  	primary key(SNo),
  	foreign key(phone) references Phone_Info(phone) on update cascade
  );
  ```

- 如果表已经创了，那么删除外键约束，重新添加新的外键约束

  按方法2操作

  ```
  //首先查询外键约束名
  show create table 引用表名
  
  //更改外键约束
  alter table 引用表 drop foreign key 约束名;
  
  执行操作的sql语句块
  
  //添加外键约束
  alter table 引用表 add foreign key 列名 references 被引用表(列名) on update cascade;
  ```

  

级联删除同理，只是将on update cascade改为on delete cascade

