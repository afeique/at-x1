<?php

echo <<<SQL

USE `acrosstime`;

SQL;

echo <<<SQL

-- ------------------------------------------------
-- USERS
-- ------------------------------------------------


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
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


DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `content` text DEFAULT NULL,
  `ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_bin;


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


-- ------------------------------------------------
-- GAMES
-- ------------------------------------------------


DROP TABLE IF EXISTS `games`;
CREATE TABLE `games` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `platforms`;
CREATE TABLE `platforms` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(20) NOT NULL,
  `abbv` varchar(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`),
  KEY `abbv_idx` (`abbv`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- GAME RELATIONS
--

DROP TABLE IF EXISTS `user_games`;
CREATE TABLE `user_games` (
  `user_id` int(10) unsigned NOT NULL,
  `game_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`, `game_id`),
  KEY `game_id_idx` (`game_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `user_platforms`;
CREATE TABLE `user_platforms` (
  `user_id` int(10) unsigned NOT NULL,
  `platform_id` int(10) unsigned NOT NULL,
  `handle` varchar(40) NOT NULL,
  PRIMARY KEY (`user_id`, `platform_id`),
  KEY `platform_id_idx` (`platform_id`),
  KEY `handle_idx` (`handle`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `game_platforms`;
CREATE TABLE `game_platforms` (
  `game_id` int(10) unsigned NOT NULL,
  `platform_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`game_id`, `platform_id`),
  KEY `platform_id_idx` (`platform_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


-- ------------------------------------------------
-- STORIES
-- ------------------------------------------------


DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `private` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `title_idx` (`title`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


DROP TABLE IF EXISTS `chapters`;
CREATE TABLE `chapters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `story_id` int(10) unsigned NOT NULL,
  `private` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `title_idx` (`title`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `desc` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `story_id` int(10) unsigned NOT NULL,
  `private` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `desc` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `story_id` int(10) unsigned NOT NULL,
  `private` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `lore`;
CREATE TABLE `lore` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `desc` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `story_id` int(10) unsigned NOT NULL,
  `private` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `title_idx` (`title`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


SQL;

