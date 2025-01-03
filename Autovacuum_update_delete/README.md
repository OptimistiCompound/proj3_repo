## 配置信息

运行脚本 `autovacuum_update_delete.sql` 中的配置代码

### `autovacuum`相关配置

```sql
-- 如果没有打开，则启用 Autovacuum
ALTER SYSTEM SET autovacuum TO on;

-- 设置 Autovacuum 检查间隔时间为 1 分钟
ALTER SYSTEM SET autovacuum_naptime TO '1min';
-- 设置触发 VACUUM 操作的死元组数量阈值
ALTER SYSTEM SET autovacuum_vacuum_threshold TO 50;
ALTER SYSTEM SET autovacuum_analyze_threshold TO 50;
-- 记录所有的 autovacuum 语句
ALTER SYSTEM SET log_autovacuum_min_duration TO -1;
```

### 其他配置如下

#### openGauss

|       参数名称       |  值   |
| :------------------: | :---: |
|    shared_buffers    |  2MB  |
|       work_mem       | 16MB  |
| maintenance_work_mem | 128MB |
| effective_cache_size |  8GB  |
|   random_page_cost   |   4   |
|    seq_page_cost     |   1   |
|     temp_buffers     |  8MB  |
|      query_dop       |   4   |

#### postgres：

|       参数名称       |  值   |
| :------------------: | :---: |
|    shared_buffers    |  2MB  |
|       work_mem       | 16MB  |
| maintenance_work_mem | 128MB |
| effective_cache_size |  8GB  |
|   random_page_cost   |   4   |
|    seq_page_cost     |   1   |
|     temp_buffers     |  8MB  |
| max_parallel_workers |   4   |