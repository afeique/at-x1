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
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
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
  `id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
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
CREATE TABLE `user_games` (
  `user_id` int(10) unsigned NOT NULL,
  `platform_id` int(10) unsigned NOT NULL,
  `handle` varchar(40) unsigned NOT NULL,
  PRIMARY KEY (`user_id`, `platform_id`),
  KEY `platform_id_idx` (`platform_id`),
  KEY `handle_idx` (`handle`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `game_platforms`;
CREATE TABLE `user_games` (
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

DROP TABLE IF EXISTS `timelog_comments`;
CREATE TABLE `timelog_comments` (
  `id` int(10) unsigned NOT NULL,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `timelog_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`),
  KEY `timelog_id_idx` (`timelog_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `timelog_likes`;
CREATE TABLE `timelog_likes` (
  `timelog_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`timelog_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `timelog_comment_likes`;
CREATE TABLE `timelog_comment_likes` (
  `comment_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`comment_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;



-- ------------------------------------------------
-- POSTS
-- ------------------------------------------------


DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATION
--

DROP TABLE IF EXISTS `post_cat_dicts`;
CREATE TABLE `post_cat_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `post_tag_dicts`;
CREATE TABLE `post_tag_dicts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `post_cats`;
CREATE TABLE `post_cats` (
  `post_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`post_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `post_tags`;
CREATE TABLE `post_tags` (
  `post_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`post_id`, `dict_id`),
  KEY `dict_id_idx` (`dict_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- SOCIAL
--

DROP TABLE IF EXISTS `post_comments`;
CREATE TABLE `post_comments` (
  `id` int(10) unsigned NOT NULL,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`),
  KEY `post_id_idx` (`post_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `post_likes`;
CREATE TABLE `post_likes` (
  `post_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`post_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `post_comment_likes`;
CREATE TABLE `post_comment_likes` (
  `comment_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`comment_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

--
-- CORE RELATIONS
--

DROP TABLE IF EXISTS `post_timelogs`;
CREATE TABLE `post_timelogs` (
  `post_id` int(10) unsigned NOT NULL,
  `timelog_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`post_id`, `timelog_id`),
  KEY `timelog_id_idx` (`timelog_id`)
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

DROP TABLE IF EXISTS `story_comments`;
CREATE TABLE `story_comments` (
  `id` int(10) unsigned NOT NULL,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `story_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`),
  KEY `story_id_idx` (`story_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `story_likes`;
CREATE TABLE `story_likes` (
  `story_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`story_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `story_comment_likes`;
CREATE TABLE `story_comment_likes` (
  `comment_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`comment_id`, `user_id`),
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

DROP TABLE IF EXISTS `article_comments`;
CREATE TABLE `article_comments` (
  `id` int(10) unsigned NOT NULL,
  `content` text NOT NULL,
  `creation_ts` int(10) unsigned NOT NULL,
  `modified_ts` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `article_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`),
  KEY `article_id_idx` (`article_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `article_likes`;
CREATE TABLE `article_likes` (
  `article_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`article_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

DROP TABLE IF EXISTS `article_comment_likes`;
CREATE TABLE `article_comment_likes` (
  `comment_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`comment_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;