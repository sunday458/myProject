/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : etemsdb

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2016-12-15 11:19:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher` (
  `teacher_id` int(11) NOT NULL AUTO_INCREMENT,
  `teacher_name` varchar(32) DEFAULT NULL,
  `teacher_password` varchar(32) DEFAULT NULL,
  `teacher_email` varchar(32) DEFAULT NULL,
  `teacher_date` datetime DEFAULT NULL,
  `teacher_note` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`teacher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES ('1', 'ck', '123456', '961900940@qq.com', '2016-12-15 10:17:56', '1111111');
INSERT INTO `teacher` VALUES ('2', 'ck2', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '2222222');
INSERT INTO `teacher` VALUES ('3', 'ck3', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '3333333');
INSERT INTO `teacher` VALUES ('4', 'ck4', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '4444444');
INSERT INTO `teacher` VALUES ('5', 'ck5', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '5555555');
INSERT INTO `teacher` VALUES ('6', 'ck6', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '6666666');
INSERT INTO `teacher` VALUES ('7', 'ck7', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '7777777');
INSERT INTO `teacher` VALUES ('8', 'ck8', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '8888888');
INSERT INTO `teacher` VALUES ('9', 'ck9', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '9999999');
INSERT INTO `teacher` VALUES ('10', 'ck10', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '10');
INSERT INTO `teacher` VALUES ('11', 'ck11', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '11');
INSERT INTO `teacher` VALUES ('12', 'ck12', '123456', '961900940@qq.com', '2016-12-15 10:18:36', '12');
