# Go

> Go语言圣经：https://gopl-zh.github.io/

## 程序结构

### 命名

变量命名有三种：

1. 关键字：关键字不能用于自定义名字

   ```
   break      default       func     interface   select
   case       defer         go       map         struct
   chan       else          goto     package     switch
   const      fallthrough   if       range       type
   continue   for           import   return      var
   
   ```

   

2. 预定义：预定义的名字可以在定义中重新使用，但是要避免过度定义预定义导致语义混乱

   ```
   内建常量: true false iota nil
   
   内建类型: int int8 int16 int32 int64
             uint uint8 uint16 uint32 uint64 uintptr
             float32 float64 complex128 complex64
             bool byte rune string error
   
   内建函数: make len cap new append copy close delete
             complex real imag
             panic recover
   
   ```

   

3. 自定义：

   - Go通常采用驼峰式对变量、函数等命名，如heapSort



包内变量和函数的**首字母是否大写**决定了其能否被其他包访问：

- 首字母大写，表示其他包能够访问这个变量/函数
- 首字母小写，表示其他包不能访问这个变量/函数

### 变量

#### 变量声明

**通用变量声明（常用于全局变量）**

```
通用表达：
var 变量名 类型 = 表达式

其中类型和表达式不一定都写，如下：
var 变量名 类型  //默认初始化为零值（Go不存在没有初始化的变量）
var 变量名 = 表达式 //Go自动推测变量类型
```

举个例子

```
var x string = "hello"
var x = "hello"
var x string

// 规定类型的时候只能使用相同类型的表达式
var x,y,z int = 2,3,4
// 不规定类型的时候可以使用不同类型的表达式
var x,y,z = true,2.3,"hello"
```

**局部变量声明**

```
x := "hello"
```

**特别说明：**

简短变量声明左边的变量可能并不是全部都是刚刚声明的。如果有一些已经在相同的词法域声明过了，那么简短变量声明语句对这些已经声明过的变量就只有赋值行为了。

在下面的代码中，第一个语句声明了in和err两个变量。在第二个语句只声明了out一个变量，然后对已经声明的err进行了赋值操作。

```
in, err := os.Open(infile)
// ...
out, err := os.Create(outfile)
```

简短变量声明语句中必须至少要声明一个新的变量，下面的代码将不能编译通过：

```Go
f, err := os.Open(infile)
// ...
f, err := os.Create(outfile) // compile error: no new variables
```

#### 指针

同C类似，不赘述

#### new函数

new(T)创建一个T类型的匿名变量，初始化为T类型的零值，然后返回该变量的地址，返回的地址（指针）类型为*T

```
p := new(int)   // p, *int 类型, 指向匿名的 int 变量
fmt.Println(*p) // "0"
*p = 2          // 设置 int 匿名变量的值为 2
fmt.Println(*p) // "2"
```

#### 变量的生命周期

区分作用域和生命周期

作用域是编译时确定的，生命周期是运行时确定的

Go的生命周期判断与C不同，Go判断变量是否可达从而确定该变量的生命周期

**因此，局部变量的生命周期可能会超出局部作用域或者函数作用域，并且编译器会自动选择该局部变量存储在栈上还是堆上**

> 如果局部变量的生命周期超出局部作用域或者函数作用域，我们称其为逃逸
>
> 一般局部变量存储在栈上，如果变量逃逸，则编译器将其存储在堆上
>
> （这么说不一定准确，等后面深入了解了打脸）

#### 赋值

与C不同，`v++`和`v--`是语句而不是表达式，这意味着`x=v++`的写法是错误的

```
v++
v--
```

**元组赋值**

先计算等号右边的值，再赋给等号左边的变量

```
x, y = y, x

a[i], a[j] = a[j], a[i]

```

计算斐波纳契数列（Fibonacci）的第N个数：

```Go
func fib(n int) int {
    x, y := 0, 1
    for i := 0; i < n; i++ {
        x, y = y, x+y
    }
    return x
}
```

#### 类型

类型提供了分隔不同概念的模型，即便它们底层类型相同，也是不同

```
type 类型名字 底层类型
```

对于每一个类型T，都有一个对应的类型转换操作T(x)，用于将x转为T类型（译注：如果T是指针类型，可能会需要用小括弧包装T，比如`(*int)(0)`）。**只有当两个类型的底层基础类型相同时，才允许这种转型操作，或者是两者都是指向相同底层结构的指针类型，这些转换只改变类型而不会影响值本身。**

比较运算符`==`和`<`也可以用来比较一个命名类型的变量和另一个有相同类型的变量，或有着相同底层类型的未命名类型的值之间做比较。但是**如果两个值有着不同的类型，则不能直接进行比较**

#### 包和文件

- 每个包享有独立的命名空间，即package1和package2可以都有函数foo，而且函数的定义也不同，在外部引用时必须显式使用package1.Foo或package2.Foo形式访问。
- 包能够隐藏内部实现信息，有点像封装的意思（首字母小写的变量/函数等外部不能访问，大写的可以）

#### 作用域

没啥好说

## 基础数据类型

### 整型

- int8、int16、int32、int64

- uint8、uint16、uint32、uint64

  - **rune**等价于int32，表示一个Unicode码点（存储Unicode码点值），主要用来表示Unicode字符（例如中文字符）

  - **byte**等价于uint8，表示字符的字节（存储字符的字节值）
  - 一个英文字符对应一个字节，一个中文字符对应三个字节，所以用len(英文字符)既能表示字节数也能表示字符数，而对于Unicode字符len(Unicode字符)只能表示字节数，不能表示字符数，需要用rune来转换

