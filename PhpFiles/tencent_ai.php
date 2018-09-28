<?php
/**
 * Created by PhpStorm.
 * User: sunew
 * Date: 2018/7/20
 * Time: 16:06
 * 腾讯Ai 控制器
 */

defined('IN_PHPCMS') or exit('No permission resources.');
class tencent_ai
{
    private $api_url;
    private $appkey = 'rnHs1chHLV6p6Amg';
    private $wxuser_face_tabl;

    //默认配置
    protected $params = [
        'app_id'     => '1107061088',
        'time_stamp' => '',
        'nonce_str'  => '',
        'sign'       => '',
    ];

    public function __construct()
    {
        //parent::__construct();
        $this->wxuser_face_tabl = pc_base::load_model('wxuser_face_model');
    }

    public function test()
    {
        echo PHPCMS_PATH;
        $mysite = siteinfo(1); //站点获取
        var_dump($mysite);exit;

        // 设置请求数据（应用密钥、接口请求参数）
        $appkey = $this->appkey;
        $params = $this->params;
        /*$params = array(
            'app_id'     => '1107061088',
            'time_stamp' => '',
            'nonce_str'  => '',
            'group_id'   => 'group_id',
            'topn'       => '5',
            'sign'       => '',
        );*/
       /* $params['group_id'] = 'group_id';
        $params['topn'] = '5';*/
        $params['mode'] = 0;
        $params['time_stamp'] = time();
        $params['nonce_str'] = substr(md5(rand()), 0, 8);
        $img_file='D:/001.jpg';
        //$img_file='/img/01.jpg';
        $img_file='http://www.yanmiban.com/img/01.jpg'; //本地

        $imgname = rand(100,999);
        $tmp = $img_file;
        $filepath = 'D:/'.date('Ymd').'/';
        if(!file_exists($filepath))
        {
            mkdir($filepath,0777,true);
        }
        var_dump($tmp,$filepath.$imgname.".png");
        if(copy($tmp,$filepath.$imgname.".png")){
            echo "上传成功";
        }else{
            echo "上传失败";
        }
        exit;

        //$img_file='https://yan.cms.asiaskin.com.cn/img/01.jpg'; //线上
        //$img_file=$mysite['domain'].'img/01.jpg';
        //var_dump(copy($img_file,$mysite['domain'].'img/'."003.jpg"));exit;

        //var_dump($img_file);//exit;
        //echo $encode = '<img src="data:image/jpg/png/gif;base64,' . $base64 .'" >';
        //echo $encode = '<img src=" '.$img_file.' " >';exit;
        //$img_file='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532086150922&di=e8ad99200feee2b17d02106d19e8b2e9&imgtype=0&src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170717%2Fa750210a4d8c49b3967b2e5d8b69f961.png';
        //$params['image'] = $this->imgToBase64($img_file);
        //$params['image'] = $this->base64EncodeImage($img_file);
        $data = file_get_contents($img_file);
        //var_dump($data);exit;
        $base64 = base64_encode($data);
        //$base64 = base64_encode($img_file);
        $params['image'] = $base64;
        //var_dump($data);

        $params['sign'] = $this->getReqSign($params, $appkey);
        //var_dump($params);exit;

        // 执行API调用
        $url = 'https://api.ai.qq.com/fcgi-bin/face/face_faceidentify';
        $url = 'https://api.ai.qq.com/fcgi-bin/face/face_detectface';
        $response =  $this->doHttpPost($url, $params);
        echo $response;die();
        $api_data = json_decode($response,true);

        if($api_data['ret']==0)
        {
            $return_data['code'] = 200;
            $return_data['message'] = '腾讯AI接口调用成功！';
        }
        else
        {
            $return_data['code'] = $api_data['ret'];
            $return_data['message'] = $api_data['msg'];
        }
        $return_data['data'] = $api_data['data'];
        echo json_encode($return_data);exit;

    }

