<?php
require './Sensitive.php';
$instance = Sensitive::getInstance();
$instance->addSensitiveWords('./banned.txt');  //引入你的敏感词库文件
$txt = "我擦，——————————你麻痹的——————，尼玛的，你个傻逼";  //需要过滤的文本
echo $instance->execFilter($txt);