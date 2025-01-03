-- 这个脚本用于测试join的性能和查询计划的不同
DROP TABLE IF EXISTS tb_join;
CREATE TABLE tb_join (id int, c1 int);

INSERT INTO tb_join select generate_series(1,10000000), random()*99;

explain select t1.c1,count(*) from tb_join t1 join tb_join t2 using (id) group by t1.c1;

-- 使用prepare进行预编译
PREPARE test_join AS
SELECT t1.c1, count(*) FROM tb_join t1 JOIN tb_join t2 USING (id) GROUP BY t1.c1;

-- 运行：
explain analyse EXECUTE test_join;
