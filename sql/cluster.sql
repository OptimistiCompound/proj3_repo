-- 创建一个不记录日志的表 clu
DROP TABLE clu;
CREATE UNLOGGED TABLE clu (
   id  bigint  NOT NULL,
   key integer NOT NULL,
   val integer NOT NULL
) WITH (
   autovacuum_vacuum_cost_delay = 0,   -- 设置 autovacuum 的延迟
   fillfactor = 10                    -- 设置 fillfactor，控制表的填充度
);

-- 向 clu 表插入 1 到 100000 之间的数字，并计算 key 的值
INSERT INTO clu (id, key, val)
SELECT i, hashint4(i), 0
FROM generate_series(1, 100000) AS i;

-- 创建一个索引 clu_idx 在 key 列上
CREATE INDEX clu_idx ON clu(key);

-- 使用 clu_idx 对 clu 表进行聚簇操作
CLUSTER clu USING clu_idx;

-- 为 clu 表添加主键约束
ALTER TABLE clu ADD PRIMARY KEY (id);

-- 执行 VACUUM 和 ANALYZE 操作以优化表和统计信息
VACUUM (ANALYZE) clu;

-- 随机更新 clu 表中的一行数据
-- set i random(1, 100000)  -- 这行语法不对，应该使用 pgagent 或应用层处理随机值。
-- 这里我们可以用随机值更新某一行
DO $$
DECLARE
   i int;
BEGIN
   -- 生成 1 到 100000 之间的随机整数

   i := floor(random() * 100000 + 1);

   -- 使用生成的随机值更新 `clu` 表
   UPDATE clu SET val = val + 1 WHERE id = i;
END $$;

-- 获取 clu 表 'key' 列的相关性值
SELECT correlation
FROM pg_stats
WHERE tablename = 'clu' AND attname = 'key';

-- 重新分析 clu 表的统计信息
ANALYZE clu;

-- 获取 clu 表 'key' 列的相关性值
SELECT correlation
FROM pg_stats
WHERE tablename = 'clu' AND attname = 'key';

-- 获取 clu 表的热更新次数和 autovacuum 执行次数
SELECT n_tup_hot_upd, autovacuum_count
FROM pg_stat_user_tables
WHERE relname = 'clu';

-- 显示 clu 表的大小和索引的大小
SELECT pg_size_pretty(
          pg_table_size('clu')   -- 获取表的磁盘大小
       ) AS tab_size,
       pg_size_pretty(
          pg_total_relation_size('clu') - pg_table_size('clu')  -- 获取索引的磁盘大小
       ) AS ind_size;
