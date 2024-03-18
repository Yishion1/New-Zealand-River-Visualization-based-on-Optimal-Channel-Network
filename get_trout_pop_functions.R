library(readxl)
library(ggplot2)
library(tidyr)
library(dplyr)

# 读取Excel文件中的所有表单
file_path <- "D:/Dissertation/ALL_code_file/NZ_trout_per_km/Trout_population.xlsx" # 请替换为您的文件实际路径
sheet_names <- excel_sheets(file_path)

# 初始化列表用于存储数据框
data_list <- list()

# 读取每个表单，并添加地区列
for(sheet in sheet_names) {
  df <- read_excel(file_path, sheet = sheet)
  df$Region <- sheet
  data_list[[sheet]] <- df
}

# 获取所有数据框中的年份，并创建一个完整的年份向量
all_years <- unique(unlist(lapply(data_list, colnames)))
all_years <- all_years[!all_years %in% "Region"] # 移除非年份列

# 标准化数据框，使它们具有相同的列
data_list <- lapply(data_list, function(df) {
  for(year in all_years) {
    if(!(year %in% colnames(df))) {
      df[[year]] <- NA # 添加缺失的年份列，值为NA
    }
  }
  df <- df[, c("Region", all_years)] # 重新排列列的顺序
  return(df)
})

# 合并所有数据框
combined_data <- bind_rows(data_list)

# 将数据转换为长格式
combined_data_long <- pivot_longer(combined_data, cols = all_years, names_to = "Year", values_to = "Population")

# 转换Year为数值型，以便在图表中正确显示
combined_data_long$Year <- as.numeric(as.character(combined_data_long$Year))

combined_data_2000_2010 <- combined_data_long %>%
  filter(Year >= 2000 & Year <= 2010)

# 估计密度
density_data <- density(combined_data_2000_2010$Population, na.rm = TRUE) # 移除NA值并计算密度

# 将密度对象转换为数据框
density_df <- data.frame(x = density_data$x, y = density_data$y)

# 绘制密度图
p <- ggplot(density_df, aes(x = x, y = y)) +
  geom_line() +
  theme_minimal() +
  labs(x = "Trout Population/ Km", y = "Density", title = "Density Estimate of Trout Population (2000-2010)")

print(p)
# Create a function that samples from the density
sample_from_density <- function(density_data, n) {
  samples <- numeric(n) # 初始化一个长度为n的向量
  count <- 0
  while(count < n) {
    sample_try <- sample(density_data$x, size = 1, replace = TRUE, prob = density_data$y)
    if (sample_try >= 0) { # 检查是否为非负值
      count <- count + 1
      samples[count] <- sample_try
    }
  }
  return(samples)
}
# Use the function to generate a sample of trout populations
# n 是您想要生成的样本大小
simulated_trout_populations <- sample_from_density(density_data, n = 1000)
