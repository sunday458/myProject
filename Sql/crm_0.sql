/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.7.19-log : Database - crm_new_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`crm_new_db` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `crm_new_db`;

/*Table structure for table `after_orders` */

DROP TABLE IF EXISTS `after_orders`;

CREATE TABLE `after_orders` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `code` varchar(64) DEFAULT NULL COMMENT '售后单号',
  `o_id` bigint(16) DEFAULT '0' COMMENT '订单号id',
  `o_code` varchar(64) DEFAULT NULL COMMENT '订单号',
  `c_id` bigint(16) DEFAULT NULL COMMENT '客户id',
  `c_name` varchar(64) DEFAULT NULL COMMENT '客户姓名',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '销售人id',
  `emp_name` varchar(64) DEFAULT NULL COMMENT '销售人姓名',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '销售员工部门id',
  `consignee_name` varchar(64) DEFAULT NULL COMMENT '收货人姓名',
  `consignee_mobile` varchar(20) DEFAULT NULL COMMENT '收货人手机',
  `consignee_mobile2` varchar(32) DEFAULT NULL COMMENT '收货人电话2',
  `consignee_phone` varchar(20) DEFAULT NULL COMMENT '收货人电话',
  `consignee_province` varchar(20) DEFAULT NULL COMMENT '收货人省份',
  `consignee_city` varchar(20) DEFAULT NULL COMMENT '收货人市',
  `consignee_county` varchar(20) DEFAULT NULL COMMENT '收货人县',
  `consignee_street` varchar(512) DEFAULT NULL COMMENT '收货人街道',
  `afterorder_type` tinyint(3) DEFAULT '1' COMMENT '售后类型 1退货 2换货 3补发',
  `reason` text COMMENT '售后原因',
  `status` tinyint(2) DEFAULT '2' COMMENT '售后状态',
  `cdate` datetime DEFAULT NULL COMMENT '创建时间',
  `udate` datetime DEFAULT NULL COMMENT '修改时间',
  `back_date` datetime DEFAULT NULL COMMENT '退回时间',
  `deal_date` datetime DEFAULT NULL COMMENT '处理时间',
  `done_date` datetime DEFAULT NULL COMMENT '退货时间',
  `flag` tinyint(2) DEFAULT '1' COMMENT '售后单状态 1在用 0放弃',
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `cid` (`c_id`),
  KEY `empid` (`emp_id`),
  KEY `depid` (`dep_id`),
  KEY `status` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=3032 DEFAULT CHARSET=utf8 COMMENT='售后订单表';

/*Table structure for table `after_orders_record` */

DROP TABLE IF EXISTS `after_orders_record`;

CREATE TABLE `after_orders_record` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `o_id` bigint(16) DEFAULT NULL COMMENT '售后单id',
  `operator` bigint(16) DEFAULT NULL COMMENT '操作人',
  `status` int(2) DEFAULT NULL COMMENT '订单状态:退回/提交/处理中/完成',
  `type` int(2) DEFAULT NULL COMMENT '记录类型:添加备注/订单状态',
  `operator_type` int(2) DEFAULT NULL COMMENT '操作人类型:售后备注/财务备注/仓库备注',
  `remark` varchar(512) DEFAULT NULL COMMENT '内容',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7507 DEFAULT CHARSET=utf8 COMMENT='售后订单记录表';

/*Table structure for table `after_refund_orders` */

DROP TABLE IF EXISTS `after_refund_orders`;

