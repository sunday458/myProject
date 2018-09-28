<?php
/**
 * Created by PhpStorm.
 * User: sunew
 * Date: 2018/7/21
 * Time: 15:30
 * 百度Ai 控制器
 */

defined('IN_PHPCMS') or exit('No permission resources.');
class baidu_ai
{
    private $wxuser_face_tabl;

    /**
     * @ 百度AI 接口有v2 v3版本，需要确认版本
     */
    //默认配置
    protected $params = [
        'client_id'     => 'tAksaRqbNFq5w46Ps99h3sl4',  //API Key
        'client_secret' => 'yY2V5LXiiHK7nTfLt0BHEOGfTPLY3skY', //Secret Key
        'grant_type'  => 'client_credentials', //默认固定值
    ];

    public function __construct()
    {
        //parent::__construct();
        $this->wxuser_face_tabl = pc_base::load_model('wxuser_face_model');
    }

    public function test()
    {
        //echo PHPCMS_PATH; //phpcms 目录
        //$mysite = siteinfo(1); //站点获取

        $access_token = $this->get_access_token(); //调用鉴权接口获取的token
        //var_dump($access_token);exit;

        $img='http://www.yanmiban.com/img/01.jpg'; //本地
        $img='D:/04.jpg'; //本地

        $image = file_get_contents($img);
        $base64 = base64_encode($image);

        // 执行API调用
        $url = 'https://aip.baidubce.com/rest/2.0/face/v3/search?access_token=' . $access_token;
        $url = 'https://aip.baidubce.com/rest/2.0/face/v3/detect?access_token=' . $access_token;
        //$url = 'https://aip.baidubce.com/rest/2.0/face/v2/detect?access_token=' . $access_token;

        //$bodys = "{\"image\":\"027d8308a2ec665acb1bdf63e513bcb9\",\"image_type\":\"FACE_TOKEN\",\"group_id_list\":\"group_repeat,group_233\",\"quality_control\":\"LOW\",\"liveness_control\":\"NORMAL\"}";

        $bodys = array(
            'image' => $base64,
            //'image_type' => "FACE_TOKEN",
            'image_type' => "BASE64",
            //'group_id_list' => "group_repeat,group_233",
            //'quality_control' => 'LOW',
            //'liveness_control' => 'NORMAL',
        );

        $bodys = json_encode($bodys); //V3版本 post参数 json化

        $res = $this->request_post($url, $bodys);
        //var_dump($res);exit;

        $api_data = json_decode($res,true);
        //var_dump($api_data);exit;

        if($api_data['error_code']==0)
        {
            $return_data['code'] = 200;
            $return_data['message'] = '百度AI接口调用成功！';
        }
        else
        {
            $return_data['code'] = $api_data['error_code'];
            $return_data['message'] = $api_data['error_msg'];
        }
        $return_data['data'] = $api_data['result']?$api_data['result']:array();
        echo json_encode($return_data);exit;

    }

    /**
     * @Author: sunew
     * @Date: 2018-7-21
     * @Description: 获取百度接口AI access_token
     * @param int $is_all 1返回全数据 0只返回access_token
     * @return mixed
     */
    private function get_access_token($is_all=0)
    {
        $post_data = $this->params;
        // 执行API调用
        $url = 'https://aip.baidubce.com/oauth/2.0/token';

        $o = "";
        foreach ( $post_data as $k => $v )
        {
            $o.= "$k=" . urlencode( $v ). "&" ;
        }
        $post_data = substr($o,0,-1);

        $res = $this->request_post($url, $post_data);

        $access_token_data = json_decode($res,true);
        if($is_all)
        {
            $access_token = $access_token_data;
        }
        else
        {
            $access_token = $access_token_data['access_token'];
        }
        return $access_token;
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

        if($type_id == 2 )
        {
            $group_id_list = $request_data['group_id_list']?$request_data['group_id_list']:'group_repeat,group_233'; //图片库
            $max_user_num = $request_data['max_user_num']?$request_data['max_user_num']:4;//返回图片数
            //明星脸( 人脸搜索)
            $ai_result = $this->face_search(PHPCMS_PATH.$files_result['data']['pic_url'],$group_id_list,$max_user_num);
            echo json_encode($ai_result);exit;

        }

        //$return_data['code'] = 200;
        //$return_data['message'] = 'ok';
        //$return_data['data'] = array('request'=>$request_data,'file'=>$files_data);
        //echo json_encode($return_data);exit;
    }