> 关于rune [详解 Go 中的 rune 类型 - 技术颜良 - 博客园 (cnblogs.com)](https://www.cnblogs.com/cheyunhua/p/16007219.html)

有符号整数采用2的补码形式表示，也就是最高bit位用来表示符号位，一个n-bit的有符号数的值域是从$-2^{n-1}$到$2^{n-1}-1$。

无符号整数的所有bit位都用于表示非负数，值域是0到$2^{n-1}$。例如，int8类型整数的值域是从-128到127，而uint8类型整数的值域是从0到255。

**运算符**

下面是Go语言中关于算术运算、逻辑运算和比较运算的二元运算符，它们按照优先级递减的顺序排列：

```
*      /      %      <<       >>     &       &^
+      -      |      ^
==     !=     <      <=       >      >=
&&
||
```

- 算术运算符`+`、`-`、`*`和`/`可以适用于整数、浮点数和复数
- 取模运算符%仅用于整数间的运算
  - 在Go语言中，%取模运算符的符号和被取模数的符号总是一致的，因此`-5%3`和`-5%-3`结果都是-2。
- 除法运算符`/`的行为则依赖于操作数是否全为整数，比如`5.0/4.0`的结果是1.25，但是5/4的结果是1，因为整数除法会向着0方向截断余数

Go语言还提供了以下的bit位操作运算符，前面4个操作运算符并不区分是有符号还是无符号数：

```
&      位运算 AND
|      位运算 OR
^      位运算 XOR
&^     位清空（AND NOT）
<<     左移
>>     右移
```

位操作运算符`^`作为二元运算符时是按位异或（XOR），当用作一元运算符时表示按位取反；也就是说，它返回一个每个bit位都取反的数。位操作运算符`&^`用于按位置零（AND NOT）：如果对应y中bit位为1的话，表达式`z = x &^ y`结果z的对应的bit位为0，否则z对应的bit位等于x相应的bit位的值。

```go
var x uint8 = 1<<1 | 1<<5
var y uint8 = 1<<1 | 1<<2

fmt.Printf("%08b\n", x) // "00100010", the set {1, 5}
fmt.Printf("%08b\n", y) // "00000110", the set {1, 2}

fmt.Printf("%08b\n", x&y)  // "00000010", the intersection {1}
fmt.Printf("%08b\n", x|y)  // "00100110", the union {1, 2, 5}
fmt.Printf("%08b\n", x^y)  // "00100100", the symmetric difference {2, 5}
fmt.Printf("%08b\n", x&^y) // "00100000", the difference {5}

for i := uint(0); i < 8; i++ {
    if x&(1<<i) != 0 { // membership test
        fmt.Println(i) // "1", "5"
    }
}

fmt.Printf("%08b\n", x<<1) // "01000100", the set {2, 6}
fmt.Printf("%08b\n", x>>1) // "00010001", the set {0, 4}

```

左移运算用零填充右边空缺的bit位，无符号数的右移运算也是用0填充左边空缺的bit位，但是有符号数的右移运算会用符号位的值填充左边空缺的bit位。

浮点数到整数的转换将丢失任何小数部分，然后向数轴零方向截断。

### 字符串

**字符串不可改变**

```go
s[0] = 'L' // compile error: cannot assign to s[0]
```

像以下情况，字符串变量s不是被改变，而是被赋予了一个新的值

```
s := "left foot"
t := s
s += ", right foot"
```

内置的len函数可以返回一个字符串中的**字节数目**（不是rune字符数目），索引操作s[i]返回**第i个字节的字节值**，i必须满足0 ≤ i< len(s)条件约束。

```go
s := "hello, world"
fmt.Println(len(s))     // "12"
fmt.Println(s[0], s[7]) // "104 119" ('h' and 'w')
```

子字符串操作s[i:j]基于原始的s字符串的第i个字节开始到第j个字节（并不包含j本身）**生成一个新字符串**。生成的新字符串将包含j-i个字节

```go
fmt.Println(s[0:5]) // "hello"
```

另外，字符串的切片操作和[]byte字节类型切片的切片操作是类似的。都写作x[m:n]，并且都是返回一个原始字节序列的子序列，**底层都是共享之前的底层数组**，因此这种操作都是常量时间复杂度。

**原生字符串和普通字符串**

原生字符串形式为 '...' ，使用单引号

- 没有转义操作，因此一般用于编写正则表达式

普通字符串形式为 "..." ，使用双引号

- 除了正则表达式都用普通字符串，拥有转义操作：

  ```
  \a      响铃
  \b      退格
  \f      换页
  \n      换行
  \r      回车
  \t      制表符
  \v      垂直制表符
  \'      单引号（只用在 '\'' 形式的rune符号面值中）
  \"      双引号（只用在 "..." 形式的字符串面值中）
  \\      反斜杠
  ```

#### 编码

Go采用的是UTF-8编码

UTF8是一个将Unicode码点编码为字节序列的**变长编码**。

如果第一个字节的高端bit为0，则表示对应7bit的ASCII字符，ASCII字符每个字符依然是一个字节，和传统的ASCII编码兼容。如果第一个字节的高端bit是110，则说明需要2个字节；后续的每个高端bit都以10开头。更大的Unicode码点也是采用类似的策略处理。

```
0xxxxxxx                             runes 0-127    (ASCII)
110xxxxx 10xxxxxx                    128-2047       (values <128 unused)
1110xxxx 10xxxxxx 10xxxxxx           2048-65535     (values <2048 unused)
11110xxx 10xxxxxx 10xxxxxx 10xxxxxx  65536-0x10ffff (other values unused)
```

变长的编码**无法直接通过索引来访问**第n个字符（即s[i]表示的是对应的字节值而不是字符）

#### 字符串与编码

字符串采用UTF编码，这意味着每个字符对应的编码字节数是**不定**的（每个字符对应一个Unicode码点值，表示一个Unicode码点值所用的字节数不定），例如ASCII字符1个字节，中文字符3个字节

**字符串以Unicode为单位生成字符**

**string(65)表示生成以只包含对应Unicode码点字符的UTF8字符串**

#### 字符串与字节slice

一个字符串是包含只读字节的数组，一旦创建，是不可变的。相比之下，一个字节slice的元素则可以自由地修改。

字符串和字节slice之间可以相互转换：

```Go
s := "abc"
b := []byte(s)
s2 := string(b)
```

为了避免转换中不必要的内存分配，bytes包和strings同时提供了许多实用函数。下面是strings包中的六个函数：

```Go
func Contains(s, substr string) bool //判断s是否包含substr
func Count(s, sep string) int  //计算s含有sep的个数
func Fields(s string) []string //按照空白分割字符串，空白指" ","\r","\t"等等
func HasPrefix(s, prefix string) bool 
func Index(s, sep string) int //返回指定字符的位置
func Join(a []string, sep string) string
```

bytes包中也对应的六个函数：

```Go
func Contains(b, subslice []byte) bool
func Count(s, sep []byte) int
func Fields(s []byte) [][]byte
func HasPrefix(s, prefix []byte) bool
func Index(s, sep []byte) int
func Join(s [][]byte, sep []byte) []byte
```

它们之间唯一的区别是字符串类型参数被替换成了字节slice类型的参数。

#### 字符串与数字

**整数转字符串**

```go
x := 123
//方法1
y := fmt.Sprintf("%d",x)
//方法2
y := strconv.Itoa(x)
```

**字符串转整数**

```go
x := "123"
y := strconv.Atoi(x)
```

**另外**

FormatInt和FormatUint函数可以用不同的进制来格式化数字：

```Go
fmt.Println(strconv.FormatInt(int64(x), 2)) // "1111011"
```

如果要将一个字符串解析为整数，可以使用strconv包的Atoi或ParseInt函数，还有用于解析无符号整数的ParseUint函数：

```Go
x, err := strconv.Atoi("123")             // x is an int
y, err := strconv.ParseInt("123", 10, 64) // base 10, up to 64 bits
```

ParseInt函数的第三个参数是用于指定整型数的大小；例如16表示int16，0则表示int。在任何情况下，返回的结果y总是int64类型，你可以通过强制类型转换将它转为更小的整数类型。

### 常量

与变量运行时确定不同，常量编译时即可确定

如果是批量声明的常量，除了第一个外其它的常量右边的初始化表达式都可以省略，如果省略初始化表达式则表示使用前面常量的初始化表达式写法，对应的常量类型也一样的。例如：

```Go
const (
    a = 1
    b
    c = 2
    d
)

fmt.Println(a, b, c, d) // "1 1 2 2"
```

**iota常量生成器**

```Go
type Weekday int

const (
    Sunday Weekday = iota
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
)
```

周日将对应0，周一为1，如此等等。

**无类型常量**

只有常量可以是无类型的

无类型常量提供比基础类型更高的运算精度，以保证其通用，可以适用于任意数据类型保证精度不会减小

对于一个没有显式类型的变量声明（包括简短变量声明），常量的形式将隐式决定变量的默认类型，就像下面的例子：

```Go
i := 0      // untyped integer;        implicit int(0)
r := '\000' // untyped rune;           implicit rune('\000')
f := 0.0    // untyped floating-point; implicit float64(0.0)
c := 0i     // untyped complex;        implicit complex128(0i)
```

## 复杂数据类型

### 数组

数组长度固定

**初始化**

默认情况下，数组的每个元素都被初始化为元素类型对应的零值，对于数字类型来说就是0。我们也可以使用数组字面值语法用一组值来初始化数组：

```Go
var q [3]int = [3]int{1, 2, 3}
var r [3]int = [3]int{1, 2}
fmt.Println(r[2]) // "0"
```

在数组字面值中，如果在数组的长度位置出现的是“...”省略号，则表示数组的长度是根据初始化值的个数来计算。因此，上面q数组的定义可以简化为

```Go
q := [...]int{1, 2, 3}
fmt.Printf("%T\n", q) // "[3]int"
```

指定键值对初始化

```go
type Currency int

const (
    USD Currency = iota // 美元
    EUR                 // 欧元
    GBP                 // 英镑
    RMB                 // 人民币
)

symbol := [...]string{USD: "$", EUR: "€", GBP: "￡", RMB: "￥"}

fmt.Println(RMB, symbol[RMB]) // "3 ￥"

```

在这种形式的数组字面值形式中，初始化索引的顺序是无关紧要的，而且没用到的索引可以省略，和前面提到的规则一样，未指定初始值的元素将用零值初始化。例如，

```Go
r := [...]int{99: -1}
```

定义了一个含有100个元素的数组r，最后一个元素被初始化为-1，其它元素都是用0初始化。

**由于数组定长，灵活性非常有限，数组依然很少用作函数参数；相反，我们一般使用slice来替代数组。**

数组的切片是slice

```
a := [...]int{0, 1, 2, 3, 4, 5} 
fmt.Printf("%T\t%T\t%T\t", a, a[:], a[1:3])
//output:
//[6]int []int []int
```



### Slice

#### 原理

类似于C++的动态数组

**slice的底层实现**

slice由三个部分组成：指针、长度和容量

- 指针：slice的数据存储在数组中，因此需要指针指向slice第一个元素在数组中对应的地址
- 长度：slice中元素的数目，长度不能超过容量
  - len函数返回长度
- 容量：slice的开始位置到底层数据的结尾位置
  - cap函数返回容量

多个slice之间可以共享底层的数据，并且引用的数组部分区间可能重叠。

**举个例子：**

```
months := [...]string{1: "January", /* ... */, 12: "December"}
Q2 := months[4:7]
summer := months[6:9]
fmt.Println(Q2)     // ["April" "May" "June"]
fmt.Println(summer) // ["June" "July" "August"]
```

![img](https://gopl-zh.github.io/images/ch4-01.png)

值得注意的是：Q2的容量cap为9，summer的容量cap为7，表现出容量的含义：slice的开始位置到**底层数据的结尾位置**

如果切片操作超出cap(s)的上限将导致一个panic异常，但是超出len(s)则是意味着扩展了slice，因为新slice的长度会变大：

```Go
fmt.Println(summer[:20]) // panic: out of range

endlessSummer := summer[:5] // extend a slice (within capacity)
fmt.Println(endlessSummer)  // "[June July August September October]"
```

字符串的切片操作和[]byte字节类型切片的切片操作是类似的。都写作x[m:n]，并且都是返回一个原始字节序列的子序列，底层都是共享之前的底层数组，因此这种操作都是常量时间复杂度。x[m:n]切片操作对于字符串则生成一个新字符串，如果x是[]byte的话则生成一个新的[]byte。

因为slice值包含指向第一个slice元素的指针，因此向函数传递slice将允许在函数内部修改底层数组的元素。

**复制一个slice只是对底层的数组创建了一个新的slice别名**

和数组不同的是，slice之间不能比较，因此我们不能使用==操作符来判断两个slice是否含有全部相等元素。不过标准库提供了高度优化的bytes.Equal函数来判断两个字节型slice是否相等（[]byte），但是对于其他类型的slice，我们必须自己展开每个元素进行比较：

```Go
func equal(x, y []string) bool {
    if len(x) != len(y) {
        return false
    }
    for i := range x {
        if x[i] != y[i] {
            return false
        }
    }
    return true
}
```

**区分：长度为0的slice和nil值的slice**

- 长度为0，即len()为0
- 一个nil值的slice没有底层数组，其长度和容量都为0

因此长度和容量为0只能说明slice为空（没有元素）

nil值说明slice没有底层数组

而类似于[]int{}长度和容量也为0，但有底层数组

#### 基础使用

**初始化**

```
//创建空slice (nil)
var numbers []int

//创建slice并初始化
//方法一
var numbers []int = make([]int,len)
//方法二
numbers := make([]int,len)
//方法三
numbers := []int{1,2,3}

//创建对arr的引用slice 
numbers := arr[:]
numbers := arr[startIndex:endIndex] 
```



#### make函数

make函数用于创建slice，map和chan

> make函数和new函数的区别（简单说）
>
> - new创建某个类型的变量，为其分配内存，内存存的值是对应类型的零值（对于slice、chan、map而言，零值为nil），返回的是该类型的指针
> - make创建slice、chan、map其中一个的变量（只能适用于这3种类型），分配内存并对其初始化，返回对应类型
>
> 对于type（slice,map,chan）而言，以type==slice举例
>
> - new返回*type，并且type的值为nil
> - make返回type，并且type为[]int{}
>
> 对于map和chan，nil没法用；对于slice，原本nil没法用， 但是append函数能够对nil slice扩容
>
> [(99+ 封私信 / 80 条消息) Go语言（golang）中，make和new有什么区别呢？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/446317882)

#### append函数

append函数从底层上需要分情况讨论

- 如果容量足够，即len<=cap，则插入元素后返回slice和原slice共享相同底层数组
- 如果容量不足，即len>cap，则插入元素后返回slice和原slice引用的是不同的底层数组

```Go
func appendInt(x []int, y int) []int {
    var z []int
    zlen := len(x) + 1
    if zlen <= cap(x) {
        // There is room to grow.  Extend the slice.
        z = x[:zlen]
    } else {
        // There is insufficient space.  Allocate a new array.
        // Grow by doubling, for amortized linear complexity.
        zcap := zlen
        if zcap < 2*len(x) {
            zcap = 2 * len(x)
        }
        z = make([]int, zlen, zcap)
        copy(z, x) // a built-in function; see text
    }
    z[len(x)] = y
    return z
}
```

每次调用appendInt函数，必须先检测slice底层数组是否有足够的容量来保存新添加的元素。如果有足够空间的话，直接扩展slice（依然在原有的底层数组之上），将新添加的y元素复制到新扩展的空间，并返回slice。因此，输入的x和输出的z共享**相同的底层数组**。

如果没有足够的增长空间的话，appendInt函数则会先分配一个足够大的slice用于保存新的结果，先将输入的x复制到新的空间，然后添加y元素。结果z和输入的x引用的将是**不同的底层数组**。

**通常是将append返回的结果直接赋值给输入的slice变量：**

```Go
runes = append(runes, r)
```

#### 应用

一个slice可以用来模拟一个stack。最初给定的空slice对应一个空的stack，然后可以使用append函数将新的值压入stack：

```Go
stack = append(stack, v) // push v
```

stack的顶部位置对应slice的最后一个元素：

```Go
top := stack[len(stack)-1] // top of stack
```

通过收缩stack可以弹出栈顶的元素

```Go
stack = stack[:len(stack)-1] // pop
```

### Map

#### 原理

map是一个**哈希表**的引用，形式为map[key]value

- 其中key必须是支持==的数据结构（key可以是基础数据类型，也可以是结构体等复杂数据类型，只要能比较）
- value可以是任意数据类型，可以是基础数据类型，**也可以是map,slice**等等



#### 基础使用

**初始化**

创建空map

```go
//方法一
ages := make(map[string]int)
//方法二
ages := map[string]int{}
```

创建map并初始化

```go
//方法一
ages := map[string]int{
	"alice": 31,
	"charlie": 34,
}
//方法二
ages := make(map[string]int)
ages["alice"]=31
ages["charlie"]=34
```

**如果我们一开始就知道names的最终大小**，给slice分配一个合适的大小将会更有效。下面的代码创建了一个空的slice，但是slice的容量刚好可以放下map中全部的key：

```Go
names := make([]string, 0, len(ages))
```

**访问**

如果ages["alice"]不存在，那么将会打印value类型对应的零值

```go
fmt.Println(ages["alice"])
```

为了区分ages["alice"]是否存在，我们可以采用如下访问方式：

```go
age, ok := ages["bob"]
if !ok { /* "bob" is not a key in this map; age == 0. */ }

// 还可以这样使用
if age,ok:=ages["bob"];!ok{ /* "bob" is not a key in this map; age == 0. */}
```

map中的元素并不是一个变量，因此我们不能对map的元素进行取址操作

```
_ = &ages["bob"] // compile error: cannot take address of map element
```

禁止对map元素取址的原因是map可能随着元素数量的增长而重新分配更大的内存空间，从而可能导致之前的地址无效。

**遍历访问**

要想遍历map中全部的key/value对的话，可以使用range风格的for循环实现，和之前的slice遍历语法类似。下面的迭代语句将在每次迭代时设置name和age变量，它们对应下一个键/值对：

```Go
for name, age := range ages {
    fmt.Printf("%s\t%d\n", name, age)
}
```

**Map的迭代顺序是不确定的**，并且不同的哈希函数实现可能导致不同的遍历顺序。在实践中，遍历的顺序是随机的，每一次遍历的顺序都不相同。这是故意的，每次都使用随机的遍历顺序可以强制要求程序不会依赖具体的哈希函数实现。如果要按顺序遍历key/value对，我们必须显式地对key进行排序，可以使用sort包的Strings函数对字符串slice进行排序。下面是常见的处理方式：

```Go
import "sort"

var names []string
for name := range ages {
    names = append(names, name)
}
sort.Strings(names)
for _, name := range names {
    fmt.Printf("%s\t%d\n", name, ages[name])
}
```

**和slice一样，map之间也不能进行相等比较**；唯一的例外是和nil进行比较。要判断两个map是否包含相同的key和value，我们必须通过一个循环实现：

```Go
func equal(x, y map[string]int) bool {
    if len(x) != len(y) {
        return false
    }
    for k, xv := range x {
        if yv, ok := y[k]; !ok || yv != xv {
            return false
        }
    }
    return true
}
```

**删除**

```go
delete(ages,"alice")
```

### 结构体

#### 基础使用

**初始化**

```go
//结构体初始化
type Employee struct {
    ID        int
    Name      string
    Address   string
    DoB       time.Time
    Position  string
    Salary    int
    ManagerID int
}
var dilbert Employee
```

结构体成员的**输入顺序也有重要的意义**。我们也可以将Position成员合并（因为也是字符串类型），或者是交换Name和Address出现的先后顺序，那样的话就是定义了不同的结构体类型。

如果结构体成员名字是以**大写字母开头**的，那么该成员就是**导出的**；这是Go语言导出规则决定的。一个结构体可能同时包含导出和未导出的成员。

一个命名为S的结构体类型将不能再包含S类型的成员：因为一个聚合的值不能包含它自身。（该限制同样适用于数组。）但是**S类型的结构体可以包含`*S`指针类型的成员**，这可以让我们创建递归的数据结构，比如链表和树结构等。

**初始化并赋值**

两种不同形式的写法不能混合使用，而且，你不能企图在外部包中用第一种顺序赋值的技巧来偷偷地初始化结构体中未导出的成员。

```go
//方法一：顺序初始化
type Point struct{ X, Y int }
p := Point{1, 2}

//方法二:指定索引初始化
anim := gif.GIF{LoopCount: nframes}
//成员被忽略的话将默认用零值
```

**结构体指针初始化**

```go
pp := &Point{1,2}

//等价于
pp = new(Point)
*pp = Point{1,2}
```

**访问**

```go
//方法一
var dilbert Employee
dilbert.salary-=5000

//方法二:对成员取地址然后修改
p := &dilbert.position
*p += "Senior"

//方法三：对结构体取地址然后修改
var employeeOfTheMonth *Employee = &dilbert
employeeOfTheMonth.Position += " (proactive team player)"

//方法三等价于
(*employeeOfTheMonth).Position += " (proactive team player)"

//方法三简化版
p := &dilbert
p.Position += "(proactive team player)"
```

结构体Employee和结构体指针*Employee都可以使用点操作符访问字段

**比较**

结构体可以通过==比较

**结构体嵌入和匿名成员**

一个结构体内可以声明一个匿名结构体，该结构体名字和数据类型相同，因此不用写名字

```go
type Point struct {
	X, Y int
}

type Circle struct {
	Point
	Radius int
}

type Wheel struct {
	Circle
	Spokes int
}
var w Wheel
w.X = 8            // equivalent to w.Circle.Point.X = 8
w.Y = 8            // equivalent to w.Circle.Point.Y = 8
w.Radius = 5       // equivalent to w.Circle.Radius = 5
w.Spokes = 20
```

如果要使用结构体字面值初始化只能这样：

```go
//方法一
w := Wheel{Circle{Point{8, 8}, 5}, 20}

//方法二
w := Wheel{
    Circle: Circle{
        Point:  Point{X: 8, Y: 8},
        Radius: 5,
    },
    Spokes: 20, // NOTE: trailing comma necessary here (and at Radius)
}

fmt.Printf("%v\n", w)
// Output:
//{{{8 8} 5} 20}

fmt.Printf("%+v\n", w)
// Output:
//{Circle:{Point:{X:8 Y:8} Radius:5} Spokes:20}

fmt.Printf("%#v\n", w)
// Output:
//main.Wheel{Circle:main.Circle{Point:main.Point{X:8, Y:8}, Radius:5}, Spokes:20}
```

在上面的例子中，Point和Circle匿名成员都是导出的。即使它们不导出（比如改成小写字母开头的point和circle），**在包内部**，我们依然可以用简短形式访问匿名成员嵌套的成员

```Go
w.X = 8 // equivalent to w.circle.point.X = 8
```

但是**在包外部**，因为circle和point没有导出，不能访问它们的成员，因此简短的匿名成员访问语法也是禁止的。

### JSON



## 函数

### 基础知识

形式：

```
func name(parameter-list) (result-list) {
    body
}
```

**函数签名**：如果两个函数 形参列表**每个形参的类型**和返回值列表**每个返回值的类型** 均相同，则这两个函数拥有相同的函数签名

没有函数体的函数声明，这表示该函数不是以Go实现的。这样的声明定义了函数签名。

```Go
package math

func Sin(x float64) float //implemented in assembly language
```

### 参数传递

Go默认使用**按值传参**（形参拷贝实参的值，修改形参不改变实参）

**引用传参**：其实Go中的引用传参本质上还是按值传参，只是拷贝的值变成了指针，因此指针的值没有被改变，但是指针指向的内存空间上的值能够被改变了

- slice,map,interface,channel使用引用传参

**多返回值**

返回值可以取名，也可以不取名，返回值也是**按值传参**

> 返回值 如果返回的是值，那么变量分配在栈上；如果返回的是指针，那么变量分配在栈上
>
> （等打脸）

### 错误处理

如果只需要判断是否失败，函数通常返回一个布尔值ok

如果想要获取错误的类型，通常函数会返回错误error类型，有五种方式处理错误

1. 错误传递。将被调用者函数域中子函数的错误**不加处理**传递给调用者
2. 处理错误后传递。在1的基础上对错误进行处理之后传递给调用者
3. 输出错误信息并结束程序（只在main函数中使用）
4. 输出错误信息，不中断程序的运行
5. 直接忽略错误

**举个例子：**

**1.错误传递**

```go
resp, err := http.Get(url)
if err != nil{
    return nil, err
}
```

**2.处理后错误传递**

```go
doc, err := html.Parse(resp.Body)
resp.Body.Close()
if err != nil {
    return nil, fmt.Errorf("parsing %s as HTML: %v", url,err)
}
```

**3.输出错误信息并结束程序**

```go
// (In function main.)
if err := WaitForServer(url); err != nil {
    fmt.Fprintf(os.Stderr, "Site is down: %v\n", err)
    os.Exit(1)
}

//调用log.Fatalf可以更简洁的代码达到与上文相同的效果。
//log中的所有函数，都默认会在错误信息之前输出时间信息。
if err := WaitForServer(url); err != nil {
    log.Fatalf("Site is down: %v\n", err)
}
```

对于log.Fatalf，我们可以设置日志的格式

```go
//添加日志的前缀
log.SetPrefix("wait: ")
//忽略日志默认输出的时间信息
log.SetFlags(0)
```

**4.直接打印错误**

```go
if err := Ping(); err != nil {
    log.Printf("ping failed: %v; networking disabled",err)
}
```

或者标准错误流输出错误信息。

```Go
if err := Ping(); err != nil {
    fmt.Fprintf(os.Stderr, "ping failed: %v; networking disabled\n", err)
}
```

log包中的所有函数会为没有换行符的字符串增加换行符。

**5. 直接忽略错误**

```Go
dir, err := ioutil.TempDir("", "scratch")
if err != nil {
    return fmt.Errorf("failed to create temp dir: %v",err)
}
// ...use temp dir…
os.RemoveAll(dir) // ignore errors; $TMPDIR is cleaned periodically
```

**特殊错误类型： io.EOF表示文件结束**

### 函数类型

函数的类型具有特殊的性质

- 函数类型是一种数据类型，形如：`func (string,int) int`
- 函数类型是一种“值”，可以赋值给其他变量，也可以以实参的方式赋值给函数

**举个例子：**

函数类型的零值是nil。调用值为nil的函数值会引起panic错误：

```Go
    var f func(int) int
    f(3) // 此处f的值为nil, 会引起panic错误
```

函数值之间不可比较，但是可以与nil比较：

```Go
    var f func(int) int
    if f != nil {
        f(3)
    }
```

### 匿名函数

```go
// squares返回一个匿名函数。
// 该匿名函数每次被调用时都会返回下一个数的平方的函数
func squares() func() int {
	var x int
	return func() int {
		x++
		return x * x
	}
}
func main() {
	f := squares()
	// () 函数调用符号
	fmt.Println(f()) // "1"
	fmt.Println(f()) // "4"
	fmt.Println(f()) // "9"
	fmt.Println(f()) // "16"
}
```

这里由于匿名函数引用了x并且返回了x*x，因此x发生了变量逃逸，被分配到堆上

`f := squares()`之后，匿名函数也发生了逃逸，被分配到堆上

x和f都在堆上，匿名函数能够使用x

之后每调用一次f，用的都是堆上的这个f，所以每次都会对堆上的x加1后取平方

**匿名函数的递归**

匿名函数如果要使用递归，一定要先声明匿名函数类型

```go
var visitAll func(items []string)
visitAll = func(items []string) {
        for _, item := range items {
            if !seen[item] {
                seen[item] = true
                visitAll(m[item])
                order = append(order, item)
            }
        }
    }
```

否则会报错

```go
visitAll := func(items []string) {
    // ...
    visitAll(m[item]) // compile error: undefined: visitAll
    // ...
}

```

### 使用迭代变量的坑

> 2024/3/20 update：
>
> Go 1.21版本修复了这个坑，简单来说：
>
> - 1.21以前，for range的变量共享同一个内存地址，每次迭代仅更改该内存地址存储的值
> - 1.21以后，for range每次迭代创建一个新变量
>
> 详见：
>
> [Go 1.21中值得关注的几个变化 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/652910579)

考虑这样一个问题：你被要求首先创建一些目录，再将目录删除。在下面的例子中我们用函数值来完成删除操作。下面的示例代码需要引入os包。为了使代码简单，我们忽略了所有的异常处理。

```Go
var rmdirs []func()
for _, d := range tempDirs() {
    dir := d // NOTE: necessary!
    os.MkdirAll(dir, 0755) // creates parent directories too
    rmdirs = append(rmdirs, func() {
        os.RemoveAll(dir)
    })
}
// ...do some work…
for _, rmdir := range rmdirs {
    rmdir() // clean up
}
```

你可能会感到困惑，为什么要在循环体中用循环变量d赋值一个新的局部变量，而不是像下面的代码一样直接使用循环变量dir。需要注意，下面的代码是错误的。

```go
var rmdirs []func()
for _, dir := range tempDirs() {
    os.MkdirAll(dir, 0755)
    rmdirs = append(rmdirs, func() {
        os.RemoveAll(dir) // NOTE: incorrect!
    })
}
```

问题的原因在于循环变量的作用域。在上面的程序中，for循环语句引入了新的词法块，循环变量dir在这个词法块中被声明。在该循环中生成的所有函数值都共享相同的循环变量。需要注意，**函数值中记录的是循环变量的内存地址，而不是循环变量某一时刻的值。**以dir为例，后续的迭代会不断更新dir的值，当删除操作执行时，for循环已完成，dir中存储的值等于最后一次迭代的值。这意味着，每次对os.RemoveAll的调用删除的都是相同的目录。

通常，为了解决这个问题，我们会引入一个与循环变量同名的局部变量，作为循环变量的副本。比如下面的变量dir，虽然这看起来很奇怪，但却很有用。

```Go
for _, dir := range tempDirs() {
    dir := dir // declares inner dir, initialized to outer dir
    // ...
}
```

这个问题不仅存在基于range的循环，在下面的例子中，对循环变量i的使用也存在同样的问题：

```Go
var rmdirs []func()
dirs := tempDirs()
for i := 0; i < len(dirs); i++ {
    os.MkdirAll(dirs[i], 0755) // OK
    rmdirs = append(rmdirs, func() {
        os.RemoveAll(dirs[i]) // NOTE: incorrect!
    })
}
```

### 可变参数

参数数量可变的函数称为可变参数函数。

在声明可变参数函数时，需要在参数列表的最后一个参数类型之前加上省略符号“...”，这表示该函数会接收任意数量的该类型参数。

```go
func sum(vals ...int) int {
    total := 0
    for _, val := range vals {
        total += val
    }
    return total
}
```

sum函数返回任意个int型参数的和。在函数体中，vals被看作是类型为[] int的切片。sum可以接收任意数量的int型参数：

```Go
fmt.Println(sum())           // "0"
fmt.Println(sum(3))          // "3"
fmt.Println(sum(1, 2, 3, 4)) // "10"
```

在上面的代码中，调用者隐式的创建一个数组，并将原始参数复制到数组中，再把数组的一个切片作为参数传给被调用函数。如果原始参数已经是切片类型，我们该如何传递给sum？只需在最后一个参数后加上省略符。下面的代码功能与上个例子中最后一条语句相同。

```Go
values := []int{1, 2, 3, 4}
fmt.Println(sum(values...)) // "10"
```

虽然在可变参数函数内部，...int 型参数的行为看起来很像切片类型，但实际上，可变参数函数和以切片作为参数的函数是不同的。

```Go
func f(...int) {}
func g([]int) {}
fmt.Printf("%T\n", f) // "func(...int)"
fmt.Printf("%T\n", g) // "func([]int)"
```

## 进阶知识

### 变量逃逸

> [详解Go逃逸分析 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/343562181)

（待填坑）

### GMP

（待填坑）

## 工程

### Go mod

#### 导入本地包

> 参考[使用go module导入本地包 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/109828249)

##### 在同一个项目下

**注意**：在一个项目（project）下我们是可以定义多个包（package）的。

###### 目录结构

现在的情况是，我们在`moduledemo/main.go`中调用了`mypackage`这个包。

```bash
moduledemo
├── go.mod
├── main.go
└── mypackage
    └── mypackage.go
```

###### 导入包

这个时候，我们需要在`moduledemo/go.mod`中按如下定义：

```go
module moduledemo

go 1.14
```

然后在`moduledemo/main.go`中按如下方式导入`mypackage`

```go
package main

import (
    "fmt"
    "moduledemo/mypackage"  // 导入同一项目下的mypackage包
)
func main() {
    mypackage.New()
    fmt.Println("main")
}
```

###### 举个例子

举一反三，假设我们现在有文件目录结构如下：

```bash
└── bubble
    ├── dao
    │   └── mysql.go
    ├── go.mod
    └── main.go
```

其中`bubble/go.mod`内容如下：

```go
module github.com/q1mi/bubble

go 1.14
```

`bubble/dao/mysql.go`内容如下：

```go
package dao

import "fmt"

func New(){
    fmt.Println("mypackage.New")
}
```

`bubble/main.go`内容如下：

```go
package main

import (
    "fmt"
    "github.com/q1mi/bubble/dao"
)
func main() {
    dao.New()
    fmt.Println("main")
}
```

##### 不在同一个项目下

###### 目录结构

```bash
├── moduledemo
│   ├── go.mod
│   └── main.go
└── mypackage
    ├── go.mod
    └── mypackage.go
```

###### 导入包

这个时候，`mypackage`也需要进行module初始化，即拥有一个属于自己的`go.mod`文件，内容如下：

```go
module mypackage

go 1.14
```

然后我们在`moduledemo/main.go`中按如下方式导入：

```go
import (
    "fmt"
    "mypackage"
)
func main() {
    mypackage.New()
    fmt.Println("main")
}
```

因为这两个包不在同一个项目路径下，你想要导入本地包，并且这些包也没有发布到远程的github或其他代码仓库地址。这个时候我们就需要在`go.mod`文件中使用`replace`指令。

在调用方也就是`packagedemo/go.mod`中按如下方式指定使用**相对路径**来寻找`mypackage`这个包。

```go
module moduledemo

go 1.14


require "mypackage" v0.0.0
replace "mypackage" => "../mypackage"
```

###### 举个例子

最后我们再举个例子巩固下上面的内容。

我们现在有文件目录结构如下：

```bash
├── p1
│   ├── go.mod
│   └── main.go
└── p2
    ├── go.mod
    └── p2.go
    └── test
    	└── test.go
```

`p1/main.go`中想要导入p2中`test.go`中定义的函数。

`p2/go.mod`内容如下：

```go
module liwenzhou.com/q1mi/p2

go 1.14
```

`p1/main.go`中按如下方式导入

```go
import (
    "fmt"
    "liwenzhou.com/q1mi/p2/test" //这里是具体想要导入的包
)
func main() {
    p2.Test()
    fmt.Println("main")
}
```

因为我并没有把`liwenzhou.com/q1mi/p2`这个包上传到`liwenzhou.com`这个网站，我们只是想导入本地的包，这个时候就需要用到`replace`这个指令了。

`p1/go.mod`内容如下：

```go
module github.com/q1mi/p1

go 1.14


require "liwenzhou.com/q1mi/p2" v0.0.0
replace "liwenzhou.com/q1mi/p2" => "../p2"
```

此时，我们就可以正常编译`p1`这个项目了。

**这里导入的包是项目的总包**

## 技巧

### fmt.Printf

```
%c 打印字符

%q 打印带有单引号的字符

%d 打印整数

%o 打印八进制数

%x 打印十六进制数

%g 打印浮点数

%e 打印浮点数

%f 打印浮点数

%T 打印变量类型

%v 打印变量

%+v 打印变量类型
%#v 打印Go语言变量类型（通常包含包）

%t 打印布尔型
```

特别地：

```
	x := 0666
	y := 0xabc
	fmt.Printf("%d %[1]o %#[1]o\n", x)
	fmt.Printf("%d %[1]x %#[1]x\n", y)
```

%后面的[1]表示继续使用前一个操作数（本来三个%要使用三个操作数，这里只使用了一个x或y），%后的#告诉Printf在用%o、%x或%X输出时生成0、0x或0X前缀。

### fmt包printf、fprintf、sprintf的使用和区别

Print打印输出：

```go
fmt.Print()  // 打印输出
```

Println打印输出并换行

```go
fmt.Println()  // 打印输出并换行
```

Printf格式化字符串并输出，最后一个字母f表示format

```go
fmt.Printf("打印这个字符串：%s ","string")  // 格式化字符串并输出
```

Fprintf把格式字符串输出到指定的文件设备中，输出到io.Writers 而不是 os.Stdout。第一个字符F表示file.

```go
fmt.Fprintf(os.Stderr, “this is a %s\n”, "string")
```

Sprintf格式化字符串并返回，不会输出，可用于赋值

```go
str := fmt.Sprintf("打印这个字符串：%s ","string")
fmt.Print(str)
fmt.SPrintf("打印这个字符串：%s ","string")  // 无任何输出
```


