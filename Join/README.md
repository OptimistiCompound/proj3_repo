本测试用于比较postgres和openGauss对于大表的join优化策略，我随机生成了一张1000万行的表，让两个数据库执行self-join并解释查询计划。

运行 `join.sql`，进行join的连接测试

## 配置信息

> 配置方法详见 `join.sql`

### opengauss

|     config_name      | config_value |
| :------------------: | :----------: |
|    shared_buffers    |    128MB     |
|       work_mem       |     64MB     |
| maintenance_work_mem |     16MB     |
| effective_cache_size |    128MB     |
|   enable_nestloop    |      on      |
|   enable_hashjoin    |      on      |
|   enable_mergejoin   |      on      |
|   random_page_cost   |      4       |
|    seq_page_cost     |      1       |
|     temp_buffers     |     8MB      |
|      query_dop       |      16      |



### PostgreSQL

|           config_name           | config_value |
| :-----------------------------: | :----------: |
|         shared_buffers          |    128MB     |
|            work_mem             |     64MB     |
|      maintenance_work_mem       |     64MB     |
|      effective_cache_size       |    128GB     |
|         enable_nestloop         |      on      |
|         enable_hashjoin         |      on      |
|        enable_mergejoin         |      on      |
|        random_page_cost         |      4       |
|          seq_page_cost          |      1       |
|          temp_buffers           |     8MB      |
| max_parallel_workers_per_gather |      16      |
