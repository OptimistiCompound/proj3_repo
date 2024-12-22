-- 创建 50 张随机生成的表，每张表有 10,000 到 30,000 行
DO $$
DECLARE
    table_num INT := 50; -- 需要创建的表的数量
    min_rows INT := 10000; -- 每张表的最小行数
    max_rows INT := 30000; -- 每张表的最大行数
    i INT := 1;
    table_name VARCHAR;
    row_count INT;
BEGIN
    FOR i IN 1..table_num LOOP
        -- 随机生成表名
        table_name := 'tb' || i;

        -- 随机生成每张表的行数
        row_count := (min_rows + (random() * (max_rows - min_rows))::INT);

        -- 创建每张表，列数为 5，列名和数据类型随机
        EXECUTE 'CREATE TABLE ' || table_name || ' (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255),
            age INT,
            country VARCHAR(255),
            latitude FLOAT,
            longitude FLOAT
        )';

        -- 向表中插入随机数据
        EXECUTE 'INSERT INTO ' || table_name || ' (name, age, country, latitude, longitude)
                 SELECT
                    ''Name_'' || floor(random() * 10000)::TEXT,
                    floor(random() * 100)::INT,
                    CASE WHEN random() < 0.5 THEN ''Country_1'' ELSE ''Country_2'' END,
                    random() * 180 - 90,  -- latitude between -90 and 90
                    random() * 360 - 180  -- longitude between -180 and 180
                 FROM generate_series(1, ' || row_count || ')';
    END LOOP;
END $$;
