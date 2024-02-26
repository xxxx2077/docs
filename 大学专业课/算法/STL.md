# STL

STL：标准模板库，是一些“容器”和基础算法的集合  

## 容器

### vector

#### 初始化

```c++
vector<int> a(10); //定义了10个整型元素的向量，没有给出初值，其值是不确定的。
vector<int> a(10,1); //定义了10个整型元素的向量,且给出每个元素的初值为1
vector<int> a(b); //用b向量来创建a向量，整体复制性赋值
```

#### 基本操作

```c++
a.clear(); //清空a中的元素
a.empty(); //判断a是否为空，空则返回ture,不空则返回false
a.pop_back(); //删除a向量的最后一个元素
a.erase(a.begin()+1,a.begin()+3); //删除a中第1个（从第0个算起）到第2个元素，也就是说删除的元素从a.begin()+1算起（包括它）一直到a.begin()+         3（不包括它）
a.push_back(5); //在a的最后一个向量后插入一个元素，其值为5
a.insert(a.begin()+1,5); //在a的第1个元素（从第0个算起）的位置插入数值5，如a为1,2,3,4，插入元素后为1,5,2,3,4
a.insert(a.begin()+1,3,5); //在a的第1个元素（从第0个算起）的位置插入3个数，其值都为5
a.insert(a.begin()+1,b+3,b+6); //b为数组，在a的第1个元素（从第0个算起）的位置插入b的第3个元素到第5个元素（不包括b+6），如b为1,2,3,4,5,9,8         ，插入元素后为1,4,5,9,2,3,4,5,9,8
a.size(); //返回a中元素的个数；
a.capacity(); //返回a在内存中总共可以容纳的元素个数
a.resize(10); //将a的现有元素个数调至10个，多则删，少则补，其值随机
a.resize(10,2); //将a的现有元素个数调至10个，多则删，少则补，其值为2
```

### list

### stack

#### 头文件

`#include <stack>`

#### 基本操作

```c++
stack<int> s;
s.push(x) 将x入栈
s.top() 获得栈顶元素
s.pop() 弹出栈顶元素
s.empty() 可以检测stack内是否为空，返回true为空，返回false为非空
s.size() 返回stack内元素的个数
```



### queue

#### 头文件

`#include <queue>`

#### 基本操作

```c++
queue<int> q;
q.push(x) 将x入队（插入队尾）
q.front() 获得队首
q.back() 获得队尾
q.pop() 删除队尾
q.empty() 可以检测queue内是否为空，返回true为空，返回false为非空
q.size() 返回queue内元素的个数
```



### set

set由**红黑树**实现，其**内部元素依照其值自动排序**，每个元素**只出现一次**，不允许重复(红黑树是平衡二叉树的一种)

#### 时间复杂度

增删改查近似：O(log N)

#### 适用场景

适用与经常查找一个元素是否在某集群中并且不要排序的场景

### map

map由红黑树实现，其**元素都是键值对**，每个元素的**键是排序的准则**，每个键**只能出现一次**，不允许重复

#### 时间复杂度

增删改查近似：O(log N)

#### 适用场景

适用于需要储存一个字典，并要求方便的根据key找value的场景

### unordered_map

unordered_map 容器底层采用的是哈希表存储结构，该结构本身不具有对数据的排序功能，所以此容器内部不会自行对存储的键值对进行排序

#### 头文件

```
#include <unordered_map>
using namespace std;
```

#### 容器模板

```
template < class Key,                        //键值对中键的类型
           class T,                          //键值对中值的类型
           class Hash = hash<Key>,           //容器内部存储键值对所用的哈希函数
           class Pred = equal_to<Key>,       //判断各个键值对键相同的规则
           class Alloc = allocator< pair<const Key,T> >  // 指定分配器对象的类型
           > class unordered_map;
```

#### 时间复杂度

查找时间复杂度为O(1)  

#### c++中map与unordered_map的区别

