<?php
/**
 * Created by PhpStorm.
 * User: sunew
 * Date: 2018/7/18
 * Time: 15:39
 * 微信小程序 控制器
 */
defined('IN_PHPCMS') or exit('No permission resources.');
class member_weixin_spro
{
    private $db;
    private $client;
    private $wxuser;
    //默认配置
    protected $config = [
        'url' => "https://api.weixin.qq.com/sns/jscode2session", //微信获取session_key接口url
        'appid' => 'wxeca7616dfc3caa84', // APPId
        'secret' => '4339a7376f863ed4676d2b5ed0db4e58', // 秘钥
        'grant_type' => 'authorization_code', // grant_type，一般情况下固定的
    ];

    public function __construct()
    {
        //parent::__construct();
        $this->db = pc_base::load_model('member_model');
        $this->wxuser = pc_base::load_model('wxuser_model');
    }

    /*public function init()
    {
        $myvar = 'hello world!';
        echo $myvar;
    }*/

    /*public function mylist()
    {
        $myvar = 'hello world!this is a example!';
        echo $myvar;
    }*/

    public function wx_login()
    {
        //开发者使用登陆凭证 code 获取 session_key 和 openid
        $APPID = $this->config['appid'];
        $AppSecret =  $this->config['secret'];

        $code = $_REQUEST['code'];

        $url="https://api.weixin.qq.com/sns/jscode2session?appid=".$APPID."&secret=".$AppSecret."&js_code=".$code."&grant_type=authorization_code";
        $arr = $this->get_url($url);  // 一个使用curl实现的get方法请求
        $arr = json_decode($arr,true);

        $openid = $arr['openid'];
        $session_key = $arr['session_key'];
        $unionid = $arr['unionid'];
        if(empty($openid))
        {
            $return_data['code'] = $arr['errcode'];
            $return_data['message'] = $arr['errmsg'];
            $data['error'] = $arr;
            $return_data['data'] = $data;
            echo json_encode($return_data);exit;
        }

        //测试数据
       /* $arr['openid'] = 'oLrsd0S6XItuWg-fEhfgnoWlVXpo';
        $openid = 'oLrsd0S6XItuWg-fEhfgnoWlVXpo';*/

        //微信用户数据入库
        $wx_result = $this->add_wxuser($arr);
        if($wx_result['code']!=200)
        {
            $return_data['code'] = $wx_result['code'];
            $return_data['message'] = $wx_result['message'];
            echo json_encode($return_data);exit;
        }

        //生成第三方3rd_session
        $session3rd  = null;
        $strPol = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
        $max = strlen($strPol)-1;
        for($i=0;$i<16;$i++)
        {
            $session3rd .=$strPol[rand(0,$max)];
        }

        //$member_cache = getcache($_REQUEST['sid']);
        $m_info = $this->get_member_data(0,$openid);
        if($m_info)
        {
            $return_data['code'] = 200;
            $return_data['message'] = '微信用户已注册为会员';
            $data['sid'] = $session3rd;
            //$data['test'] = $arr;
            $return_data['data'] = $data;
            setcache($session3rd, array('mid'=>$m_info['userid'],'openid'=>$openid,'session_key'=>$session_key));

            //更新用户登录信息
            $login_info_result = $this->update_login_info($session3rd);
            if($login_info_result['code']!=200)
            {
                $return_data['code'] = $login_info_result['code'];
                $return_data['message'] = $login_info_result['message'];
            }

            echo json_encode($return_data);exit;
        }

        //会员信息 入库：分别入库 Ucenter 和 PHPCMS 会员表
        $get_data = $this->db->get_one( 'userid >= 1', 'userid', 'userid desc');
        if($get_data['userid'])
        {
            $max_userid = $get_data['userid']?$get_data['userid']:1;
            $user_name = 'lyj_'.$max_userid.'_'.rand(100,999);
        }
        else
        {
            $max_userid = substr(md5(rand()), 0, 6);
            $user_name = 'lyj_'.$max_userid.'_'.rand(100,999);
        }

        $add_data = array(
            'username'=>$user_name,
            //'userid'=>4,
            'password'=>'lyj2018',
            //'password'=>$this->creat_password('lyj123456'),
            'email'=>'lyj_'.date('YmdHis').'@qq.com',
            'encrypt'=>substr(md5(rand()), 0, 6),
            'openid'=>$openid,
            'unionid'=>$unionid,
            'wxid'=>$wx_result['data']['wxid'],
        );

        //try
        //{
            $add_result = $this->add_member($add_data);
            if($add_result['code']!=200)
            {
                $return_data['code'] = $add_result['code'];
                $return_data['message'] = $add_result['message'];
            }
            else
            {
                $return_data['code'] = $add_result['code'];
                $return_data['message'] = $add_result['message'];
                $data['sid'] = $session3rd;
                //$data['mid'] = $add_result['data']['mid'];
                //$data['test_data'] = $arr;
                $return_data['data'] = $data;

                setcache($session3rd, array('mid'=>$add_result['data']['mid'],'openid'=>$openid,'session_key'=>$session_key));

                //更新用户登录信息
                $login_info_result = $this->update_login_info($session3rd);
                if($login_info_result['code']!=200)
                {
                    $return_data['code'] = $login_info_result['code'];
                    $return_data['message'] = $login_info_result['message'];
                }

            }
        /*}
        catch (Exception $e)
        {
            $error = $e->getMessage();
            $return_data['code'] = 4022;
            $return_data['message'] = '网络原因,异常数据,终止执行！';
            $data['error'] = $error;
            $return_data['data'] = $data;
            return false;
            exit();
        }*/
        echo json_encode($return_data);exit;

    }

