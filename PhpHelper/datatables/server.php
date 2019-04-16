<?php 
header("Content-type: text/html;charset=utf-8");//防止乱码
//1、获取链接
$conn=@mysql_connect("localhost","root","");
if(!$conn){
	//mysql_error()是返回mysql的上一次操作
	die("连接失败".mysql_error());
}else{
		//echo '连接成功！<br/>';
}
//2、选择对应的数据库
@mysql_select_db("etemsdb");
//3、设置操作编码（可有可无，建议有）
mysql_query("set names utf8");//保证是按照utf8码操作的【utf8无-的，有-的是网页版的！！！！！！！】

$draw = $_GET['draw']; //第几次请求
//排序
$order_column = $_GET['order']['0']['column']; // 哪一列排序
$order_dir= $_GET['order']['0']['dir']; // ase desc 升序或者降序
//拼接排序sql
$orderSql = "";
if(isset($order_column)){
    $i = intval($order_column);
    switch($i){
        case 0;$orderSql = " order by teacher_id ".$order_dir;break;
        case 1;$orderSql = " order by teacher_name ".$order_dir;break;
        // case 2;$orderSql = " order by teacher_password ".$order_dir;break;
        case 2;$orderSql = " order by teacher_email ".$order_dir;break;
        case 3;$orderSql = " order by teacher_date ".$order_dir;break;
        case 4;$orderSql = " order by teacher_note ".$order_dir;break;
        default;$orderSql = '';
    }
}

//分页
$start = $_GET['start'];//从多少开始
$length = $_GET['length'];//数据长度
$limitSql = '';
$limitFlag = isset($_GET['start']) && $length != -1 ;
if ($limitFlag ) {
    $limitSql = " LIMIT ".intval($start).", ".intval($length);
}

//定义查询数据总记录数sql
$sumSql = "SELECT count(teacher_id) as sum FROM teacher";
//条件过滤后记录数 必要
$recordsFiltered = 0;
//表的总记录数 必要
$recordsTotal = 0;
$recordsTotalResult = mysql_query($sumSql,$conn);
while($row=mysql_fetch_assoc($recordsTotalResult)){
	$recordsTotal = $row['sum'];
}
//搜索//定义过滤条件查询过滤后的记录数sql
$search = $_GET['search']['value'];//获取前台传过来的过滤条件
// 每列搜索
$j = 1;
$search_arr =array();
$colSearchSql='';
for($j=0;$j<6;$j++){
    $colSearchable = $_GET['columns'][$j]['searchable'];
    $colSearchVal = $_GET['columns'][$j]['search']['value'];
    if(strlen($colSearchVal)>0 && $colSearchable == 'true' ){
        switch ($j) {
            case 0: $colSearchVal = "teacher_id LIKE '%".$colSearchVal."%'";
                    array_push($search_arr,$colSearchVal);
                    break;
            case 1: $colSearchVal = "teacher_name LIKE '%".$colSearchVal."%'";
                    array_push($search_arr,$colSearchVal);
                    break;
            case 2: $colSearchVal = "teacher_password LIKE '%".$colSearchVal."%'";
                    array_push($search_arr,$colSearchVal);
                    break;
            case 3: $colSearchVal = "teacher_email LIKE '%".$colSearchVal."%'";
                    array_push($search_arr,$colSearchVal);
                    break;
            case 4: $colSearchVal = "teacher_date LIKE '%".$colSearchVal."%'";
                    array_push($search_arr,$colSearchVal);
                    break;
            case 5: $colSearchVal = "teacher_note LIKE '%".$colSearchVal."%'";
                    array_push($search_arr,$colSearchVal);
                    break;
            default:
                # code...
                break;
        }
    }
}
if(empty($search_arr) == false){
    $colSearchSql = " WHERE ".implode(" AND ",$search_arr);
}
// 综合搜索sql
// $zSearchSql =" where teacher_id || teacher_name || teacher_password || teacher_email || teacher_date || teacher_note LIKE '%".$search."%'";
$zSearchSql = " teacher_id LIKE '%".$search."%' OR teacher_name LIKE '%".$search."%' OR teacher_email LIKE '%".$search."%' OR teacher_date LIKE '%".$search."%' OR teacher_note LIKE '%".$search."%'";
// 拼接搜索SQL
$sumSearchSql = '';
if(strlen($colSearchSql)>0 && strlen($search)>0){
    $sumSearchSql = $colSearchSql." AND (".$zSearchSql.")";
}else if(strlen($colSearchSql)>0 && strlen($search)==0){
    $sumSearchSql = $colSearchSql;
}else if(strlen($colSearchSql)==0 && strlen($search)>0){
    $sumSearchSql = " WHERE ".$zSearchSql;
}else{
    $sumSearchSql = '';
}
if(strlen($sumSearchSql)>0){
    $recordsFilteredResult = mysql_query($sumSql.$sumSearchSql);
    while ($row = mysql_fetch_assoc($recordsFilteredResult)) {
        $recordsFiltered =  $row['sum'];
    }
}else{
    $recordsFiltered = $recordsTotal;
}
// query data
$sql='';
$totalResultSql = "SELECT * FROM teacher";
$infos = array();
// 拼接最终SQL
$sql=$totalResultSql.$sumSearchSql.$orderSql.$limitSql;
$dataResult = mysql_query($sql,$conn);
while ($row = mysql_fetch_assoc($dataResult)) {
    // $obj = array($row['teacher_id'], $row['teacher_name'], $row['teacher_password'], $row['teacher_email'], $row['teacher_date'], $row['teacher_note']);
    // array_push($infos,$obj);
    array_push($infos,$row);

}
// return data
echo json_encode(array(
	"draw" => $draw,
	"recordsTotal" =>$recordsTotal,  // necessary
	"recordsFiltered" =>$recordsFiltered, // necessary
	"data" =>$infos // necessary
	),JSON_UNESCAPED_UNICODE);