    /**
     * @Author: sunew
     * @Date: 2018-7-21
     * @Description: 腾讯AI 接口主入口
     */
    public function pic_api()
    {
        $request_data = $_REQUEST;
        $files_data = $_FILES;

        $type_id = $request_data['type_id']?$request_data['type_id']:1; //类型
        $sid = $request_data['sid'];

        //图片下载到服务器，并信息入库
        $files_result = $this->pic_upload($sid,$type_id,$files_data);
        if($files_result['code']!=200)
        {
            $return_data['code'] = $files_result['code'];
            $return_data['message'] = $files_result['message'];
            echo json_encode($return_data);exit;
        }
        $files_size = $files_result['data']['size']; //图片大小
        $pic_url = $files_result['data']['pic_url']; //图片

        if( $type_id == 1 )
        {
            //返回批次
            $batch_number = time();
            //人脸检测与分析
            $ai_result = $this->face_detection(PHPCMS_PATH.$files_result['data']['pic_url']);
            if(!empty($ai_result['data']))
            {
                $ai_result['data']['batch_number'] = $batch_number;
                $ai_result['data']['pic_url'] = $pic_url;
            }

        }
        elseif( $type_id == 3 )
        {
            //TODO 参数接收
            $decoration = $request_data['decoration']?$request_data['decoration']:1;
            //魔法变脸(人脸化妆)
            $ai_result = $this->ptu_facedecoration(PHPCMS_PATH.$files_result['data']['pic_url'],$sid,$decoration,$type_id,time());

        }
        elseif( $type_id == 4 )
        {
            //TODO 参数接收
            $cosmetic = $request_data['cosmetic']?$request_data['cosmetic']:1;
            //一键 ps(人脸美妆)
            $ai_result = $this->ptu_facecosmetic(PHPCMS_PATH.$files_result['data']['pic_url'],$sid,$cosmetic,$type_id,time());

        }

        if($ai_result['code']!=200)
        {
            $pic_id = $files_result['data']['pic_id'];
            $wxuser_face_tabl = $this->wxuser_face_tabl;
            $wxuser_face_tabl->update(array('is_valid'=>2), $where = "id=$pic_id");
        }
        echo json_encode($ai_result);exit;
        //$return_data['code'] = 200;
        //$return_data['message'] = 'ok';
        //$return_data['data'] = array('request'=>$request_data,'file'=>$files_data);
        //echo json_encode($return_data);exit;
    }

    /**
     * @Author: sunew
     * @Date: 2017-11-9
     * @Description: 人脸检测
     */
    public function face_detection($img_file,$mode=0)
    {
        //$mysite = siteinfo(1); //站点获取

        //var_dump($img_file);exit;
        // 设置请求数据（应用密钥、接口请求参数）
        $appkey = $this->appkey;
        $params = $this->params;

        $params['mode'] = $mode;
        $params['time_stamp'] = time();
        $params['nonce_str'] = substr(md5(rand()), 0, 8);

        //$img_file='http://www.yanmiban.com/img/01.jpg'; //本地

        $data = file_get_contents($img_file);
        $base64 = base64_encode($data);
        $params['image'] = $base64;

        $params['sign'] = $this->getReqSign($params, $appkey);

        // 执行API调用
        $url = 'https://api.ai.qq.com/fcgi-bin/face/face_detectface';
        $response =  $this->doHttpPost($url, $params);
        $api_data = json_decode($response,true);
        //var_dump($api_data);exit;

        if($api_data['ret']==0)
        {
            $return_data['code'] = 200;
            $return_data['message'] = '腾讯AI接口调用成功！';
        }
        else
        {
            $return_data['code'] = $api_data['ret'];
            $return_data['message'] = $api_data['msg'];
        }
        $return_data['data'] = $api_data['data'];

        return $return_data;
    }

    /**
     * @Author: sunew
     * @Date: 2018-7-23
     * @Description: 人脸 美妆AI 接口
     */
    public function ptu_facecosmetic($img_file,$sid,$cosmetic=1,$type_id=4,$batch_number=0)
    {
        $appkey = $this->appkey;
        $params = $this->params;

        $params['cosmetic'] = $cosmetic;  //美妆编码
        $params['time_stamp'] = time();
        $params['nonce_str'] = substr(md5(rand()), 0, 8);

        //$img_file='http://www.yanmiban.com/img/01.jpg'; //本地

        $data = file_get_contents($img_file);
        $base64 = base64_encode($data);
        $params['image'] = $base64;

        $params['sign'] = $this->getReqSign($params, $appkey);

        // 执行API调用
        $url = 'https://api.ai.qq.com/fcgi-bin/ptu/ptu_facecosmetic';

        $response =  $this->doHttpPost($url, $params);
        $api_data = json_decode($response,true);
        //var_dump($api_data);exit;

        if($api_data['ret']==0)
        {
            $image_src = "data:image/jpg/png/gif;base64,' . {$api_data['data']['image']} .'";
            //$encode = '<img src="' . $image_src .'" >';
            $return_data['data'] = $api_data['data'];
            $return_data['data']['img_src'] = $image_src;
            $return_data['code'] = 200;
            $return_data['message'] = '腾讯AI接口调用成功！';

            //TODO 接口图片保存
            $member_cache = getcache($sid);  //缓存 获取 微信用户数据
            $add_result = $this->add_wxuser_face_data($member_cache['mid'],$type_id,$image_src,2, $batch_number);

        }
        else
        {
            $return_data['code'] = $api_data['ret'];
            $return_data['message'] = $api_data['msg'];
            $return_data['data'] = $api_data['data'];
        }

        //var_dump($return_data);exit;

        return $return_data;
    }

