# New-Zealand-River-Visualization-based-on-Optimal-Channel-Network
This is my dissertation, which uses the REC2 (River Environment Classification, v2.3) dataset from NIWA and DEM (Digital Elevation Model) to visual the New Zealand river network and store the detail information of the river network such as elevation and speed of the river in a river class object for further analysis.

# 3.12：
Function：Extract the river network according to the HydroID in REC2， visualize the river network using OCN and store the data in river class objects.

To Do：1.Find ways to simulate the population of trout in NZ river, maybe take the average number

       2. Simulatie the mobility,see (Movement and Mortality of Adult Brown Trout in the Motupiko River, New Zealand: Effects of Water Temperature, Flow, and Flooding) 

       
       Most of the tagged fish moved only a
short distance during the study, around 64% moving
less than 1,000 m. Rates of movement ranged from 0 to
801 m/d and averaged 22.5 m/d, although this mean
was heavily skewed by the largest movements. The
geometric mean movement rate was 0.68 m/d


      3. Simulate the probility that trout go upstream or downstream, most trout stay downstream.

# 3.18：
FILE： get_trout_pop use the data from 2000 to 2010 to create Kernel density estimation of the data. And use the density probability to estimate the trout population according to how long the river segments is. 因为人口数量不能为0，但是KDE会自己向外扩张从而平滑曲线，所以在函数里面，我去掉了小于0的   
```
pop0 <- sample_from_density(density_data, n = OCNwe$RN$nNodes)*OCNwe$RN$leng/1000
```
related paper (Kernel density estimation and its application)itmconf_sam2018_00037

to do: the proliferation rate and mobility need to be simulated

# 3.19：
Accodrding to (Movement and Mortality of Adult Brown Trout in theMotupiko River, New Zealand: Effects of Water Temperature,Flow, and Flooding) , Rates of movement ranged from 0 to
 801 m/d and averaged 22.5 m/d, although this meanwas heavily skewed by the largest movements. The geometric mean movement rate was 0.68 m/d.
Thus the mobility can be seen as 0.68*Timestep/day


To do： 根据 Density Trout /Km 里面的数据，去掉outlier， 然后模拟曲线来计算生殖率

# 3.24：
#Influence[d(i)]=Influence[d(i)]+Influence[i]×(upstreamInfluenceWeight)^l
#这里Influence}[i]表示节点i当前的影响力值，upstreamInfluenceWeight是上游节点对下游节点的影响力权重，l是从节点i到达下游节点的层级数，d(i)是节点i的直接下游节点。
新增函数 calculateInfluenceDynamically <- function(connectivity, upstreamInfluenceWeight, OCNwe)
分析了weight和connectivity对权重分布的影响
to do 把权重与pop的density结合起来得到模拟的种群数量数据


# 4.2
尝试一维河流传播模型，但是偏微分求解遇到问题，无法计算。 明天尝试自定义河流权重函数，用户可自定义每个支流的初始influence，尝试融入污染数据


# 4.3
OCN aggregate 的时候应该选择较小的值，就可以避免influences计算时间过长。完成weighted river的population 模拟。
To do:写证明文档
# 4.28
完成shiny基础框架，
to do分两种污染源展示河流图，可以在一开始处理数据时候就把数据分开成两份，最后删掉原始数据。在shiny里面提供用户选项。
