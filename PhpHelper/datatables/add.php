<?php
// 增加记录
$conn=@mysql_connect("localhost","root",""); //数据库
@mysql_select_db("etemsdb"); //数据表

$name=$_GET['name'];
$pwd=$_GET['pwd'];
$email=$_GET['email'];
$date=$_GET['date'];
$note=$_GET['note'];

$sql="INSERT INTO teacher (  `teacher_name`, `teacher_password`, `teacher_email`, `teacher_date`, `teacher_note`) VALUES ('".$name."',md5('".$pwd."'),'".$email."','".$date."','".$note."')";
$res=mysql_query($sql,$conn);

if($res){
	echo json_encode(array(
		"status"=>true,
		"info"=>"add success"
		),JSON_UNESCAPED_UNICODE);
}else{
	echo json_encode(array(
		"status"=>false,
		"info"=>"add error",
		"sql"=>$sql
		),JSON_UNESCAPED_UNICODE);
}