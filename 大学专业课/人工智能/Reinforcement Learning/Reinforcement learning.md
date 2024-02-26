# 强化学习

什么是强化学习？

强化学习是智能体(agent)在环境(environment)中采取动作(action)以**最大化奖励(reward)的策略(policy)**

强化学习的终极目标：求解最优策略

![image-20231220194010506](Reinforcement learning.assets/image-20231220194010506.png)

## 基本概念

### 智能体(agent)

强化学习的对象

### 状态(State)

状态是agent与环境交互过程的每一个阶段

> The status of the agent with respect to the environment

我们用例子更加形象地说明什么是状态

以grid-world example为例，agent可以在该网格世界中移动到每一个格子，每个网格就是一个状态

![image-20231220193653967](Reinforcement learning.assets/image-20231220193653967.png)



### 状态空间(State space)

the set of all states 

同样以grid-world为例，$S = \{{s_i}\}_{i=1}^9$

### 动作(Action)

在**某个状态**，agent能够采取的能够影响环境状态的行为

- 动作依赖于状态，即不同状态能够采取的动作也不同

- 同样以grid-world为例，对于每个状态都有如下可能的东动作：

  *•* *a*1: move upwards;

  *•* *a*2: move rightwards;

  *•* *a*3: move downwards;

  *•* *a*4: move leftwards;

  *•* *a*5: stay unchanged;

### 动作空间(Action space **of a state**)

the set of all possible actions **of a state**

- 同样以grid-world为例，$A(s_i) = \{{a_i}\}^{5}_{i=1}.$

### 状态转换( state transition)

智能体采取一个动作之后，从一个状态到达另一个状态的过程

- 我们一般使用条件概率描述状态转换

- 如下图，$p(s_2|s_1,a_2)=1$表示agent采取a2动作之后从状态s1到状态s2的可能性为1

  在确定性情景中，状态转换的条件概率为1或0

  在随机性情境中，状态转换的条件概率为0到1之间的任一值。

  ![image-20231220200029972](Reinforcement learning.assets/image-20231220200029972.png)

### 策略(Policy)

*Policy* tells the agent what actions to take **at a state.** 

- 策略指的是每个状态的策略，而不是全局的策略。

- 举个例子：在grid-world例子中，policy指挥九个格子分别应该采取什么动作，而不是从某一开始状态到终止状态的特定路线（即下面提到的Path）经过的状态（特定路线经过的状态一定少于或等于9个状态）

  ![image-20231220200840060](Reinforcement learning.assets/image-20231220200840060.png)

- Path：从某一开始状态到终止状态经过的状态集合

- 我们通常使用条件概率描述policy

  > 在强化学习中，我们使用符号$\pi$表示Policy

  **确定性情景：**

  $\pi（a_2|s_1)=1$表示在状态s1采取动作a2的可能性为1

  ![image-20231220201112111](Reinforcement learning.assets/image-20231220201112111.png)

  **随机性情景：**

  $\pi（a_2|s_1)=0.5$表示在状态s1采取动作a2的可能性为0.5

  ![image-20231220201139571](Reinforcement learning.assets/image-20231220201139571.png)

### 奖赏(Reward)

a **real number** we get after taking an action. 

- A real number指：回报是标量
- 奖赏是**某个状态**采取**某个动作**后的奖赏，而不是全局的奖赏
- A **positive** reward represents **encouragement** to take such actions.

- A **negative** reward represents **punishment** to take such actions.

- Zero reward表示没有惩罚，这也算是一种encouragement

- 当然，我们也可以使用negative reward表示encouragement，使用positive reward表示punishment，此时我们的最优策略就从maxmize total rewards 变成 minimize total rewards

- **奖赏依赖于当前的状态和动作，而不是下一个状态**

- Reward can be interpreted as a **human-machine interface**, with which we can guide the agent to behave as what we expect.

- 奖赏的值也分为确定性情景和随机性情景两种情况

  - 确定性情景：

    $p(r = -1|s_1, a_1) = 1$表示状态s1采取a1动作得到奖赏为-1的可能性为1

    ![image-20231220202444978](Reinforcement learning.assets/image-20231220202444978.png)

  - 随机性情景

    同样以上图为例，$p(r = -1|s_1, a_1) = 0.5$表示状态s1采取a1动作得到奖赏为-1的可能性为0.5，$p(r = 1|s_1, a_1) = 0.5$表示状态s1采取a1动作得到奖赏为1的可能性为0.5

    所以状态s1采取动作a1有0.5的概率得到奖赏1，有0.5的概率得到奖赏-1

  