    /**
     * @Author: sunew
     * @Date: 2018-7-18
     * @Description: 获取会员信息
     * @param $user_id
     * @param $openid
     * @return array
     */
    public function get_member_data($user_id,$openid='')
    {
        $member_model = $this->db;
        $where['userid'] = $user_id;
        if($openid)
        {
            unset($where);
            $where['openid'] = $openid;
        }
        $get_data = $member_model->get_one($where, $data = '*');
        return $get_data?$get_data:array();
    }

    /**
     * @Author: sunew
     * @Date: 2018-7-18
     * @Description: 添加会员
     */
    public function add_member($add_data=array())
    {
        $referer_url = HTTP_REFERER;
        /*$add_data = array(
            'username'=>'test_name'.rand(100,1000),
            //'userid'=>4,
            'password'=>'lyj123456',
            //'password'=>$this->creat_password('lyj123456'),
            'email'=>'test_data'.rand(100,1000).'@qq.com',
            'encrypt'=>substr(md5(rand()), 0, 6),
        );*/
        $info = $this->_checkuserinfo($add_data);
        if($info['code']!=200)
        {
            $return_data['code'] = $info['code'];
            $return_data['message'] = $info['message'];
            return $return_data;
        }

        $info = $info['data'];

        if(!$this->_checkname($add_data['username'])) //用户名校验
        {
            $return_data['code'] = 4005;
            $return_data['message'] = L('member_exist');
            return $return_data;
        }

        if(!$this->_checkpasswd($info['password'])) //密码校验6-20位
        {
            $return_data['code'] = 4006;
            $return_data['message'] = L('password_format_incorrect');
            return $return_data;
        }

        $info['regip'] = ip();
        $info['overduedate'] = $info['overduedate']?strtotime($info['overduedate']):time();

        //Ucenter 会员注册
        if(pc_base::load_config('system', 'phpsso'))
        {
            $this->_init_phpsso();
            $status = $this->client->ps_member_register($info['username'], $info['password'], $info['email'], $info['regip'],$info['encrypt']);
            if($status > 0)
            {
                unset($info[pwdconfirm]);
                $info['phpssouid'] = $status;
                //取phpsso密码随机数
                $memberinfo = $this->client->ps_get_member_info($status);
                $memberinfo = unserialize($memberinfo);
                $info['encrypt'] = $memberinfo['random'];
                $info['password'] = password($info['password'], $info['encrypt']);
                $info['regdate'] = $info['lastdate'] = SYS_TIME;

                //微信数据
                $info['mobile'] = '';
                $info['nickname'] = $info['username'];
                //$info['openid']  = 'openid'.rand(100,1000);
                $info['unionid'] = $info['unionid']?$info['unionid']:'';
                $info['sex'] = $info['sex']?$info['sex']:0;
                $info['province'] = $info['province']?$info['province']:'';
                $info['city'] = $info['city']?$info['city']:'';
                $info['country'] = $info['country']?$info['country']:'';
                $info['header_url'] = $info['avatarUrl']?$info['avatarUrl']:'img/01.jpg';

                $add_result = $this->db->insert($info);
                if($this->db->insert_id())
                {
                    $return_data['code'] = 200;
                    $return_data['message'] = L('operation_success');
                    $return_data['data'] = array('mid'=>$this->db->insert_id());
                    //var_dump($return_data);exit;
                    return $return_data;
                    //showmessage(L('operation_success'),'?m=member&c=member&a=add', '', 'add');
                }
            }
            elseif($status == -4)
            {
                $return_data['code'] = 4014;
                $return_data['message'] = L('username_deny');
            }
            elseif($status == -5)
            {
                $return_data['code'] =4015;
                $return_data['message'] = L('email_deny');
            }
            else
            {
                $return_data['code'] = 4016;
                $return_data['message'] = L('operation_failure');
            }

            return $return_data;
        }
        else
        {
            //showmessage(L('enable_register').L('enable_phpsso'), 'index.php?m=member&c=index&a=login');
            $return_data['code'] = 4009;
            $return_data['message'] = L('enable_phpsso');
            return $return_data;
        }
        exit;

    }