- **运行效率方面**：unordered_map最高，而map效率较低但 提供了稳定效率和有序的序列。
- **占用内存方面**：map内存占用略低，unordered_map内存占用略高,而且是线性成比例的。
- **map**
  **优点：**有序性，这是map结构最大的优点，其元素的有序性在很多应用中都会简化很多的操作。红黑树，内部实现一个红黑书使得map的很多操作在lgn的时间复杂度下就可以实现，因此效率非常的高。
  **缺点：**空间占用率高，因为map内部实现了红黑树，虽然提高了运行效率，但是因为每一个节点都需要额外保存父节点，孩子节点以及红/黑性质，使得每一个节点都占用大量的空间
  适用处：对于那些有顺序要求的问题，用map会更高效一些。
- **unordered_map**
  **优点：**内部实现了哈希表，因此其查找速度是常量级别的。
  **缺点：**哈希表的建立比较耗费时间
  适用处：对于查找问题，unordered_map会更加高效一些，因此遇到查找问题，常会考虑一下用unordered_map

### priority_queue  

#### 头文件

`#include <queue>`

#### 定义

```
priority_queue<Type, Container, Functional>
```

Type为数据类型， Container为保存数据的容器，Functional为元素比较方式。

如果不写后两个参数，那么容器默认用的是vector，比较方式默认用operator<，也就是优先队列是大顶堆，队头元素最大。

##### 大根堆

默认大根堆

```
priority_queue<int, vector<int>> p;
或者
priority_queue<int, vector<int>,less<T>> p;
```



##### 小根堆

```
priority_queue<int, vector<int>, greater<int> > p;
```



##### 自定义比较

方法1：定义struct类型

```
struct cmp{
	bool operator()(Node a, Node b){
		if(a.x == b.x)	return a.y>b.y;
		return a.x>b.x;
	}
};
 
priority_queue<Node, vector<Node>, cmp>p;
```

方法2：定义比较函数

```
bool cmp(vector<int>&a,vector<int>&b){
	return a[0]>b[0];
}
priority_queue<Node, vector<vector<int>>, cmp>p;
```



##### 元素为pair

pair的比较规则：先比较第一个元素，第一个相等比较第二个。

#### 基本操作

```c++
priority_queue<int> p;
q.push(x) 将x入堆
q.top() 获得堆顶元素
q.pop() 堆顶元素弹出
q.empty() 可以检测优先队列是否为空，返回true为空，返回false为非空
q.size() 返回优先队列内元素的个数
```



### string 

### 

### pair

#### 创建和初始化

```
pair<string, string> anon;        // 创建一个空对象anon，两个元素类型都是string
pair<string, int> word_count;     // 创建一个空对象 word_count, 两个元素类型分别是string和int类型
pair<string, vector<int> > line;  // 创建一个空对象line，两个元素类型分别是string和vector类型
```



## 算法

排序（sort）：会根据数据量的大小自动选择快排、插入排序和堆排序

上界（upper_bound） :查找一个非递减序列中第一个值大于val元素的位置

下界（lower_bound） :查找一个非递减序列中第一个值大于等于val元素的位置

数值判断： min(x,y), max(x, y), abs(x), swap(x, y)

按字典序/逆序给出全排列的下一：next_permutation()/prev_permutation

```
听起来有点抽象，我们直接举个很简单的例子，字符串“123”的按照字典序正确的全排列是：

"123" "132" "213" "231" "312" "321"

执行以下程序

#include <iostream>
#include <algorithm>
using namespace std;

int main() {
  string number = "213";
  next_permutation(number.begin(), number.end());
  cout << number;

  return 0;
}
此时输出得到的是 "231"

如果我们想得到一个序列的完整全排列，可以这样

#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

int main() {
  vector<char> chars = {'a', 'b', 'c'};
  do {
    cout << chars[0] << chars[1] << chars[2] << endl;
  } while (next_permutation(chars.begin(), chars.end()));

  return 0;
}
输出结果为

abc
acb
bac
bca
cab
cba
```

大整数类： BigInteger（Java）