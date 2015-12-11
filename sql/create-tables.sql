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
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


-- ================================================
-- GAMES
-- ================================================

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


-- ================================================
-- CORE
-- ================================================


-- ------------------------------------------------
-- TIMELOGS
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

--
-- ORGANIZATION
--

DROP TABLE IF EXISTS `timelog_cat_dicts`;
CREATE TABLE `timelog_cat_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `timelog_tag_dicts`;
CREATE TABLE `timelog_tag_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `timelog_cats`;
CREATE TABLE `timelog_cats` (
  `timelog_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`timelog_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `timelog_tags`;
CREATE TABLE `timelog_tags` (
  `timelog_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`timelog_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- SOCIAL
--

DROP TABLE IF EXISTS `timelog_likes`;
CREATE TABLE `timelog_likes` (
  `timelog_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`timelog_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;



-- ------------------------------------------------
-- THREADS
-- ------------------------------------------------


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

--
-- ORGANIZATION
--

DROP TABLE IF EXISTS `thread_cat_dicts`;
CREATE TABLE `thread_cat_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `thread_tag_dicts`;
CREATE TABLE `thread_tag_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `thread_cats`;
CREATE TABLE `thread_cats` (
  `thread_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`thread_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `thread_tags`;
CREATE TABLE `thread_tags` (
  `thread_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`thread_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- SOCIAL
--

DROP TABLE IF EXISTS `thread_likes`;
CREATE TABLE `thread_likes` (
  `thread_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`thread_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
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
  PRIMARY KEY (`id`),
  KEY `title_idx` (`title`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATION
--

DROP TABLE IF EXISTS `story_cat_dicts`;
CREATE TABLE `story_cat_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `story_tag_dicts`;
CREATE TABLE `story_tag_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `story_cats`;
CREATE TABLE `story_cats` (
  `story_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`story_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `story_tags`;
CREATE TABLE `story_tags` (
  `story_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`story_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- SOCIAL
--

DROP TABLE IF EXISTS `story_likes`;
CREATE TABLE `story_likes` (
  `story_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`story_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


-- ------------------------------------------------
-- ARTICLES
-- ------------------------------------------------


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

--
-- ORGANIZATION
--

DROP TABLE IF EXISTS `article_cat_dicts`;
CREATE TABLE `article_cat_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `article_tag_dicts`;
CREATE TABLE `article_tag_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `article_cats`;
CREATE TABLE `article_cats` (
  `article_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`article_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `article_tags`;
CREATE TABLE `article_tags` (
  `article_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`article_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- SOCIAL
--

DROP TABLE IF EXISTS `article_likes`;
CREATE TABLE `article_likes` (
  `article_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`article_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;