CREATE TABLE `after_refund_orders` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `code` varchar(64) DEFAULT NULL COMMENT '退货单号',
  `o_id` int(11) DEFAULT NULL COMMENT '订单id',
  `o_code` varchar(32) DEFAULT NULL COMMENT '订单号',
  `after_o_id` int(11) DEFAULT '0' COMMENT '售后单id',
  `after_o_sn` varchar(32) DEFAULT NULL COMMENT '售后单号',
  `c_id` bigint(16) DEFAULT NULL COMMENT '客户id',
  `c_name` varchar(64) DEFAULT NULL COMMENT '客户姓名',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '销售人id',
  `emp_name` varchar(64) DEFAULT NULL COMMENT '销售人姓名',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '销售员工部门id',
  `order_amount` decimal(8,2) DEFAULT NULL COMMENT '订单总额',
  `consignee_name` varchar(64) DEFAULT NULL COMMENT '收货人姓名',
  `consignee_mobile` varchar(20) DEFAULT NULL COMMENT '收货人手机',
  `consignee_mobile2` varchar(16) DEFAULT NULL COMMENT '收货人手机2',
  `consignee_phone` varchar(20) DEFAULT NULL COMMENT '收货人电话',
  `consignee_province` varchar(20) DEFAULT NULL COMMENT '收货人省份',
  `consignee_city` varchar(20) DEFAULT NULL COMMENT '收货人市',
  `consignee_county` varchar(20) DEFAULT NULL COMMENT '收货人县',
  `consignee_street` varchar(512) DEFAULT NULL COMMENT '收货人街道',
  `status` int(2) DEFAULT NULL COMMENT '状态',
  `d_name` varchar(128) DEFAULT NULL COMMENT '物流公司名称',
  `d_code` varchar(20) DEFAULT NULL COMMENT '物流单号',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `back_date` datetime DEFAULT NULL COMMENT '批准时间',
  `approval_date` datetime DEFAULT NULL COMMENT '收货时间',
  `receive_date` datetime DEFAULT NULL COMMENT '退货时间',
  `refund_payment_date` datetime DEFAULT NULL COMMENT '退款时间',
  `done_date` datetime DEFAULT NULL COMMENT '完成时间',
  `is_get` tinyint(2) DEFAULT '0' COMMENT '是否计算业绩',
  `get_amount` decimal(8,2) DEFAULT '0.00' COMMENT '业绩金额',
  `is_add_reduce` tinyint(2) DEFAULT '0' COMMENT '业绩添加还是减少 1添加',
  `is_refund` tinyint(2) DEFAULT '0' COMMENT '是否退款',
  `is_back` tinyint(2) DEFAULT '0' COMMENT '是否退货 1退货',
  `refund_amount` decimal(8,2) DEFAULT '0.00' COMMENT '退款金额',
  `refund_account` text COMMENT '退款账户备注',
  `remark` text COMMENT '订单备注',
  `modifier` bigint(16) DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `o_emp_id` int(11) DEFAULT NULL COMMENT '原订单客服id',
  `o_emp_name` varchar(64) DEFAULT NULL COMMENT '原订单客服名称',
  `o_dep_id` int(11) DEFAULT NULL COMMENT '原订单客服部门',
  `reduce_sign` tinyint(2) DEFAULT '0' COMMENT '算签收 0是',
  `add_refund` tinyint(2) DEFAULT '0' COMMENT '算退货 1是',
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `cid` (`c_id`),
  KEY `empid` (`emp_id`),
  KEY `depid` (`dep_id`),
  KEY `status` (`status`),
  KEY `did` (`d_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2219 DEFAULT CHARSET=utf8 COMMENT='售后退货单表';

/*Table structure for table `after_refund_orders_goods` */

DROP TABLE IF EXISTS `after_refund_orders_goods`;

CREATE TABLE `after_refund_orders_goods` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '订单-产品表',
  `refund_o_id` int(16) DEFAULT NULL COMMENT '退货单id',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `p_id` bigint(16) DEFAULT NULL COMMENT '产品id',
  `name` varchar(64) DEFAULT NULL COMMENT '产品名称',
  `code` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `purchase_num` smallint(5) DEFAULT '0' COMMENT '购买数量',
  `refund_num` smallint(5) DEFAULT '0' COMMENT '退货数量',
  `actual_num` smallint(5) DEFAULT '0' COMMENT '实际退货数量',
  `price` decimal(8,2) DEFAULT NULL COMMENT '单价',
  `total` decimal(8,2) DEFAULT NULL COMMENT '总价',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oid` (`o_id`),
  KEY `pid` (`p_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16151 DEFAULT CHARSET=utf8 COMMENT='售后订单-产品表';

/*Table structure for table `after_refund_orders_record` */

DROP TABLE IF EXISTS `after_refund_orders_record`;

CREATE TABLE `after_refund_orders_record` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `o_id` bigint(16) DEFAULT NULL COMMENT '售后退货单id',
  `operator` bigint(16) DEFAULT NULL COMMENT '操作人',
  `status` int(2) DEFAULT NULL COMMENT '订单状态:退回/提交/处理中/完成',
  `type` int(2) DEFAULT NULL COMMENT '记录类型:添加备注/订单状态',
  `operator_type` int(2) DEFAULT NULL COMMENT '操作人类型:售后备注/财务备注/仓库备注',
  `remark` varchar(512) DEFAULT NULL COMMENT '内容',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10409 DEFAULT CHARSET=utf8 COMMENT='售后退货单记录表';

/*Table structure for table `announcement` */

DROP TABLE IF EXISTS `announcement`;

CREATE TABLE `announcement` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '公告表',
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `attachment` bigint(16) DEFAULT NULL COMMENT '附件',
  `remark` varchar(128) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COMMENT='公告表';

/*Table structure for table `attachments` */

DROP TABLE IF EXISTS `attachments`;

CREATE TABLE `attachments` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `save_path` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `save_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `md5` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `size` decimal(64,0) DEFAULT NULL,
  `ref_count` int(7) DEFAULT NULL,
  `ext_name` varchar(8) CHARACTER SET utf8 DEFAULT NULL,
  `height` int(6) DEFAULT NULL,
  `width` int(6) DEFAULT NULL,
  `cdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=364 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='附件表()';

/*Table structure for table `bugs` */

DROP TABLE IF EXISTS `bugs`;

CREATE TABLE `bugs` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT 'bug列表',
  `state` int(2) DEFAULT NULL COMMENT '状态',
  `level` int(2) DEFAULT NULL COMMENT '等级',
  `module` varchar(64) DEFAULT NULL COMMENT '所属模块',
  `submodule` varchar(64) DEFAULT NULL COMMENT '子模块',
  `desctest` text COMMENT '问题描述',
  `descdev` text COMMENT '开发反馈',
  `imgs` varchar(256) DEFAULT NULL COMMENT '附件列表',
  `dever` varchar(64) DEFAULT NULL COMMENT '负责人',
  `closer` varchar(64) DEFAULT NULL COMMENT '关闭人',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifyer` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='BUG表(-)';

/*Table structure for table `courier_bill_log` */

DROP TABLE IF EXISTS `courier_bill_log`;

CREATE TABLE `courier_bill_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `bill_id` bigint(20) unsigned NOT NULL COMMENT '订单ID',
  `company_code` varchar(100) NOT NULL DEFAULT '' COMMENT '快递公司编码',
  `courier_no` varchar(100) NOT NULL DEFAULT '' COMMENT '快递单号',
  `waybill_process` text NOT NULL COMMENT '快递进度',
  `waybill_state` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '快递状态，0在途中、1已揽收、2疑难、3已签收、4退签、5同城派送中、6退回、7转单',
  `sign_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '签收时间',
  `log` tinytext COMMENT '最后一次详情记录',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL COMMENT '信息更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `waybill_no_company_id` (`courier_no`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/*Table structure for table `courier_company` */

DROP TABLE IF EXISTS `courier_company`;

CREATE TABLE `courier_company` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `company_code` varchar(100) NOT NULL COMMENT '快递公司编码',
  `company_name` varchar(100) NOT NULL DEFAULT '' COMMENT '快递公司名称',
  `company_sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序，越小越前',
  `company_status` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '状态，0禁用、1启用',
  `tracking_api` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '接口api，1.淘宝快递 2.快递100',
  `courier_token` varchar(100) NOT NULL DEFAULT '' COMMENT '接口api的编码',
  PRIMARY KEY (`id`),
  KEY `company_code` (`company_code`,`tracking_api`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk COMMENT='快递公司(兼容旧快递公司表 deliver_company)';

/*Table structure for table `crm_auths` */

DROP TABLE IF EXISTS `crm_auths`;

CREATE TABLE `crm_auths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_name` varchar(32) NOT NULL COMMENT '节点名称',
  `auth_pid` int(11) NOT NULL DEFAULT '0' COMMENT '父级id',
  `auth_c` varchar(32) NOT NULL COMMENT '控制器名称',
  `auth_a` varchar(64) NOT NULL COMMENT '方法名称',
  `auth_level` int(11) NOT NULL DEFAULT '0' COMMENT '是否顶级',
  `is_show` tinyint(2) unsigned DEFAULT '1' COMMENT '是否显示',
  `is_new` tinyint(2) unsigned DEFAULT '0' COMMENT '是否新打开窗口',
  `is_button` tinyint(2) unsigned DEFAULT '0' COMMENT '是否按钮',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标名称',
  `sort` smallint(5) unsigned DEFAULT '100' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `auth_name_index` (`auth_name`)
) ENGINE=MyISAM AUTO_INCREMENT=501 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_auths_copy_2018_5_8_mumu` */

DROP TABLE IF EXISTS `crm_auths_copy_2018_5_8_mumu`;

CREATE TABLE `crm_auths_copy_2018_5_8_mumu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_name` varchar(32) NOT NULL COMMENT '节点名称',
  `auth_pid` int(11) NOT NULL DEFAULT '0' COMMENT '父级id',
  `auth_c` varchar(32) NOT NULL COMMENT '控制器名称',
  `auth_a` varchar(64) NOT NULL COMMENT '方法名称',
  `auth_level` int(11) NOT NULL DEFAULT '0' COMMENT '是否顶级',
  `is_show` tinyint(2) unsigned DEFAULT '1' COMMENT '是否显示',
  `is_new` tinyint(2) unsigned DEFAULT '0' COMMENT '是否新打开窗口',
  `is_button` tinyint(2) unsigned DEFAULT '0' COMMENT '是否按钮',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标名称',
  `sort` smallint(5) unsigned DEFAULT '100' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `auth_name_index` (`auth_name`)
) ENGINE=MyISAM AUTO_INCREMENT=501 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_batch_log` */

DROP TABLE IF EXISTS `crm_batch_log`;

CREATE TABLE `crm_batch_log` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '订单快递费导入日志',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `d_code` varchar(64) DEFAULT NULL COMMENT '订单编号',
  `batch_no` varchar(50) NOT NULL COMMENT '导入批次号',
  `postage_money` decimal(6,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '快递运费金额',
  `status` int(2) DEFAULT NULL COMMENT '状态',
  `msg` varchar(1024) DEFAULT NULL COMMENT '描述',
  `cdate` datetime DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `log_no` varchar(40) DEFAULT NULL COMMENT '快递号',
  PRIMARY KEY (`id`,`batch_no`)
) ENGINE=MyISAM AUTO_INCREMENT=3827 DEFAULT CHARSET=utf8 COMMENT='订单快递费导入日志';

/*Table structure for table `crm_distributor_tbl` */

DROP TABLE IF EXISTS `crm_distributor_tbl`;

CREATE TABLE `crm_distributor_tbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '经销商ID',
  `alipay_number` varchar(120) NOT NULL COMMENT '支付宝账号',
  `wechat_number` varchar(120) NOT NULL COMMENT '微信账号',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态 1审核中 2通过',
  `op_id` int(11) NOT NULL COMMENT '操作人ID',
  `add_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `crm_employee_info_log` */

DROP TABLE IF EXISTS `crm_employee_info_log`;

CREATE TABLE `crm_employee_info_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `e_id` int(11) NOT NULL COMMENT '员工ID',
  `type` tinyint(4) NOT NULL COMMENT '类型 1入职 2转正 3离职 4复职',
  `op_id` int(11) NOT NULL COMMENT '操作人ID',
  `op_time` int(11) NOT NULL COMMENT '类型对应时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `param` text,
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `e_id` (`e_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='员工入离职信息记录表';

/*Table structure for table `crm_express_log` */

DROP TABLE IF EXISTS `crm_express_log`;

CREATE TABLE `crm_express_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uid` int(10) unsigned NOT NULL COMMENT '用户id',
  `o_code` varchar(30) NOT NULL COMMENT '订单编号',
  `content` varchar(1024) NOT NULL COMMENT '操作内容',
  `batch_no` varchar(50) DEFAULT NULL COMMENT '导入批次号',
  `status` int(2) DEFAULT NULL COMMENT '状态',
  `logistics_num` varchar(64) DEFAULT NULL COMMENT '物流单号',
  `msg` varchar(1024) DEFAULT NULL COMMENT '描述',
  `add_time` int(11) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='快递费用导入操作日志';

/*Table structure for table `crm_left_stock` */

DROP TABLE IF EXISTS `crm_left_stock`;

CREATE TABLE `crm_left_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL,
  `goods_sn` varchar(128) DEFAULT NULL,
  `goods_name` varchar(512) DEFAULT NULL,
  `goods_num` int(11) DEFAULT '0' COMMENT '结余+占用',
  `left_date` datetime DEFAULT NULL COMMENT '结余日期',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6529 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_log` */

DROP TABLE IF EXISTS `crm_log`;

CREATE TABLE `crm_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uid` int(10) unsigned NOT NULL COMMENT '用户id',
  `content` varchar(1024) NOT NULL COMMENT '操作内容',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1507765 DEFAULT CHARSET=utf8 COMMENT='操作日志';

/*Table structure for table `crm_login_log` */

DROP TABLE IF EXISTS `crm_login_log`;

CREATE TABLE `crm_login_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) DEFAULT NULL,
  `pwd` varchar(128) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `createtime` datetime DEFAULT NULL,
  `content` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=159720 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_login_wechat` */

DROP TABLE IF EXISTS `crm_login_wechat`;

CREATE TABLE `crm_login_wechat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) DEFAULT NULL,
  `pwd` varchar(128) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `openid` varchar(64) DEFAULT NULL,
  `nickname` varchar(64) DEFAULT NULL,
  `createtime` datetime DEFAULT NULL,
  `content` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_luck_draw_code_tbl` */

DROP TABLE IF EXISTS `crm_luck_draw_code_tbl`;

CREATE TABLE `crm_luck_draw_code_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL COMMENT '兑换码',
  `code_name` varchar(50) DEFAULT NULL COMMENT '抽奖码名',
  `type_id` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '兑换码类型 1.积分兑换 2.签到兑换 3.生日兑换',
  `exchange_opp_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '兑换机会id',
  `goods_id` int(10) unsigned NOT NULL COMMENT '商品id',
  `goods_name` varchar(200) NOT NULL COMMENT '商品名',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '兑换码状态 1 未使用 2 已使用',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `order_phone` varchar(20) NOT NULL DEFAULT '0' COMMENT '下单用户号码',
  `use_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `order_sn` varchar(30) NOT NULL DEFAULT '0' COMMENT '订单号',
  `note` text COMMENT '备注',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `op_id` int(10) DEFAULT '0' COMMENT '管理员id',
  PRIMARY KEY (`id`),
  KEY `order_sn` (`order_sn`),
  KEY `code` (`code`),
  KEY `user_id` (`user_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='抽奖码兑换表';

/*Table structure for table `crm_order_ship_back` */

DROP TABLE IF EXISTS `crm_order_ship_back`;

CREATE TABLE `crm_order_ship_back` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL COMMENT '订单id',
  `order_sn` varchar(128) DEFAULT NULL COMMENT '订单编码',
  `is_shipped` tinyint(2) DEFAULT '0' COMMENT '发货',
  `is_back` tinyint(2) DEFAULT '0' COMMENT '发货退回',
  `is_received` tinyint(2) DEFAULT '0' COMMENT '收到退货',
  `flag` tinyint(2) DEFAULT '0' COMMENT '未处理状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4118 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_roles` */

DROP TABLE IF EXISTS `crm_roles`;

CREATE TABLE `crm_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(32) NOT NULL COMMENT '角色名称',
  `role_auth_id` text NOT NULL COMMENT '节点ID',
  `is_all` tinyint(2) DEFAULT '0' COMMENT '所有数据',
  `status` tinyint(2) DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_shipping_address_tbl` */

DROP TABLE IF EXISTS `crm_shipping_address_tbl`;

CREATE TABLE `crm_shipping_address_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `consignee` varchar(64) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `mobile_type` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '手机类型，0 其他，1 大陆手机',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '收货人电话',
  `province` varchar(20) NOT NULL DEFAULT '' COMMENT '省份',
  `city` varchar(20) NOT NULL DEFAULT '' COMMENT '城市',
  `county` varchar(20) NOT NULL DEFAULT '' COMMENT '行政区',
  `street` varchar(300) NOT NULL DEFAULT '' COMMENT '收货详细地址',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否默认地址， 0 是， 1 否',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='用户收货地址';

/*Table structure for table `crm_stock_record_task` */

DROP TABLE IF EXISTS `crm_stock_record_task`;

CREATE TABLE `crm_stock_record_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_record_id` int(11) DEFAULT '0' COMMENT '处理记录最后id',
  `deal_num` smallint(6) DEFAULT '0' COMMENT '处理数量',
  `cdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1040 DEFAULT CHARSET=utf8;

/*Table structure for table `crm_wechat` */

DROP TABLE IF EXISTS `crm_wechat`;

CREATE TABLE `crm_wechat` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '微信号id',
  `wechat` varchar(255) NOT NULL COMMENT '微信号',
  `img` varchar(255) NOT NULL COMMENT '图片路径',
  `nickname` varchar(32) NOT NULL COMMENT '昵称',
  `emp_id` int(16) DEFAULT '0' COMMENT '客服id',
  `emp_name` varchar(1024) NOT NULL COMMENT '客服名称',
  `dep_id` int(16) DEFAULT '0' COMMENT '部门id',
  `is_limited` tinyint(2) DEFAULT '0' COMMENT '是否被强制下线',
  `controller_num` int(10) NOT NULL COMMENT '好友上限',
  `qq` varchar(16) DEFAULT NULL COMMENT 'QQ',
  `mobile` char(11) DEFAULT NULL COMMENT '手机',
  `identify` char(19) DEFAULT NULL COMMENT '身份证号',
  `name` varchar(30) DEFAULT NULL COMMENT '姓名',
  `is_bank` tinyint(2) DEFAULT '0' COMMENT '0 未绑定银行卡 1已绑定银行卡',
  `is_order` varchar(255) DEFAULT '0' COMMENT '0 未购买理财产品 1 已购买',
  `is_public` tinyint(3) DEFAULT '1' COMMENT '是不是公众号 1 普通号 2公众号 3公众虚拟号',
  `pid` int(10) DEFAULT '0' COMMENT '父级id',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '使用状态 1使用 0停用',
  `adate` datetime DEFAULT NULL COMMENT '分配日期',
  `sdate` datetime DEFAULT NULL COMMENT '注册时间',
  `cdate` datetime DEFAULT NULL COMMENT '添加时间',
  `udate` datetime DEFAULT NULL COMMENT '修改时间',
  `is_get_message` tinyint(2) DEFAULT '1' COMMENT '是否可以采集信息',
  `flag` tinyint(2) DEFAULT '1',
  `server_name` varchar(512) DEFAULT NULL COMMENT '导入批次号',
  `mobile_type` varchar(512) DEFAULT NULL COMMENT '手机型号',
  `change_name` text COMMENT '客服名称改变记录',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=835 DEFAULT CHARSET=utf8;

/*Table structure for table `customer` */

DROP TABLE IF EXISTS `customer`;

CREATE TABLE `customer` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '客户表',
  `name` varchar(64) DEFAULT NULL COMMENT '客户姓名',
  `code` varchar(64) DEFAULT NULL COMMENT '客户编号',
  `province` varchar(16) DEFAULT NULL COMMENT '省',
  `city` varchar(16) DEFAULT NULL COMMENT '市',
  `county` varchar(16) DEFAULT NULL COMMENT '区',
  `street` varchar(200) DEFAULT NULL COMMENT '街道',
  `phone_first` varchar(20) DEFAULT NULL COMMENT '联系电话1',
  `phone_second` varchar(20) DEFAULT NULL COMMENT '联系电话2',
  `phone_third` varchar(20) DEFAULT NULL COMMENT '联系电话3',
  `source` int(2) DEFAULT NULL COMMENT '客户来源',
  `interest` int(2) DEFAULT NULL COMMENT '客户意向产品',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '销售人员id',
  `emp_id_old` bigint(16) DEFAULT NULL COMMENT '原销售人员id',
  `level` int(2) DEFAULT NULL COMMENT '客户等级',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `zdate` datetime DEFAULT NULL COMMENT '转入时间',
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `head` bigint(20) DEFAULT NULL COMMENT '客户图片',
  `skin_problems` varchar(512) DEFAULT NULL COMMENT '肌肤问题',
  `skin_problems_code` int(2) DEFAULT NULL COMMENT '肌肤问题编号',
  `pox_muscle` varchar(20) DEFAULT NULL COMMENT '痘肌',
  `coarse_pore` varchar(20) DEFAULT NULL COMMENT '毛孔粗大',
  `sensitive_muscle` varchar(20) DEFAULT NULL COMMENT '敏感肌',
  `muscle_spot` varchar(20) DEFAULT NULL COMMENT '斑肌',
  `corrugator` varchar(20) DEFAULT NULL COMMENT '皱肌',
  `dark_yellow_muscle` int(2) DEFAULT NULL COMMENT '暗黄肌',
  `dry_muscle` int(2) DEFAULT NULL COMMENT '干燥肌',
  `face` varchar(512) DEFAULT NULL COMMENT '脸型',
  `marital_status` int(2) DEFAULT NULL COMMENT '婚姻状态',
  `education` int(2) DEFAULT NULL COMMENT '学历',
  `occupation` varchar(512) DEFAULT NULL COMMENT '职业',
  `age` int(16) DEFAULT NULL COMMENT '年龄',
  `face_value_integral` varchar(16) DEFAULT NULL COMMENT '颜值（积分）',
  `interest_label` varchar(2014) DEFAULT NULL COMMENT '兴趣标签',
  `monthly_target` int(8) DEFAULT NULL COMMENT '月目标',
  `height` varchar(16) DEFAULT NULL COMMENT '客户身高',
  `weight` varchar(16) DEFAULT NULL COMMENT '客户体重',
  `obesity_type` varchar(16) DEFAULT NULL COMMENT '肥胖类型',
  `birthday` datetime DEFAULT NULL COMMENT '员工生日',
  `sex` int(2) DEFAULT NULL COMMENT '性别',
  `interest_secondClass` bigint(16) DEFAULT NULL COMMENT '客户意向产品小分类',
  `first_order_time` datetime DEFAULT NULL COMMENT '首次下单时间',
  `second_order_time` datetime DEFAULT NULL COMMENT '第二次下单时间',
  `last_payment_name` varchar(32) DEFAULT NULL COMMENT '上次支付方式',
  `is_purchase` tinyint(4) DEFAULT '0' COMMENT '是否下单',
  `purchase_time` smallint(6) DEFAULT '0' COMMENT '购买次数',
  `mobile_type` tinyint(1) DEFAULT '1' COMMENT '1：大陆，2：其他',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `code` (`code`),
  KEY `empid` (`emp_id`),
  KEY `empidold` (`emp_id_old`),
  KEY `flag` (`flag`),
  KEY `phone_first` (`phone_first`),
  KEY `phone_second` (`phone_second`),
  KEY `phone_third` (`phone_third`),
  KEY `province` (`province`,`city`,`county`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='客户表';

/*Table structure for table `customer_record` */

DROP TABLE IF EXISTS `customer_record`;

CREATE TABLE `customer_record` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '客户跟进表',
  `c_id` bigint(16) DEFAULT NULL COMMENT '客户id',
  `record` varchar(1024) DEFAULT NULL COMMENT '跟进内容',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '销售id',
  `emp_name` varchar(64) DEFAULT NULL COMMENT '销售姓名',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `date` datetime DEFAULT NULL COMMENT '下次跟进日期',
  PRIMARY KEY (`id`),
  KEY `cid` (`c_id`),
  KEY `empid` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5118 DEFAULT CHARSET=utf8 COMMENT='客户跟进表';

/*Table structure for table `customer_record_attachment` */

DROP TABLE IF EXISTS `customer_record_attachment`;

CREATE TABLE `customer_record_attachment` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '客户跟进附件',
  `cr_id` bigint(16) DEFAULT NULL COMMENT '客户跟进表id',
  `attach_id` bigint(16) DEFAULT NULL COMMENT '附件id',
  `title` varchar(512) DEFAULT NULL COMMENT '附件标题',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户跟进附件';

/*Table structure for table `customer_source` */

DROP TABLE IF EXISTS `customer_source`;

CREATE TABLE `customer_source` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '客户来源类别表',
  `name` varchar(20) DEFAULT NULL COMMENT '类别名称',
  `parent` bigint(16) DEFAULT NULL COMMENT '上级类别',
  `show_index` int(5) DEFAULT NULL COMMENT '排序',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COMMENT='客户来源类别表';

/*Table structure for table `daytask` */

DROP TABLE IF EXISTS `daytask`;

CREATE TABLE `daytask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) DEFAULT '0' COMMENT '部门id',
  `task_time` date DEFAULT NULL COMMENT '日期',
  `payables` decimal(11,2) unsigned DEFAULT '0.00' COMMENT '应支付金额',
  `order_num` int(11) DEFAULT '0' COMMENT '统计的订单数',
  `payed_price` decimal(11,2) unsigned DEFAULT '0.00' COMMENT '已支付金额',
  `postage` decimal(7,2) DEFAULT NULL COMMENT '销售填写的邮费',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1848 DEFAULT CHARSET=utf8 COMMENT='每天销售额记录表';

/*Table structure for table `deliver_company` */

DROP TABLE IF EXISTS `deliver_company`;

CREATE TABLE `deliver_company` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '物流公司',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `s_company` varchar(64) DEFAULT NULL,
  `s_name` varchar(64) DEFAULT NULL,
  `s_mobile` varchar(64) DEFAULT NULL,
  `s_phone` varchar(64) DEFAULT NULL,
  `s_province` varchar(64) DEFAULT NULL,
  `s_city` varchar(64) DEFAULT NULL,
  `s_county` varchar(64) DEFAULT NULL,
  `s_address` varchar(64) DEFAULT NULL,
  `app_key` varchar(64) DEFAULT NULL,
  `app_secret` varchar(64) DEFAULT NULL,
  `session_key` varchar(64) DEFAULT NULL,
  `account_no` varchar(64) DEFAULT NULL,
  `kd100code` varchar(64) DEFAULT NULL,
  `phone` varchar(64) DEFAULT NULL COMMENT '电话',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='物流公司';

/*Table structure for table `deliver_goods_batch` */

DROP TABLE IF EXISTS `deliver_goods_batch`;

CREATE TABLE `deliver_goods_batch` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '发货批次表',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `d_id` bigint(16) DEFAULT NULL COMMENT '物流公司',
  `status` int(2) DEFAULT NULL COMMENT '状态,1:未发货,2:已发货',
  `person` bigint(16) DEFAULT NULL COMMENT '经手人',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发货批次表(-)';

/*Table structure for table `deliver_goods_orders` */

DROP TABLE IF EXISTS `deliver_goods_orders`;

CREATE TABLE `deliver_goods_orders` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '发货批次表',
  `dgb_id` varchar(64) DEFAULT NULL COMMENT '发货批次ID',
  `o_id` varchar(64) DEFAULT NULL COMMENT '订单ID',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发货-订单表(-)';

/*Table structure for table `department` */

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
  `id` bigint(16) NOT NULL COMMENT '部门表',
  `com_id` bigint(16) DEFAULT NULL COMMENT '单位id',
  `name` varchar(64) DEFAULT NULL COMMENT '部门名称',
  `code` varchar(64) DEFAULT NULL COMMENT '部门编号',
  `status` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '是否删除1有效 2无效',
  `step` int(4) NOT NULL DEFAULT '999' COMMENT '排序,大的前面',
  `parents_list` text COMMENT '父list',
  `child_list` text COMMENT '子list',
  `duty` varchar(512) DEFAULT NULL COMMENT '部门职责',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `fullpath` varchar(1024) DEFAULT NULL COMMENT '全路径',
  `parent` bigint(16) DEFAULT NULL COMMENT '父id',
  `yjid` int(11) DEFAULT NULL COMMENT '商城后台ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门表';

/*Table structure for table `employee` */

DROP TABLE IF EXISTS `employee`;

CREATE TABLE `employee` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '员工表',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '部门id',
  `position_id` int(11) DEFAULT '0' COMMENT '职位ID',
  `position_name` varchar(64) DEFAULT NULL COMMENT '岗位名称',
  `is_manager` int(1) DEFAULT NULL COMMENT '是否管理者',
  `name` varchar(64) DEFAULT NULL COMMENT '员工姓名',
  `code` varchar(64) DEFAULT NULL COMMENT '员工编号',
  `entry_date` date DEFAULT NULL COMMENT '入职时间',
  `quit_date` date DEFAULT NULL COMMENT '离职时间',
  `education` int(2) DEFAULT NULL COMMENT '学历',
  `specialty` varchar(64) DEFAULT NULL COMMENT '专业',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `birthday` varchar(20) DEFAULT NULL COMMENT '生日日期',
  `sex` int(2) DEFAULT NULL COMMENT '性别',
  `native_place` varchar(20) DEFAULT NULL COMMENT '籍贯',
  `nation` int(2) DEFAULT NULL COMMENT '民族',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ',
  `email` varchar(64) DEFAULT NULL COMMENT '邮箱',
  `domicile_address` varchar(512) DEFAULT NULL COMMENT '户籍地址',
  `now_living_address` varchar(512) DEFAULT NULL COMMENT '现联系地址',
  `emergency_contact` varchar(64) DEFAULT NULL COMMENT '紧急联系人',
  `emergency_contactphone` varchar(20) DEFAULT NULL COMMENT '紧急联系人电话',
  `introduction` varchar(64) DEFAULT NULL COMMENT '介绍人',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `head` bigint(16) DEFAULT NULL COMMENT '头像',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `status` int(2) DEFAULT NULL COMMENT '是否离职 0离职/1在职',
  `modifier` bigint(16) DEFAULT NULL,
  `monthly_target` decimal(8,2) DEFAULT NULL COMMENT '销售员工月目标',
  `fan_number` int(16) DEFAULT NULL COMMENT '粉丝数',
  `role_id` varchar(256) DEFAULT ',4,' COMMENT '角色id',
  `yjid` int(11) DEFAULT NULL COMMENT '商城后台ID',
  `login_time` int(11) DEFAULT NULL COMMENT '登录时间',
  `login_ip` varchar(64) DEFAULT NULL COMMENT '登录IP',
  `company_ownership` int(2) DEFAULT NULL COMMENT '公司归属',
  `contract_ownership` int(2) DEFAULT NULL COMMENT '合同归属',
  `correction_time` date DEFAULT NULL COMMENT '转正时间',
  `quit_type` int(2) DEFAULT NULL COMMENT '离职原因',
  `quit_reason` varchar(255) DEFAULT NULL COMMENT '离职原因',
  `graduate_school` varchar(64) DEFAULT NULL COMMENT '毕业学校',
  `certificate` varchar(255) DEFAULT NULL COMMENT '资格证书',
  `emergency_relationship` varchar(64) DEFAULT NULL COMMENT '与紧急联系人关系',
  `family_phone` varchar(20) DEFAULT NULL COMMENT '家人电话',
  `bank_card_number` varchar(64) DEFAULT NULL COMMENT '银行卡号',
  `bank_card_type` varchar(64) DEFAULT NULL COMMENT '银行卡类型',
  `bank_branch` varchar(64) DEFAULT NULL COMMENT '支行',
  `id_address` varchar(255) DEFAULT NULL COMMENT '身份证地址',
  `fixed_begin_time` int(11) DEFAULT NULL COMMENT '固定限期开始时间',
  `fixed_end_time` int(11) DEFAULT NULL COMMENT '固定限期结束时间',
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `depID` (`dep_id`),
  KEY `name` (`name`),
  KEY `pname` (`position_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2807 DEFAULT CHARSET=utf8 COMMENT='员工表';

/*Table structure for table `employee_c` */

DROP TABLE IF EXISTS `employee_c`;

CREATE TABLE `employee_c` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '员工表',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '部门id',
  `position_id` int(11) DEFAULT '0' COMMENT '职位ID',
  `position_name` varchar(64) DEFAULT NULL COMMENT '岗位名称',
  `is_manager` int(1) DEFAULT NULL COMMENT '是否管理者',
  `name` varchar(64) DEFAULT NULL COMMENT '员工姓名',
  `code` varchar(64) DEFAULT NULL COMMENT '员工编号',
  `entry_date` date DEFAULT NULL COMMENT '入职时间',
  `quit_date` date DEFAULT NULL COMMENT '离职时间',
  `education` int(2) DEFAULT NULL COMMENT '学历',
  `specialty` varchar(64) DEFAULT NULL COMMENT '专业',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `birthday` varchar(20) DEFAULT NULL COMMENT '生日日期',
  `sex` int(2) DEFAULT NULL COMMENT '性别',
  `native_place` varchar(20) DEFAULT NULL COMMENT '籍贯',
  `nation` int(2) DEFAULT NULL COMMENT '民族',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ',
  `email` varchar(64) DEFAULT NULL COMMENT '邮箱',
  `domicile_address` varchar(512) DEFAULT NULL COMMENT '户籍地址',
  `now_living_address` varchar(512) DEFAULT NULL COMMENT '现联系地址',
  `emergency_contact` varchar(64) DEFAULT NULL COMMENT '紧急联系人',
  `emergency_contactphone` varchar(20) DEFAULT NULL COMMENT '紧急联系人电话',
  `introduction` varchar(64) DEFAULT NULL COMMENT '介绍人',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `head` bigint(16) DEFAULT NULL COMMENT '头像',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `status` int(2) DEFAULT NULL COMMENT '是否离职 0离职/1在职',
  `modifier` bigint(16) DEFAULT NULL,
  `monthly_target` decimal(8,2) DEFAULT NULL COMMENT '销售员工月目标',
  `fan_number` int(16) DEFAULT NULL COMMENT '粉丝数',
  `role_id` varchar(256) DEFAULT ',4,' COMMENT '角色id',
  `yjid` int(11) DEFAULT NULL COMMENT '商城后台ID',
  `login_time` int(11) DEFAULT NULL COMMENT '登录时间',
  `login_ip` varchar(64) DEFAULT NULL COMMENT '登录IP',
  `company_ownership` int(2) DEFAULT NULL COMMENT '公司归属',
  `contract_ownership` int(2) DEFAULT NULL COMMENT '合同归属',
  `correction_time` date DEFAULT NULL COMMENT '转正时间',
  `quit_type` int(2) DEFAULT NULL COMMENT '离职原因',
  `quit_reason` varchar(255) DEFAULT NULL COMMENT '离职原因',
  `graduate_school` varchar(64) DEFAULT NULL COMMENT '毕业学校',
  `certificate` varchar(255) DEFAULT NULL COMMENT '资格证书',
  `emergency_relationship` varchar(64) DEFAULT NULL COMMENT '与紧急联系人关系',
  `family_phone` varchar(20) DEFAULT NULL COMMENT '家人电话',
  `bank_card_number` varchar(64) DEFAULT NULL COMMENT '银行卡号',
  `bank_card_type` varchar(64) DEFAULT NULL COMMENT '银行卡类型',
  `bank_branch` varchar(64) DEFAULT NULL COMMENT '支行',
  `id_address` varchar(255) DEFAULT NULL COMMENT '身份证地址',
  `fixed_begin_time` int(11) DEFAULT NULL COMMENT '固定限期开始时间',
  `fixed_end_time` int(11) DEFAULT NULL COMMENT '固定限期结束时间',
  PRIMARY KEY (`id`),
  KEY `depID` (`dep_id`),
  KEY `name` (`name`),
  KEY `pname` (`position_name`),
  KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工表';

/*Table structure for table `employee_change` */

DROP TABLE IF EXISTS `employee_change`;

CREATE TABLE `employee_change` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '人事变动表',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '员工id',
  `type` int(2) DEFAULT NULL COMMENT '变动类型:入职/离职/岗位变动',
  `reason` bigint(16) DEFAULT NULL COMMENT '变动原因',
  `date` datetime DEFAULT NULL COMMENT '变动时间',
  `operator` bigint(16) DEFAULT NULL COMMENT '操作人',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '新部门id',
  `dep_name` varchar(64) DEFAULT NULL COMMENT '部门',
  `old_dep_id` bigint(16) DEFAULT NULL COMMENT '原部门id',
  `pos_name` varchar(64) DEFAULT NULL COMMENT '岗位',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2227 DEFAULT CHARSET=utf8 COMMENT='人事变动表';

/*Table structure for table `error_login` */

DROP TABLE IF EXISTS `error_login`;

CREATE TABLE `error_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) DEFAULT NULL,
  `pwd` varchar(128) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `error_count` tinyint(4) NOT NULL DEFAULT '0',
  `error_data` int(11) NOT NULL DEFAULT '0',
  `createtime` datetime DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `content` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;

/*Table structure for table `express_weight` */

DROP TABLE IF EXISTS `express_weight`;

CREATE TABLE `express_weight` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `o_id` bigint(16) DEFAULT NULL,
  `o_code` varchar(255) DEFAULT NULL,
  `d_name` varchar(255) DEFAULT NULL,
  `d_code` varchar(20) DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `cdate` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `guanyi` */

DROP TABLE IF EXISTS `guanyi`;

CREATE TABLE `guanyi` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '管易对照表',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `g_id` bigint(16) DEFAULT NULL,
  `g_code` varchar(64) DEFAULT NULL COMMENT '管易商品代码',
  `g_name` varchar(64) DEFAULT NULL COMMENT '管易商品名称',
  `g_barcode` varchar(64) DEFAULT NULL COMMENT '管易商品条码',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `warehouse` tinyint(3) DEFAULT '1' COMMENT '管易商品所在仓库',
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `name` (`name`),
  KEY `g_code` (`g_code`),
  KEY `g_name` (`g_name`),
  KEY `g_id` (`g_id`),
  KEY `g_goodcode` (`g_barcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管易对照表';

/*Table structure for table `guanyi_stock_change_record` */

DROP TABLE IF EXISTS `guanyi_stock_change_record`;

CREATE TABLE `guanyi_stock_change_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sn` varchar(128) DEFAULT NULL COMMENT '编号，如订单号',
  `goods_id` int(11) NOT NULL COMMENT '产品id',
  `goods_name` varchar(512) DEFAULT NULL COMMENT '产品名称',
  `goods_sn` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `goods_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '数量',
  `content` text NOT NULL COMMENT '用途',
  `date` datetime NOT NULL COMMENT '时间',
  `oparetor_name` varchar(128) DEFAULT NULL COMMENT '操作人姓名',
  `old_stock` int(11) DEFAULT '0' COMMENT '变动前库存',
  `new_stock` int(11) DEFAULT '0' COMMENT '变动后库存',
  `type` smallint(6) DEFAULT '0' COMMENT '变动类型',
  `remark` text COMMENT '备注',
  `sold_num` int(11) DEFAULT '0',
  `assign_num` int(11) DEFAULT '0',
  `storage_num` int(11) DEFAULT '0',
  `before_num` int(11) DEFAULT '0',
  `kucun_test` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `incentive_slogan` */

DROP TABLE IF EXISTS `incentive_slogan`;

CREATE TABLE `incentive_slogan` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '激励标语主键',
  `slogan` varchar(2014) DEFAULT NULL COMMENT '励志标语',
  `user_type` bigint(16) DEFAULT NULL COMMENT '标语所属的部门',
  `user_id` bigint(16) DEFAULT NULL COMMENT '编写标语的员工',
  `cdate` date DEFAULT NULL,
  `udate` date DEFAULT NULL,
  `flag` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='导航公告(--)';

/*Table structure for table `interest_class` */

DROP TABLE IF EXISTS `interest_class`;

CREATE TABLE `interest_class` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '客户意向产品类别表',
  `name` varchar(20) DEFAULT NULL COMMENT '类别名称',
  `parent` bigint(16) DEFAULT NULL COMMENT '上级类别',
  `show_index` int(5) DEFAULT NULL COMMENT '排序',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='客户意向产品分类';

/*Table structure for table `inventory_batch` */

DROP TABLE IF EXISTS `inventory_batch`;

CREATE TABLE `inventory_batch` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '库存盘点批次',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `pdate` datetime DEFAULT NULL COMMENT '盘点时间',
  `status` int(2) DEFAULT NULL COMMENT '状态 1 未提交 2 已提交',
  `attachment` bigint(16) DEFAULT NULL COMMENT '附件',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8 COMMENT='盘点批次表';

/*Table structure for table `inventory_batch_product` */

DROP TABLE IF EXISTS `inventory_batch_product`;

CREATE TABLE `inventory_batch_product` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '库存盘点批次-产品',
  `ib_id` bigint(16) DEFAULT NULL COMMENT '库存盘点批次id',
  `p_id` bigint(16) DEFAULT NULL COMMENT '产品id',
  `quantity` int(8) DEFAULT NULL COMMENT '数量',
  `unit_price` decimal(8,2) DEFAULT NULL COMMENT '单价',
  `inventory_quantity` int(8) DEFAULT NULL COMMENT '核查库存',
  `overage` int(8) DEFAULT NULL COMMENT '盘盈',
  `loss` int(8) DEFAULT NULL COMMENT '盘亏',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1170 DEFAULT CHARSET=utf8 COMMENT='盘点批次产品表';

/*Table structure for table `invoicing_summary` */

DROP TABLE IF EXISTS `invoicing_summary`;

CREATE TABLE `invoicing_summary` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '进销存汇总表',
  `p_id` bigint(16) DEFAULT NULL COMMENT '产品id',
  `p_code` varchar(64) DEFAULT NULL COMMENT '产品编号',
  `p_name` varchar(64) DEFAULT NULL COMMENT '产品名称',
  `last_quantity` int(9) DEFAULT NULL COMMENT '上月结存数量',
  `last_price` decimal(11,2) DEFAULT NULL COMMENT '上月结存单价',
  `last_total_price` decimal(11,2) DEFAULT NULL COMMENT '上月结存总金额',
  `warehousing_quantity` int(9) DEFAULT NULL COMMENT '本月入库数量',
  `warehousing_price` decimal(11,2) DEFAULT NULL COMMENT '本月入库单价',
  `warehousing_total_price` decimal(11,2) DEFAULT NULL COMMENT '本月入库总金额',
  `expor_quantity` int(9) DEFAULT NULL COMMENT '本月出库数量',
  `expor_price` decimal(11,2) DEFAULT NULL COMMENT '本月出库单价',
  `expor_total_price` decimal(11,2) DEFAULT NULL COMMENT '本月出库总金额',
  `this_quantity` int(9) DEFAULT NULL COMMENT '本月结存数量',
  `this_price` decimal(11,2) DEFAULT NULL COMMENT '本月结存单价',
  `this_total_price` decimal(11,2) DEFAULT NULL COMMENT '本月结存总金额',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `job_change_reason` */

DROP TABLE IF EXISTS `job_change_reason`;

CREATE TABLE `job_change_reason` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '岗位变动类型id',
  `reason_name` varchar(20) DEFAULT NULL COMMENT '原因的名称',
  `remark` varchar(1024) DEFAULT NULL,
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='岗位变动原因表';

/*Table structure for table `knowledge` */

DROP TABLE IF EXISTS `knowledge`;

CREATE TABLE `knowledge` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '知识库',
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `type` int(2) DEFAULT NULL COMMENT '类型',
  `remark` varchar(128) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='知识库';

/*Table structure for table `knowledge_attachment` */

DROP TABLE IF EXISTS `knowledge_attachment`;

CREATE TABLE `knowledge_attachment` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '知识库附件表',
  `kn_id` bigint(16) DEFAULT NULL COMMENT '知识库id',
  `type` int(2) DEFAULT NULL COMMENT '附件类型',
  `attachment` bigint(16) DEFAULT NULL COMMENT '附件',
  `remark` varchar(128) DEFAULT NULL COMMENT '附件描述',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='知识库附件表';

/*Table structure for table `labor_contract` */

DROP TABLE IF EXISTS `labor_contract`;

CREATE TABLE `labor_contract` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '劳动合同表',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '员工id',
  `type` int(2) DEFAULT NULL COMMENT '签订类型_新签/续签/终止',
  `status` int(2) DEFAULT NULL COMMENT '合同状态_有效/终止',
  `start_date` datetime DEFAULT NULL COMMENT '合同开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '合同结束时间',
  `sign_date` datetime DEFAULT NULL COMMENT '签订日期',
  `operator` bigint(16) DEFAULT NULL COMMENT '操作人',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='劳动合同表';

/*Table structure for table `monthtask` */

DROP TABLE IF EXISTS `monthtask`;

CREATE TABLE `monthtask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` char(7) DEFAULT '0000-00' COMMENT '月任务时间',
  `u_id` int(10) unsigned DEFAULT '0' COMMENT '添加者id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='月任务列表';

/*Table structure for table `order_by_gdy` */

DROP TABLE IF EXISTS `order_by_gdy`;

CREATE TABLE `order_by_gdy` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `eid` bigint(16) DEFAULT NULL COMMENT '跟单员id',
  `ecode` varchar(64) DEFAULT NULL COMMENT '跟单员编号',
  `did` bigint(16) DEFAULT NULL COMMENT '跟单员负责的部门的id',
  `dcode` varchar(2048) DEFAULT NULL COMMENT '跟单员负责的部门id串',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `remark` varchar(512) DEFAULT NULL,
  `modifier` bigint(20) DEFAULT NULL,
  `depNames` varchar(512) DEFAULT NULL COMMENT '跟单部门的串',
  `ename` varchar(128) DEFAULT NULL COMMENT '跟单员姓名',
  PRIMARY KEY (`id`),
  KEY `gdy_eid` (`eid`),
  KEY `gdy_did` (`did`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='跟单查看部门订单权限表';

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '订单表',
  `code` varchar(64) DEFAULT NULL COMMENT '订单号',
  `c_id` bigint(16) DEFAULT NULL COMMENT '客户id',
  `c_name` varchar(64) DEFAULT NULL COMMENT '客户姓名',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '销售人id',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '销售员工部门id',
  `new_emp_id` bigint(16) DEFAULT NULL COMMENT '转入销售人id',
  `new_emp_name` varchar(64) DEFAULT NULL COMMENT '转入销售人姓名',
  `emp_name` varchar(64) DEFAULT NULL COMMENT '销售人姓名',
  `submit_date` datetime DEFAULT NULL COMMENT '下单日期',
  `total_price` decimal(8,2) DEFAULT NULL COMMENT '订单总额',
  `goods_amount` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '产品总额',
  `payed_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '已支付金额',
  `payables` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '应支付金额',
  `consignee_name` varchar(64) DEFAULT NULL COMMENT '收货人姓名',
  `consignee_mobile` varchar(20) DEFAULT NULL COMMENT '收货人手机',
  `consignee_phone` varchar(20) DEFAULT NULL COMMENT '收货人电话',
  `consignee_province` varchar(20) DEFAULT NULL COMMENT '收货人省份',
  `consignee_city` varchar(20) DEFAULT NULL COMMENT '收货人市',
  `consignee_county` varchar(20) DEFAULT NULL COMMENT '收货人县',
  `consignee_street` varchar(512) DEFAULT NULL COMMENT '收货人街道',
  `status` int(2) DEFAULT NULL COMMENT '状态',
  `d_id` bigint(16) DEFAULT NULL COMMENT '物流公司id',
  `d_code` varchar(20) DEFAULT NULL COMMENT '物流单号',
  `d_destination` varchar(512) DEFAULT NULL COMMENT '物流送货目的地',
  `d_departure` varchar(512) DEFAULT NULL COMMENT '物流送货出发地',
  `pay_type` int(2) DEFAULT NULL COMMENT '支付类型:1到付/2部分支付/3全额支付',
  `postage_money` decimal(6,2) DEFAULT NULL COMMENT '代收费用 邮费',
  `other_money` decimal(6,2) DEFAULT NULL COMMENT '其他费用',
  `service_money` decimal(6,2) DEFAULT NULL COMMENT '服务费',
  `need_shipping_fee` decimal(6,2) DEFAULT '0.00' COMMENT '快递应付金额',
  `divide_equally` varchar(512) DEFAULT NULL COMMENT '参与订单分成人员id',
  `divide_equally_text` varchar(1024) DEFAULT NULL COMMENT '参与订单分成人员姓名',
  `print_status` int(2) DEFAULT NULL COMMENT '订单打印状态',
  `print_operator` varchar(64) DEFAULT NULL COMMENT '打印操作员',
  `re_purchase` int(2) unsigned DEFAULT '0' COMMENT '复购',
  `accounting_date` datetime DEFAULT NULL COMMENT '下单记账时间',
  `deliver_date` datetime DEFAULT NULL COMMENT '发货时间',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `postage` decimal(6,2) DEFAULT NULL COMMENT '销售填写的邮费',
  `reduction` decimal(8,2) DEFAULT NULL COMMENT '减免金额',
  `client_wechat` varchar(128) DEFAULT NULL COMMENT '客户微信号',
  `emp_wechat` varchar(128) DEFAULT NULL COMMENT '客服微信号',
  `remark` text COMMENT '订单备注',
  `approval_date` datetime DEFAULT NULL COMMENT '批准时间',
  `sign_date` datetime DEFAULT NULL COMMENT '签收时间',
  `refund_date` datetime DEFAULT NULL COMMENT '退货时间',
  `refund_payment_date` datetime DEFAULT NULL COMMENT '拒收退款时间',
  `shipping_payment_date` datetime DEFAULT NULL COMMENT '到付记账时间',
  `is_checked` tinyint(2) DEFAULT '0' COMMENT '快递费核对状态',
  `is_after` tinyint(2) DEFAULT '0' COMMENT '是否售后单',
  `after_o_id` int(11) DEFAULT '0' COMMENT '售后单id',
  `after_o_sn` varchar(32) DEFAULT NULL COMMENT '售后单号',
  `lost_date` datetime DEFAULT NULL COMMENT '快递丢失时间',
  `is_after_status` tinyint(2) DEFAULT '0' COMMENT '是否在售后状态 1是',
  `is_after_date` datetime DEFAULT NULL COMMENT '填写售后单时间',
  `reduce_sign` tinyint(2) DEFAULT '0' COMMENT '算签收 0是',
  `handle` tinyint(2) DEFAULT '1' COMMENT '是否是已处理订单，默认为1(未处理)；2(已处理)',
  `add_refund` tinyint(2) DEFAULT '0' COMMENT '算退货 1是',
  `invalid_date` datetime DEFAULT NULL COMMENT '无效时间',
  `normal_date` datetime DEFAULT NULL COMMENT '恢复时间',
  `cktuihuo_date` datetime DEFAULT NULL COMMENT '仓库退货收件时间',
  `yjid` int(11) DEFAULT NULL,
  `shortAddress` varchar(255) DEFAULT NULL,
  `returns_code` varchar(50) DEFAULT NULL COMMENT '退货快递单号',
  `freightage` decimal(6,2) DEFAULT '0.00' COMMENT '快递运费',
  `pay_url` text COMMENT '在线支付连接',
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `cid` (`c_id`),
  KEY `empid` (`emp_id`),
  KEY `depid` (`dep_id`),
  KEY `newempid` (`new_emp_id`),
  KEY `status` (`status`),
  KEY `paytype` (`pay_type`),
  KEY `did` (`d_id`),
  KEY `cdate` (`cdate`),
  KEY `consignee_province` (`consignee_province`,`consignee_city`,`consignee_county`),
  KEY `submit_date` (`submit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单表';

/*Table structure for table `orders_deliver_cost` */

DROP TABLE IF EXISTS `orders_deliver_cost`;

CREATE TABLE `orders_deliver_cost` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '订单邮费',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `d_code` varchar(64) DEFAULT NULL COMMENT '订单编号',
  `batch_no` varchar(50) DEFAULT NULL COMMENT '导入批次号',
  `status` int(2) DEFAULT NULL COMMENT '状态',
  `msg` varchar(1024) DEFAULT NULL COMMENT '描述',
  `show_index` int(8) DEFAULT NULL COMMENT '排序',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `type` tinyint(1) DEFAULT '1' COMMENT 'type为2是快递运费批次记录',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单邮费';

/*Table structure for table `orders_pay` */

DROP TABLE IF EXISTS `orders_pay`;

CREATE TABLE `orders_pay` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '支付表',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `type` bigint(16) DEFAULT NULL COMMENT '支付工具',
  `name` varchar(64) DEFAULT NULL COMMENT '支付工具昵称',
  `price` decimal(8,2) DEFAULT NULL COMMENT '支付金额',
  `date` datetime DEFAULT NULL COMMENT '支付时间',
  `onlinecode` varchar(255) DEFAULT NULL,
  `online_pay` tinyint(4) DEFAULT '0' COMMENT '在线支付状态 0未支付，1支付成功',
  `online_paydate` datetime DEFAULT NULL COMMENT '在线支付时间',
  `sign` int(1) DEFAULT NULL COMMENT '是否记账:待记账/已记账',
  `sign_operator` bigint(16) DEFAULT NULL COMMENT '记账人id',
  `sign_date` datetime DEFAULT NULL COMMENT '记账时间',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `remark` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oid` (`o_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付表';

/*Table structure for table `orders_pay_type` */

DROP TABLE IF EXISTS `orders_pay_type`;

CREATE TABLE `orders_pay_type` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '支付工具',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `sort` smallint(6) DEFAULT '100' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='支付工具';

/*Table structure for table `orders_product` */

DROP TABLE IF EXISTS `orders_product`;

CREATE TABLE `orders_product` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '订单-产品表',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `p_id` bigint(16) DEFAULT NULL COMMENT '产品id',
  `name` varchar(64) DEFAULT NULL COMMENT '产品名称',
  `code` varchar(32) DEFAULT NULL COMMENT '产品编码',
  `quantity` int(5) DEFAULT NULL COMMENT '数量',
  `price` decimal(8,2) DEFAULT NULL COMMENT '单价',
  `total` decimal(8,2) DEFAULT NULL COMMENT '总价',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oid` (`o_id`),
  KEY `pid` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单-产品表';

/*Table structure for table `orders_record` */

DROP TABLE IF EXISTS `orders_record`;

CREATE TABLE `orders_record` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '订单记录表',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `operator` bigint(16) DEFAULT NULL COMMENT '操作人',
  `status` int(2) DEFAULT NULL COMMENT '订单状态:下单/记账/批准/发货/退货/收到退货/退款/换货',
  `type` int(2) DEFAULT NULL COMMENT '记录类型:添加备注/订单状态',
  `operator_type` int(2) DEFAULT NULL COMMENT '操作人类型:销售备注/跟单备注/财务备注/仓库备注',
  `remark` varchar(512) DEFAULT NULL COMMENT '内容',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `o_id` (`o_id`,`flag`),
  KEY `operator` (`operator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单记录表';

/*Table structure for table `permanent_assets` */

DROP TABLE IF EXISTS `permanent_assets`;

CREATE TABLE `permanent_assets` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '固定资产表',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `first_class` bigint(16) DEFAULT NULL COMMENT '大类别',
  `second_class` bigint(16) DEFAULT NULL COMMENT '小类别',
  `spec` varchar(64) DEFAULT NULL COMMENT '规格',
  `group` bigint(16) DEFAULT NULL COMMENT '固定资产组',
  `serial_number` varchar(20) DEFAULT NULL COMMENT '产品序列号',
  `sell_price` varchar(20) DEFAULT NULL COMMENT '产品条形码',
  `buy_date` datetime DEFAULT NULL COMMENT '购置日期',
  `purchase_amount` bigint(16) DEFAULT NULL COMMENT '购置金额',
  `account_unit` varchar(20) DEFAULT NULL COMMENT '出账单位',
  `dep_id` bigint(16) DEFAULT NULL COMMENT '使用部门',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '使用人',
  `status` int(2) DEFAULT NULL COMMENT '状态:申领/外借/归还/调拨/报废/变卖',
  `type` varchar(20) DEFAULT NULL COMMENT '资产代码',
  `position` varchar(20) DEFAULT NULL COMMENT '存放地点',
  `quantity` int(8) DEFAULT NULL COMMENT '数量',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='固定资产表(-)';

/*Table structure for table `permanent_assets_class` */

DROP TABLE IF EXISTS `permanent_assets_class`;

CREATE TABLE `permanent_assets_class` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '固定资产类别表',
  `name` varchar(20) DEFAULT NULL COMMENT '类别名称',
  `parent` bigint(16) DEFAULT NULL COMMENT '上级类别',
  `show_index` int(5) DEFAULT NULL COMMENT '排序',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='固定资产分类表(-)';

/*Table structure for table `permanent_assets_record` */

DROP TABLE IF EXISTS `permanent_assets_record`;

CREATE TABLE `permanent_assets_record` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '固定资产使用变更表',
  `pa_id` bigint(16) DEFAULT NULL COMMENT '资产id',
  `emp_id` bigint(16) DEFAULT NULL COMMENT '员工id',
  `type` int(2) DEFAULT NULL COMMENT '变更类型:申领/外借/归还/调拨/报废/变卖/空闲',
  `date` datetime DEFAULT NULL COMMENT '变更时间',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='固定资产使用变更表(-)';

/*Table structure for table `product` */

DROP TABLE IF EXISTS `product`;

CREATE TABLE `product` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '产品表',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `u_code` varchar(200) DEFAULT NULL COMMENT '用友编码',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `img` bigint(16) DEFAULT NULL,
  `first_class` bigint(16) DEFAULT NULL COMMENT '大类别',
  `second_class` bigint(16) DEFAULT NULL COMMENT '小类别',
  `spec` varchar(64) DEFAULT NULL COMMENT '规格',
  `unit` varchar(64) DEFAULT NULL COMMENT '单位',
  `serial_number` varchar(64) DEFAULT NULL COMMENT '产品序列号',
  `bar_code` varchar(64) DEFAULT NULL COMMENT '产品条形码',
  `sell_price` decimal(11,2) DEFAULT '0.00' COMMENT '售价',
  `reserve` int(9) DEFAULT '0' COMMENT '库存',
  `warning` int(6) DEFAULT '0' COMMENT '预警数量',
  `sold` int(9) DEFAULT '0' COMMENT '已售数量',
  `status` int(2) DEFAULT '0' COMMENT '状态:上架/下架',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `type` int(2) DEFAULT '0' COMMENT '产品类型:1:单品,2:套餐',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT '1',
  `modifier` bigint(16) DEFAULT NULL,
  `storage_num` int(11) DEFAULT '0' COMMENT '入库数量',
  `assign_num` int(11) DEFAULT '0' COMMENT '商品购买占用数量',
  `sold_num` int(11) DEFAULT '0' COMMENT '销售数量',
  `pandian_num` int(11) DEFAULT '0' COMMENT '盘点数',
  `return_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退货数量',
  `is_sync` int(11) DEFAULT '0' COMMENT '是否同步到第三方商城',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `u_code` (`u_code`),
  KEY `name` (`name`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=904 DEFAULT CHARSET=utf8 COMMENT='产品表';

/*Table structure for table `product_class` */

DROP TABLE IF EXISTS `product_class`;

CREATE TABLE `product_class` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '产品类别表',
  `name` varchar(20) DEFAULT NULL COMMENT '类别名称',
  `parent` bigint(16) DEFAULT NULL COMMENT '上级类别',
  `show_index` int(5) DEFAULT NULL COMMENT '排序',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8 COMMENT='产品分类表';

/*Table structure for table `product_definition` */

DROP TABLE IF EXISTS `product_definition`;

CREATE TABLE `product_definition` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '货号',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `u_code` varchar(64) DEFAULT NULL COMMENT '用友编号',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `first_class` bigint(16) DEFAULT NULL COMMENT '大类别',
  `second_class` bigint(16) DEFAULT NULL COMMENT '小类别',
  `type` int(2) DEFAULT NULL COMMENT '类型:固定资产/销售产品',
  `spec` varchar(64) DEFAULT NULL COMMENT '规格',
  `unit` varchar(64) DEFAULT NULL COMMENT '单位',
  `serial_number` varchar(64) DEFAULT NULL COMMENT '产品序列号',
  `bar_code` varchar(64) DEFAULT NULL COMMENT '产品条形码',
  `img` bigint(16) DEFAULT NULL COMMENT '图片',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `name` (`name`),
  KEY `u_code` (`u_code`)
) ENGINE=InnoDB AUTO_INCREMENT=421 DEFAULT CHARSET=utf8 COMMENT='货号表';

/*Table structure for table `product_old` */

DROP TABLE IF EXISTS `product_old`;

CREATE TABLE `product_old` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '产品表',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `u_code` varchar(200) DEFAULT NULL COMMENT '用友编码',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `img` bigint(16) DEFAULT NULL,
  `first_class` bigint(16) DEFAULT NULL COMMENT '大类别',
  `second_class` bigint(16) DEFAULT NULL COMMENT '小类别',
  `spec` varchar(64) DEFAULT NULL COMMENT '规格',
  `unit` varchar(64) DEFAULT NULL COMMENT '单位',
  `serial_number` varchar(64) DEFAULT NULL COMMENT '产品序列号',
  `bar_code` varchar(64) DEFAULT NULL COMMENT '产品条形码',
  `sell_price` decimal(11,2) DEFAULT NULL COMMENT '售价',
  `reserve` int(9) DEFAULT NULL COMMENT '库存',
  `warning` int(6) DEFAULT NULL COMMENT '预警数量',
  `sold` int(9) DEFAULT NULL COMMENT '已售数量',
  `status` int(2) DEFAULT NULL COMMENT '状态:上架/下架',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `type` int(2) DEFAULT NULL COMMENT '产品类型:1:单品,2:套餐',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `storage_num` int(11) DEFAULT '0' COMMENT '入库数量',
  `assign_num` int(11) DEFAULT '0' COMMENT '商品购买占用数量',
  `sold_num` int(11) DEFAULT '0' COMMENT '销售数量',
  `pandian_num` int(11) DEFAULT NULL,
  `is_sync` int(11) DEFAULT '0' COMMENT '是否同步到第三方商城',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `u_code` (`u_code`),
  KEY `name` (`name`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='产品表';

/*Table structure for table `product_set_meal` */

DROP TABLE IF EXISTS `product_set_meal`;

CREATE TABLE `product_set_meal` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '产品_套餐表',
  `set_id` bigint(16) DEFAULT NULL COMMENT '套餐id',
  `p_id` bigint(16) DEFAULT NULL COMMENT '产品id',
  `quantity` int(5) DEFAULT NULL COMMENT '数量',
  `spec` varchar(64) DEFAULT NULL COMMENT '规格',
  `unit` varchar(64) DEFAULT NULL COMMENT '单位',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `name` varchar(512) DEFAULT NULL COMMENT '产品名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1019 DEFAULT CHARSET=utf8 COMMENT='产品_套餐表';

/*Table structure for table `receipt_money` */

DROP TABLE IF EXISTS `receipt_money`;

CREATE TABLE `receipt_money` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '到付收款记录',
  `o_id` bigint(16) DEFAULT NULL COMMENT '订单id',
  `o_code` varchar(64) DEFAULT NULL COMMENT '订单编号',
  `postage` decimal(6,2) DEFAULT NULL COMMENT '邮费',
  `service` decimal(6,2) DEFAULT NULL COMMENT '服务费',
  `receipt_money` decimal(8,2) DEFAULT NULL COMMENT '代收款',
  `batch_no` varchar(20) DEFAULT NULL COMMENT '导入批次号',
  `status` int(2) DEFAULT NULL COMMENT '状态',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='到付收款记录(-)';

/*Table structure for table `receive_batch` */

DROP TABLE IF EXISTS `receive_batch`;

CREATE TABLE `receive_batch` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '到货批次表',
  `st_id` bigint(16) DEFAULT NULL COMMENT '采购批次id',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `type` int(2) DEFAULT NULL COMMENT '到货类型:销售产品/固定资产',
  `date` datetime DEFAULT NULL COMMENT '到货时间',
  `status` int(2) DEFAULT NULL COMMENT '状态 1 未提交 2 已提交 3 已入库',
  `attachment` bigint(16) DEFAULT NULL COMMENT '附件',
  `person` bigint(16) DEFAULT NULL COMMENT '经手人',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='到货批次表';

/*Table structure for table `receive_batch_product` */

DROP TABLE IF EXISTS `receive_batch_product`;

CREATE TABLE `receive_batch_product` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '到货批次表-货号',
  `re_id` bigint(16) DEFAULT NULL COMMENT '到货批次id',
  `sbp_id` bigint(16) DEFAULT NULL COMMENT '采购批次货号ID',
  `quantity` int(8) DEFAULT NULL COMMENT '到货数量',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='到货批次表-货号';

/*Table structure for table `return_goods_reason` */

DROP TABLE IF EXISTS `return_goods_reason`;

CREATE TABLE `return_goods_reason` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '退货原因类型id',
  `reason_name` varchar(20) DEFAULT NULL COMMENT '原因的名称',
  `remark` varchar(1024) DEFAULT NULL,
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='退货原因表';

/*Table structure for table `sms_send_log_tbl` */

DROP TABLE IF EXISTS `sms_send_log_tbl`;

CREATE TABLE `sms_send_log_tbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cellphone` varchar(20) NOT NULL COMMENT '手机号码',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '验证码生成时间',
  `validate` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否验证，默认是没有验证',
  `sms_id` int(11) NOT NULL DEFAULT '0' COMMENT '短信批号',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0：发送；1：重新发送',
  `code_num` varchar(6) NOT NULL DEFAULT '0' COMMENT '验证码',
  `sign_name` varchar(20) NOT NULL COMMENT '短信签名',
  `template` varchar(100) NOT NULL COMMENT '发送的短信模板',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `stock_batch` */

DROP TABLE IF EXISTS `stock_batch`;

CREATE TABLE `stock_batch` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '采购批次',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `date` datetime DEFAULT NULL COMMENT '采购时间',
  `amount` decimal(11,2) DEFAULT NULL COMMENT '采购总金额',
  `down_payment` decimal(8,2) DEFAULT NULL COMMENT '预付定金',
  `discount` decimal(11,2) DEFAULT NULL COMMENT '折扣金额',
  `dues` decimal(11,2) DEFAULT NULL COMMENT '应付款',
  `status` int(2) DEFAULT NULL COMMENT '状态 1 未提交 2 已提交',
  `type` int(2) DEFAULT NULL COMMENT '采购类型:固定资产/销售产品',
  `attachment` bigint(16) DEFAULT NULL COMMENT '附件',
  `invoice` varchar(512) DEFAULT NULL COMMENT '发票号',
  `shipping_method` varchar(512) DEFAULT NULL COMMENT '送货方式',
  `settlement_modes` varchar(512) DEFAULT NULL COMMENT '结算方式',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `oparetor_id` int(11) DEFAULT NULL COMMENT '操作者id',
  `sup_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='采购批次表';

/*Table structure for table `stock_batch_product` */

DROP TABLE IF EXISTS `stock_batch_product`;

CREATE TABLE `stock_batch_product` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '采购批次-货号',
  `st_id` bigint(16) DEFAULT NULL COMMENT '采购批次id',
  `de_id` bigint(16) DEFAULT NULL COMMENT '货号id',
  `pname` varchar(512) DEFAULT NULL COMMENT '产品名称',
  `pcode` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `sup_id` bigint(16) DEFAULT NULL COMMENT '供应商id',
  `quantity` int(8) DEFAULT NULL COMMENT '采购数量',
  `unit_price` decimal(8,2) DEFAULT NULL COMMENT '单价',
  `total_price` decimal(8,2) DEFAULT NULL COMMENT '总额',
  `tax_rate` decimal(8,2) DEFAULT NULL COMMENT '税率',
  `tax_unit_price` decimal(8,2) DEFAULT NULL COMMENT '含税单价',
  `tax_total_price` decimal(8,2) DEFAULT NULL COMMENT '含税总额',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='采购批次-货号';

/*Table structure for table `stock_change_record` */

DROP TABLE IF EXISTS `stock_change_record`;

CREATE TABLE `stock_change_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sn` varchar(128) DEFAULT NULL COMMENT '编号，如订单号',
  `goods_id` int(11) NOT NULL COMMENT '产品id',
  `goods_name` varchar(512) DEFAULT NULL COMMENT '产品名称',
  `goods_sn` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `goods_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '数量',
  `content` text NOT NULL COMMENT '用途',
  `date` datetime NOT NULL COMMENT '时间',
  `oparetor_name` varchar(128) DEFAULT NULL COMMENT '操作人姓名',
  `old_stock` int(11) DEFAULT '0' COMMENT '变动前库存',
  `new_stock` int(11) DEFAULT '0' COMMENT '变动后库存',
  `type` smallint(6) DEFAULT '0' COMMENT '变动类型',
  `remark` text COMMENT '备注',
  `sold_num` int(11) DEFAULT '0',
  `assign_num` int(11) DEFAULT '0',
  `storage_num` int(11) DEFAULT '0',
  `before_num` int(11) DEFAULT '0',
  `kucun_test` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`),
  KEY `sn` (`sn`),
  KEY `date` (`date`)
) ENGINE=MyISAM AUTO_INCREMENT=2601098 DEFAULT CHARSET=utf8;

/*Table structure for table `stock_change_record_old` */

DROP TABLE IF EXISTS `stock_change_record_old`;

CREATE TABLE `stock_change_record_old` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sn` varchar(128) DEFAULT NULL COMMENT '编号，如订单号',
  `goods_id` int(11) NOT NULL COMMENT '产品id',
  `goods_name` varchar(512) DEFAULT NULL COMMENT '产品名称',
  `goods_sn` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `goods_num` smallint(6) NOT NULL DEFAULT '0' COMMENT '数量',
  `content` text NOT NULL COMMENT '用途',
  `date` datetime NOT NULL COMMENT '时间',
  `oparetor_name` varchar(128) DEFAULT NULL COMMENT '操作人姓名',
  `old_stock` int(11) DEFAULT '0' COMMENT '变动前库存',
  `new_stock` int(11) DEFAULT '0' COMMENT '变动后库存',
  `type` smallint(6) DEFAULT '0' COMMENT '变动类型',
  `remark` text COMMENT '备注',
  `sold_num` int(11) DEFAULT '0',
  `assign_num` int(11) DEFAULT '0',
  `storage_num` int(11) DEFAULT '0',
  `before_num` int(11) DEFAULT '0',
  `kucun_test` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`),
  KEY `sn` (`sn`),
  KEY `date` (`date`)
) ENGINE=MyISAM AUTO_INCREMENT=2479790 DEFAULT CHARSET=utf8;

/*Table structure for table `supplier` */

DROP TABLE IF EXISTS `supplier`;

CREATE TABLE `supplier` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `code` varchar(64) DEFAULT NULL COMMENT '编号',
  `contact_name` varchar(64) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '联系电话',
  `contact_address` varchar(512) DEFAULT NULL COMMENT '联系地址',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8 COMMENT='供货商表';

/*Table structure for table `sys_config` */

DROP TABLE IF EXISTS `sys_config`;

CREATE TABLE `sys_config` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '【系统配置信息】',
  `key` varchar(63) DEFAULT NULL COMMENT '配置项',
  `value` varchar(254) DEFAULT NULL COMMENT '配置内容',
  `remark` varchar(512) DEFAULT NULL COMMENT '描述',
  `cdate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

/*Table structure for table `sys_func` */

DROP TABLE IF EXISTS `sys_func`;

CREATE TABLE `sys_func` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '系统功能',
  `key` varchar(256) DEFAULT NULL COMMENT '功能唯一标示',
  `text` varchar(32) DEFAULT NULL COMMENT '标题',
  `icon` varchar(256) DEFAULT NULL COMMENT '图标',
  `index` int(2) DEFAULT NULL COMMENT '顺序',
  `match` varchar(64) DEFAULT NULL COMMENT '请求路径',
  `parent` bigint(16) DEFAULT NULL COMMENT '父级功能',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifyer` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `sys_jobs` */

DROP TABLE IF EXISTS `sys_jobs`;

CREATE TABLE `sys_jobs` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT,
  `class` varchar(1024) DEFAULT NULL COMMENT '执行器类名',
  `interval` int(2) DEFAULT NULL COMMENT '执行时间单位（0分；1小时；2天）',
  `radix` int(2) DEFAULT NULL COMMENT '执行时间间隔',
  `start` datetime DEFAULT NULL COMMENT '执行时间点',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注说明',
  `flag` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `sys_role` */

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色',
  `name` varchar(32) DEFAULT NULL COMMENT '名称',
  `index` int(5) DEFAULT NULL COMMENT '顺序',
  `desc` varchar(1024) DEFAULT NULL COMMENT '描述',
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifyer` bigint(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `sys_role_func` */

DROP TABLE IF EXISTS `sys_role_func`;

CREATE TABLE `sys_role_func` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色权限',
  `role_id` bigint(16) DEFAULT NULL COMMENT '角色',
  `func_id` bigint(16) DEFAULT NULL COMMENT '功能',
  `data_area` int(2) DEFAULT NULL COMMENT '数据区域权限',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `sys_set` */

DROP TABLE IF EXISTS `sys_set`;

CREATE TABLE `sys_set` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '【系统配置信息】',
  `const_key` varchar(20) NOT NULL,
  `const_value` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`,`const_key`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `sys_sets` */

DROP TABLE IF EXISTS `sys_sets`;

CREATE TABLE `sys_sets` (
  `const_key` varchar(20) NOT NULL,
  `const_value` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`const_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `sys_user_role` */

DROP TABLE IF EXISTS `sys_user_role`;

CREATE TABLE `sys_user_role` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户角色',
  `user_id` bigint(16) DEFAULT NULL COMMENT '用户id',
  `role_id` bigint(16) DEFAULT NULL COMMENT '角色id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `task` */

DROP TABLE IF EXISTS `task`;

CREATE TABLE `task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) DEFAULT '0' COMMENT '部门id',
  `date_id` int(11) DEFAULT '0' COMMENT '月任务id',
  `total_price` decimal(11,2) DEFAULT NULL COMMENT '月任务销售额',
  `u_id` int(10) unsigned DEFAULT '0' COMMENT '添加者id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=341 DEFAULT CHARSET=utf8;

/*Table structure for table `track_log` */

DROP TABLE IF EXISTS `track_log`;

CREATE TABLE `track_log` (
  `track_log_id` int(11) NOT NULL AUTO_INCREMENT,
  `orders_id` int(11) NOT NULL COMMENT '订单ID',
  `user_id` int(11) NOT NULL COMMENT '操作人 员工ID',
  `user_name` varchar(50) NOT NULL COMMENT '操作人姓名',
  `track_log_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '跟单状态 0 未处理 1处理中 2已处理',
  `track_remark` varchar(255) NOT NULL COMMENT '跟单备注',
  `create_time` int(11) NOT NULL COMMENT '跟单提交时间',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父节点',
  `add_time` int(11) NOT NULL COMMENT '记录入库时间',
  PRIMARY KEY (`track_log_id`),
  KEY `user_id` (`user_id`),
  KEY `status_cratetime_tracktime` (`track_log_status`,`create_time`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '【用户信息】',
  `login_name` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '登录账号',
  `password` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '登录密码',
  `password_crm` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `head_img` int(16) DEFAULT NULL COMMENT '用户头像',
  `gender` int(2) DEFAULT NULL COMMENT '性别',
  `phone` varchar(18) CHARACTER SET utf8 DEFAULT NULL COMMENT '手机号码',
  `openid` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '微信openid',
  `type` int(2) DEFAULT NULL COMMENT '用户类型:管理员/供应商/个人用户',
  `obj_id` bigint(16) DEFAULT NULL COMMENT '供应商id',
  `status` int(2) DEFAULT NULL COMMENT '账号状态',
  `err_count` int(2) DEFAULT NULL COMMENT '错误次数',
  `login_count` int(11) DEFAULT NULL COMMENT '登录次数',
  `login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `login_ip` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cdate` datetime DEFAULT NULL,
  `udate` datetime DEFAULT NULL,
  `flag` int(1) DEFAULT NULL,
  `modifier` bigint(16) DEFAULT NULL,
  `more_type` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '更多用户类型（一个用户有多种身份）',
  `role_id` varchar(256) COLLATE utf8_unicode_ci DEFAULT ',4,' COMMENT '角色id',
  `channel_id` text COLLATE utf8_unicode_ci COMMENT '渠道id',
  `error_status` int(2) DEFAULT '1' COMMENT '登录错误状态',
  `we_nickname` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '微信用户名称',
  `we_headimgurl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '微信头像图片',
  `detail` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `lname` (`login_name`),
  KEY `type` (`type`),
  KEY `objid` (`obj_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2582 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*Table structure for table `w_OrdersStatus` */

DROP TABLE IF EXISTS `w_OrdersStatus`;

CREATE TABLE `w_OrdersStatus` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL COMMENT '发货软件-是否显示相关订单状态',
  `IsVisible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='控制发货软件-订单状态-搜索';

/*Table structure for table `yj_check_background_log` */

DROP TABLE IF EXISTS `yj_check_background_log`;

CREATE TABLE `yj_check_background_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `e_id` int(11) NOT NULL COMMENT '员工ID',
  `is_work` int(2) NOT NULL COMMENT '状态 1录用 0弃用',
  `result` text NOT NULL COMMENT '调查情况记录',
  `check_time` int(11) NOT NULL COMMENT '调查时间',
  `add_user_id` int(11) NOT NULL COMMENT '添加人ID',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='背景调查表';

/*Table structure for table `yj_contract_log` */

DROP TABLE IF EXISTS `yj_contract_log`;

CREATE TABLE `yj_contract_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `e_id` int(11) NOT NULL COMMENT '员工ID',
  `contract_type` int(2) NOT NULL COMMENT '1试用 2转正',
  `trial_begin_time` int(11) DEFAULT NULL COMMENT '试用期开始时间',
  `trial_end_time` int(11) DEFAULT NULL COMMENT '试用期结束时间',
  `renew_time` int(11) DEFAULT NULL COMMENT '续签时间',
  `renew_begin_time` int(11) DEFAULT NULL COMMENT '续签开始时间',
  `renew_end_time` int(11) DEFAULT NULL COMMENT '续签结束时间',
  `renew_num` int(2) DEFAULT NULL COMMENT '续签次数',
  `add_user_id` int(11) NOT NULL COMMENT '添加人ID',
  `update_user_id` int(11) DEFAULT NULL COMMENT '编辑人员ID',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工合同续签表';

/*Table structure for table `yj_discipline_log` */

DROP TABLE IF EXISTS `yj_discipline_log`;

CREATE TABLE `yj_discipline_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `e_id` int(11) NOT NULL COMMENT '员工ID',
  `type` int(2) NOT NULL COMMENT '类型',
  `reason` text NOT NULL COMMENT '原因',
  `num` int(2) NOT NULL DEFAULT '1' COMMENT '奖罚第N次',
  `add_user_id` int(11) NOT NULL COMMENT '录入人员ID',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态 -1删除 1正常',
  `discipline_time` int(11) NOT NULL COMMENT '违纪时间',
  `update_user_id` int(11) DEFAULT NULL COMMENT '更新人员ID',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='违纪登记表';

/*Table structure for table `yj_member_level_and_point_limit_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_limit_tbl`;

CREATE TABLE `yj_member_level_and_point_limit_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` tinyint(3) unsigned NOT NULL COMMENT '积分类型(注册，受邀注册等）',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `continues` tinyint(3) unsigned NOT NULL COMMENT '连续次数',
  `total_point` int(10) unsigned NOT NULL COMMENT '最大总分',
  `init_add_time` int(10) unsigned NOT NULL COMMENT '初始化添加时间',
  `init_total_point` int(10) unsigned NOT NULL COMMENT '初始化最大积分',
  `init_continues` tinyint(3) unsigned NOT NULL COMMENT '初始化连续次数',
  `object_id` varchar(100) CHARACTER SET gbk NOT NULL DEFAULT '0' COMMENT '对象ID(例如订单ID之类的)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_type_id` (`customer_id`,`type_id`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员积分记录表';

/*Table structure for table `yj_member_level_and_point_log_0_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_0_tbl`;

CREATE TABLE `yj_member_level_and_point_log_0_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员操作记录表';

/*Table structure for table `yj_member_level_and_point_log_1_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_1_tbl`;

CREATE TABLE `yj_member_level_and_point_log_1_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_2_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_2_tbl`;

CREATE TABLE `yj_member_level_and_point_log_2_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_3_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_3_tbl`;

CREATE TABLE `yj_member_level_and_point_log_3_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_4_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_4_tbl`;

CREATE TABLE `yj_member_level_and_point_log_4_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_5_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_5_tbl`;

CREATE TABLE `yj_member_level_and_point_log_5_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_6_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_6_tbl`;

CREATE TABLE `yj_member_level_and_point_log_6_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_7_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_7_tbl`;

CREATE TABLE `yj_member_level_and_point_log_7_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_8_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_8_tbl`;

CREATE TABLE `yj_member_level_and_point_log_8_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_log_9_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_log_9_tbl`;

CREATE TABLE `yj_member_level_and_point_log_9_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL COMMENT '类型id(注册，受邀注册等)',
  `add_time` int(10) unsigned NOT NULL COMMENT '添加时间',
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `point` int(10) DEFAULT '0' COMMENT '积分',
  `remark` varchar(255) CHARACTER SET gbk NOT NULL COMMENT '备注',
  `params` text CHARACTER SET gbk COMMENT '加减积分的一些参数(如goods_id等)',
  PRIMARY KEY (`id`),
  KEY `user_id_type_id` (`customer_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `yj_member_level_and_point_tbl` */

DROP TABLE IF EXISTS `yj_member_level_and_point_tbl`;

CREATE TABLE `yj_member_level_and_point_tbl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `update_time` int(10) unsigned NOT NULL COMMENT '更新时间',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `plus_point_total` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '加积分的总',
  `minus_point_total` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '减积分的总',
  `bill_finish_num` int(10) DEFAULT '0' COMMENT '成功完成订单的次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员积分总表';

/*Table structure for table `yj_position_tbl` */

DROP TABLE IF EXISTS `yj_position_tbl`;

CREATE TABLE `yj_position_tbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '职位ID',
  `dep_id` int(11) NOT NULL COMMENT '职位所属部门',
  `position_name` varchar(50) NOT NULL COMMENT '职位名称',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态 1启用 2禁止',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `step` tinyint(3) NOT NULL DEFAULT '100' COMMENT '排序 越大越前',
  `add_user_id` int(11) NOT NULL COMMENT '添加人ID',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=185 DEFAULT CHARSET=utf8 COMMENT='员工职位表';

/*Table structure for table `yj_preferential_activities` */

DROP TABLE IF EXISTS `yj_preferential_activities`;

CREATE TABLE `yj_preferential_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(255) NOT NULL COMMENT '活动名称',
  `begin_time` int(11) NOT NULL COMMENT '开始时间',
  `end_time` int(11) NOT NULL COMMENT '结束时间',
  `level` varchar(255) NOT NULL COMMENT '适用会员等级',
  `activity_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '活动状态',
  `is_add` tinyint(4) NOT NULL COMMENT '会员等级是否优惠叠加 1是 -1否',
  `activity_rules_id` tinyint(4) NOT NULL COMMENT '活动规则id',
  `activity_rules_mode` varchar(255) NOT NULL COMMENT '活动优惠具体规则',
  `goods_type_id` text COMMENT '产品类型ID',
  `add_user_id` int(11) NOT NULL COMMENT '创建人ID',
  `params` text COMMENT '接收的产品列表',
  `update_user_id` int(11) DEFAULT NULL COMMENT '更新人员ID',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='优惠活动表';

/*Table structure for table `yj_preferential_activities_goods_list` */

DROP TABLE IF EXISTS `yj_preferential_activities_goods_list`;

CREATE TABLE `yj_preferential_activities_goods_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID 对应的商品列表ID',
  `act_id` int(10) unsigned NOT NULL COMMENT '活动id',
  `goods_id` int(10) NOT NULL COMMENT '补充参与活动的商品id',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='优惠活动商品关联表';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