    public function update_member_info()
    {
        $get_data = $_REQUEST;
        $session3rd = $get_data['sid'];

        if(empty($session3rd) || empty($get_data) )
        {
            $return_data['code'] = 4001;
            $return_data['message'] = L('数据异常,请检查数据格式！');
            echo json_encode($return_data);exit;
        }

        $member_data = getcache($session3rd);

        if(empty($member_data))
        {
            $return_data['code'] = 4002;
            $return_data['message'] = L('微信端请重新登录小程序授权！');
            echo json_encode($return_data);exit;
        }

        if(empty($member_data['openid']))
        {
            $return_data['code'] = 4010;
            $return_data['message'] = L('微信用户数据数据异常,请重新授权小程序！');
            echo json_encode($return_data);exit;
        }

        $update_data = array(
            //'openid'=>$post_data['openid'],
            'avatar_url'=>$get_data['avatarUrl'],//头像
            'nickname'=>$get_data['nickName'],//昵称
            //'unionid'=>$post_data['unionid'],
            'province'=>$get_data['province'],
            'city'=>$get_data['city'],
            'country'=>$get_data['country'],
            'language'=>$get_data['language'],
            'gender'=>$get_data['gender'],
            'lately_time'=>time(),
            //'mobile'=>'',
        );
        $wxuser_model = $this->wxuser;
        $where['openid'] = $member_data['openid'];
        $update_result = $wxuser_model->update($update_data, $where);
        if($update_result!==false)
        {
            $return_data['code'] = 200;
            $return_data['message'] = L('会员微信信息完善成功！');
        }
        else
        {
            $return_data['code'] = 4010;
            $return_data['message'] = L('网络异常,会员微信信息完善失败！');
        }

        echo json_encode($return_data);exit;

    }

