## 理论

### 语言简介

- 运行时非常小，不需要垃圾收集，并且对于程序中声明的任何值，默认情况下更倾向于堆栈（ stack）分配，而不是堆（ heap）分配（开销）
- 静态和**强类型**语言 
  - 强类型要求编译时能够知道所有变量的类型


Rust 工具链包含两个主要组件：编译器 rustc 和软件包管理器 Cargo ，Cargo用于管理Rust项目



### 变量与可变性

#### 变量类型

变量有三种类型

- 不可变量

  - let用于声明不可变量

  - Shadowing：可以多次声明同名的不可变量，后一次声明会覆盖前一次声明

    ```
    let x = 1;
    let x = "ok";// 此时x为"ok"
    ```

    

- 常量

  - 常量不可以使用mut

  - 可在任何作用域内声明，包括**全局作用域**

  - 声明常量需要显式声明其类型

  - 常量只可以绑定到常量表达式，无法绑定到函数的调用结果或只能在运行时才能计算出的值（常量的编译时性质）

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

#### 变量隐藏（Shadowing）

可以使用相同的名字声明新的变量（类型可以不同，值可以不同），新的变量会Shadow（隐藏）之前声明的变量

```rust
let x = 5
let x = x + 1
let x = x * 2
//x = 12
```

### 基本数据类型

#### 变量类型

Rust是静态编译语言，编译时需要知道所有变量类型

- 一般来说，基于使用的值Rust可以推测出它的具体类型
- 如果可能的类型比较多（例如string转换为整数的parse方法，编译器不知道转换为i32还是u32），那么就需要程序员添加类型标注，否则编译会报错

#### 标量类型

##### 整数类型

![image-20240331112729516](Rust learning.assets/image-20240331112729516.png)

**整数默认类型为`i32`**

isize和usize的位数由计算机架构决定：64位系统则64位，32位系统则32位

isize和usize主要是对数组索引操作

###### 整数字面值

![image-20240331113058918](Rust learning.assets/image-20240331113058918.png)



98_222 等价于98,222

###### 整数溢出

- **debug模式**下编译：如果发生溢出，程序运行时会panic
- **release模式（--release）**下编译：Rust不会检查整数溢出，**Rust 会按照补码循环溢出，不会panic。**简而言之，大于该类型最大值的数值会被补码转换成该类型能够支持的对应数字的最小值。比如在 `u8` 的情况下，256 变成 0，257 变成 1，依此类推。

##### 浮点类型

- f32:32位精度
- f64:64位精度

**默认f64**

#### 布尔类型（bool）

- true
- false

#### 字符类型

char，字面值用单引号，4字节，Unicode标量值

```rust
fn main() {
    let c = 'z';
    let z = 'ℤ';
    let g = '国';
    let heart_eyed_cat = '😻';
}
```

### 复合数据类型

#### 元组

长度固定，可容纳不同类型的值

```rust
let t = (500,3.14,'a');
// 或者
let t:(i32,f64,char) = (500,3.14,'a');
```

元组解构

```
let (x,y,z) = t;
println!("{}{}{}",x,y,z);
// x=500, y=3.14, z='a'
```

访问元组元素

```rust
println!("{}{}{}",t.0,t.1,t.2);
```



#### 数组

长度固定，每个元素类型必须相同

数据存放在栈上

```rust
let rest_days = ["Saturday","Sunday"]
//声明类型方式：[类型;长度]
let a:[i32;5]=[1,2,3,4,5]
//另一种声明方式：如果数组各个元素值相同，则 赋值[初始值;数组长度]
let a = [3;5]
```

数组访问：形如a[0]

如果访问的索引超出数组的范围，那么（如下图）

- 编译（cargo build）会进行简单地检查，对于比较复杂地情况可能会通过
- 但运行一定会报错

#### 字符串和切片

##### 切片（slice）

```rust
let s = String::from("hello world");

let hello = &s[0..5];
let world = &s[6..11];
```

