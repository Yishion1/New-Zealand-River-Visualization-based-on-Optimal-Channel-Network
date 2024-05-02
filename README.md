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

# 4.30
to do：https://catalogue.data.govt.nz/dataset/river-environment-classification-rec2-new-zealand    Lengthdown Real The distance to coast from any reach to its outlet reach, where the river drains (m). Headwater Integer Number (0) denoting whether a stream is a “source” (headwater) stream. Non-zero for non-headwater streams.  通过红心标注源头节点
![image](https://github.com/Yishion1/New-Zealand-River-Visualization-based-on-Optimal-Channel-Network/assets/66151793/47549162-4cc6-4208-a38c-59a1efd0ae04)
对于论文可以加入一些关于河流自相关的分析，最后产出的shiny可以加入自相关的图标

# 5.2
# Horton-Strahler Method for Analyzing River Networks

The Horton-Strahler method is a hierarchical system used to classify the branches of a river network. This system assigns an order to each segment of the river based on the structure of tributaries. It is particularly useful in geomorphology for quantifying the complexity of river networks.

## Method Overview

The Horton-Strahler method ranks river streams based on the number of tributaries upstream. The primary classification rules are:

- If a stream segment has no tributaries, it is assigned order one.
- When two streams of the same order join, the order of the resulting stream is one higher than the common order.
- If two streams of different orders join, the order of the resulting stream is the higher of the two.

## River Network Characteristics
Upon classifying the river streams using the Horton-Strahler method, we can analyze the river network by examining the number and average length of streams at each order. The relationships are described by the following formulas:
### Number of Streams at Each Order

The number of streams \(N_i\) at each order \(i\) and average length (L_i\) at each order \(i\)  can be estimated by:
![image](https://github.com/Yishion1/New-Zealand-River-Visualization-based-on-Optimal-Channel-Network/assets/66151793/d1d33c22-2767-47ec-a2db-fca88239abdd)
where:
- \(N_1\) is the number of first-order streams.
- \(R_B\) is the bifurcation ratio, typically between 3 and 5.The Branching Ratio in the context of river networks or any branching systems (such as tree branches, blood vessels, etc.) refers to the ratio of the number of branches in one order to the number of branches in the next higher order. 
- \(L_1\) is the average length of first-order streams.
- \(R_L\) is the length ratio, usually between 1.5 and 3.


## Bifurcation Ratio

![image](https://github.com/Yishion1/New-Zealand-River-Visualization-based-on-Optimal-Channel-Network/assets/66151793/b490c455-6648-4be0-b4fe-a37193f9ee31)    
where:
- \(N_ij\) is the number of stream order i join stream order j.


### What does it do?  
Stable branch ratio: If the branch ratio is stable, it indicates that the river network has high self-similarity（Similarities between morphological characteristics or hydrological attributes of adjacent river segments） and regularity. This suggests that the river network has a similar structure at different scales, often associated with uniform topography and consistent erosion processes.

Drastic variation of branch ratio: If the branch ratio varies greatly in different parts of the river network or between different levels, it may indicate that the river network has been significantly affected by local topographic or geological conditions, such as rock hardness, soil erosion, and slope changes in the terrain.
