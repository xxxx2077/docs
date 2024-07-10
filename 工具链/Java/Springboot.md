# Java

**Java的基础知识：**

JavaGuide：[Java基础常见面试题总结(上) | JavaGuide](https://javaguide.cn/java/basis/java-basic-questions-01.html)

**Java配置**

[Java 开发环境配置 | 菜鸟教程 (runoob.com)](https://www.runoob.com/java/java-environment-setup.html)

jdk download

[Java Downloads | Oracle 中国](https://www.oracle.com/cn/java/technologies/downloads/#jdk17-windows)

# Maven

## Introduction

- Java项目管理和构建工具
- 不同开发工具创建的项目结构一样，规范了项目结构
- 提供一键部署自动化功能
- 管理项目中所有的jar包
  - Maven引入一个仓库，所有的jar包放在里面，所有项目引用这个仓库
  - 如果本机没有，会去网络寻找仓库
- 解决jar包和jar包版本冲突问题
  - 利用“依赖传递”特性把jar包引入

## Configuration

[Maven 环境配置 | 菜鸟教程 (runoob.com)](https://www.runoob.com/maven/maven-setup.html)

如果Maven官网访问不了，打开以下链接

[Index of /dist/maven/maven-3 (apache.org)](https://archive.apache.org/dist/maven/maven-3/)

解压maven编译包之后，打开/conf/settings.xml

添加你想要设置maven仓库（存放所有jar包）的本地位置

![image-20240710172326567](Springboot.assets\image-20240710172326567-1720603416318-1.png)

配置远程仓库

![image-20240710173145058](springboot.assets\image-20240710173145058.png)

配置maven环境变量

- 看以上给的菜鸟教程地址

测试maven是否配置成功

![image-20240710173516968](Springboot.assets\image-20240710173516968.png)

# Springboot