与go一样，rust中的slice本质上是对于底层数组的引用，是对底层数组的“视图”，在rust中引用使用`&`表示

如下图，world为切片

![img](https://pic1.zhimg.com/80/v2-69da917741b2c610732d8526a9cc86f5_1440w.jpg)

**切片的通用形式：**

- `&[T]`，共享切片('shared slice')，常被直接称为切片(`slice`)，它不拥有它指向的数据，只是借用。
- `&mut [T]`，可变切片('mutable slice')，可变借用它指向的数据。

特别地，字符串的切片类型为`&str`

> 在对字符串使用切片语法时需要格外小心，切片的索引必须落在字符之间的边界位置，也就是 UTF-8 字符的边界，例如中文在 UTF-8 中占用三个字节，下面的代码就会崩溃：
>
> ```rust
>  let s = "中国人";
>  let a = &s[0..2];
>  println!("{}",a);
> ```
>
> 因为我们只取 `s` 字符串的前两个字节，但是本例中每个汉字占用三个字节，因此没有落在边界处，也就是连 `中` 字都取不完整，此时程序会直接崩溃退出，如果改成 `&s[0..3]`，则可以正常通过编译。 因此，当你需要对字符串做切片索引操作时，需要格外小心这一点, 关于该如何操作 UTF-8 字符串，参见[这里](https://course.rs/basic/compound-type/string-slice.html#操作-utf-8-字符串)。

**字符串字面量是切片`&str`**，所以字符串字面值不可变

```rust
let s: &str = "Hello, world!";
```

##### 字符串

与go相同，字符串是UTF-8编码，字符串中的每个字符所占字节是不定的（1~4）

> 注意区分：
>
> - 字符串String：`String`中的字符字节数长度可变
> - 字符类型char：字节长度固定为4个字节（Unicode类型）

字符串有多种类型，语言层面定义的是str类型，该类型定义的是不可变的字符串（硬编码进可执行文件），常用的切片&str是str的引用

Rust标准库还提供了其他类型的字符串，包括但不仅限于String

**但是，我们常用的字符串往往是String类型和&str类型，这两种类型都是UTF-8编码**

- String字符串存储在**堆**上，可增长，可改变，具有所有权

###### `String`与`&str`的转换

`&str->String`

```rust
let s = String::from("hello,world");
let s = "hello,world".to_string();
```

`String->&str`

对String类型变量取引用即可，例如

```rust
let s = String::from("hello,world");
let s = &s[..]
```

###### 字符串索引

在go中，对字符串取某个索引会访问对应的字节，如果这个字节不是字符的边界，那么打印这个字节会出现乱码

Rust为了避免这种情况，不允许这种行为：

```rust
let s1 = String::from("hello");
let h = s1[0];
```

该代码会产生如下错误：

```console
3 |     let h = s1[0];
  |             ^^^^^ `String` cannot be indexed by `{integer}`
  |
  = help: the trait `Index<{integer}>` is not implemented for `String`
```

同样地，对于字符串切片，如果索引落在字符边界之外，会造成程序的崩溃

```rust
let hello = "中国人";
let s = &hello[0..2];
```

运行上面的程序，会直接造成崩溃：

```console
thread 'main' panicked at 'byte index 2 is not a char boundary; it is inside '中' (bytes 0..3) of `中国人`', src/main.rs:4:14
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

###### 字符串追加

- `s.push_str()`用于添加`&str`
- `s.push()`用于添加`char`

这两个方法都是**在原有的字符串上追加，并不会返回新的字符串**。由于字符串追加操作要修改原来的字符串，则该字符串必须是可变的，即**字符串变量必须由 `mut` 关键字修饰**。

```rust
fn main(){
    let mut s = String::from("hello");
    s.push_str(",world");
    println!("{}",s);
    s.push('!');
    println!("{}",s);
}
```

###### 字符串插入

- `s.insert_str()`用于添加`&str`
- `s.insert()`用于添加`char`

这俩方法需要传入两个参数，第一个参数是字符（串）插入位置的索引，第二个参数是要插入的字符（串），索引从 0 开始计数，如果越界则会发生错误。由于字符串插入操作要**修改原来的字符串**，则该字符串必须是可变的，即**字符串变量必须由 `mut` 关键字修饰**。

```rust
fn main(){
    let mut s = String::from("hello");
    s.push_str(",world");
    println!("{}",s);
    s.push('!');
    println!("{}",s);
}
```

代码运行结果：

```console
插入字符 insert() -> Hello, rust!
插入字符串 insert_str() -> Hello, I like rust!
```

###### 字符串替换

如果想要把字符串中的某个字符串替换成其它的字符串，那可以使用 `replace()` 方法。与替换有关的方法有三个。

1、`replace`

该方法可适用于 `String` 和 `&str` 类型。`replace()` 方法接收两个参数，第一个参数是要被替换的字符串，第二个参数是新的字符串。该方法会替换所有匹配到的字符串。**该方法是返回一个新的字符串，而不是操作原来的字符串**。

示例代码如下：

```rust
fn main() {
    let string_replace = String::from("I like rust. Learning rust is my favorite!");
    let new_string_replace = string_replace.replace("rust", "RUST");
    dbg!(new_string_replace);
}
```

代码运行结果：

```console
new_string_replace = "I like RUST. Learning RUST is my favorite!"
```

2、`replacen`

该方法可适用于 `String` 和 `&str` 类型。`replacen()` 方法接收三个参数，前两个参数与 `replace()` 方法一样，第三个参数则表示替换的个数。**该方法是返回一个新的字符串，而不是操作原来的字符串**。

示例代码如下：

```rust
fn main() {
    let string_replace = "I like rust. Learning rust is my favorite!";
    let new_string_replacen = string_replace.replacen("rust", "RUST", 1);
    dbg!(new_string_replacen);
}
```

代码运行结果：

```console
new_string_replacen = "I like RUST. Learning rust is my favorite!"
```

3、`replace_range`

该方法仅适用于 `String` 类型。`replace_range` 接收两个参数，第一个参数是要替换字符串的范围（Range），第二个参数是新的字符串。**该方法是直接操作原来的字符串，不会返回新的字符串。该方法需要使用 `mut` 关键字修饰**。

示例代码如下：

```rust
fn main() {
    let mut string_replace_range = String::from("I like rust!");
    string_replace_range.replace_range(7..8, "R");
    dbg!(string_replace_range);
}
```

代码运行结果：

```console
string_replace_range = "I like Rust!"
```

###### 字符串删除

与字符串删除相关的方法有 4 个，它们分别是 `pop()`，`remove()`，`truncate()`，`clear()`。这四个方法仅适用于 `String` 类型。

1、 `pop` —— 删除并返回字符串的最后一个字符

**该方法是直接操作原来的字符串**。但是存在返回值，其返回值是一个 `Option` 类型，如果字符串为空，则返回 `None`。 示例代码如下：

```rust
fn main() {
    let mut string_pop = String::from("rust pop 中文!");
    let p1 = string_pop.pop();
    let p2 = string_pop.pop();
    dbg!(p1);
    dbg!(p2);
    dbg!(string_pop);
}
```

代码运行结果：

```console
p1 = Some(
   '!',
)
p2 = Some(
   '文',
)
string_pop = "rust pop 中"
```

2、 `remove` —— 删除并返回字符串中指定位置的字符

**该方法是直接操作原来的字符串**。但是存在返回值，其返回值是删除位置的字符串，只接收一个参数，表示该字符起始索引位置。`remove()` 方法是按照字节来处理字符串的，如果参数所给的位置不是合法的字符边界，则会发生错误。

示例代码如下：

```rust
fn main() {
    let mut string_remove = String::from("测试remove方法");
    println!(
        "string_remove 占 {} 个字节",
        std::mem::size_of_val(string_remove.as_str())
    );
    // 删除第一个汉字
    string_remove.remove(0);
    // 下面代码会发生错误
    // string_remove.remove(1);
    // 直接删除第二个汉字
    // string_remove.remove(3);
    dbg!(string_remove);
}
```

代码运行结果：

```console
string_remove 占 18 个字节
string_remove = "试remove方法"
```

3、`truncate` —— 删除字符串中从指定位置开始到结尾的全部字符

**该方法是直接操作原来的字符串**。无返回值。该方法 `truncate()` 方法是按照字节来处理字符串的，如果参数所给的位置不是合法的字符边界，则会发生错误。

示例代码如下：

```rust
fn main() {
    let mut string_truncate = String::from("测试truncate");
    string_truncate.truncate(3);
    dbg!(string_truncate);
}
```

代码运行结果：

```console
string_truncate = "测"
```

4、`clear` —— 清空字符串

**该方法是直接操作原来的字符串**。调用后，删除字符串中的所有字符，相当于 `truncate()` 方法参数为 0 的时候。

示例代码如下：

```rust
fn main() {
    let mut string_clear = String::from("string clear");
    string_clear.clear();
    dbg!(string_clear);
}
```

代码运行结果：

```console
string_clear = ""
```

###### 字符串连接 

1、使用 `+` 或者 `+=` 连接字符串

使用 `+` 或者 `+=` 连接字符串，要求右边的参数必须为字符串的切片引用（Slice）类型。其实当调用 `+` 的操作符时，相当于调用了 `std::string` 标准库中的 [`add()`](https://doc.rust-lang.org/std/string/struct.String.html#method.add) 方法，这里 `add()` 方法的第二个参数是一个引用的类型。因此我们在使用 `+` 时， 必须传递切片引用类型。不能直接传递 `String` 类型。**`+` 是返回一个新的字符串，所以变量声明可以不需要 `mut` 关键字修饰**。

示例代码如下：

```rust
fn main() {
    let string_append = String::from("hello ");
    let string_rust = String::from("rust");
    // &string_rust会自动解引用为&str
    let result = string_append + &string_rust;
    let mut result = result + "!"; // `result + "!"` 中的 `result` 是不可变的
    result += "!!!";

    println!("连接字符串 + -> {}", result);
}
```

代码运行结果：

```console
连接字符串 + -> hello rust!!!!
```

`add()` 方法的定义：

```rust
fn add(self, s: &str) -> String
```

因为该方法涉及到更复杂的特征功能，因此我们这里简单说明下：

```rust
fn main() {
    let s1 = String::from("hello,");
    let s2 = String::from("world!");
    // 在下句中，s1的所有权被转移走了，因此后面不能再使用s1
    let s3 = s1 + &s2;
    assert_eq!(s3,"hello,world!");
    // 下面的语句如果去掉注释，就会报错
    // println!("{}",s1);
}
```

`self` 是 `String` 类型的字符串 `s1`，该函数说明，只能将 `&str` 类型的字符串切片添加到 `String` 类型的 `s1` 上，然后返回一个新的 `String` 类型，所以 `let s3 = s1 + &s2;` 就很好解释了，将 `String` 类型的 `s1` 与 `&str` 类型的 `s2` 进行相加，最终得到 `String` 类型的 `s3`。

由此可推，以下代码也是合法的：

```rust
let s1 = String::from("tic");
let s2 = String::from("tac");
let s3 = String::from("toe");

// String = String + &str + &str + &str + &str
let s = s1 + "-" + &s2 + "-" + &s3;
```

`String + &str`返回一个 `String`，然后再继续跟一个 `&str` 进行 `+` 操作，返回一个 `String` 类型，不断循环，最终生成一个 `s`，也是 `String` 类型。

`s1` 这个变量通过调用 `add()` 方法后，所有权被转移到 `add()` 方法里面， `add()` 方法调用后就被释放了，同时 `s1` 也被释放了。再使用 `s1` 就会发生错误。这里涉及到[所有权转移（Move）](https://course.rs/basic/ownership/ownership.html#转移所有权)的相关知识。

2、使用 `format!` 连接字符串

`format!` 这种方式适用于 `String` 和 `&str` 。`format!` 的用法与 `print!` 的用法类似，详见[格式化输出](https://course.rs/basic/formatted-output.html#printprintlnformat)。

示例代码如下：

```rust
fn main() {
    let s1 = "hello";
    let s2 = String::from("rust");
    let s = format!("{} {}!", s1, s2);
    println!("{}", s);
}
```

代码运行结果：

```console
hello rust!
```

###### 遍历字符串

**字符**

如果你想要以 Unicode 字符的方式遍历字符串，最好的办法是使用 `chars` 方法，例如：

```rust
for c in "中国人".chars() {
    println!("{}", c);
}
```

输出如下

```console
中
国
人
```

**字节**

这种方式是返回字符串的底层字节数组表现形式：

```rust
for b in "中国人".bytes() {
    println!("{}", b);
}
```

输出如下：

```console
228
184
173
229
155
189
228
186
186
```

**获取子串**

想要准确的从 UTF-8 字符串中获取子串是较为复杂的事情，例如想要从 `holla中国人नमस्ते` 这种变长的字符串中取出某一个子串，使用标准库你是做不到的。 你需要在 `crates.io` 上搜索 `utf8` 来寻找想要的功能。

可以考虑尝试下这个库：[utf8_slice](https://crates.io/crates/utf8_slice)。

#### 结构体

初始化

```rust
struct User{
	name:String,
	age:u32
}
```

- 初始化实例时，每个字段都要初始化
- 初始化字段顺序不需要和结构体定义的顺序相同

```rust
let mut user1 = User{
	age : 28,
	name : String::from("winson"),
};

println!("{}",user1.age);
```

如果结构体某个字段需要可变，那么整个结构体实例需要声明为可变

不能声明结构体某个字段可变

**结构体中具有所有权的字段转移出去后，将无法再访问该字段，但是可以正常访问其它的字段**

##### 简化结构体创建

下面的函数类似一个构建函数，返回了 `User` 结构体的实例：

```rust
fn build_user(email: String, username: String) -> User {
    User {
        email: email,
        username: username,
        active: true,
        sign_in_count: 1,
    }
}
```

它接收两个字符串参数： `email` 和 `username`，然后使用它们来创建一个 `User` 结构体，并且返回。可以注意到这两行： `email: email` 和 `username: username`，非常的扎眼，因为实在有些啰嗦，如果你从 TypeScript 过来，肯定会鄙视 Rust 一番，不过好在，它也不是无可救药：

```rust
fn build_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

如上所示，当函数参数和结构体字段同名时，可以直接使用缩略的方式进行初始化，跟 TypeScript 中一模一样。

##### 结构体更新语法

在实际场景中，有一种情况很常见：根据已有的结构体实例，创建新的结构体实例，例如根据已有的 `user1` 实例来构建 `user2`：

```rust
  let user2 = User {
        active: user1.active,
        username: user1.username,
        email: String::from("another@example.com"),
        sign_in_count: user1.sign_in_count,
    };
```

老话重提，如果你从 TypeScript 过来，肯定觉得啰嗦爆了：竟然手动把 `user1` 的三个字段逐个赋值给 `user2`，好在 Rust 为我们提供了 `结构体更新语法`：

```rust
  let user2 = User {
        email: String::from("another@example.com"),
        ..user1
    };
```

因为 `user2` 仅仅在 `email` 上与 `user1` 不同，因此我们只需要对 `email` 进行赋值，剩下的通过结构体更新语法 `..user1` 即可完成。

`..` 语法表明凡是我们没有显式声明的字段，全部从 `user1` 中自动获取。需要注意的是 `..user1` 必须在结构体的尾部使用。

#### 枚举类型

Rust中的枚举类型比其他语言的枚举类型还要好用很多

枚举类型可用于声明一类事物所有可能的值，这里的值可以是不同数据类型

```
enum 
```

##### `Option<T>`

Rust使用`Option<T>`类型表示那些可能为空的值，`Option<T>`与T类型为不同类型，两者不能进行任意运算，这避免了“编程者认为某个值不为空，而实际为空，从而造成程序panic”的情况

如果要将`Option<T>`与T进行运算，就要将`Option<T>`转换为T类型

```rust
enum Option<T>{
	Some(T),
	None,
}
```

对于None类型需要额外声明接收变量类型，因为编译器无法确定None的类型

```rust
let some_number = Some(5);
let some_string = Some("a string");

let absent_number: Option<i32> = None;
```

如下函数，x为可能为空的参数

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

let five = Some(5);
let six = plus_one(five);
let none = plus_one(None);
```



### 函数

函数的位置可以随便放，Rust 不关心我们在哪里定义了函数，只要有定义即可

函数命名采用下划线，形如

```rust
fn this_is_a_function (parameter-list)->return-value{
	body
}
```

**参数**

函数形参需要声明类型

**返回值**

> Rust是基于表达式的语言，表达式都有值，能返回值的都是表达式
>
> 常见的表达式有：
>
> - 宏
> - 函数
> - 花括号包裹的语句块
> - if condition { expression1 } else { expression2 }

函数返回值不能命名，且只能返回一个（如果要返回多个使用元组）

函数返回值即函数体的返回值，函数体属于语句块

> 语句块默认返回值为语句块最后一行表达式的值
>
> （如果最后一行是语句，则默认返回值为空元组）
>
> - 分号结尾为语句，语句没有值
> - 没有分号结尾为表达式

可以使用return 提前返回

**返回值类型**

- 普通数据类型

- () 表示没有返回值

  - 例如下面的 `report` 函数会隐式返回一个 `()`：

    ```rust
    use std::fmt::Debug;
    
    fn report<T: Debug>(item: T) {
      println!("{:?}", item);
    
    }
    ```

    与上面的函数返回值相同，但是下面的函数显式的返回了 `()`：

    ```rust
    fn clear(text: &mut String) -> () {
      *text = String::from("");
    }
    ```

- ! 表示永不返回

  - 当用 `!` 作函数返回类型的时候，表示该函数永不返回( diverge function )，特别的，这种语法往往用做会导致程序崩溃的函数：

    ```rust
    fn dead_end() -> ! {
      panic!("你已经到了穷途末路，崩溃吧！");
    }
    ```

    下面的函数创建了一个无限循环，该循环永不跳出，因此函数也永不返回：

    ```rust
    fn forever() -> ! {
      loop {
        //...
      };
    }
    ```

### 所有权和借用

#### 堆栈

栈：栈中所有数据都必须占用已知且固定大小的内存空间

堆：对于大小未知或可能变化的数据，我们需要将它存储在堆上

- 分配堆内存时，将会返回对应内存位置的指针，指针大小固定，存储在栈上，通过该指针访问堆内存
- 堆上的数据缺乏组织

#### 所有权

> 所有权三大原则
>
> 1. Rust 中每一个值都被一个变量所拥有，该变量被称为值的所有者
> 2. 一个值同时只能被一个变量所拥有，或者说一个值只能拥有一个所有者
> 3. 当所有者(变量)离开作用域范围时，这个值将被丢弃(drop)

**拷贝和移动**

对于存储在**栈**上的数据（固定大小），赋值通过**值拷贝**的方式完成，并不需要所有权转移

```rust
let x = 5;
let y = x;
// x和y都可用
```

对于存储在**堆**上的数据，赋值时Rust编译器会进行类似浅拷贝的操作，但是不同于浅拷贝，Rust特性在于它会将所有权转移，这个操作被称为 **移动(move)**

以如下例子进行说明：

> `String` 类型是一个复杂类型，由存储在栈中的**堆指针**、**字符串长度**、**字符串容量**共同组成

```rust
let s1 = String::from("hello");
let s2 = s1;
//s2可用，s1不可用，s1对应堆空间的值的所有权转移到了s2上
```

![s1 moved to s2](https://pic1.zhimg.com/80/v2-3ec77951de6a17584b5eb4a3838b4b61_1440w.jpg)

如图，s2拷贝了s1的指针，长度和容量，没有拷贝堆数据，并且使s1无效

这样就解决了我们之前的问题，`s1` 不再指向任何数据，只有 `s2` 是有效的，当 `s2` 离开作用域，它就会释放内存。 相信此刻，你应该明白了，为什么 Rust 称呼 `let a = b` 为**变量绑定**了吧？

**深拷贝**

Rust并不自动执行深拷贝，无论是栈还是堆，都默认进行浅拷贝（此处暂时把 移动 也称为浅拷贝，毕竟只是比浅拷贝多了 转移所有权 一步）

如果要强制进行深拷贝，需要调用clone函数

```rust
let s1 = String::from("hello");
let s2 = s1.clone();

println!("s1 = {}, s2 = {}", s1, s2);
```

Rust 有一个叫做 `Copy` 的特征，可以用在类似整型这样在栈中存储的类型。如果一个类型拥有 `Copy` 特征，一个旧的变量在被赋值给其他变量后仍然可用，也就是赋值的过程即是拷贝的过程。

那么什么类型是可 `Copy` 的呢？可以查看给定类型的文档来确认，这里可以给出一个通用的规则： **任何基本类型的组合可以 `Copy` ，不需要分配内存或某种形式资源的类型是可以 `Copy` 的**。如下是一些 `Copy` 的类型：

- 所有整数类型，比如 `u32`
- 布尔类型，`bool`，它的值是 `true` 和 `false`
- 所有浮点数类型，比如 `f64`
- 字符类型，`char`
- 元组，当且仅当其包含的类型也都是 `Copy` 的时候。比如，`(i32, i32)` 是 `Copy` 的，但 `(i32, String)` 就不是
- 不可变引用 `&T` ，例如[转移所有权](https://course.rs/basic/ownership/ownership.html#转移所有权)中的最后一个例子，**但是注意: 可变引用 `&mut T` 是不可以 Copy的**

#### 借用（borrow)

获取变量的引用，称之为借用。

`&` 符号即是引用，它们允许你使用值，但是不获取所有权，如图所示： ![&String s pointing at String s1](https://pic1.zhimg.com/80/v2-fc68ea4a1fe2e3fe4c5bb523a0a8247c_1440w.jpg)

常规引用是一个指针类型，指向了对象存储的内存地址

```rust
fn main() {
    let x = 5;
    let y = &x;

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

借用有两种：

1. 不可变引用，形如 `&x`
2. 可变引用，形如 `&mut x`

**同一作用域，特定数据只能有一个可变引用，但可以拥有任意多个不可变引用**

**同一作用域，不可变引用与可变引用不能同时存在**

**引用必须总是有效的**（这句话的意思是：不能返回无效地址的引用）

> 注意，引用的作用域 `s` 从创建开始，一直持续到它最后一次使用的地方，这个跟变量的作用域有所不同，变量的作用域从创建持续到某一个花括号 `}`

Rust 的编译器一直在优化，早期的时候，引用的作用域跟变量作用域是一致的，这对日常使用带来了很大的困扰，你必须非常小心的去安排可变、不可变变量的借用，免得无法通过编译，例如以下代码：

```rust
fn main() {
   let mut s = String::from("hello");

    let r1 = &s;
    let r2 = &s;
    println!("{} and {}", r1, r2);
    // 新编译器中，r1,r2作用域在这里结束

    let r3 = &mut s;
    println!("{}", r3);
} // 老编译器中，r1、r2、r3作用域在这里结束
  // 新编译器中，r3作用域在这里结束
```

在老版本的编译器中（Rust 1.31 前），将会报错，因为 `r1` 和 `r2` 的作用域在花括号 `}` 处结束，那么 `r3` 的借用就会触发 **无法同时借用可变和不可变**的规则。

但是在新的编译器中，该代码将顺利通过，因为 **引用作用域的结束位置从花括号变成最后一次使用的位置**，因此 `r1` 借用和 `r2` 借用在 `println!` 后，就结束了，此时 `r3` 可以顺利借用到可变引用。

### 流程控制

- if..else
- else if
- for,while,loop

#### if..else

- **`if` 语句块是表达式**，这里我们使用 `if` 表达式的返回值来给 `number` 进行赋值：`number` 的值是 `5`
- 用 `if` 来赋值时，要保证每个分支返回的类型一样(事实上，这种说法不完全准确，见[这里](https://course.rs/appendix/expressions.html#if表达式))，此处返回的 `5` 和 `6` 就是同一个类型，如果返回类型不一致就会报错

#### for

while无需多言

```rust
fn main() {
    for i in 1..=5 {
        println!("{}", i);
    }
}
```

以上代码循环输出一个从 1 到 5 的序列，简单粗暴，核心就在于 `for` 和 `in` 的联动，语义表达如下：

```rust
for 元素 in 集合 {
  // 使用元素干一些你懂我不懂的事情
}
```

这个语法跟 JavaScript 还蛮像，应该挺好理解。

注意，使用 `for` 时我们往往使用集合的引用形式，除非你不想在后面的代码中继续使用该集合（比如我们这里使用了 `container` 的引用）。如果不使用引用的话，所有权会被转移（move）到 `for` 语句块中，后面就无法再使用这个集合了)：

```rust
for item in &container {
  // ...
}
```

> 对于实现了 `copy` 特征的数组(例如 [i32; 10] )而言， `for item in arr` 并不会把 `arr` 的所有权转移，而是直接对其进行了拷贝，因此循环之后仍然可以使用 `arr` 。

如果想在循环中，**修改该元素**，可以使用 `mut` 关键字：

```rust
for item in &mut collection {
  // ...
}
```

总结如下：

| 使用方法                      | 等价使用方式                                      | 所有权     |
| ----------------------------- | ------------------------------------------------- | ---------- |
| `for item in collection`      | `for item in IntoIterator::into_iter(collection)` | 转移所有权 |
| `for item in &collection`     | `for item in collection.iter()`                   | 不可变借用 |
| `for item in &mut collection` | `for item in collection.iter_mut()`               | 可变借用   |

如果想在循环中**获取元素的索引**：

```rust
fn main() {
    let a = [4, 3, 2, 1];
    // `.iter()` 方法把 `a` 数组变成一个迭代器
    for (i, v) in a.iter().enumerate() {
        println!("第{}个元素是{}", i + 1, v);
    }
}
```

有同学可能会想到，如果我们想用 `for` 循环控制某个过程执行 10 次，但是又不想单独声明一个变量来控制这个流程，该怎么写？

```rust
for _ in 0..10 {
  // ...
}
```

可以用 `_` 来替代 `i` 用于 `for` 循环中，在 Rust 中 `_` 的含义是忽略该值或者类型的意思，如果不使用 `_`，那么编译器会给你一个 `变量未使用的` 的警告。

#### loop

```rust
n main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {}", result);
}
```

以上代码当 `counter` 递增到 `10` 时，就会通过 `break` 返回一个 `counter * 2` 的值，最后赋给 `result` 并打印出来。

这里有几点值得注意：

- **break 可以单独使用，也可以带一个返回值**，有些类似 `return`
- **loop 是一个表达式**，因此可以返回一个值

## 工程

rust的源文件后缀为.rs

```
rustc --version //检查rust版本
rustc main.rs//运行简单rust程序
```

### Cargo

cargo用于rust的项目

cargo生成文件简要介绍：

- cargo.toml为配置文件
- 不要修改cargo.lock

```
cargo --version//检查cargo版本
cargo new hello_cargo//生成新的cargo项目
//进入cargo项目后
cargo build//编译rust的cargo项目
cargo run//编译并执行，若第一次已编译且编译后没有改动，则第二次直接执行
cargo check//检查代码，不生成可执行文件
cargo build --release//用于发布，编译时会进行优化，代码运行更快，但编译时间更长
```

