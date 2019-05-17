###### 技术点的总结

```
1. 对于大数据、涉及N次操作的功能和程序，请考虑到超时和并发情况

2.
```

```
//数据库事务和读取执行问题

/**
 *  思考： A程序执行事务入AA库操作,B程序获取AA库的数据，先执行A再执行B，B能读取到AA表的记录吗？      
 * 模拟场景代码如下：
 */
	public function test_db1()
	{
		$db = M('member');
		$db->startTrans();
		try{
			for ($i=0; $i < 2 ; $i++) {
				$add['name'] = 'user_'.rand(1000,9999); 
				$add['lv'] = rand(1,10); 
				$add['phone'] = '138'.rand(10001000,10009000); 
				$add['add_time'] = time(); 
				$db->add($add);
				sleep(4);
			}
		}catch(\Exception $e){
			$error = $e->getMessage();
			$db->rollback();
		}
		$db->commit();
		echo date('Y-m-d H:i:s').'入库测试结束';
	}

	public function test_db()
	{
		var_dump(rand(1,2));
		$db = M('member');
		$list = $db->select();
		echo '<pre>';
		var_dump($list);
	}
  
  // 执行的结果是只有等A程序执行入库操作完成之后，B程序才能获取到记录
```
     
- 数据库
	+ Mysql的数据库添加或更新操作
	* 新增一个员工时，如果该员工已存在(以员工号f_emp_code作为判断依据)，则更新，否则插入。而且工资f_salary，更新时，不得低于原工资（即：工资只能涨，不能降）。
```
*方法一：传统方法
插入
INSERT INTO t_emp(
	f_emp_code ,
	f_emp_name ,
	f_city ,
	f_salary
) SELECT '10007' ,
	 '新人' ,
	 '西安' ,
	 1000 
	FROM DUAL WHERE NOT EXISTS(
	SELECT * FROM t_emp WHERE f_emp_code = '10007'
);
更新：　
UPDATE t_emp SET f_emp_name = '新人2' ,
 f_city = '西安' ,
 f_salary = IF(1000 > f_salary , 1000 , f_salary) WHERE f_emp_code = '10007'
缺点就是得写2条语句，分别处理插入和更新的场景。
```
```
方法二：replace into
REPLACE INTO t_emp(
	f_emp_code ,
	f_emp_name ,
	f_city ,
	f_salary
) VALUES(
	'10007' ,
	'新人' ,
	'西安' ,
	IF(1000 > f_salary , 1000 , f_salary));
replace into相当于，先检测该记录是否存在(根据表上的唯一键)，如果存在，先delete，然后再insert。 这个方法有一个很大的问题，如果记录存在，每次执行完，主键自增id就变了（相当于重新insert了一条），对于有复杂关联的业务场景，如果主表的id变了，其它子表没做好同步，会死得很难看。-- 不建议使用该方法！
```
```
方法三：on duplicate key
INSERT INTO t_emp(
	f_emp_code ,
	f_emp_name ,
	f_city ,
	f_salary)
VALUES(
	'10007' ,
	'新人' ,
	'西安' ,
	1000) 
ON DUPLICATE KEY UPDATE 
	f_emp_code = values(f_emp_code) ,
	f_emp_name = values(f_emp_name),
	f_city = values(f_city),
	f_salary = if(values(f_salary)>f_salary,values(f_salary),f_salary);
注意上面的on duplicate key，遇到重复键（即：违反了唯一约束），这时会做update，否则做insert。该方法，没有replace into的副作用，不会导致已存在记录的自增id变化。但是有另外一个问题，如果这个表上有不止一个唯一约束，在特定版本的mysql中容易产生dead lock（死锁），见网友文章https://blog.csdn.net/pml18710973036/article/details/78452688
```
