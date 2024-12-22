-- 将 id 列设置为主键
ALTER TABLE cities
ADD CONSTRAINT cities_pkey PRIMARY KEY (id);

DROP TABLE IF EXISTS db_config_QPS;
-- 首先查看两者的配置，确保baseline相同
CREATE TABLE db_config_QPS (
    db_type VARCHAR(50),         -- 数据库类型（PostgreSQL/OpenGauss）
    config_name VARCHAR(100),    -- 配置项名称
    config_value VARCHAR(255),   -- 配置项值
    PRIMARY KEY (db_type, config_name)
);

-- 设置 OpenGauss 配置参数（拉满配置）
SET shared_buffers = '16GB';  -- 提高 shared_buffers
SET work_mem = '512MB';       -- 提高 work_mem
SET maintenance_work_mem = '2GB';  -- 提高 maintenance_work_mem
SET effective_cache_size = '32GB';  -- 提高 effective_cache_size
SET random_page_cost = 1;    -- 设置为更低的值，假设使用 SSD
SET seq_page_cost = 1;       -- 设置为更低的值，假设使用 SSD
SET temp_buffers = '1GB';    -- 增大临时缓冲区
SET query_dop = 8;           -- 设置查询的并行度

-- 设置 PostgreSQL 的配置参数（拉满配置）
SET shared_buffers = '16GB';  -- 提高 shared_buffers
SET work_mem = '512MB';       -- 提高 work_mem
SET maintenance_work_mem = '2GB';  -- 提高 maintenance_work_mem
SET effective_cache_size = '32GB';  -- 提高 effective_cache_size
SET random_page_cost = 1;    -- 设置为更低的值，假设使用 SSD
SET seq_page_cost = 1;       -- 设置为更低的值，假设使用 SSD
SET temp_buffers = '1GB';    -- 增大临时缓冲区
SET max_parallel_workers = 8;  -- 增加并行查询工作线程数量

-- 重新加载配置
SELECT pg_reload_conf();

-- OpenGauss 配置插入
INSERT INTO db_config_QPS (db_type, config_name, config_value)
VALUES
    ('OpenGauss', 'shared_buffers', (SELECT current_setting('shared_buffers'))),
    ('OpenGauss', 'work_mem', (SELECT current_setting('work_mem'))),
    ('OpenGauss', 'maintenance_work_mem', (SELECT current_setting('maintenance_work_mem'))),
    ('OpenGauss', 'effective_cache_size', (SELECT current_setting('effective_cache_size'))),
    ('OpenGauss', 'random_page_cost', (SELECT current_setting('random_page_cost'))),
    ('OpenGauss', 'seq_page_cost', (SELECT current_setting('seq_page_cost'))),
    ('OpenGauss', 'temp_buffers', (SELECT current_setting('temp_buffers'))),
    ('OpenGauss', 'query_dop', (SELECT current_setting('query_dop')));

-- PostgreSQL 配置插入
INSERT INTO db_config_QPS (db_type, config_name, config_value)
VALUES
    ('PostgreSQL', 'shared_buffers', (SELECT current_setting('shared_buffers'))),
    ('PostgreSQL', 'work_mem', (SELECT current_setting('work_mem'))),
    ('PostgreSQL', 'maintenance_work_mem', (SELECT current_setting('maintenance_work_mem'))),
    ('PostgreSQL', 'effective_cache_size', (SELECT current_setting('effective_cache_size'))),
    ('PostgreSQL', 'random_page_cost', (SELECT current_setting('random_page_cost'))),
    ('PostgreSQL', 'seq_page_cost', (SELECT current_setting('seq_page_cost'))),
    ('PostgreSQL', 'temp_buffers', (SELECT current_setting('temp_buffers'))),
    ('PostgreSQL', 'max_parallel_workers', (SELECT current_setting('max_parallel_workers')));

-- 查看配置结果
SELECT * FROM db_config_QPS;