    /**
     * @Author: sunew
     * @Date: 2018-7-19
     * @Description: 微信用户数据入库
     * @param $wx_user_data
     * @return mixed
     */
    public function add_wxuser($wx_user_data)
    {
        $wxuser_model = $this->wxuser;
        $where['openid'] = $wx_user_data['openid'];
        $find_data = $wxuser_model->get_one($where, $data = '*', $order = '', $group = '');

        if(empty($wx_user_data['openid']))
        {
            $return_data['code'] = 4010;
            $return_data['message'] = L('微信用户数据数据异常！');
            $return_data['data'] = array('wxid'=>0);
            return $return_data;
        }

        if($find_data)
        {
            $return_data['code'] = 200;
            $return_data['message'] = L('微信用户数据已存在！');
            $return_data['data'] = array('wxid'=>$find_data['wxid']);
            return $return_data;
        }

        $add_data = array(
            'openid'=>$wx_user_data['openid'],
            'nickname'=>$wx_user_data['nickname'],
            'avatar_url'=>$wx_user_data['avatarUrl'],
            'city'=>$wx_user_data['city'],
            'country'=>$wx_user_data['country'],
            'province'=>$wx_user_data['province'],
            'gender'=>$wx_user_data['gender'],
            'unionid'=>$wx_user_data['unionid'],
            'language'=>$wx_user_data['language'],
            'add_time'=>time(),
        );

        $wxuser_model->insert($add_data);

        if($wxuser_model->insert_id())
        {
            $return_data['code'] = 200;
            $return_data['message'] = L('微信用户数据入库成功！');
            $return_data['data'] = array('wxid'=>$wxuser_model->insert_id());
        }
        else
        {
            $return_data['code'] = 4015;
            $return_data['message'] = L('微信用户数据入库失败！');
            $return_data['data'] = array('wxid'=>0);
        }
        return $return_data;
    }

    /**
     * @Author: sunew
     * @Date: 2018-7-20
     * @Description: 更新 用户登录信息
     */
    public function update_login_info($session3rd)
    {
        if(empty($session3rd) )
        {
            $return_data['code'] = 4001;
            $return_data['message'] = L('数据异常,请检查用户数据格式！！');
            return $return_data;
        }

        $member_data = getcache($session3rd);

        if(empty($member_data))
        {
            $return_data['code'] = 4002;
            $return_data['message'] = L('微信端请重新登录小程序授权！！');
            return $return_data;
        }

        if(empty($member_data['openid']))
        {
            $return_data['code'] = 4010;
            $return_data['message'] = L('微信用户数据数据异常,请重新授权小程序！！');
            return $return_data;
        }

        $find_data = $this->get_member_data($member_data['mid']);
        if(empty($find_data))
        {
            $return_data['code'] = 4003;
            $return_data['message'] = L('无效的微信用户数据！！');
            return $return_data;
        }

        /*$update_data['lastip'] = ip();
        $update_data['login_num'] = 'login_num+1';*/
        $update_data_str = " `lastip`='".ip()."',`login_num`=`login_num`+1 ";
        //更新phpcms  会员表登录数据
        $member_model = $this->db;
        $where['openid'] = $member_data['openid'];
        $member_update_result = $member_model->update($update_data_str, $where);

        unset($update_data);
        unset($where);
        //更新sso 用户登录数据
        $sso_member_model = pc_base::load_model('sso_members_model');
        $where['uid'] = $find_data['phpssouid'];
        $update_data['lastip'] = ip();
        $update_data['lastdate'] = time();
        $sso_update_result = $sso_member_model->update($update_data, $where);

        $return_data['code'] = 4015;
        $return_data['message'] = L('网络异常,微信用户登录数据更新失败！');
        if( ($member_update_result!==false) && ($sso_update_result!==false) )
        {
            $return_data['code'] = 200;
            $return_data['message'] = L('微信用户登录数据更新成功！！');
        }

        return $return_data;
    }

