## 绪论

机器学习：机器通过数据等途径获得知识技能的过程  

![image-20240105220000572](Machine Learning.assets/image-20240105220000572.png)

### 机器学习算法分类

有无标记信息

- 监督学习：有标记
  - 分类、回归
- 无监督学习：无标记
  - 聚类、降维

![image-20240105220138418](Machine Learning.assets/image-20240105220138418.png)

#### 监督学习

![image-20240105221254748](Machine Learning.assets/image-20240105221254748.png)

![image-20240105221316453](Machine Learning.assets/image-20240105221316453.png)

#### 无监督学习

![image-20240105220227907](Machine Learning.assets/image-20240105220227907.png)

### 主流的机器学习算法

#### 深度学习

深度学习性能比传统的机器学习方法高很多

![image-20240105220445084](Machine Learning.assets/image-20240105220445084.png)

#### 强化学习

![image-20240105220544854](Machine Learning.assets/image-20240105220544854.png)

### 人工智能三要素

数据，算法，智力

### 机器学习基本术语

![image-20240105221056233](Machine Learning.assets/image-20240105221056233.png)

## 线性回归

![image-20240105221408803](Machine Learning.assets/image-20240105221408803.png)

### 线性模型

![image-20240105221443094](Machine Learning.assets/image-20240105221443094.png)

![image-20240105221511040](Machine Learning.assets/image-20240105221511040.png)

**线性模型的特点**  

- 形式简单、易于建模
- 可解释性
- 非线性模型的基础  

![image-20240105222340886](Machine Learning.assets/image-20240105222340886.png)

### 线性回归问题

![image-20240105222429195](Machine Learning.assets/image-20240105222429195.png)

![image-20240105222507047](Machine Learning.assets/image-20240105222507047.png)

![image-20240105222904818](Machine Learning.assets/image-20240105222904818.png)

### 线性回归求解

#### 统计学方法（单特征）

![image-20240105223039467](Machine Learning.assets/image-20240105223039467.png)

##### 最小二乘法

#### 计算机优化算法：梯度下降算法

#### 统计学方法（多特征）：矩阵变换

![image-20240106103710219](Machine Learning.assets/image-20240106103710219.png)

## 模型评估

### 训练误差和泛化误差

误差：预测输出与样本的真实输出之间的差异

训练误差（或经验误差）：在训练数据样本上的误差

泛化误差： 在**新样本**上的误差

机器学习的目的是使学得的模型不仅对已知数据而且对**未知新数据**都能有很好的预测能力（泛化能力强）  

![image-20240106105528068](Machine Learning.assets/image-20240106105528068.png)

![image-20240106105553403](Machine Learning.assets/image-20240106105553403.png)

欠拟合：学习能力“太弱”

- 解决方法：增加模型复杂度，增加训练轮数

过拟合：学习能力“太强”，训练过度，导致泛化性能下降

- 很常见，无法避免，但可以通过**正则化**和**减少特征**“缓解”  

**正则化**

![image-20240106105715202](Machine Learning.assets/image-20240106105715202.png)

### 为什么正则项能避免过拟合

![image-20240106112024082](Machine Learning.assets/image-20240106112024082.png)

![image-20240106112004277](Machine Learning.assets/image-20240106112004277.png)

### 泛化评估

![image-20240106112128077](Machine Learning.assets/image-20240106112128077.png)

#### 训练集和测试集的产生方法  

##### 留出法

![image-20240106112418564](Machine Learning.assets/image-20240106112418564.png)

##### 交叉验证法

![image-20240106112536786](Machine Learning.assets/image-20240106112536786.png)

##### 自助法

![image-20240106113209290](Machine Learning.assets/image-20240106113209290.png)

![image-20240106113328618](Machine Learning.assets/image-20240106113328618.png)

![image-20240106113419235](Machine Learning.assets/image-20240106113419235.png)

### 性能度量

![image-20240106113528846](Machine Learning.assets/image-20240106113528846.png)

![image-20240106113933082](Machine Learning.assets/image-20240106113933082.png)

![image-20240106114011013](Machine Learning.assets/image-20240106114011013.png)

查准率：预测出来的正例中正确的比率  

查全率：正例被预测出来的比率  

**查准率和查全率相互矛盾** 

