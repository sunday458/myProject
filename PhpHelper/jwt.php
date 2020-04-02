<?php
/**
 * PHP实现jwt
 */
class Jwt {
 
    //头部
    private static $header=array(
        'alg'=>'HS256', //生成signature的算法
        'typ'=>'JWT'    //类型
    );
 
    //使用HMAC生成信息摘要时所使用的密钥
    private static $key='123456';
 
 
    /**
     * 获取jwt token
     * @param array $payload jwt载荷   格式如下非必须
     * [
     *  'iss'=>'jwt_admin',  //该JWT的签发者
     *  'iat'=>time(),  //签发时间
     *  'exp'=>time()+7200,  //过期时间
     *  'nbf'=>time()+60,  //该时间之前不接收处理该Token
     *  'sub'=>'www.admin.com',  //面向的用户
     *  'jti'=>md5(uniqid('JWT').time())  //该Token唯一标识
     * ]
     * @return bool|string
     */
    public static function getToken(array $payload)
    {
        if(is_array($payload))
        {
            $base64header=self::base64UrlEncode(json_encode(self::$header,JSON_UNESCAPED_UNICODE));
            $base64payload=self::base64UrlEncode(json_encode($payload,JSON_UNESCAPED_UNICODE));
            $token=$base64header.'.'.$base64payload.'.'.self::signature($base64header.'.'.$base64payload,self::$key,self::$header['alg']);
            return $token;
        }else{
            return false;
        }
    }
 
 
    /**
     * 验证token是否有效,默认验证exp,nbf,iat时间
     * @param string $Token 需要验证的token
     * @return bool|string
     */
    public static function verifyToken(string $Token)
    {
        $tokens = explode('.', $Token);
        if (count($tokens) != 3)
            return false;
 
        list($base64header, $base64payload, $sign) = $tokens;
 
        //获取jwt算法
        $base64decodeheader = json_decode(self::base64UrlDecode($base64header), JSON_OBJECT_AS_ARRAY);
        if (empty($base64decodeheader['alg']))
            return false;
 
        //签名验证
        if (self::signature($base64header . '.' . $base64payload, self::$key, $base64decodeheader['alg']) !== $sign)
            return false;
 
        $payload = json_decode(self::base64UrlDecode($base64payload), JSON_OBJECT_AS_ARRAY);
 
        //签发时间大于当前服务器时间验证失败
        if (isset($payload['iat']) && $payload['iat'] > time())
            return false;
 
        //过期时间小于当前服务器时间验证失败
        if (isset($payload['exp']) && $payload['exp'] < time())
            return false;
 
        //该nbf时间之前不接收处理该Token
        if (isset($payload['nbf']) && $payload['nbf'] > time())
            return false;
 
        return $payload;
    }
 
 
 
 
    /**
     * base64UrlEncode   https://jwt.io/  中base64UrlEncode编码实现
     * @param string $input 需要编码的字符串
     * @return string
     */
    private static function base64UrlEncode(string $input)
    {
        return str_replace('=', '', strtr(base64_encode($input), '+/', '-_'));
    }
 
    /**
     * base64UrlEncode  https://jwt.io/  中base64UrlEncode解码实现
     * @param string $input 需要解码的字符串
     * @return bool|string
     */
    private static function base64UrlDecode(string $input)
    {
        $remainder = strlen($input) % 4;
        if ($remainder) {
            $addlen = 4 - $remainder;
            $input .= str_repeat('=', $addlen);
        }
        return base64_decode(strtr($input, '-_', '+/'));
    }
 
    /**
     * HMACSHA256签名   https://jwt.io/  中HMACSHA256签名实现
     * @param string $input 为base64UrlEncode(header).".".base64UrlEncode(payload)
     * @param string $key
     * @param string $alg   算法方式
     * @return mixed
     */
    private static function signature(string $input, string $key, string $alg = 'HS256')
    {
        $alg_config=array(
            'HS256'=>'sha256'
        );
        return self::base64UrlEncode(hash_hmac($alg_config[$alg], $input, $key,true));
    }
}
 
    //测试和官网是否匹配begin
    $payload=array('sub'=>'1234567890','name'=>'John Doe','iat'=>1516239022);
    $jwt=new Jwt();
    $token=$jwt->getToken($payload);
    echo "<pre>";
    echo $token;
    
    //对token进行验证签名
    $getPayload=$jwt->verifyToken($token);
    echo "<br><br>";
    var_dump($getPayload);
    echo "<br><br>";
    //测试和官网是否匹配end
    
    
    //自己使用测试begin
    // 用户授权成功后，token存放在缓存或者数据库中，后续检验
    $sub= 'www.admin.com';
    $user_name = 'admin';
    $payload_test=array(
        'iss'=>$user_name, //签发者
        'iat'=>time(),   //签发时间
        'exp'=>time()+7200, //过期时间
        'nbf'=>time(), //该时间之前不接收处理该Token
        'sub'=>$sub, //受众||面向用户
        'jti'=>md5(uniqid('JWT').time()), //该Token唯一标识
    );
    $token_test=Jwt::getToken($payload_test);
    $token_test='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhZG1pbiIsImlhdCI6MTU4NTgxMTk0MywiZXhwIjoxNTg1ODE5MTQzLCJuYmYiOjE1ODU4MTE5NDMsInN1YiI6Ind3dy5hZG1pbi5jb20iLCJqdGkiOiIyMjY2N2ZkZTg5Yzc4OGFkYmE0NDYxYjQ1ZmNmMDAwOCJ9.8JJa-Te34eX1bDaXzuU20knnooMpCk1NNxW-U2fnpkU'; //测试使用
    echo "<pre>";
    echo $token_test;
    //echo $token_test = $token_test.'2334';
    
    //对token进行验证签名
    $getPayload_test=Jwt::verifyToken($token_test);
    echo "<br><br>";
    var_dump($getPayload_test);
    echo "<br><br>";
    //自己使用时候end
    // 存放redis
    //$redis = new \Redis();
    //$redis->connect('127.0.0.1',6379);
    //$redis->sadd($user_name,'token',$token_test);

    //测试判断
    if($getPayload_test){
        $exp_date = date('Y-m-d H:i:s',$getPayload_test['exp']);
        $now_time = time();
        $now_date = date('Y-m-d H:i:s',$now_time);

        echo '当前时间：'.$now_date.'<br/>';
        echo 'token过期时间：'.$exp_date.'<br/>';
        // 1. 用户 登录 用户名字和密码，请求API 授权组装数据，获取token
        // 2. 客户端保存token，每次请求附带token
        // 3. 请求后端 均需校验token，检验失败则XXX；校验成功需要判断过期时间 等等... 重新授权登录...
    }else{
        $return_data['code'] = 4500;
        $return_data['message'] = '非法访问!';
        echo json_encode($return_data);
        exit;
    }