### 轨迹Trajectory & 回报Return

![image-20231220203054949](Reinforcement learning.assets/image-20231220203054949.png)

Trajectory可以无限长，当Trajectory无限长，得到的Return有可能是无穷

<u>**Return** could be used to evaluate whether a policy is good or not</u>

#### Discounted return

我们在前面提到“Trajectory可以无限长，当Trajectory无限长，得到的Return有可能是无穷”，例如下图：

到达终止状态s9后，策略选择原地不动，那么就会一直循环在s9状态

![image-20231220203954506](Reinforcement learning.assets/image-20231220203954506.png)

为了避免Return为无穷的情况，我们引入折扣因子(discount rate)

$\gamma ∈ [0, 1)$

引入折扣因子后，原来无穷的Return变为有限值，可以通过无穷级数计算得到

除此之外，折扣因子还有更神奇的用途：它是一个赋予现在值和未来值的权重

- $\gamma$越接近0，表示越重视当下值
- $\gamma$越接近1，表示越重视未来值

![image-20231220204244296](Reinforcement learning.assets/image-20231220204244296.png)

### Episode

> When interacting with the environment following a policy, the agent may stop at some *terminal states*. The resulting trajectory is called an *episode* (or a trial)

中文好像没有很好的解释

游戏里面的关卡和剧集里面每一集e1、e2的e都用episode表示

在强化学习中，Episode指agent在环境里面执行某个策略从开始到结束这一过程。

Episode是有限长的Trajectory

**有限过程的任务叫做episodic tasks**

Tasks with episodes are called ***episodic tasks*.**

**无限过程的任务叫做continuing tasks**

Some tasks may have no terminal states, meaning the interaction with the environment will never end. Such tasks are called ***continuing tasks***.

**我们可以将episodic tasks转换为continuing tasks：**

> In fact, we can treat episodic and continuing tasks in a unified mathematical way by converting episodic tasks to continuing tasks.
>
> - Option 1: Treat the target state as a special absorbing state. Once the agent reaches an absorbing state, it will never leave. The consequent rewards *r* = 0.
> - Option 2: Treat the target state as a normal state with a policy. The agent can still leave the target state and gain *r* = +1 when entering the target state.
>
> We consider option 2 in this course so that we don’t need to distinguish the target state from the others and can treat it as a normal state.

有两种转换方法：

1. 将目标状态视作“策略为：采取停留在原地的动作，并且该终止状态采取该动作后奖赏为0”的状态
2. 将目标状态视作普通状态，agent到达目标状态不会停下， 而是继续走，目标状态与其他状态唯一不同之处：目标状态的奖赏为+1



### 马尔可夫决策过程(Markov decision process, MDP)

马尔可夫决策过程 (Markov decision process, MDP) 描述了强化学习的环境规律，几乎所有的强化学习问题都可以形式化为MDPs

MDP框架包括了三个部分，也就是名字所提到的Markov process&decison

#### 马尔科夫性质(Markov)

马尔可夫性质：

$𝑃(𝑆_{𝑡+1}|𝑆1, 𝑆2, 𝑆3, … , 𝑆𝑡) = 𝑃(𝑆_{𝑡+1}|𝑆𝑡) $

➢给定当前状态𝑆𝑡 ，未来$𝑆_{𝑡+1}$与历史$𝑆_1, 𝑆_2, 𝑆_3,…$无关

➢$𝑆_{𝑡+1}$取决于$𝑆_𝑡$，不用考虑历史状态

马尔科夫过程就是具有马尔科夫性质的离散随机过程

#### 过程(process)

![image-20231222154459364](Reinforcement learning.assets/image-20231222154459364.png)

过程指的就是**随机过程**，包括过程记载的集合和随机概率

集合包括：

- 有限个状态集合
- 动作集合
- 奖赏集合

随机概率包括：

1. 当前状态s采取动作a到达状态s'的概率$p(s'|s,a)$
2. 当前状态s采取动作a获得奖赏r的概率$p(r|s,a)$