    /**
     * @Author: sunew
     * @Date: 2018-7-23
     * @Description: 腾讯AI接口 人脸变妆
     * @return mixed
     */
    public function ptu_facedecoration($img_file,$sid,$decoration=1,$type_id=3,$batch_number=0)
    {
        // 设置请求数据
        $appkey = $this->appkey;
        $params = $this->params;

        $params['decoration'] = $decoration; //变妆编码
        $params['time_stamp'] = time();
        $params['nonce_str'] = substr(md5(rand()), 0, 8);

        //$img_file='http://www.yanmiban.com/img/03.jpg'; //本地

        $data = file_get_contents($img_file);
        $base64 = base64_encode($data);
        $params['image'] = $base64;
        //var_dump($params);exit;
        $params['sign'] = $this->getReqSign($params, $appkey);

        // 执行API调用
        $url = 'https://api.ai.qq.com/fcgi-bin/ptu/ptu_facedecoration';
        $response = $this->doHttpPost($url, $params);
        //echo $response;exit;

        $api_data = json_decode($response,true);
        //echo $encode = '<img src="data:image/jpg/png/gif;base64,' . $api_data['data']['image'] .'" >';exit; //图片输出预览
        //var_dump($api_data);exit;

        if($api_data['ret']==0)
        {
            $image_src = "data:image/jpg/png/gif;base64,' . {$api_data['data']['image']} .'";
            //$encode = '<img src="' . $image_src .'" >';
            $return_data['data'] = $api_data['data'];
            $return_data['data']['img_src'] = $image_src;
            $return_data['code'] = 200;
            $return_data['message'] = '腾讯AI接口调用成功！';

            //TODO 接口图片保存
            $member_cache = getcache($sid);  //缓存 获取 微信用户数据
            $add_result = $this->add_wxuser_face_data($member_cache['mid'],$type_id,$image_src,2,$batch_number);

        }
        else
        {
            $return_data['code'] = $api_data['ret'];
            $return_data['message'] = $api_data['msg'];
            $return_data['data'] = $api_data['data'];
        }

        //var_dump($return_data);exit;

        return $return_data;


    }

    public function pic_upload($sid,$type_id,$files)
    {
        //$mysite = siteinfo(1); //站点获取
        //$imgname = $files['file']['name'];
        if(empty($sid) || empty($type_id) ||empty($files) )
        {
            $return_data['code'] = 4001;
            $return_data['message'] = L('微信用户上传图片保存,参数错误,请检查！');
            $return_data['data'] = array('pic_url'=>'');
            return $return_data;
        }

        $member_cache = getcache($sid);  //缓存 获取 微信用户数据
        if(empty($member_cache))
        {
            $return_data['code'] = 4002;
            $return_data['message'] = L('微信端请重新登录小程序授权！');
            return $return_data;
        }

        if(empty($member_cache['openid']) || empty($member_cache['mid']) )
        {
            $return_data['code'] = 4003;
            $return_data['message'] = L('微信用户数据数据异常,请重新授权小程序！');
            return $return_data;
        }

        $tmp = $files['file']['tmp_name'];

        $new_pic_name = date('YmdHis').'.jpg';
        //$filepath = $mysite['domain'].'img/'.date('Ymd').'/';
        $filepath = PHPCMS_PATH.'uploads/apps/'.date('Ymd').'/';

        if(!file_exists($filepath))
        {
            mkdir($filepath,0777,true);
        }

        if(move_uploaded_file($tmp,$filepath.$new_pic_name))
        {
            //echo "上传成功";
            //var_dump($filepath.$new_pic_name);
            $file_size = filesize($filepath.$new_pic_name);
            if($file_size >= 1024*1024)
            {
                //大于1M 压缩处理
                $this->image_png_size_add($filepath.$new_pic_name,$filepath.$new_pic_name);
            }

            //图片信息入库
            $add_result = $this->add_wxuser_face_data($member_cache['mid'],$type_id,'uploads/apps/'.date('Ymd').'/'.$new_pic_name);
            if($add_result['code']!=200)
            {
                $return_data['code'] = $add_result['code'];
                $return_data['message'] = $add_result['message'];
                $return_data['data'] = array('pic_url'=>'','size'=>$file_size);

                unlink($filepath);
            }
            else
            {
                $return_data['code'] = 200;
                $return_data['message'] = L('微信用户上传图片保存成功');
                $return_data['data'] = array('pic_url'=>'uploads/apps/'.date('Ymd').'/'.$new_pic_name,'size'=>$file_size);
            }
        }
        else
        {
            //echo "上传失败";
            //var_dump('error');
            $return_data['code'] = 4005;
            $return_data['message'] = L('微信用户上传图片保存失败,请检查！');
            $return_data['data'] = array('pic_url'=>'');
        }
        return $return_data;
    }

