-- 这个脚本用于测试join的性能和查询计划的不同
DROP TABLE db_config_comparison;
-- 首先查看两者的配置，确保baseline相同
CREATE TABLE db_config_comparison (
    db_type VARCHAR(50),         -- 数据库类型（PostgreSQL/OpenGauss）
    config_name VARCHAR(100),    -- 配置项名称
    config_value VARCHAR(255),   -- 配置项值
    PRIMARY KEY (db_type, config_name)
);

-- 设置 OpenGauss 配置参数
SET shared_buffers = '128MB';
SET work_mem = '64MB';
SET maintenance_work_mem = '64MB';
SET effective_cache_size = '128GB';
SET enable_nestloop = 'on';
SET enable_hashjoin = 'on';
SET enable_mergejoin = 'on';
SET random_page_cost = 4;
SET seq_page_cost = 1;
SET temp_buffers = '8MB';
SET query_dop = 16;

-- 设置 PostgreSQL 的配置参数
SET shared_buffers = '128MB';
SET work_mem = '64MB';
SET maintenance_work_mem = '64MB';
SET effective_cache_size = '128GB';
SET enable_nestloop = 'on';
SET enable_hashjoin = 'on';
SET enable_mergejoin = 'on';
SET random_page_cost = 4;
SET seq_page_cost = 1;
SET temp_buffers = '8MB';
SET max_parallel_workers_per_gather = 16;

-- 重新加载配置
SELECT pg_reload_conf();

-- OpenGauss 配置插入
INSERT INTO db_config_comparison (db_type, config_name, config_value)
VALUES
    ('OpenGauss', 'shared_buffers', (SELECT current_setting('shared_buffers'))),
    ('OpenGauss', 'work_mem', (SELECT current_setting('work_mem'))),
    ('OpenGauss', 'maintenance_work_mem', (SELECT current_setting('maintenance_work_mem'))),
    ('OpenGauss', 'effective_cache_size', (SELECT current_setting('effective_cache_size'))),
    ('OpenGauss', 'enable_nestloop', (SELECT current_setting('enable_nestloop'))),
    ('OpenGauss', 'enable_hashjoin', (SELECT current_setting('enable_hashjoin'))),
    ('OpenGauss', 'enable_mergejoin', (SELECT current_setting('enable_mergejoin'))),
    ('OpenGauss', 'random_page_cost', (SELECT current_setting('random_page_cost'))),
    ('OpenGauss', 'seq_page_cost', (SELECT current_setting('seq_page_cost'))),
    ('OpenGauss', 'temp_buffers', (SELECT current_setting('temp_buffers'))),
    ('OpenGauss', 'query_dop', (SELECT current_setting('query_dop')));


-- PostgreSQL 配置插入
INSERT INTO db_config_comparison (db_type, config_name, config_value)
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

SELECT * FROM db_config_comparison;

CREATE TABLE tb_join (id int, c1 int);

INSERT INTO tb_join select generate_series(1,10000000), random()*99;

explain select t1.c1,count(*) from tb_join t1 join tb_join t2 using (id) group by t1.c1;

-- 使用prepare进行预编译
PREPARE test_join AS
SELECT t1.c1, count(*) FROM tb_join t1 JOIN tb_join t2 USING (id) GROUP BY t1.c1;

-- 运行：
explain analyse EXECUTE test_join;