- 假设要提高查全率，由于TP+FN为真实正例情况，TP+FN不变，那么我们需要提高TP，也就是尽量将样本预测为正例（“宁愿误报，也不要漏报”）。尽量将样本预测为正例的策略会导致TP+FP的数量增大，由于分母增大比分子多，所以查准率会降低**（当我们采用“宁愿误报，也不要漏报”的策略，就是提高误报率，降低漏报率，前者对应查准率下降，后者对应查全率提高）**
- 同理假设要提高查准率，尽量将样本预测为负例，避免预测样本为正例（“宁愿漏报，也不要误报”），这个策略会导致TP+FN下降，从而提高查准率；同时也会导致TP减小导致查全率减小**（当我们采用“宁愿漏报，也不要误报”的策略，就是降低误报率，提高漏报率，前者对应查准率提高，后者对应查全率下降）**

![image-20240106115741546](Machine Learning.assets/image-20240106115741546.png)

阈值越低，代表越倾向于预测样本为正例，即”宁愿误报不要漏报“的策略，因此查全率提高，查准率降低

![image-20240106120316168](Machine Learning.assets/image-20240106120316168.png)

![image-20240106120338238](Machine Learning.assets/image-20240106120338238.png)

**为什么P-R曲线越往外的模型能力越好  ？**

这是因为在右上角，精确度和召回率都很高。这意味着模型能够保持高的精确度，同时召回尽可能多的正例。

![image-20240106123813527](Machine Learning.assets/image-20240106123813527.png)

![image-20240106123920092](Machine Learning.assets/image-20240106123920092.png)

![image-20240106123949935](Machine Learning.assets/image-20240106123949935.png)

![image-20240106124018239](Machine Learning.assets/image-20240106124018239.png)

![image-20240106124153172](Machine Learning.assets/image-20240106124153172.png)

![image-20240106125645438](Machine Learning.assets/image-20240106125645438.png)

解释为什么第三个因子为0：

![image-20240106125845056](Machine Learning.assets/image-20240106125845056.png)

![image-20240106125723660](Machine Learning.assets/image-20240106125723660.png)

![image-20240106124249371](Machine Learning.assets/image-20240106124249371.png)

![image-20240106124256149](Machine Learning.assets/image-20240106124256149.png)

## 集成学习

![image-20240106144539906](Machine Learning.assets/image-20240106144539906.png)

![image-20240106144602435](Machine Learning.assets/image-20240106144602435.png)

启发：集成个体应“好而不同” 

- 个体学习要有一定的准确性
-  个体学习要有一定的多样性  

**核心：如何产生并结合“好而不同”的个体学习器？**  

产生

- 并行化方法：可同时生成、个体学习器间不存在强依赖关系的方法，代表是Bagging和随机森林  
- 串行化方法：必须串行生成、个体学习器间存在强依赖关系的方法，代表是Boosting（AdaBoost）

结合（怎样组合弱分类器）

- 平均法（用于数值型输出，有简单平均法、加权平均法等）
-  投票法（用于分类任务，有绝对多数投票法、相对多数投票法、加权投票法等）
- 学习法（用于训练数据较多的情形，代表是Stacking）

### Bagging

![image-20240106145450779](Machine Learning.assets/image-20240106145450779.png)

![image-20240106145459048](Machine Learning.assets/image-20240106145459048.png)

![image-20240106145653588](Machine Learning.assets/image-20240106145653588.png)

![image-20240106150759786](Machine Learning.assets/image-20240106150759786.png)

![image-20240106150811327](Machine Learning.assets/image-20240106150811327.png)

### 随机森林

![image-20240106151219697](Machine Learning.assets/image-20240106151219697.png)

![image-20240106151537441](Machine Learning.assets/image-20240106151537441.png)

![image-20240106154005425](Machine Learning.assets/image-20240106154005425.png)

## 强化学习

![image-20240109101552069](Machine Learning.assets/image-20240109101552069.png)

### 蒙特卡罗法和时间差分法的比较

![image-20240109095840546](Machine Learning.assets/image-20240109095840546.png)

![image-20240109095826215](Machine Learning.assets/image-20240109095826215.png)

![image-20240109100615317](Machine Learning.assets/image-20240109100615317.png)

### Sarsa v.s. Q-Learning  

![image-20240109104040792](Machine Learning.assets/image-20240109104040792.png)

![image-20240109104047225](Machine Learning.assets/image-20240109104047225.png)