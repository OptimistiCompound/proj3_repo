#### **openGauss**的计划如下

```postgresql
"Streaming(type: LOCAL GATHER dop: 1/16)  (cost=200202.45..200202.71 rows=100 width=12) (actual time=[17231.476,17231.785]..[17231.476,17231.785], rows=100)"
"  ->  HashAggregate  (cost=200202.45..200202.51 rows=100 width=12) (actual time=[17210.606,17210.607]..[17221.609,17221.611], rows=100)"
        Group By Key: t1.c1
"        ->  Streaming(type: LOCAL REDISTRIBUTE dop: 16/16)  (cost=200199.77..200202.42 rows=100 width=12) (actual time=[17107.532,17210.246]..[17118.665,17221.439], rows=1600)"
"              ->  HashAggregate  (cost=200199.77..200199.83 rows=100 width=12) (actual time=[17122.979,17122.998]..[17227.694,17227.719], rows=1600)"
                    Group By Key: t1.c1
"                    ->  Hash Join  (cost=91432.81..197074.75 rows=10000048 width=4) (actual time=[4118.325,16962.350]..[4346.175,24613.910], rows=10000000)"
                          Hash Cond: (t1.id = t2.id)
"                          ->  Streaming(type: LOCAL REDISTRIBUTE dop: 16/16)  (cost=0.00..76906.34 rows=10000048 width=8) (actual time=[0.070,3145.846]..[212.893,3349.521], rows=10000000)"
"                                ->  Seq Scan on tb_join t1  (cost=0.00..24015.53 rows=10000048 width=8) (actual time=[0.005,2540.156]..[0.008,2648.286], rows=10000000)"
"                          ->  Hash  (cost=76906.34..76906.34 rows=10000048 width=4) (actual time=[4099.909,4099.909]..[4115.587,4115.587], rows=10000000)"
                                Max Buckets: 131072  Max Batches: 16  Max Memory Usage: 1369kB
                                Min Buckets: 131072  Min Batches: 16  Min Memory Usage: 1369kB
"                                ->  Streaming(type: LOCAL REDISTRIBUTE dop: 16/16)  (cost=0.00..76906.34 rows=10000048 width=4) (actual time=[0.077,2558.128]..[179.766,2732.366], rows=10000000)"
"                                      ->  Seq Scan on tb_join t2  (cost=0.00..24015.53 rows=10000048 width=4) (actual time=[0.134,2014.841]..[1.152,2109.835], rows=10000000)"
Total runtime: 17284.136 ms
```

**实际用时：17284.136 ms**



#### **PostgreSQL**的执行如下

```
Finalize GroupAggregate  (cost=224732445.98..224732873.88 rows=200 width=12) (actual time=23038.091..28648.779 rows=100 loops=1)
  Group Key: t1.c1
  ->  Gather Merge  (cost=224732445.98..224732855.88 rows=3200 width=12) (actual time=23038.055..28648.693 rows=800 loops=1)
        Workers Planned: 16
        Workers Launched: 7
        ->  Sort  (cost=224731445.63..224731446.13 rows=200 width=12) (actual time=22852.345..22852.375 rows=100 loops=8)
              Sort Key: t1.c1
              Sort Method: quicksort  Memory: 29kB
              Worker 0:  Sort Method: quicksort  Memory: 29kB
              Worker 1:  Sort Method: quicksort  Memory: 29kB
              Worker 2:  Sort Method: quicksort  Memory: 29kB
              Worker 3:  Sort Method: quicksort  Memory: 29kB
              Worker 4:  Sort Method: quicksort  Memory: 29kB
              Worker 5:  Sort Method: quicksort  Memory: 29kB
              Worker 6:  Sort Method: quicksort  Memory: 29kB
              ->  Partial HashAggregate  (cost=224731435.98..224731437.98 rows=200 width=12) (actual time=22852.274..22852.310 rows=100 loops=8)
                    Group Key: t1.c1
                    Batches: 1  Memory Usage: 48kB
                    Worker 0:  Batches: 1  Memory Usage: 48kB
                    Worker 1:  Batches: 1  Memory Usage: 48kB
                    Worker 2:  Batches: 1  Memory Usage: 48kB
                    Worker 3:  Batches: 1  Memory Usage: 48kB
                    Worker 4:  Batches: 1  Memory Usage: 48kB
                    Worker 5:  Batches: 1  Memory Usage: 48kB
                    Worker 6:  Batches: 1  Memory Usage: 48kB
                    ->  Parallel Hash Join  (cost=60752.57..68479935.98 rows=31250300001 width=4) (actual time=18698.276..22742.421 rows=1250000 loops=8)
                          Hash Cond: (t1.id = t2.id)
                          ->  Parallel Seq Scan on tb_join t1  (cost=0.00..50498.03 rows=625003 width=8) (actual time=1.113..1251.532 rows=1250000 loops=8)
                          ->  Parallel Hash  (cost=50498.03..50498.03 rows=625003 width=4) (actual time=9063.024..9063.024 rows=1250000 loops=8)
                                Buckets: 131072  Batches: 256  Memory Usage: 2656kB
                                ->  Parallel Seq Scan on tb_join t2  (cost=0.00..50498.03 rows=625003 width=4) (actual time=86.099..1537.025 rows=1250000 loops=8)
Planning Time: 2.918 ms
JIT:
  Functions: 115
"  Options: Inlining true, Optimization true, Expressions true, Deforming true"
"  Timing: Generation 16.294 ms, Inlining 278.393 ms, Optimization 229.166 ms, Emission 170.155 ms, Total 694.008 ms"
Execution Time: 28663.835 ms
```

**实际用时：28663.835 ms**