将分点1的概率$p(s'|s,a)$汇总即为**状态转移矩阵**

![image-20231222155342467](Reinforcement learning.assets/image-20231222155342467.png)

#### 决策(decision)

决策指的就是策略(policy)，指挥agent在每个状态应该采取什么动作

#### 补充

##### 马尔可夫过程

马尔可夫过程 (Markov Process)是满足马尔可夫性质

的离散随机过程，又称**马尔可夫链 (Markov Chain)**

➢ 有限个状态集合𝑆

➢ 状态转移矩阵P

##### 马尔可夫奖赏过程

马尔可夫奖赏过程：马尔可夫链+奖赏

• 有限个状态集合𝑆

• 状态转移矩阵𝑃

• 奖赏函数$𝑅_𝑠 = 𝔼[𝑅_{𝑡+1}|𝑆_𝑡 = 𝑠]$

• 折扣因子𝛾 ∈ [0,1]



## 贝尔曼方程

为了更好地表述“回报”，我们用随机变量$G_t$表示状态$S_t$出发得到的某条Trajectory所得到的回报(这里实际为discounted return)

![image-20231222155835447](Reinforcement learning.assets/image-20231222155835447.png)

### 状态值函数(State value function)/状态值

**从状态$𝑆_𝑡$开始， 采取策略𝜋，获得的回报$𝐺_𝑡$的期望**  
$$
𝑉_𝜋(𝑠) = 𝔼_𝜋[𝐺_𝑡|𝑆_𝑡=𝑠]=𝔼_𝜋[𝑅_{𝑡+1} + 𝛾𝑅_{𝑡+2} + 𝛾^2𝑅_{𝑡+3} + ⋯ |𝑆_𝑡 = 𝑠
$$
有几点需要注意：

1. 状态值函数是针对状态s和策略$\pi$的函数。相同状态下采取不同策略$\pi$所得到的状态值不同，相同策略不同状态s所得到的状态值也不同

2. **状态值$𝑉_𝜋(𝑠)$和回报$G_t$的区别**

   状态值函数$𝑉_𝜋(𝑠)$是从状态$𝑆_𝑡$开始能获得的所有回报$G_t$的平均值（即所有可能轨迹）

   如果轨迹只有一条，即所有情况都是确定的，即$π(a|s), p(r|s,a), p(s_0|s,a) $ 都是“确定的”（这里的确定意为，概率为1或0），那么状态值函数$𝑉_𝜋(𝑠)$与回报$G_t$相同

3. 状态值函数可用于评价当前策略的好坏，状态值越大，说明策略越好，因为所能得到的回报期望越大

### 动作值函数(Action-value function)

**从状态𝑠并执行动作𝑎开始，采取策略𝜋，获得的回报的期望**  
$$
𝑞_𝜋(𝑠,𝑎) = 𝔼_𝜋[𝐺_𝑡|𝑆_𝑡 = 𝑠, 𝐴_𝑡 = 𝑎]= 𝔼_𝜋[𝑅_{𝑡+1} + 𝛾𝑅_{𝑡+2} + 𝛾^2𝑅_{𝑡+3} + ⋯ 𝑆_𝑡 = 𝑠, 𝐴_𝑡 = 𝑎
$$
有几点需要注意：

1. 动作值函数是针对状态s，动作a和**策略$\pi$**的函数。

### 状态值函数和动作值函数的关系

$$

\begin{aligned} 
v_π(s) &= \Sigma_aπ(a|s)q_π(s,a) (2)\\
q_π(s,a) &= \Sigma_rp(r|s,a)r + \gamma\Sigma_{s'}p(s'|s,a)v_π(s') (4)
\end{aligned} 
$$



(2)式告诉我们：可以从动作值函数得到状态值函数

(4)式告诉我们：可以从状态值函数得到动作值函数

### 贝尔曼方程

![image-20231223204635761](Reinforcement learning.assets/image-20231223204635761.png)

#### 状态值函数推导

$G_t$可以写成
$$
\begin{aligned} 
G_t &= 𝑅_{𝑡+1} + 𝛾𝑅_{𝑡+2} + 𝛾^2𝑅_{𝑡+3} + ⋯\\
	&=𝑅_{𝑡+1} + 𝛾(𝑅_{𝑡+2} + 𝛾𝑅_{𝑡+3} + ⋯)\\
	&=𝑅_{𝑡+1} + 𝛾G_{t+1}
\end{aligned}
$$
状态值函数可以写成
$$
\begin{aligned} 
V_π(s) &= E[G_t|S_t = s]\\
&= E[R_{t+1} + γG_{t+1}|S_t = s]\\
&= E[R_{t+1}|S_t = s] + γE[G_{t+1}|S_t = s]
\end{aligned}
$$
然后分别计算$E[R_{t+1}|S_t = s]$和$E[G_{t+1}|S_t = s]$

##### 计算$E[R_{t+1}|S_t = s]$

注：采取动作a之后有不同概率得到对应不同值$R_{t+1}$，但我们只想要得到采取动作a得到的$R_{t+1}$，所以对采取动作a得到的所有可能的$R_{t+1}$求期望

![image-20231223161309928](Reinforcement learning.assets/image-20231223161309928.png)

##### 计算$E[G_{t+1}|S_t = s]$

注：由于马尔可夫性质，$E[G_{t+1}|S_t = s,S_{t+1} = s']=E[G_{t+1}|S_{t+1} = s']$

![image-20231223161322542](Reinforcement learning.assets/image-20231223161322542.png)

**把两步计算结果综合起来**

![image-20231223163717159](Reinforcement learning.assets/image-20231223163717159.png)

![image-20231223163945009](Reinforcement learning.assets/image-20231223163945009.png)

**把这个结果整理一下：**

这个结果表示状态s采取动作a所能得到的return的期望
$$
\begin{aligned} 
\Sigma_rp(r|s,a)r&=𝔼_𝜋(R_{t+1}|S_t=s,A_t=a)\\
\Sigma_{s'}p(s'|s,a)v_\pi(s')&=𝔼_𝜋(G_{t+1}|S_t=s,A_t=a)\\
𝔼_𝜋(R_{t+1}|S_t=s,A_t=a) + 𝛾𝔼_𝜋(G_{t+1}|S_t=s,A_t=a)&= 𝔼_𝜋(R_{t+1}+𝛾G_{t+1}|S_t=s,A_t=a) \\
\Sigma_a\pi(a|s)𝔼_𝜋(R_{t+1}+𝛾G_{t+1}|S_t=s,A_t=a) &=𝔼_𝜋[𝑅_{𝑡+1} + 𝛾𝑉_𝜋(𝑆_{𝑡+1}) |𝑆_𝑡 = 𝑠]
\end{aligned}
$$
![image-20231223164754096](Reinforcement learning.assets/image-20231223164754096.png)

我们就能得到
$$
\begin{aligned} 
𝑉_𝜋(𝑠) = 𝔼_𝜋[𝑅_{𝑡+1} + 𝛾𝑉_𝜋(𝑆_{𝑡+1}) |𝑆_𝑡 = 𝑠]
\end{aligned}
$$
挖个坑，感觉这个推导还是不太对，具体见

[MDP贝尔曼方程的详细推导 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/422749374)

#### 动作值函数推导

我们由状态值函数推导可知：
$$
\begin{aligned}
𝑉_𝜋(𝑠) = 𝔼_𝜋[𝐺_𝑡|𝑆_𝑡=𝑠]
&=\Sigma_a\pi(a|s)𝔼_𝜋[𝐺_𝑡|𝑆_𝑡 = 𝑠, 𝐴_𝑡 =𝑎]\\
&=\Sigma_a\pi(a|s)E(R_{t+1}+𝛾G_{t+1}|S_t=s,A_t=a) \\
&= 𝔼_𝜋[𝑅_{𝑡+1} + 𝛾𝑉_𝜋(𝑆_{𝑡+1}) |𝑆_𝑡 = 𝑠]\\
\end{aligned}
$$
由动作值函数定义可知：
$$
𝑞_𝜋(𝑠,𝑎) = 𝔼_𝜋[𝐺_𝑡|𝑆_𝑡 = 𝑠, 𝐴_𝑡 = 𝑎]
$$
所以可以得到：
$$
𝑉_𝜋(𝑠) =\Sigma_a\pi(a|s)𝑞_𝜋(𝑠,𝑎)
$$
我们也能得到：

动作值函数$𝑞_𝜋(𝑠,𝑎)$等于这个式子

![image-20231223164754096](Reinforcement learning.assets/image-20231223164754096.png)
