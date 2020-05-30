/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : clouddb01

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2020-05-30 23:50:05
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept` (
  `deptno` bigint(20) NOT NULL AUTO_INCREMENT,
  `dname` varchar(60) DEFAULT NULL,
  `db_source` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`deptno`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dept
-- ----------------------------
INSERT INTO `dept` VALUES ('1', '开发部', 'cloudDB01');
INSERT INTO `dept` VALUES ('2', '人事部', 'cloudDB01');
INSERT INTO `dept` VALUES ('3', '财务部', 'cloudDB01');
INSERT INTO `dept` VALUES ('4', '市场部', 'cloudDB01');
INSERT INTO `dept` VALUES ('5', '运维部', 'cloudDB01');
INSERT INTO `dept` VALUES ('6', 'deptyan', 'cloudDB01');
