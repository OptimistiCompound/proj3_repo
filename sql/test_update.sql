
drop table if exists test1;
 create table test1
 (
     id int ,
     var varchar
 ) ;

select * from test1;

insert into test1 values(1,2);

update test1 t set var=tt.var from (select 1,generate_series(3,4)::varchar ) as tt(id,var) where  tt.id = t.id;

select * from test1;