    /**
     * @Author: sunew
     * @Date: 2018-7-24
     * @Description: 前端 上图图片接口
     * @return mixed
     */
    public function pic_upload_api()
    {
        $request_data = $_REQUEST;
        $files = $_FILES;

        $type_id = $request_data['type_id']?$request_data['type_id']:1; //类型
        $sid = $request_data['sid'];//第三方sessionID
        $batch_number = $request_data['batch_number']; //批次

        //$mysite = siteinfo(1); //站点获取
        //$imgname = $files['file']['name'];
        if(empty($sid) || empty($type_id) ||empty($files) || empty($batch_number))
        {
            $return_data['code'] = 4001;
            $return_data['message'] = L('微信用户上传图片保存,参数错误,请检查！');
            $return_data['data'] = array('pic_url'=>'');
            return $return_data;
        }

        $member_cache = getcache($sid);  //缓存 获取 微信用户数据
        if(empty($member_cache))
        {
            $return_data['code'] = 4002;
            $return_data['message'] = L('微信端请重新登录小程序授权！');
            return $return_data;
        }

        if(empty($member_cache['openid']) || empty($member_cache['mid']) )
        {
            $return_data['code'] = 4003;
            $return_data['message'] = L('微信用户数据数据异常,请重新授权小程序！');
            return $return_data;
        }

        $file_size =  $files['file']['size']; //文件大小
        if($file_size >= 1024*1024*5 ) //大于5M
        {
            $return_data['code'] = 4004;
            $return_data['message'] = L('图片大小超过5M,请重新上传！');
            return $return_data;
        }

        $tmp = $files['file']['tmp_name'];

        $new_pic_name = date('YmdHis').'.jpg';
        //$filepath = $mysite['domain'].'img/'.date('Ymd').'/';
        $filepath = PHPCMS_PATH.'uploads/apps/'.date('Ymd').'/';

        if(!file_exists($filepath))
        {
            mkdir($filepath,0777,true);
        }

        if(move_uploaded_file($tmp,$filepath.$new_pic_name))
        {
            //echo "上传成功";
            //var_dump($filepath.$new_pic_name);
            $file_size = filesize($filepath.$new_pic_name);
            if($file_size >= 1024*1024)
            {
                //大于1M 压缩处理
                $this->image_png_size_add($filepath.$new_pic_name,$filepath.$new_pic_name);
            }

            //图片信息入库
            $add_result = $this->add_wxuser_face_data($member_cache['mid'],$type_id,'uploads/apps/'.date('Ymd').'/'.$new_pic_name, 2, $batch_number);
            if($add_result['code']!=200)
            {
                $return_data['code'] = $add_result['code'];
                $return_data['message'] = $add_result['message'];
                //$return_data['data'] = array('pic_url'=>'');
                $return_data['data']['pic_url']='';
                $return_data['data']['size']=$file_size;

                unlink($filepath);
            }
            else
            {
                $return_data['code'] = 200;
                $return_data['message'] = L('微信用户上传图片保存成功');
                $return_data['data']['pic_url']='uploads/apps/'.date('Ymd').'/'.$new_pic_name;
                $return_data['data']['size']=$file_size;
                $return_data['data']['pic_id']=$add_result['data']['id'];
            }
        }
        else
        {
            //echo "上传失败";
            //var_dump('error');
            $return_data['code'] = 4005;
            $return_data['message'] = L('微信用户上传图片保存失败,请检查！');
            $return_data['data']['pic_url']='';
            //$return_data['data']['size']=$file_size;
/*            $return_data['data']['request']=$request_data;
            $return_data['data']['file']=$files;
            $return_data['data']['member']=$member_cache;
            $return_data['data']['test_pic']=$filepath.$new_pic_name;
            $return_data['data']['tmp']=$tmp;*/
            //$return_data['data'] = array('pic_url'=>'');
        }
        //return $return_data;
        /*$return_data['code'] = 200;
        $return_data['message'] = 'ok';
        $return_data['data'] = array('request'=>$request_data,'file'=>$files);*/
        echo json_encode($return_data);exit;
    }

