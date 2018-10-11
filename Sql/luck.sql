-- phpMyAdmin SQL Dump
-- version phpStudy 2014
-- http://www.phpmyadmin.net
-- 作者：yule
-- 主机: localhost
-- 生成日期: 2017 年 02 月 08 日 06:56
-- 服务器版本: 5.5.53
-- PHP 版本: 5.4.45

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


-- --------------------------------------------------------

--
-- 表的结构 `hr_lucky_draw`
--

CREATE TABLE IF NOT EXISTS `hr_lucky_draw` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL COMMENT '活动名称',
  `description` text COMMENT '活动描述',
  `start_time` int(10) DEFAULT NULL COMMENT '开始时间',
  `end_time` int(10) DEFAULT NULL COMMENT '结束时间',
  `add_time` int(10) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `hr_lucky_draw`
--

INSERT INTO `hr_lucky_draw` (`id`, `title`, `description`, `start_time`, `end_time`, `add_time`) VALUES
(1, 'dwwdadw2323', '212232ssss', 1486274280, 1487143560, 1486281970),


-- --------------------------------------------------------

--
-- 表的结构 `hr_lucky_prize`
--

CREATE TABLE IF NOT EXISTS `hr_lucky_prize` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `prize` varchar(50) DEFAULT NULL COMMENT '奖品',
  `odds` decimal(4,2) DEFAULT NULL COMMENT '中奖几率，为整数',
  `number` int(4) DEFAULT NULL COMMENT '奖品数量',
  `remain_num` int(4) DEFAULT NULL COMMENT '剩余奖品数量',
  `draw_id` int(4) DEFAULT NULL COMMENT '抽奖活动的ID',
  `add_time` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- 转存表中的数据 `hr_lucky_prize`
--

INSERT INTO `hr_lucky_prize` (`id`, `prize`, `odds`, `number`, `remain_num`, `draw_id`, `add_time`) VALUES
(1, '华为P9', '0.00', 1, 1, 1, 1486352523),
(2, '现金888元', '0.00', 2, 2, 1, 1486348991),
(3, '100元话费', '0.20', 20, 20, 1, 1486353742),
(5, '50元话费', '0.30', 30, 30, 1, 1486353866),
(6, '30元话费', '0.50', 50, 50, 1, 1486353865),
(7, '10元话费', '1.00', 100, 100, 1, 1486353887),
(8, '代金券200元', '30.00', 800, 788, 1, 1486353884),
(13, '代金券300元', '10.00', 600, 597, 1, 1486353885),
(15, '100M流量', '1.00', 100, 100, 1, 1486353845);

-- --------------------------------------------------------

--
-- 表的结构 `hr_lucky_results`
--

CREATE TABLE IF NOT EXISTS `hr_lucky_results` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `member_id` int(8) DEFAULT NULL COMMENT '会员ID',
  `draw_id` int(4) DEFAULT NULL COMMENT '活动ID',
  `result_described` varchar(60) DEFAULT NULL COMMENT '描述记录',
  `is_win` int(4) DEFAULT '0' COMMENT '是否中奖,奖品ID，未中为0',
  `is_sure` tinyint(1) DEFAULT '0' COMMENT '是否已发奖',
  `add_time` int(10) DEFAULT NULL COMMENT '抽奖时间',
  `bj_time` int(10) DEFAULT NULL COMMENT '发奖时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=55 ;

--
-- 转存表中的数据 `hr_lucky_results`
--



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
