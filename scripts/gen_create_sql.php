<?php


echo <<<SQL
USE `acrosstime`;

-- ================================================
-- ACCOUNTS
-- ================================================

-- ------------------------------------------------
-- USERS
-- ------------------------------------------------


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_general_ci NOT NULL,
  `handle` varchar(255) NOT NULL,
  `pass_hash` char(64) NOT NULL,
  `reset_token` char(32) DEFAULT NULL,
  `ap` int(10) unsigned NOT NULL DEFAULT '0',
  `rp` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_uq` (`email`),
  UNIQUE KEY `handle_uq` (`handle`),
  UNIQUE KEY `reset_token_uq` (`reset_token`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_bin;


-- ------------------------------------------------
-- SESSIONS
-- ------------------------------------------------


DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(128) COLLATE utf8_bin NOT NULL,
  `content` text DEFAULT NULL,
  `ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


SQL;


echo <<<SQL
-- ------------------------------------------------
-- CORE
-- ------------------------------------------------


DROP TABLE IF EXISTS `timelogs`;
CREATE TABLE `timelogs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `minutes` int(10) unsigned NOT NULL DEFAULT '0',
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `threads`;
CREATE TABLE `threads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `forum_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `title_idx` (`title`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `title_idx` (`title`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;



SQL;



foreach ($arg as $a) {
	$x = strtoupper($a);
	echo <<<SQL
--
-- $x ORGANIZATION
--

DROP TABLE IF EXISTS `{$a}_cat_dicts`;
CREATE TABLE `{$a}_cat_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `{$a}_tag_dicts`;
CREATE TABLE `{$a}_tag_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_bin;

--
-- $x ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `{$a}_cats`;
CREATE TABLE `{$a}_cats` (
  `{$a}_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`timelog_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `{$a}_tags`;
CREATE TABLE `timelog_tags` (
  `{$a}_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`timelog_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


--
-- $x SOCIAL
--

DROP TABLE IF EXISTS `{$a}_likes`;
CREATE TABLE `{$a}_likes` (
  `{$a}_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`thread_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


SQL;


}