    // 微信用户 AI图片上传入库
    public function add_wxuser_face_data($user_id,$type_id,$pic_url,$is_user=1,$batch_number=0,$add_data=array())
    {
        if(empty($user_id) || empty($type_id) || empty($pic_url) )
        {
            $return_data['code'] = 4001;
            $return_data['message'] = L('微信用户上传图片数据不合法,请检查');
            $return_data['data'] = array('id'=>0);
            return $return_data;
        }

        //批次
        if(empty($batch_number))
        {
            $batch_number = time();
        }

        //user_id的判断 是用户ID 或 第三方 sessionId
        if(is_numeric($user_id))
        {
            $add_data['user_id'] = $user_id;
        }
        else
        {
            //第三方 sessionId
            $member_cache = getcache($user_id);  //缓存 获取 微信用户数据
            if(empty($member_cache))
            {
                $return_data['code'] = 4002;
                $return_data['message'] = L('微信端请重新登录小程序授权！');
                return $return_data;
            }

            if(empty($member_cache['openid']) || empty($member_cache['mid']) )
            {
                $return_data['code'] = 4003;
                $return_data['message'] = L('微信用户数据数据异常,请重新授权小程序！');
                return $return_data;
            }

            $add_data['user_id'] = $member_cache['mid'];

        }

        $add_data['type_id'] = $type_id;
        $add_data['is_user'] = $is_user; //是否用户上传
        $add_data['batch_num'] = $batch_number;//图片批次
        $add_data['pic_url'] = serialize($pic_url);
        $add_data['size'] = filesize(PHPCMS_PATH.$pic_url);
        //$add_data['size'] = $this->getsize(filesize(PHPCMS_PATH.$pic_url),'kb');
        $add_data['add_time'] = time();
        /*var_dump(filesize(PHPCMS_PATH.$pic_url));
        var_dump($this->getsize(filesize(PHPCMS_PATH.$pic_url),'kb'));exit;*/

        $this->wxuser_face_tabl->insert($add_data);
        if($this->wxuser_face_tabl->insert_id())
        {
            $return_data['code'] = 200;
            $return_data['message'] = L('微信用户上传图片入库成功');
            $return_data['data'] = array('id'=>$this->wxuser_face_tabl->insert_id());
        }
        else
        {
            $return_data['code'] = 4005;
            $return_data['message'] = L('微信用户上传图片入库失败');
            $return_data['data'] = array('id'=>0);
        }
        return $return_data;
    }

    // getReqSign ：根据 接口请求参数 和 应用密钥 计算 请求签名
    // 参数说明
    //   - $params：接口请求参数（特别注意：不同的接口，参数对一般不一样，请以具体接口要求为准） /* 关联数组 */
    //   - $appkey：应用密钥  /* 字符串*/
    // 返回数据
    //   - 签名结果
    private function getReqSign($params, $appkey)
    {
        // 1. 字典升序排序
        ksort($params);

        // 2. 拼按URL键值对
        $str = '';
        foreach ($params as $key => $value)
        {
            if ($value !== '')
            {
                $str .= $key . '=' . urlencode($value) . '&';
            }
        }

        // 3. 拼接app_key
        $str .= 'app_key=' . $appkey;

        // 4. MD5运算+转换大写，得到请求签名
        $sign = strtoupper(md5($str));
        return $sign;
    }

