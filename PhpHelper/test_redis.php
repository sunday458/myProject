<?php
//连接本地的 Redis 服务
 $redis = new Redis();
 $redis->connect('127.0.0.1', 6379);
 echo '<pre>';
/*echo "Connection to server sucessfully";
 //设置 redis 字符串数据
 //$redis->set("tutorial-name", "Redis tutorial");
 // 获取存储的数据并输出
 echo "Stored string in redis:: " . $redis->get("tutorial-name").'<br/>';
//var_dump($redis->RENAME('tutorial-name','test_name'));
 print_r($redis->get("test_name"));*/

//2.string类型的常用命令： 
/*自加：incr 
  自减：decr 
  加： incrby 
  减： decrby */


 //3.list列表 类型支持的常用命令： 
/*lpush:从左边推入 
lpop:从右边弹出 
rpush：从右变推入 
rpop:从右边弹出 
llen：查看某个list数据类型的长度 */
echo '<br/>-------------list列表<br/>';
 /*$redis->rpush('list1','a'); //右边插入
 $redis->rpush('list1','b');
 $redis->rpush('list1','c');*/
 $lpop = $redis->lpop('list1');//左边弹出
 var_dump($lpop);
 var_dump($redis->llen('list1'));
 var_dump($redis->lrange('list1',0,-1)); //获取list中从第一个0表示到最后一个的数据-1
 var_dump($redis->lindex('list1',2));    //获取list的下标=2的数据; 

 //4.set 集合类型支持的常用命令： 
/*sadd:添加数据 
scard:查看set数据中存在的元素个数 
sismember:判断set数据中是否存在某个元素 
srem:删除某个set数据中的元素 */
echo '<br/>------------set 集合<br/>';
$redis->sadd('set1','a'); //添加
$redis->sadd('set1','b'); //添加
$redis->sadd('set1','c'); //添加
$num = $redis->scard('set1'); 
$set_arr = $redis->smembers('set1');
var_dump($num);
var_dump($set_arr);

//4、hash 哈希
// hset:添加hash数据 
// hget:获取hash数据 
// hmget:获取多个hash数据 
// hgetall:获取所有hash数据 
 echo '<br/>------------hash 哈希 集合<br/>';
$redis->hset('hash1','name','xiaoming');
$redis->hset('hash1','age',21);
/*$redis->hset('hash2','name','Lisi');
$redis->hset('hash2','age',22);*/
$hash_obj = $redis->hgetall('hash1');
$name = $redis->hget('hash1','name');
$hash_arr = $redis->hmget('hash1',array('name','age'));
var_dump($hash_obj);
var_dump($name);
var_dump($hash_arr);

//5、zset 有序集合
// zadd:添加 
// zcard:查询 
// zrange:数据排序 
echo '<br/>-------------zset 有序集合<br/>';
$redis->delete('zset1');
$redis->zadd('zset1',100,'xiaoming');
$redis->zadd('zset1',90,'lisi');
$redis->zadd('zset1',85,'zhangsan');
$zset_arr1 = $redis->zrange('zset1',1,-1);
$zset_arr2 = $redis->zrevrange('zset1',0,-1);
var_dump($zset_arr1);
var_dump($zset_arr2);