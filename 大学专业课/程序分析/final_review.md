## Introduction

### 为什么需要程序分析

- 程序可靠性
  - 空指针引用，内存泄露
- 程序安全性
  - 隐私信息泄露，注入攻击
- 编译优化
  - 死代码消除
- 程序理解
  - IDE继承关系，类型注解

### 莱斯定理（Rice' Theorem）

没有一种方法能够肯定地判断某个程序是否满足某种性质

或 那些我们所关注的not trivial性质是不能被肯定地判断的

> 注，not trivial性质包括：
>
> - Does P contain any private information leaks? 
> - Does P dereference any null pointers? 
> - Are all the cast operations in P safe? 
> - Can v1 and v2 in P point to the same memory location? 
> - Will certain assert statements in P fail? 
> -  Is this piece of code in P dead (so that it could be eliminated)?

### Perfect Analysis

Soundness(纯粹性)：满足条件的一定在结果集中

Completeness(完备性)：结果集中的元素一定满足条件

举个例子：

条件：程序有bug。

结果：分析器检测出来

**Soundness：**有bug的程序一定被分析器检测出来。所以一个纯粹的分析器从来不会放过一个不正确的程序。

- overapproximate 过拟合。即报告有bug的范围比实际有bug的范围要大，从而覆盖所有有bug的程序。
- 可理解为“宁愿误报也不要漏报”
- Soundness中，我们希望分析器能够包含所有可能的bug
  - positive：分析器能够检测出来；negative：分析器没有检测出来
  - true：false： 程序有bug

**Completeness：**被分析器检测出来的程序一定有bug。所以一个完备的分析器从来不会冤枉一个正确的程序。

- underapproximate 欠拟合。
- “宁愿漏报也不要误报”

如果既满足sound又满足complete，即又不漏报，又不误报，则称为perfect static analysis

举个例子，某程序一共有50个bug，分析器只报告了50个bug，且这50个bug就是某程序实际存在的bug，不多也不少，那就是perfect static analysis

**根据Rice' theorem，显然perfect static analysis不存在**

![image-20240703104747839](final_review.assets/image-20240703104747839.png)

然而我们可以使用**Useful static analysis**

- 妥协soundness，即往complete方向发展，争取准确性
- 妥协completeness，即往sound方向发展，争取全面性

![image-20240703142518357](final_review.assets/image-20240703142518357.png)

实际静态分析中，更偏向于sound

在保证sound的前提下，对精度和速度进行取舍平衡

### Static Analysis

**静态分析本质上是abstraction+over-approximation**

**over-approximation包括transfer functions 和 control flows**

#### abstraction

针对问题求解范围对值域进行抽象，从而缩小求解域的范围

![image-20240703143614580](final_review.assets/image-20240703143614580.png)

#### Over-approximation

##### transfer function

转换函数 定义了如何对不同的程序语句求值（经过抽象之后的值）

转换函数根据 **需要分析的问题** 和 **不同程序语句的语义** 来定义

## Intermediate Representation

![image-20240703150944373](final_review.assets/image-20240703150944373.png)

![image-20240703151002466](final_review.assets/image-20240703151002466.png)

#### ![image-20240703150932516](final_review.assets/image-20240703150932516.png)

SSA：

- 每个定义语句都会产生一个新的变量名
- 传递新变量名直到下一次使用
- 每个变量名都只对应一次定义

![image-20240703151143901](final_review.assets/image-20240703151143901.png)

### CFG

#### Basic block

Basic block的特性：

只有一个入口，且入口为basic block的第一条语句

只有一个出口，且出口为basic block的最后一条语句

