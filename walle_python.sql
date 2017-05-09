/*
 Navicat Premium Data Transfer

 Source Server         : localdata
 Source Server Type    : MySQL
 Source Server Version : 50704
 Source Host           : localhost
 Source Database       : walle-python

 Target Server Type    : MySQL
 Target Server Version : 50704
 File Encoding         : utf-8

 Date: 05/09/2017 14:46:46 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `environment`
-- ----------------------------
DROP TABLE IF EXISTS `environment`;
CREATE TABLE `environment` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(100) DEFAULT 'master' COMMENT '环境名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0无效，1有效',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='项目环境配置表';

-- ----------------------------
--  Records of `environment`
-- ----------------------------
BEGIN;
INSERT INTO `environment` VALUES ('2', '开发环境', '1', '2017-03-08 17:26:07', '2017-03-08 17:26:07');
COMMIT;

-- ----------------------------
--  Table structure for `my`
-- ----------------------------
DROP TABLE IF EXISTS `my`;
CREATE TABLE `my` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` int(1) NOT NULL DEFAULT '0' COMMENT '成交的所有收',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `my`
-- ----------------------------
BEGIN;
INSERT INTO `my` VALUES ('1', '9', '2017-04-18 09:35:45', '2017-04-18 09:35:45'), ('2', '19', '2017-04-18 09:35:57', '2017-04-18 09:35:57'), ('3', '199999', '2017-04-18 09:36:54', '2017-04-18 09:36:54'), ('4', '99999999', '2017-04-18 09:37:07', '2017-04-18 09:37:07');
COMMIT;

-- ----------------------------
--  Table structure for `permission`
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `name_cn` varchar(30) NOT NULL COMMENT '模块中文名称',
  `name_en` varchar(30) NOT NULL COMMENT '模块英文名称',
  `pid` int(6) NOT NULL COMMENT '父模块id，顶级pid为0',
  `type` enum('action','controller','module') DEFAULT 'action' COMMENT '类型',
  `sequence` int(11) DEFAULT '0' COMMENT '排序序号sprintf("%2d%2d%2d", module_id, controller_id, 自增两位数)',
  `archive` tinyint(1) NOT NULL DEFAULT '0' COMMENT '归档：0有效，1无效',
  `icon` varchar(30) DEFAULT '' COMMENT '模块',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='权限表';

-- ----------------------------
--  Table structure for `project`
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `user_id` int(10) NOT NULL COMMENT '添加项目的用户id',
  `name` varchar(100) DEFAULT 'master' COMMENT '项目名字',
  `environment_id` int(1) NOT NULL COMMENT 'environment的id',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0无效，1有效',
  `version` varchar(40) DEFAULT '' COMMENT '线上当前版本，用于快速回滚',
  `excludes` text COMMENT '要排除的文件',
  `target_user` varchar(50) NOT NULL COMMENT '目标机器的登录用户',
  `target_root` varchar(200) NOT NULL COMMENT '目标机器的 server 目录',
  `target_library` varchar(200) NOT NULL COMMENT '目标机器的版本库',
  `servers` text COMMENT '目标机器列表',
  `prev_deploy` text COMMENT '部署前置任务',
  `post_deploy` text COMMENT '同步之前任务',
  `prev_release` text COMMENT '同步之前目标机器执行的任务',
  `post_release` text COMMENT '同步之后目标机器执行的任务',
  `post_release_delay` int(11) NOT NULL DEFAULT '0' COMMENT '每台目标机执行post_release任务间隔/延迟时间 单位:秒',
  `keep_version_num` int(3) NOT NULL DEFAULT '20' COMMENT '线上版本保留数',
  `repo_url` varchar(200) DEFAULT '' COMMENT 'git地址',
  `repo_username` varchar(50) DEFAULT '' COMMENT '版本管理系统的用户名，一般为svn的用户名',
  `repo_password` varchar(50) DEFAULT '' COMMENT '版本管理系统的密码，一般为svn的密码',
  `repo_mode` varchar(50) DEFAULT 'branch' COMMENT '上线方式：branch/tag',
  `repo_type` varchar(10) DEFAULT 'git' COMMENT '上线方式：git/svn',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='项目配置表';

-- ----------------------------
--  Records of `project`
-- ----------------------------
BEGIN;
INSERT INTO `project` VALUES ('1', '1', '瓦力自部署', '1', '1', '12121', '.log', 'wushuiyong', '/home/wushuiyong/walle/webroot', '/home/wushuiyong/walle/release', null, null, null, null, null, '0', '20', 'git@bitbucket.org:wushuiyong/walle-web.git', '', '', 'branch', 'git', '2017-03-11 23:30:53', '2017-03-11 23:31:48');
COMMIT;

-- ----------------------------
--  Table structure for `project_server`
-- ----------------------------
DROP TABLE IF EXISTS `project_server`;
CREATE TABLE `project_server` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `project_id` int(10) NOT NULL COMMENT '项目名字',
  `server_id` int(10) NOT NULL COMMENT '被打标签的实物id： 如 server.id',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='项目与服务器关系表';

-- ----------------------------
--  Records of `project_server`
-- ----------------------------
BEGIN;
INSERT INTO `project_server` VALUES ('1', '1', '1', '2017-03-11 23:37:50', '2017-03-11 23:37:50'), ('2', '1', '2', '2017-03-11 23:37:56', '2017-03-11 23:37:56'), ('3', '1', '3', '2017-03-11 23:38:03', '2017-03-11 23:38:03');
COMMIT;

-- ----------------------------
--  Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL COMMENT '角色名称',
  `permission_ids` text COMMENT '权限id列表,逗号分隔',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
--  Records of `role`
-- ----------------------------
BEGIN;
INSERT INTO `role` VALUES ('1', '技术人员', '1,2,3,5', '2017-03-24 13:52:09', '2017-03-24 13:52:09'), ('2', '测试同学', '1,3,5,7', '2017-03-26 13:23:44', '2017-03-26 13:23:44');
COMMIT;

-- ----------------------------
--  Table structure for `server`
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `name` varchar(100) DEFAULT '' COMMENT 'server name',
  `host` varchar(30) NOT NULL COMMENT 'ip/host',
  `port` int(1) DEFAULT '22' COMMENT 'ssh port',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='服务器记录表';

-- ----------------------------
--  Records of `server`
-- ----------------------------
BEGIN;
INSERT INTO `server` VALUES ('1', 'dev-wushuiyong', '172.16.0.231', '22', '2017-03-11 23:34:27', '2017-03-11 23:34:27'), ('2', 'mkt-dev-ky', '172.16.0.194', '22', '2017-03-11 23:35:12', '2017-03-11 23:35:12'), ('3', 'mkt-dev-yindongyang', '172.16.0.177', '22', '2017-03-11 23:37:18', '2017-03-11 23:37:18');
COMMIT;

-- ----------------------------
--  Table structure for `tag`
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `name` varchar(100) DEFAULT 'master' COMMENT '标签',
  `label` varchar(20) NOT NULL COMMENT '标签类型：server, ',
  `label_id` int(10) NOT NULL COMMENT '被打标签的实物id： 如 server.id',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='tag 标签表';

-- ----------------------------
--  Records of `tag`
-- ----------------------------
BEGIN;
INSERT INTO `tag` VALUES ('1', '用户端FE', 'user_group', '0', '2017-05-08 19:56:19', '2017-05-08 19:56:19'), ('2', '营销中心', 'user_group', '0', '2017-05-08 19:57:05', '2017-05-08 19:57:05'), ('3', '黄晓露', 'user_group', '0', '2017-05-08 20:52:55', '2017-05-08 21:06:38');
COMMIT;

-- ----------------------------
--  Table structure for `task`
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `user_id` bigint(21) unsigned NOT NULL COMMENT '用户id',
  `project_id` int(11) NOT NULL COMMENT '项目id',
  `action` int(1) DEFAULT '0' COMMENT '0全新上线，2回滚',
  `status` tinyint(1) NOT NULL COMMENT '状态0：新建提交，1审核通过，2审核拒绝，3上线完成，4上线失败',
  `title` varchar(100) NOT NULL COMMENT '上线单标题',
  `link_id` varchar(100) DEFAULT '' COMMENT '上线的软链号',
  `ex_link_id` varchar(100) DEFAULT '' COMMENT '被替换的上次上线的软链号',
  `servers` text COMMENT '上线的机器',
  `commit_id` varchar(40) DEFAULT '' COMMENT 'git commit id',
  `branch` varchar(100) DEFAULT 'master' COMMENT '选择上线的分支',
  `file_transmission_mode` smallint(3) NOT NULL DEFAULT '1' COMMENT '上线文件模式: 1.全量所有文件 2.指定文件列表',
  `file_list` text COMMENT '文件列表，svn上线方式可能会产生',
  `enable_rollback` int(1) NOT NULL DEFAULT '1' COMMENT '能否回滚此版本0：no 1：yes',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='上线单记录表';

-- ----------------------------
--  Records of `task`
-- ----------------------------
BEGIN;
INSERT INTO `task` VALUES ('1', '1', '1', '0', '1', 'Demo 测试上线单', 'prev_link_id_test', 'prev_link_id_test', '172.16.0.231,172.16.0.177', '5bf82db', 'master', '1', null, '1', '2017-03-11 23:41:24', '2017-03-11 23:45:10'), ('2', '1', '1', '0', '1', '测试使用 vue 2.0', 'vue_import', 'prev_link_id_test', '172.16.0.231,172.16.0.177', '5bf82db', 'master', '1', null, '1', '2017-03-12 17:31:55', '2017-03-12 17:32:11'), ('3', '1', '1', '0', '1', '到底 vue2 与 jinja 2 会产生什么样的火花呢？', 'vue_jinja', 'vue_import', '172.16.0.231,172.16.0.177', '5bf82db', 'master', '1', null, '1', '2017-03-12 17:32:59', '2017-03-12 17:33:29');
COMMIT;

-- ----------------------------
--  Table structure for `task_record`
-- ----------------------------
DROP TABLE IF EXISTS `task_record`;
CREATE TABLE `task_record` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `stage` varchar(20) DEFAULT NULL COMMENT '阶段',
  `sequence` int(10) DEFAULT NULL COMMENT '序列号',
  `user_id` int(21) unsigned NOT NULL COMMENT '用户id',
  `task_id` bigint(11) NOT NULL COMMENT 'Task id',
  `status` tinyint(1) NOT NULL COMMENT '状态0：新建提交，1审核通过，2审核拒绝，3上线完成，4上线失败',
  `command` text COMMENT '命令与参数',
  `success` text COMMENT '成功返回信息',
  `error` text COMMENT '错误信息',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8 COMMENT='任务执行记录表';

-- ----------------------------
--  Records of `task_record`
-- ----------------------------
BEGIN;
INSERT INTO `task_record` VALUES ('98', 'prev_deploy', '1', '33', '1', '1', 'whoami', 'wushuiyong', '', '2017-03-15 18:32:51', '2017-03-15 18:32:51'), ('99', 'prev_deploy', '1', '33', '32', '1', 'python --version', 'Python 2.7.10', '', '2017-03-15 18:32:51', '2017-03-15 18:32:51'), ('100', 'prev_deploy', '1', '33', '32', '1', 'git --version', 'git version 2.2.2', '', '2017-03-15 18:32:51', '2017-03-15 18:32:51'), ('101', 'prev_deploy', '1', '33', '32', '1', 'mkdir -p None', '', '', '2017-03-15 18:32:51', '2017-03-15 18:32:51'), ('102', 'prev_deploy', '1', '33', '1', '1', 'whoami', 'wushuiyong', '', '2017-03-15 18:34:16', '2017-03-15 18:34:16'), ('103', 'prev_deploy', '1', '33', '32', '1', 'python --version', 'Python 2.7.10', '', '2017-03-15 18:34:16', '2017-03-15 18:34:16'), ('104', 'prev_deploy', '1', '33', '32', '1', 'git --version', 'git version 2.2.2', '', '2017-03-15 18:34:16', '2017-03-15 18:34:16'), ('105', 'prev_deploy', '1', '33', '32', '1', 'mkdir -p None', '', '', '2017-03-15 18:34:16', '2017-03-15 18:34:16'), ('106', 'prev_deploy', '1', '33', '1', '1', 'whoami', 'wushuiyong', '', '2017-03-15 18:34:57', '2017-03-15 18:34:57'), ('107', 'prev_deploy', '1', '33', '32', '1', 'python --version', 'Python 2.7.10', '', '2017-03-15 18:34:58', '2017-03-15 18:34:58'), ('108', 'prev_deploy', '1', '33', '32', '1', 'git --version', 'git version 2.2.2', '', '2017-03-15 18:34:58', '2017-03-15 18:34:58'), ('109', 'prev_deploy', '1', '33', '32', '1', 'mkdir -p /Users/wushuiyong/workspace/meolu/data/codebase/walle-web', '', '', '2017-03-15 18:34:58', '2017-03-15 18:34:58'), ('110', 'prev_deploy', '1', '33', '1', '1', 'whoami', 'wushuiyong', '', '2017-03-15 18:36:28', '2017-03-15 18:36:28'), ('111', 'prev_deploy', '1', '33', '32', '1', 'python --version', 'Python 2.7.10', '', '2017-03-15 18:36:28', '2017-03-15 18:36:28'), ('112', 'prev_deploy', '1', '33', '32', '1', 'git --version', 'git version 2.2.2', '', '2017-03-15 18:36:28', '2017-03-15 18:36:28'), ('113', 'prev_deploy', '1', '33', '32', '1', 'mkdir -p /Users/wushuiyong/workspace/meolu/data/codebase/walle-web', '', '', '2017-03-15 18:36:28', '2017-03-15 18:36:28'), ('114', 'prev_deploy', '1', '33', '1', '1', 'whoami', 'wushuiyong', '', '2017-03-16 11:02:28', '2017-03-16 11:02:28'), ('115', 'prev_deploy', '1', '33', '32', '1', 'python --version', 'Python 2.7.10', '', '2017-03-16 11:02:29', '2017-03-16 11:02:29'), ('116', 'prev_deploy', '1', '33', '32', '1', 'git --version', 'git version 2.2.2', '', '2017-03-16 11:02:29', '2017-03-16 11:02:29'), ('117', 'prev_deploy', '1', '33', '32', '1', 'mkdir -p /Users/wushuiyong/workspace/meolu/data/codebase/walle-web', '', '', '2017-03-16 11:02:29', '2017-03-16 11:02:29'), ('118', 'prev_deploy', '1', '33', '1', '1', 'whoami', 'wushuiyong', '', '2017-03-16 11:03:47', '2017-03-16 11:03:47'), ('119', 'prev_deploy', '1', '33', '32', '1', 'python --version', 'Python 2.7.10', '', '2017-03-16 11:03:47', '2017-03-16 11:03:47'), ('120', 'prev_deploy', '1', '33', '32', '1', 'git --version', 'git version 2.2.2', '', '2017-03-16 11:03:47', '2017-03-16 11:03:47'), ('121', 'prev_deploy', '1', '33', '32', '1', 'mkdir -p /Users/wushuiyong/workspace/meolu/data/codebase/walle-web', '', '', '2017-03-16 11:03:47', '2017-03-16 11:03:47');
COMMIT;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户昵称',
  `is_email_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否邮箱认证',
  `email` varchar(50) NOT NULL COMMENT '邮箱',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `password_hash` varchar(50) NOT NULL COMMENT 'hash',
  `avatar` varchar(100) DEFAULT 'default.jpg' COMMENT '头像图片地址',
  `role_id` int(6) NOT NULL COMMENT '角色id',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态: 0新建，1正常，2冻结',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
--  Records of `user`
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', 'wushuiyong', '1', 'wushuiyong@renrenche.com', '', '', 'default.jpg', '1', '1', '2017-03-17 09:03:09', '2017-03-17 09:03:09'), ('13', 'wushuiyong@local.com', '0', 'wushuiyong@walle-web.io', 'pbkdf2:sha1:1000$59T3110Q$7703684fd0bb722985b037703329c82891acd84b', '', null, '0', '0', '2017-03-20 19:05:44', '2017-04-13 14:52:06'), ('14', 'wushuiyong@walle-web.ios', '0', 'wushuiyong@walle-web.ios', 'pbkdf2:sha1:1000$KSjsIBCf$762bf8c30adc6eef288df31547dbd80fa8b81c93', '', null, '0', '0', '2017-04-13 15:03:57', '2017-04-13 15:03:57'), ('15', 'wushuiyong@walle-web.ioss', '0', 'wushuiyong@walle-web.ioss', 'pbkdf2:sha1:1000$We4EXI4O$c363470dbc91d9bf897fec3a76fdedeaf5f564b8', '', null, '0', '0', '2017-04-13 15:03:57', '2017-04-13 15:03:57');
COMMIT;

-- ----------------------------
--  Table structure for `user_group`
-- ----------------------------
DROP TABLE IF EXISTS `user_group`;
CREATE TABLE `user_group` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `user_id` int(10) DEFAULT '0' COMMENT '用户id',
  `group_id` int(10) DEFAULT '0' COMMENT '用户组id',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户组关联表';

-- ----------------------------
--  Records of `user_group`
-- ----------------------------
BEGIN;
INSERT INTO `user_group` VALUES ('1', '13', '1', '2017-05-08 19:56:38', '2017-05-08 19:56:38');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
