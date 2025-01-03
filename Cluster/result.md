以下是不同fillfactor参数下postgres和opengauss的表现

### opengauss

| fillfactor | cluster 用时 |
| :--------: | :----------: |
|    100     |  5 s 109 ms  |
|     90     |  5 s 892 ms  |
|     70     |  6 s 849 ms  |
|     50     |  8 s 258 ms  |
|     30     |  8 s 551 ms  |
|     10     |  2 s 262 ms  |


### postgres

| fillfactor | cluster 用时 |
| :--------: | :----------: |
|    100     |  4 s 849 ms  |
|     90     |  5 s 579 ms  |
|     70     |  6 s 344 ms  |
|     50     |  7 s 972 ms  |
|     30     |  8 s 659 ms  |
|     10     |  1 s 520 ms  |

需要注意的是，随着fillfactor增大，一方面表的紧凑增加，这会提高`CLUSTER`的速度，但同时数据量的增大，又会拖慢`CLUSTER`的速度。