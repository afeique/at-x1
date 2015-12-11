<?php


foreach ($arg as $a) {
	$_cat_dict = <<<SQL
--
-- ORGANIZATION
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
-- ORGANIZATIONAL RELATIONS
--

DROP TABLE IF EXISTS `{$a}_cats`;
CREATE TABLE `timelog_cats` (
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
SQL;


}


$a = array();


$arg = array(
	'timelog', 
	'thread', 
	'story', 
	'article', 
	'art', 
	'music', 
	'forum', 
	'community',
);
$engine = 'INNODB';
$base_config = array(
	'ENGINE' => $engine,
	'DEFAULT CHARACTER SET' => 'utf8',
	'COLLATE' => 'utf8_general_ci'
);

foreach ($arg as $s) 
{
	$a = array(
		array(
			'name' => $s .'_cat_dict',
			'fields' => array(
				'id' => 'int(10) unsigned NOT NULL AUTO_INCREMENT',
				'name' => 'varchar(40) NOT NULL',
				'parent_id' => 'int(10) unsigned DEFAULT NULL',
				'PRIMARY KEY' => 'id',
				'INDEX' => 'parent_id',
			),
			'config' => $base_config,
		),
		array(
			'name' => $s .'_cats',
			'fields' => array(
				$s .'_id' => 'int(10) unsigned NOT NULL',
				'dict_id' => 'int(10) unsigned NOT NULL',
				'PRIMARY KEY' => array($s .'_id', 'dict_id'),
			),
			'config' => $base_config,
		),
		array(
			'name' => $s .'_tag_dict',
			'fields' => array(
				'id' => 'int(10) unsigned NOT NULL AUTO_INCREMENT',
				'name' => 'varchar(40)',
				'PRIMARY KEY' => 'id',
			),
			'config' => $base_config
		),
	);
}

$core_org = array(
	'_cat_dict' = array(
		'_id',
		'dict_id',
	),
	'_tag_dict' = array(
		'_id',
		'dict_id',
	),
	'_cats' = array(
		'_id',
		'dict_id',
	),
	'_tags' = array(

	)
);

namespace ATX;

class Table implements ArrayAccess {
	public $ids = NULL;
	public $title = NULL;
	public $name = NULL;
	public $desc = NULL;
	public $uri = NULL;
	public $ts = NULL;
	public $creation_ts = NULL;
	public $modified_ts = NULL;


	
	public function offsetExists($offset) {

	}


} 