    // doHttpPost ：执行POST请求，并取回响应结果
    // 参数说明
    //   - $url   ：接口请求地址
    //   - $params：完整接口请求参数（特别注意：不同的接口，参数对一般不一样，请以具体接口要求为准）
    // 返回数据
    //   - 返回false表示失败，否则表示API成功返回的HTTP BODY部分
    private function doHttpPost($url, $params)
    {
        $curl = curl_init();

        $response = false;
        do
        {
            // 1. 设置HTTP URL (API地址)
            curl_setopt($curl, CURLOPT_URL, $url);

            // 2. 设置HTTP HEADER (表单POST)
            $head = array(
                'Content-Type: application/x-www-form-urlencoded'
            );
            curl_setopt($curl, CURLOPT_HTTPHEADER, $head);

            // 3. 设置HTTP BODY (URL键值对)
            $body = http_build_query($params);
            curl_setopt($curl, CURLOPT_POST, true);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $body);

            // 4. 调用API，获取响应结果
            curl_setopt($curl, CURLOPT_HEADER, false);
            curl_setopt($curl, CURLOPT_NOBODY, false);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, true);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
            $response = curl_exec($curl);
            if ($response === false)
            {
                $response = false;
                break;
            }

            $code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
            if ($code != 200)
            {
                $response = false;
                break;
            }
        } while (0);

        curl_close($curl);
        return $response;
    }

    public function del_pic()
    {
        $post_data = $_POST;
        if(empty($post_data))
        {
            $return_data['code'] = 4005;
            $return_data['message'] = '参数错误,请检查数据格式！';
            echo json_encode($return_data);exit;
        }
        $id = $post_data['id']?$post_data['id']:0;
        $type = $post_data['type']?$post_data['type']:1;

        if(is_array($id))
        {
            $id = array(200,300);
            $id_str = implode(',',$id);
            //var_dump($id_str);exit;
            $wxuser_face_tabl = $this->wxuser_face_tabl;
            $list = $wxuser_face_tabl->select($where = "id in($id_str)");
            foreach($list as $k=>$v)
            {
                $del_pic_list[]= array('id'=>$v['id'],'pic_url'=>'/'.unserialize($v['pic_url']));
            }
            if(empty($list))
            {
                $return_data['code'] = 4001;
                $return_data['message'] = '无效图片集合！';
            }
            else
            {
                $wxuser_face_tabl->update(array('is_del'=>1), $where = "id in($id_str)");
                $return_data['code'] = 200;
                $return_data['message'] = '图片删除成功！';
            }

        }
        else
        {
            $wxuser_face_tabl = $this->wxuser_face_tabl;
            $face_data = $wxuser_face_tabl->get_one($where = "id=$id");
            $del_pic_list[]= array('id'=>$face_data['id'],'pic_url'=>'/'.unserialize($face_data['pic_url']));
            if(empty($face_data))
            {
                $return_data['code'] = 4010;
                $return_data['message'] = '无效图片！';
            }
            else
            {
                $wxuser_face_tabl->update(array('is_del'=>1), $where = "id=$id");
                $return_data['code'] = 200;
                $return_data['message'] = '图片删除成功！';
            }
        }

        //物理删除
        if($type==2)
        {
            if($del_pic_list)
            {
                $wxuser_face_tabl = $this->wxuser_face_tabl;
                foreach($del_pic_list as $d_v)
                {
                    unlink($d_v['pic_url']); //执行物理删除
                    $wxuser_face_tabl->delete($where = "id={$d_v['id']}");//数据库删除
                }
            }
        }
        echo json_encode($return_data);exit;
    }

    //生成16位随机字符串
    private function createNonceStr($length = 16)
    {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        $str = "";
        for ($i = 0; $i < $length; $i++) {
            $str .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
        }
        return $str;
    }

    //* 获取图片的Base64编码
    public function base64EncodeImage ($image_file)
    {
        /*$base64_image = '';
        $image_info = getimagesize($image_file);
        $image_data = fread(fopen($image_file, 'r'), filesize($image_file));
        $base64_image = 'data:' . $image_info['mime'] . ';base64,' . chunk_split(base64_encode($image_data));
        return $base64_image;*/
        if(file_exists($image_file) || is_file($image_file)){
            $base64_image = '';
            $image_info = getimagesize($image_file);
            $image_data = fread(fopen($image_file, 'r'), filesize($image_file));
            $base64_image = 'data:' . $image_info['mime'] . ';base64,' . chunk_split(base64_encode($image_data));
            return $base64_image;
        }
        else{
            return '';
        }
        //输出
        //$encode = '<img src="data:image/jpg/png/gif;base64,' . $base64 .'" >';
    }

    /**
     * 获取图片的Base64编码(不支持url)
     * @param $img_file 传入本地图片地址
     * @return string
     */
    public function imgToBase64($img_file)
    {
         $img_base64 = '';
         if (file_exists($img_file))
         {
             $app_img_file = $img_file; // 图片路径
             $img_info = getimagesize($app_img_file); // 取得图片的大小，类型等

             //echo '<pre>' . print_r($img_info, true) . '</pre><br>';
             $fp = fopen($app_img_file, "r"); // 图片是否可读权限

             if ($fp) {
                           $filesize = filesize($app_img_file);
                 $content = fread($fp, $filesize);
                 $file_content = chunk_split(base64_encode($content)); // base64编码
                 switch ($img_info[2])
                 {   //判读图片类型
                     case 1: $img_type = "gif";
                           break;
                     case 2: $img_type = "jpg";
                           break;
                     case 3: $img_type = "png";
                           break;
                 }

                 $img_base64 = 'data:image/' . $img_type . ';base64,' . $file_content;//合成图片的base64编码

             }
             fclose($fp);
         }

         return $img_base64; //返回图片的base64
    }

    /**
     * 获取站点配置信息
     * @param  $siteid 站点id
     */
    function get_site_setting($siteid) {
        $siteinfo = getcache('sitelist', 'commons');
        return string2array($siteinfo[$siteid]['setting']);
    }

    /**
     * desription 压缩图片
     * @param sting $imgsrc 图片路径
     * @param string $imgdst 压缩后保存路径
     */
    function image_png_size_add($imgsrc,$imgdst)
    {
        ini_set('memory_limit','512M'); //升级为申请256M内存
        set_time_limit(0);   // 设置脚本最大执行时间 为0 永不过期

        list($width,$height,$type)=getimagesize($imgsrc);
        /* var_dump(getimagesize($imgsrc));//exit;
         var_dump($width,$height,$type);*/
        //exit();
        /* $new_width = ($width>1024?1024:$width)*0.9;
         $new_height =($height>819?819:$height)*0.9;   */
        $new_width = ceil($width*0.5);
        $new_height = ceil($height*0.5);
        //var_dump($new_width,$new_height,$type);
        //exit();
        switch($type){
            case 1:
                $giftype=$this->check_gifcartoon($imgsrc);
                if($giftype){
                    header('Content-Type:image/gif');
                    $image_wp=imagecreatetruecolor($new_width, $new_height);
                    $image = imagecreatefromgif($imgsrc);
                    imagecopyresampled($image_wp, $image, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
                    imagejpeg($image_wp, $imgdst,75);
                    imagedestroy($image_wp);
                }
                break;
            case 2:
                header('Content-Type:image/jpeg');
                $image_wp=imagecreatetruecolor($new_width, $new_height);
                $image = imagecreatefromjpeg($imgsrc);
                imagecopyresampled($image_wp, $image, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
                imagejpeg($image_wp, $imgdst,100);
                imagedestroy($image_wp);
                break;
            case 3:
                header('Content-Type:image/png');
                $image_wp=imagecreatetruecolor($new_width, $new_height);
                $image = imagecreatefrompng($imgsrc);
                imagecopyresampled($image_wp, $image, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
                imagejpeg($image_wp, $imgdst,100);
                imagedestroy($image_wp);
                break;
        }
    }
    /**
     * desription 判断是否gif动画
     * @param sting $image_file图片路径
     * @return boolean t 是 f 否
     */
    function check_gifcartoon($image_file)
    {
        $fp = fopen($image_file,'rb');
        $image_head = fread($fp,1024);
        fclose($fp);
        return preg_match("/".chr(0x21).chr(0xff).chr(0x0b).'NETSCAPE2.0'."/",$image_head)?false:true;
    }

    private function getsize($size, $format)
    {
        $p = 0;
        if ($format == 'kb') {
            $p = 1;
        } elseif ($format == 'mb') {
            $p = 2;
        } elseif ($format == 'gb') {
            $p = 3;
        }
        $size /= pow(1024, $p);
        return number_format($size, 3);
    }


}