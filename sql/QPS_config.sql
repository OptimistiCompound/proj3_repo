-- 这是运行点查测试前的配置设定

-- 将 id 列设置为主键
ALTER TABLE cities
ADD CONSTRAINT cities_pkey PRIMARY KEY (id);

DROP TABLE db_config_QPS;
-- 首先查看两者的配置，确保baseline相同
CREATE TABLE db_config_QPS (
    db_type VARCHAR(50),         -- 数据库类型（PostgreSQL/OpenGauss）
    config_name VARCHAR(100),    -- 配置项名称
    config_value VARCHAR(255),   -- 配置项值
    PRIMARY KEY (db_type, config_name)
);

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
    ('PostgreSQL', 'enable_nestloop', (SELECT current_setting('enable_nestloop'))),
    ('PostgreSQL', 'enable_hashjoin', (SELECT current_setting('enable_hashjoin'))),
    ('PostgreSQL', 'enable_mergejoin', (SELECT current_setting('enable_mergejoin'))),
    ('PostgreSQL', 'random_page_cost', (SELECT current_setting('random_page_cost'))),
    ('PostgreSQL', 'seq_page_cost', (SELECT current_setting('seq_page_cost'))),
    ('PostgreSQL', 'temp_buffers', (SELECT current_setting('temp_buffers'))),
    ('PostgreSQL', 'max_parallel_workers_per_gather', (SELECT current_setting('max_parallel_workers_per_gather')));

SELECT * FROM db_config_QPS;