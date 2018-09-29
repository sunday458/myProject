<?php 
// 1. 生成原始的二维码(生成图片文件)  
function scerweima($url=''){  
    require_once 'phpqrcode.php';  
      
    $value = $url;                  //二维码内容  
      
    $errorCorrectionLevel = 'L';    //容错级别   
    $matrixPointSize = 5;           //生成图片大小    
      
    //生成二维码图片  
    $filename = 'qrcode/'.microtime().'.png';  
    QRcode::png($value,$filename , $errorCorrectionLevel, $matrixPointSize, 2);    
    
    $QR = $filename;                //已经生成的原始二维码图片文件    
  
  
    $QR = imagecreatefromstring(file_get_contents($QR));    
    
    //输出图片    
    imagepng($QR, 'qrcode.png');    
    imagedestroy($QR);  
    return '<img src="qrcode.png" alt="使用微信扫描支付">';     
}  
//调用查看结果  
echo scerweima('https://www.baidu.com');    

//2. 在生成的二维码中加上logo(生成图片文件)  
/*function scerweima1($url=''){  
    require_once 'phpqrcode.php';  
    $value = $url;                  //二维码内容    
    $errorCorrectionLevel = 'H';    //容错级别    
    $matrixPointSize = 6;           //生成图片大小    
    //生成二维码图片  
    $filename = 'qrcode/'.microtime().'.png';  
    QRcode::png($value,$filename , $errorCorrectionLevel, $matrixPointSize, 2);    
      
    $logo = 'qrcode/logo.jpg';  //准备好的logo图片     
    $QR = $filename;            //已经生成的原始二维码图    
  
    if (file_exists($logo)) {     
        $QR = imagecreatefromstring(file_get_contents($QR));        //目标图象连接资源。  
        $logo = imagecreatefromstring(file_get_contents($logo));    //源图象连接资源。  
        $QR_width = imagesx($QR);           //二维码图片宽度     
        $QR_height = imagesy($QR);          //二维码图片高度     
        $logo_width = imagesx($logo);       //logo图片宽度     
        $logo_height = imagesy($logo);      //logo图片高度     
        $logo_qr_width = $QR_width / 4;     //组合之后logo的宽度(占二维码的1/5)  
        $scale = $logo_width/$logo_qr_width;    //logo的宽度缩放比(本身宽度/组合后的宽度)  
        $logo_qr_height = $logo_height/$scale;  //组合之后logo的高度  
        $from_width = ($QR_width - $logo_qr_width) / 2;   //组合之后logo左上角所在坐标点  
          
        //重新组合图片并调整大小  
        /* 
         *  imagecopyresampled() 将一幅图像(源图象)中的一块正方形区域拷贝到另一个图像中 
         */  
        /*imagecopyresampled($QR, $logo, $from_width, $from_width, 0, 0, $logo_qr_width,$logo_qr_height, $logo_width, $logo_height);   
    }     
    
    //输出图片    
    imagepng($QR, 'qrcode.png');    
    imagedestroy($QR);  
    imagedestroy($logo);  
    return '<img src="qrcode.png" alt="使用微信扫描支付">';     
}  
  
//调用查看结果  
echo scerweima1('https://www.baidu.com');  */

/*//3. 生成原始的二维码(不生成图片文件)  
function scerweima2($url=''){  
    require_once 'phpqrcode.php';  
      
    $value = $url;                  //二维码内容  
    $errorCorrectionLevel = 'L';    //容错级别   
    $matrixPointSize = 5;           //生成图片大小    
    //生成二维码图片  
    $QR = QRcode::png($value,false,$errorCorrectionLevel, $matrixPointSize, 2);  
}  
//调用查看结果  
$pic = scerweima2('https://www.baidu.com');  */
header('Content-type:text/html;charset=utf-8');
$dir = iconv("UTF-8", "GBK", "Hello/bookcover");
if (!file_exists($dir))
{
    mkdir ($dir,0777,true);
    echo '创建文件夹bookcover成功';
} 
else 
{
    echo '需创建的文件夹bookcover已经存在';
}
