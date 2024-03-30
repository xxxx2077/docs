## 理论

### 语言简介

- 运行时非常小，不需要垃圾收集，并且对于程序中声明的任何值，默认情况下更倾向于堆栈（ stack）分配，而不是堆（ heap）分配（开销）
- 静态和强类型语言  

Rust 工具链包含两个主要组件：编译器 rustc 和软件包管理器 Cargo ，Cargo用于管理Rust项目



### 变量

变量有三种类型

- 不可变量

  - let用于声明不可变量

  - Shadowing：可以多次声明同名的不可变量，后一次声明会覆盖前一次声明

    ```
    let x = 1;
    let x = "ok";// 此时x为"ok"
    ```

    

- 常量

  - 可在任何作用域内声明，包括**全局作用域**

  - 声明常量需要显式声明其类型

  - 用全大写字母，单词之间用下划线连接

    ```
    const MAX_SIZE:u32 = 123;
    ```

    

- 变量

  - 使用let 和 mut一起声明

```rust
let foo = 1; //Rust默认let声明为不可变的量
foo = 2;//会报错
let mut bar = 1; //mut可声明变量
bar = 2;//不会报错
```

变量名后使用':'+类型名，来显式声明变量类型



## 实践

rust的源文件后缀为.rs

```
rustc --version //检查rust版本
rustc main.rs//运行简单rust程序
```



cargo用于rust的项目

```
cargo --version//检查cargo版本
cargo new hello_cargo//生成新的cargo项目
//进入cargo项目后
cargo build//编译rust的cargo项目
cargo run//编译并执行，若第一次已编译且编译后没有改动，则第二次直接执行
cargo check//检查代码，不生成可执行文件
cargo build --release//用于发布，编译时会进行优化，代码运行更快，但编译时间更长
```

