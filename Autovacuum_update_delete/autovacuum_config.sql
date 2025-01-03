-- 这个脚本文件用于进行autovacuum_delete_update测试的配置

-- autovacuum的相关配置
-- 如果没有打开，则启用 Autovacuum
ALTER SYSTEM SET autovacuum TO on;

-- 设置 Autovacuum 检查间隔时间为 1 分钟
ALTER SYSTEM SET autovacuum_naptime TO '1min';
-- 设置触发 VACUUM 操作的死元组数量阈值
ALTER SYSTEM SET autovacuum_vacuum_threshold TO 50;
ALTER SYSTEM SET autovacuum_analyze_threshold TO 50;
-- 记录所有的 autovacuum 语句
ALTER SYSTEM SET log_autovacuum_min_duration TO -1;



-- 检查是否设置正确
SHOW autovacuum; -- 检查是否打开了autovacuum功能
SHOW autovacuum_naptime;
SHOW autovacuum_vacuum_threshold;
SHOW autovacuum_analyze_threshold;
SHOW log_autovacuum_min_duration;
SHOW log_min_messages;

SHOW shared_preload_libraries;

-- 其他配置

-- 设置 OpenGauss 配置参数
SET shared_buffers = '2MB';
SET work_mem = '16MB';
SET maintenance_work_mem = '128MB';
SET effective_cache_size = '8GB';
SET random_page_cost = 4;
SET seq_page_cost = 1;
SET temp_buffers = '8MB';
SET query_dop = 4;

-- 设置 PostgreSQL 的配置参数
SET shared_buffers = '2MB';
SET work_mem = '16MB';
SET maintenance_work_mem = '128MB';
SET effective_cache_size = '8GB';
SET random_page_cost = 4;
SET seq_page_cost = 1;
SET temp_buffers = '8MB';
SET max_parallel_workers = 4;

-- 重新加载配置
SELECT pg_reload_conf();