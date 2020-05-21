<?php

/**
 *
 * 工具类，使用该类来实现自动依赖注入。
 *
 */
class Ioc {

    // 获得类的对象实例
    public static function getInstance($className) {

        $paramArr = self::getMethodParams($className);

        return (new ReflectionClass($className))->newInstanceArgs($paramArr);
    }

    /**
     * 执行类的方法
     * @param  [type] $className  [类名]
     * @param  [type] $methodName [方法名称]
     * @param  [type] $params     [额外的参数]
     * @return [type]             [description]
     */
    public static function make($className, $methodName, $params = []) {

        // 获取类的实例
        $instance = self::getInstance($className);

        //var_dump($instance);exit;

        // 获取该方法所需要依赖注入的参数
        $paramArr = self::getMethodParams($className, $methodName);

        return $instance->{$methodName}(...array_merge($paramArr, $params));
    }

    /**
     * 获得类的方法参数，只获得有类型的参数
     * @param  [type] $className   [description]
     * @param  [type] $methodsName [description]
     * @return [type]              [description]
     */
    protected static function getMethodParams($className, $methodsName = '__construct') {

        // 通过反射获得该类
        $class = new ReflectionClass($className);
        $paramArr = []; // 记录参数，和参数类型

        // 判断该类是否有构造函数
        if ($class->hasMethod($methodsName)) {
            // 获得构造函数
            $construct = $class->getMethod($methodsName);

            // 判断构造函数是否有参数
            $params = $construct->getParameters();

            if (count($params) > 0) {

                // 判断参数类型
                foreach ($params as $key => $param) {

                    if ($paramClass = $param->getClass()) {

                        // 获得参数类型名称
                        $paramClassName = $paramClass->getName();

                        // 获得参数类型
                        $args = self::getMethodParams($paramClassName);
                        $paramArr[] = (new ReflectionClass($paramClass->getName()))->newInstanceArgs($args);
                    }
                }
            }
        }

        return $paramArr;
    }
}

class A {

    protected $cObj;

    /**
     * 用于测试多级依赖注入 B依赖A，A依赖C
     * @param C $c [description]
     */
    public function __construct(C $c) {

        $this->cObj = $c;
    }

    public function aa() {

        echo 'this is A->test';
    }

    public function aac() {

        $this->cObj->cc();
    }
}

class B {

    protected $aObj;

    /**
     * 测试构造函数依赖注入
     * @param A $a [使用引来注入A]
     */
    public function __construct(A $a) {

        $this->aObj = $a;
    }

    /**
     * [测试方法调用依赖注入]
     * @param  C      $c [依赖注入C]
     * @param  string $b [这个是自己手动填写的参数]
     * @return [type]    [description]
     */
    public function bb(C $c, $b) {

        $c->cc();
        echo "\r\n";

        echo 'params:' . $b;
    }

    /**
     * 验证依赖注入是否成功
     * @return [type] [description]
     */
    public function bbb() {

        $this->aObj->aac();
    }
}

class C {

    public function cc() {

        echo 'this is C->cc';
    }
}

/**
 * php中的错误和异常是两个不同的概念。
错误：是因为脚本的问题，比如少写了分号，调用未定义的函数，除0，等一些编译语法错误。
异常：是因为业务逻辑和流程，不符合预期情况，比如验证请求参数，不通过就用 throw new 抛一个异常。
 */

/*error_reporting(E_ALL);
ini_set('display_errors', 'on');

//注册一个会在php中止时执行的函数
register_shutdown_function(function () {
    //获取最后发生的错误
    $error = error_get_last();
    if (!empty($error)) {
        echo $error['message'], '<br>';
        echo $error['file'], ' ', $error['line'];
    }
});*/
//phpinfo();

//Ioc::make('B', 'bb', ['this is param b']);
/*PHP5 版本 致命错误不再往下执行 try{}catch{},无法捕获,但是有方式*/
/*try{
    Ioc::make('A', 'cc', ['this is param AAA']);
}catch (\Exception $e){
    echo $e->getMessage();
}*/

/*PHP7 版本 捕获错误和异常*/
try {
    Ioc::make('A', 'aac', ['this is param AAA']);
} catch (\Throwable $e) {
    echo $e->getMessage();
}