    /**
     * @Author: sunew
     * @Date: 2018-7-24
     * @Description: 百度AI 人脸搜索接口
     */
    public function face_search($img='',$group_id_list="group_repeat,group_233",$max_user_num=4)
    {
        $access_token = $this->get_access_token(); //调用鉴权接口获取的token
        //var_dump($access_token);exit;

        $img='http://www.yanmiban.com/img/01.jpg'; //本地

        $image = file_get_contents($img);
        $base64 = base64_encode($image);
        // 执行API调用
        $bodys = array(
            'image' => $base64, //必填
            'image_type' => "BASE64", //必填 BASE64:图片的base64值，base64编码后的图片数据，编码后的图片大小不超过2M；URL:图片的 URL地址( 可能由于网络等原因导致下载图片时间过长)；FACE_TOKEN: 人脸图片的唯一标识，调用人脸检测接口时，会为每个人脸图片赋予一个唯一的FACE_TOKEN，同一张图片多次检测得到的FACE_TOKEN是同一个。
            'group_id_list' => $group_id_list, //必填 从指定的group中进行查找用逗号分隔，上限20个
            'quality_control' => 'NORMAL', //否 图片质量控制NONE: 不进行控制LOW:较低的质量要求NORMAL: 一般的质量要求HIGH: 较高的质量要求默认 NONE 若图片质量不满足要求，则返回结果中会提示质量检测失败
            'liveness_control' => 'NORMAL', //否 NONE: 不进行控制LOW:较低的活体要求(高通过率 低攻击拒绝率)NORMAL: 一般的活体要求(平衡的攻击拒绝率, 通过率)HIGH: 较高的活体要求(高攻击拒绝率 低通过率)默认NONE
            'max_user_num' => $max_user_num, //否 查找后返回的用户数量。返回相似度最高的几个用户，默认为1，最多返回20个
        );

        $bodys = json_encode($bodys); //V3版本 post参数 json化
        $url = 'https://aip.baidubce.com/rest/2.0/face/v3/search?access_token=' . $access_token;
        //$bodys = "{\"image\":\"027d8308a2ec665acb1bdf63e513bcb9\",\"image_type\":\"FACE_TOKEN\",\"group_id_list\":\"group_repeat,group_233\",\"quality_control\":\"LOW\",\"liveness_control\":\"NORMAL\"}";
        $res = $this->request_post($url, $bodys);

        var_dump($res);exit;

        $api_data = json_decode($res,true);
        //var_dump($api_data);exit;

        if($api_data['error_code']==0)
        {
            $return_data['code'] = 200;
            $return_data['message'] = '百度AI接口调用成功！';
        }
        else
        {
            $return_data['code'] = $api_data['error_code'];
            $return_data['message'] = $api_data['error_msg'];
        }
        $return_data['data'] = $api_data['result']?$api_data['result']:array();
        echo json_encode($return_data);exit;

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
            //批号
            $batch_number = 1;

            //图片信息入库
            $add_result = $this->add_wxuser_face_data($member_cache['mid'],$type_id,'uploads/apps/'.date('Ymd').'/'.$new_pic_name);
            if($add_result['code']!=200)
            {
                $return_data['code'] = $add_result['code'];
                $return_data['message'] = $add_result['message'];
                $return_data['data'] = array('pic_url'=>'');

                unlink($filepath);
            }
            else
            {
                $return_data['code'] = 200;
                $return_data['message'] = L('微信用户上传图片保存成功');
                $return_data['data'] = array('pic_url'=>'uploads/apps/'.date('Ymd').'/'.$new_pic_name);
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

    // 微信用户 AI图片上传入库
    public function add_wxuser_face_data($user_id,$type_id,$pic_url,$is_user=1,$batch_number=0)
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
        $add_data['add_time'] = time();

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


    private function request_post($url = '', $param = '')
    {
        if (empty($url) || empty($param)) {
            return false;
        }

        $postUrl = $url;
        $curlPost = $param;
        // 初始化curl
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $postUrl);
        curl_setopt($curl, CURLOPT_HEADER, 0);
        // 要求结果为字符串且输出到屏幕上
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        // post提交方式
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $curlPost);
        // 运行curl
        $data = curl_exec($curl);
        curl_close($curl);

        return $data;
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


}