-- 这个脚本用于测试加入了autovacuum的情况下update和delete的性能

-- 设置脚本执行时间为 10 分钟
DO $$
DECLARE
    start_time TIMESTAMP := clock_timestamp();  -- 使用 clock_timestamp() 获取精确到微秒的时间
    end_time TIMESTAMP := start_time + INTERVAL '10 minutes';  -- 执行时间为 10 分钟
    op_start_time TIMESTAMP;
    op_end_time TIMESTAMP;
    op_duration INTERVAL;
    sleep_time INTERVAL;
BEGIN
    -- 循环直到脚本运行 10 分钟
    WHILE clock_timestamp() < end_time LOOP

        -- 记录 UPDATE 操作开始时间
        op_start_time := clock_timestamp();  -- 使用 clock_timestamp() 获取精确的开始时间
        -- 执行批量 UPDATE 操作（更新未处理的行）
        UPDATE cities
        SET state_name = 'UpdatedState'
        WHERE id IN (
            SELECT id FROM cities TABLESAMPLE SYSTEM (10) LIMIT 10000
        );
        -- 记录 UPDATE 操作结束时间
        op_end_time := clock_timestamp();  -- 使用 clock_timestamp() 获取精确的结束时间
        -- 计算 UPDATE 操作持续时间
        op_duration := op_end_time - op_start_time;
        -- 输出 UPDATE 操作的时间
        RAISE NOTICE 'UPDATE operation duration: %', op_duration;

        -- 记录 DELETE 操作开始时间
        op_start_time := clock_timestamp();  -- 使用 clock_timestamp() 获取精确的开始时间
        -- 执行批量 DELETE 操作（删除随机的行）
        DELETE FROM cities
        WHERE id IN (
            SELECT id FROM cities TABLESAMPLE SYSTEM (10) LIMIT 4000
        );
        -- 记录 DELETE 操作结束时间
        op_end_time := clock_timestamp();  -- 使用 clock_timestamp() 获取精确的结束时间
        -- 计算 DELETE 操作持续时间
        op_duration := op_end_time - op_start_time;
        -- 输出 DELETE 操作的时间
        RAISE NOTICE 'DELETE operation duration: %', op_duration;

        -- 生成随机的睡眠时间（20-40秒之间）
        sleep_time := (RANDOM() * 20 + 20) * INTERVAL '1 second';
        -- 暂停随机的时间后再执行下一轮操作
        PERFORM pg_sleep(EXTRACT(epoch FROM sleep_time));
    END LOOP;
END $$;


-- 查看执行 autovacuum 的次数
SELECT relname, n_dead_tup, last_autovacuum, autovacuum_count
FROM pg_stat_user_tables
WHERE relname = 'cities';

SELECT query, total_time, calls
FROM pg_stat_statements
WHERE query LIKE '%vacuum%' ORDER BY total_time DESC;

SELECT *
FROM information_schema.columns
WHERE table_name = 'pg_stat_statements';

SELECT
    query,
    total_exec_time,
    calls,
    min_exec_time,
    max_exec_time,
    mean_exec_time
FROM
    pg_stat_statements
WHERE
    query LIKE '%vacuum%'  -- 查找包含 'vacuum' 的查询
ORDER BY
    total_exec_time DESC;