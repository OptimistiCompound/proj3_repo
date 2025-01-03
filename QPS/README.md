## 数据集

在点查实验中，我使用的数据集cities来自于
https://github.com/dr5hn/countries-states-cities-database

你可以在原仓库中找到cities表，或者你可以使用本项目提供的cities.csv文件和cities.sql来导入数据

## 数据库压测工具JMeters

Apache JMeter™ 是一款开源软件，完全采用 Java 编写，旨在进行负载测试功能行为和性能测量。最初是为测试 Web 应用程序设计的，但后来扩展到其他测试功能。

Apache JMeter 可以用于测试静态和动态资源、Web 动态应用程序的性能。
它可以模拟对服务器、服务器群组、网络或对象的高负载，以测试其强度或分析在不同负载类型下的整体性能。

### 软件下载

官网：https://jmeter.apache.org/

### JMeter 配置

#### 线程组

选择10s之内生成50线程，模仿用户请求。同时，循环300次，以统计平均数据。

#### 请求样式

见文件`QPS.sql`

```sql
explain analyse
SELECT count(*) FROM cities
WHERE id BETWEEN '19482' AND '32626';
```

## 数据库配置

运行`QPS_config.sql`进行配置