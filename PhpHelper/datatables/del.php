<?php
// 删除记录
$conn=@mysql_connect("localhost","root",""); //数据库
@mysql_select_db("etemsdb"); //数据表
$id=$_GET['id'];
$sql = "DELETE FROM `teacher` WHERE teacher_id = ".$id;
$res = mysql_query($sql,$conn);
if($res){
	echo json_encode(array(
		"status"=>true,
		// "data"=>"this is data~",
		"id"=>$id
	),JSON_UNESCAPED_UNICODE);
}else{
	echo json_encode(array(
		"status"=>false,
		// "data"=>"this is data~",
		"id"=>$id
	),JSON_UNESCAPED_UNICODE);
}