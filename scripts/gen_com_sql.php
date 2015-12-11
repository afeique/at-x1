<?php

echo <<<SQL

USE `acrosstime`;

SQL;

$arg = array('timelog', 'thread', 'story', 'article', 'art', 'music', 'community', 'forum');

foreach ($arg as $a):
$x = strtoupper($a);
echo <<<SQL

-- ------------------------------------------------
-- $x COMMON
-- ------------------------------------------------

--
-- $x DICTS
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
-- $x DICT RELATIONS
--

DROP TABLE IF EXISTS `{$a}_cats`;
CREATE TABLE `{$a}_cats` (
  `{$a}_id` int(10) unsigned NOT NULL,
  `dict_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`{$a}_id`, `dict_id`),
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
  `ts` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`{$a}_id`, `user_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;


SQL;

endforeach;


$arg = array('timelog', 'thread', 'story', 'article', 'art', 'music');

foreach ($arg as $a):
$x = strtoupper($a);
echo <<<SQL

-- ------------------------------------------------
-- POSTS
-- ------------------------------------------------

SQL;

echo <<<SQL

--
-- $x POSTS
--

DROP TABLE IF EXISTS `{$a}_posts`;
CREATE TABLE `{$a}_posts` (
  `{$a}_id` int(10) unsigned NOT NULL,
  `post_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`{$a}_id`, `user_id`),
  KEY `post_id_idx` (`post_id`)
) ENGINE=INNODB DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

SQL;


endforeach;