    /**
     * 发起http请求
     * @param string $url 访问路径
     * @param array $params 参数，该数组多于1个，表示为POST
     * @param int $expire 请求超时时间
     * @param array $extend 请求伪造包头参数
     * @param string $hostIp HOST的地址
     * @return array    返回的为一个请求状态，一个内容
     */
    public function makeRequest($url, $params = array(), $expire = 0, $extend = array(), $hostIp = '')
    {
        if (empty($url)) {
            return array('code' => '100');
        }

        $_curl = curl_init();
        $_header = array(
            'Accept-Language: zh-CN',
            'Connection: Keep-Alive',
            'Cache-Control: no-cache'
        );
        // 方便直接访问要设置host的地址
        if (!empty($hostIp)) {
            $urlInfo = parse_url($url);
            if (empty($urlInfo['host'])) {
                $urlInfo['host'] = substr(DOMAIN, 7, -1);
                $url = "http://{$hostIp}{$url}";
            } else {
                $url = str_replace($urlInfo['host'], $hostIp, $url);
            }
            $_header[] = "Host: {$urlInfo['host']}";
        }

        // 只要第二个参数传了值之后，就是POST的
        if (!empty($params)) {
            curl_setopt($_curl, CURLOPT_POSTFIELDS, http_build_query($params));
            curl_setopt($_curl, CURLOPT_POST, true);
        }

        if (substr($url, 0, 8) == 'https://') {
            curl_setopt($_curl, CURLOPT_SSL_VERIFYPEER, FALSE);
            curl_setopt($_curl, CURLOPT_SSL_VERIFYHOST, FALSE);
        }
        curl_setopt($_curl, CURLOPT_URL, $url);
        curl_setopt($_curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($_curl, CURLOPT_USERAGENT, 'API PHP CURL');
        curl_setopt($_curl, CURLOPT_HTTPHEADER, $_header);

        if ($expire > 0) {
            curl_setopt($_curl, CURLOPT_TIMEOUT, $expire); // 处理超时时间
            curl_setopt($_curl, CURLOPT_CONNECTTIMEOUT, $expire); // 建立连接超时时间
        }

        // 额外的配置
        if (!empty($extend)) {
            curl_setopt_array($_curl, $extend);
        }

        $result['result'] = curl_exec($_curl);
        $result['code'] = curl_getinfo($_curl, CURLINFO_HTTP_CODE);
        $result['info'] = curl_getinfo($_curl);
        if ($result['result'] === false) {
            $result['result'] = curl_error($_curl);
            $result['code'] = -curl_errno($_curl);
        }

        curl_close($_curl);
        return $result;
    }

    public function get_url($url)
    {
        $info=curl_init();
        curl_setopt($info,CURLOPT_RETURNTRANSFER,true);
        curl_setopt($info,CURLOPT_HEADER,0);
        curl_setopt($info,CURLOPT_NOBODY,0);
        curl_setopt($info,CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($info,CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($info,CURLOPT_URL,$url);
        $output= curl_exec($info);
        curl_close($info);
        return $output;
    }

    public function get_small_program_conf()
    {
        $site_model = pc_base::load_model('site_model');
        $where['siteid'] = 1;
        $get_data = $site_model->get_one($where = '', $data = '*', $order = '', $group = '');
        //var_dump($get_data);
        $small_program_str = $get_data['xiaochengxu']; //小程序配置信息
        return $this->array_encode($small_program_str);
    }

    /**
     * 初始化phpsso
     * about phpsso, include client and client configure
     * @return string phpsso_api_url phpsso地址
     */
    private function _init_phpsso() {
        pc_base::load_app_class('client', '', 0);
        define('APPID', pc_base::load_config('system', 'phpsso_appid'));
        $phpsso_api_url = pc_base::load_config('system', 'phpsso_api_url');
        $phpsso_auth_key = pc_base::load_config('system', 'phpsso_auth_key');
        $this->client = new client($phpsso_api_url, $phpsso_auth_key);
        return $phpsso_api_url;
    }

    //替代eval实现字符串转数组
    function array_encode($string)
    {
        //删除空格
        $string=str_replace(' ','',$string);
        //容错空数组
        if($string=='array()'){
            return array();
        }
        //数组格式容错
        if(substr($string,0,6)=='array('&&$string[strlen($string)-1]==')'){
            $Array=array();
            $array=substr($string,6,strlen($string)-7);
            //容错，不要分隔小数组中的逗号
            if(strpos($array,'array(')===0){
                $array=str_replace(",array",",#array",$array);
                $array=explode(',#',$array);
            }else{
                $array=explode(',',$array);
            }
            if(strpos($array[0],'array(')===0){
                //小数组
                foreach($array as $key => &$value){
                    $Array[]=array_encode($value);
                }
            }elseif(strpos($array[0],'=>')){
                //键值对数组
                foreach($array as $key => &$value){
                    //容错，不要分隔小数组中的键值符号
                    if(strpos($value,'array(')>0){
                        $value=str_replace("=>array","=>#array",$value);
                        $value=explode('=>#',$value);
                    }else{
                        $value=explode('=>',$value);
                    }
                    if(!(strpos($value[1],'\'')===0||strpos($value[1],'"')===0||strpos($value[1],'array')===0)){
                        if(strpos($value[1],'.')>0){
                            //双精度
                            $Array[preg_replace("/'|\"/","",$value[0])]=(double)$value[1];
                        }else{
                            //整形
                            $Array[preg_replace("/'|\"/","",$value[0])]=(int)$value[1];
                        }
                    }elseif(strpos($value[1],'array')===0){
                        //小数组
                        $Array[preg_replace("/'|\"/","",$value[0])]=array_encode($value[1]);
                    }else{
                        //字符串
                        $Array[preg_replace("/'|\"/","",$value[0])]=preg_replace("/'|\"/","",$value[1]);
                    }
                }
            }else{
                //索引数组
                foreach($array as $key =>&$value){
                    if(!(strpos($value,'\'')===0||strpos($value,'"')===0||strpos($value,'array')===0)){
                        if(strpos($value,'.')>0){
                            //双精度
                            $Array[]=(double)$value;
                        }else{
                            //整形
                            $Array[]=(int)$value;
                        }
                    }elseif(strpos($value,'array')===0){
                        //小数组
                        $Array[]=array_encode($value);
                    }else{
                        //字符串
                        $Array[]=preg_replace("/'|\"/","",$value);
                    }
                }
            }
            return $Array;
        }else{
            return false;
        }
    }

    private function _checkuserinfo($data, $is_edit=0) {
        $return_data = array('code'=>200,'message'=>'数据校验通过','data'=>$data);
        if(!is_array($data))
        {
            return $return_data =array('code'=>4001,'message'=>L('need_more_param'));
        }
        elseif (!is_username($data['username']) && !$is_edit)
        {
            return $return_data =array('code'=>4002,'message'=>L('username_format_incorrect'));
        }
        elseif (!isset($data['userid']) && $is_edit)
        {
            return $return_data =array('code'=>4002,'message'=>L('username_format_incorrect'));
        }
        /*elseif (empty($data['email']) || !is_email($data['email']))
        {
            return $return_data =array('code'=>4003,'message'=>L('email_format_incorrect'));
        }*/
        return $return_data;
    }

    private function _checkpasswd($password){
        if (!is_password($password)){
            return false;
        }
        return true;
    }

    private function _checkname($username) {
        $username =  trim($username);
        if ($this->db->get_one(array('username'=>$username))){
            return false;
        }
        return true;
    }

    private function creat_password($password) {
        $encrypt = substr(md5(rand()), 0, 6);
        return array(md5(md5($password).$encrypt),$encrypt);
    }

}