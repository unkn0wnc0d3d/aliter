CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `password` varchar(40) NOT NULL,
  `Email` varchar(60) NOT NULL,
  `gender` tinyint(1) NOT NULL default 1,
  `loginCount` mediumint(9) unsigned NOT NULL default 0,
  `lastLogin` datetime NULL,
  `lastIP` varchar(100) NULL,
  `gmLevel` tinyint(2) NOT NULL default 0,
  `banUntil` datetime NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) AUTO_INCREMENT=2000000;

CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `accountID` int(11) unsigned NOT NULL default 0,
  `charNum` tinyint(1) NOT NULL default 0,
  `name` varchar(30) NOT NULL,
  `job` smallint(6) unsigned NOT NULL default 0,
  `baseLevel` smallint(6) unsigned NOT NULL default 1,
  `baseExp` bigint(20) unsigned NOT NULL default 0,
  `jobLevel` smallint(6) unsigned NOT NULL default 1,
  `jobExp` bigint(20) unsigned NOT NULL default 0,
  `zeny` int(11) unsigned NOT NULL default 0,
  `str` smallint(4) unsigned NOT NULL default 0,
  `agi` smallint(4) unsigned NOT NULL default 0,
  `vit` smallint(4) unsigned NOT NULL default 0,
  `int` smallint(4) unsigned NOT NULL default 0,
  `dex` smallint(4) unsigned NOT NULL default 0,
  `luk` smallint(4) unsigned NOT NULL default 0,
  `maxHP` mediumint(8) unsigned NOT NULL default 0,
  `hp` mediumint(8) unsigned NOT NULL default 0,
  `maxSP` mediumint(6) unsigned NOT NULL default 0,
  `sp` mediumint(6) unsigned NOT NULL default 0,
  `statusPoints` smallint(4) unsigned NOT NULL default 0,
  `skillPoints` smallint(4) unsigned NOT NULL default 0,
  `partyID` int(11) unsigned NOT NULL default 0,
  `guildID` int(11) unsigned NOT NULL default 0,
  `petID` int(11) unsigned NOT NULL default 0,
  `homunculusID` int(11) unsigned NOT NULL default 0,
  `mercenaryID` int(11) unsigned NOT NULL default 0,
  `hairStyle` tinyint(4) unsigned NOT NULL default 0,
  `hairColor` smallint(5) unsigned NOT NULL default 0,
  `clothesColor` smallint(5) unsigned NOT NULL default 0,
  `viewWeapon` smallint(6) unsigned NOT NULL default 1,
  `viewShield` smallint(6) unsigned NOT NULL default 0,
  `viewHeadTop` smallint(6) unsigned NOT NULL default 0,
  `viewHeadMiddle` smallint(6) unsigned NOT NULL default 0,
  `viewHeadBottom` smallint(6) unsigned NOT NULL default 0,
  `map` varchar(20) NOT NULL default 'new_zone01',
  `x` smallint(4) unsigned NOT NULL default 53,
  `y` smallint(4) unsigned NOT NULL default 111,
  `saveMap` varchar(20) NOT NULL default 'new_zone01',
  `saveX` smallint(4) unsigned NOT NULL default 53,
  `saveY` smallint(4) unsigned NOT NULL default 111,
  `online` tinyint(2) NOT NULL default 0,
  `fame` int(11) unsigned NOT NULL default 0,
  `guildPositionID` int(11) unsigned NOT NULL default 0,
  `guildTaxed` int(11) unsigned NOT NULL default 0,
  PRIMARY KEY  (`id`),
  KEY `partyID` (`partyID`),
  KEY `guildID` (`guildID`),
  KEY `name` (`name`),
  KEY `online` (`online`)
) AUTO_INCREMENT=150000;

CREATE TABLE IF NOT EXISTS `guildCastle` (
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `guildID` int(11) unsigned NOT NULL DEFAULT '0',
  `economy` int(11) unsigned NOT NULL DEFAULT '0',
  `defense` int(11) unsigned NOT NULL DEFAULT '0',
  `investedEconomy` int(11) unsigned NOT NULL DEFAULT '0',
  `investedDefence` int(11) unsigned NOT NULL DEFAULT '0',
  `nextTime` int(11) unsigned NOT NULL DEFAULT '0',
  `payTime` int(11) unsigned NOT NULL DEFAULT '0',
  `createTime` int(11) unsigned NOT NULL DEFAULT '0',
  `kafraHired` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian1` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian2` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian3` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian4` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian5` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian6` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian7` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `guardian8` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `guildID` (`guildID`)
);

CREATE TABLE IF NOT EXISTS `guildEmblems` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guildID` int(11) unsigned NOT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `guildExpulsion` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guildID` int(11) unsigned NOT NULL DEFAULT '0',
  `characterID` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL DEFAULT '',
  `reason` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `guildPositions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guildID` int(9) unsigned NOT NULL DEFAULT '0',
  `positionID` tinyint(2) unsigned NOT NULL,
  `name` varchar(24) NOT NULL DEFAULT '',
  `mode` tinyint(11) unsigned NOT NULL DEFAULT '0',
  `tax` tinyint(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `guildID` (`guildID`,`positionID`)
);

CREATE TABLE IF NOT EXISTS `guildRelations` (
  `guildID` int(11) unsigned NOT NULL DEFAULT '0',
  `relatedID` int(11) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL DEFAULT '',
  `type` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`guildID`,`relatedID`,`type`),
  KEY `relatedID` (`relatedID`)
);

CREATE TABLE IF NOT EXISTS `guilds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL DEFAULT '',
  `masterID` int(11) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(6) unsigned NOT NULL DEFAULT '0',
  `connectedMembers` tinyint(6) unsigned NOT NULL DEFAULT '0',
  `capacity` tinyint(6) unsigned NOT NULL DEFAULT '0',
  `averageLevel` smallint(6) unsigned NOT NULL DEFAULT '1',
  `exp` int(11) unsigned NOT NULL DEFAULT '0',
  `nextExp` int(11) unsigned NOT NULL DEFAULT '0',
  `skillPoints` tinyint(11) unsigned NOT NULL DEFAULT '0',
  `messageTitle` varchar(60) NOT NULL,
  `messageBody` varchar(120) NOT NULL,
  PRIMARY KEY (`id`,`masterID`),
  KEY `masterID` (`masterID`)
);

CREATE TABLE IF NOT EXISTS `inventory` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `characterID` int(11) unsigned NOT NULL default 0,
  `itemID` int(11) unsigned NOT NULL default 0,
  `amount` int(11) unsigned NOT NULL default 1,
  `equipLocation` mediumint(8) unsigned NOT NULL default 0,
  `identified` tinyint(1) NOT NULL default 0,
  `refine` tinyint(3) unsigned NOT NULL default 0,
  `broken` tinyint(1) unsigned NOT NULL default 0,
  `forger` int(11) unsigned NOT NULL default 0,
  `element` tinyint(2) unsigned NOT NULL default 0,
  `very` tinyint(1) unsigned NOT NULL default 0,
  `card1` smallint(11) NOT NULL default 0,
  `card2` smallint(11) NOT NULL default 0,
  `card3` smallint(11) NOT NULL default 0,
  `card4` smallint(11) NOT NULL default 0,
  PRIMARY KEY  (`id`),
  KEY `characterID` (`characterID`)
);

CREATE TABLE IF NOT EXISTS `mercenary` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `characterID` int(11) NOT NULL,
  `class` mediumint(9) unsigned NOT NULL default '0',
  `hp` int(12) NOT NULL default '1',
  `sp` int(12) NOT NULL default '1',
  `killCounter` int(11) NOT NULL,
  `timeRemaining` int(11) NOT NULL default '0', 
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `items` (
  `id` smallint(5) unsigned NOT NULL default 0,
  `cleanName` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` tinyint(2) unsigned NOT NULL default 0,
  `priceBuy` mediumint(10) unsigned default NULL,
  `priceSell` mediumint(10) unsigned default NULL,
  `weight` smallint(5) unsigned NOT NULL default 0,
  `attack` smallint(3) unsigned default NULL,
  `defence` tinyint(3) unsigned default NULL,
  `range` tinyint(2) unsigned default NULL,
  `slots` tinyint(2) unsigned default NULL,
  `equipJobs` int(12) unsigned default NULL,
  `equipUpper` tinyint(8) unsigned default NULL,
  `equipGenders` tinyint(2) unsigned default NULL,
  `equipLocations` smallint(4) unsigned default NULL,
  `weaponLevel` tinyint(2) unsigned default NULL,
  `equipLevel` tinyint(3) unsigned default NULL,
  `refineable` tinyint(1) unsigned default NULL,
  `view` smallint(3) unsigned default NULL,
  `script` text,
  `equipScript` text,
  `unequipScript` text,
  PRIMARY KEY  (`id`)
);

CREATE TABLE IF NOT EXISTS `monsters` (
  `id` mediumint(9) unsigned NOT NULL default '0',
  `cleanName` text NOT NULL,
  `translatedName` text NOT NULL,
  `internationalName` text NOT NULL,
  `level` tinyint(6) unsigned NOT NULL default '0',
  `hp` int(9) unsigned NOT NULL default '0',
  `sp` mediumint(9) unsigned NOT NULL default '0',
  `baseExp` mediumint(9) unsigned NOT NULL default '0',
  `jobExp` mediumint(9) unsigned NOT NULL default '0',
  `atkMin` smallint(6) unsigned NOT NULL default '0',
  `atkMax` smallint(6) unsigned NOT NULL default '0',
  `physicalDef` smallint(6) unsigned NOT NULL default '0',
  `magicDef` smallint(6) unsigned NOT NULL default '0',
  `str` tinyint(4) unsigned NOT NULL default '0', 
  `agi` tinyint(4) unsigned NOT NULL default '0', 
  `vit` tinyint(4) unsigned NOT NULL default '0', 
  `int` tinyint(4) unsigned NOT NULL default '0', 
  `dex` tinyint(4) unsigned NOT NULL default '0', 
  `luk` tinyint(4) unsigned NOT NULL default '0', 
  `attackType` tinyint(4) unsigned NOT NULL default '0',
  `skillRange` tinyint(4) unsigned NOT NULL default '0',
  `sightRange` tinyint(4) unsigned NOT NULL default '0',
  `scale` tinyint(4) unsigned NOT NULL default '0', 
  `race` tinyint(4) unsigned NOT NULL default '0', 
  `element` tinyint(4) unsigned NOT NULL default '0', 
  `mode` tinyint(6) unsigned NOT NULL default '0',
  `speed` smallint(6) unsigned NOT NULL default '0', 
  `attackDelay` smallint(6) unsigned NOT NULL default '0',
  `attackAnimation` smallint(6) unsigned NOT NULL default '0', 
  `damageAnimation` smallint(6) unsigned NOT NULL default '0',
  `mvpExp` mediumint(9) unsigned NOT NULL default '0', 
  `mvpBonusExp` smallint(9) unsigned NOT NULL default '0', 
  `mvpdropID1` smallint(9) unsigned NOT NULL default '0', 
  `mvpdropRate1` smallint(9) unsigned NOT NULL default '0', 
  `mvpdropID2` smallint(9) unsigned NOT NULL default '0',
  `mvpdropRate2` smallint(9) unsigned NOT NULL default '0', 
  `mvpdropID3` smallint(9) unsigned NOT NULL default '0', 
  `mvpdropRate3` smallint(9) unsigned NOT NULL default '0', 
  `dropID1` smallint(9) unsigned NOT NULL default '0', 
  `dropRate1` smallint(9) unsigned NOT NULL default '0',
  `dropID2` smallint(9) unsigned NOT NULL default '0',
  `dropRate2` smallint(9) unsigned NOT NULL default '0',
  `dropID3` smallint(9) unsigned NOT NULL default '0', 
  `dropRate3` smallint(9) unsigned NOT NULL default '0',
  `dropID4` smallint(9) unsigned NOT NULL default '0',
  `dropRate4` smallint(9) unsigned NOT NULL default '0', 
  `dropID5` smallint(9) unsigned NOT NULL default '0',
  `dropRate5` smallint(9) unsigned NOT NULL default '0', 
  `dropID6` smallint(9) unsigned NOT NULL default '0',
  `dropRate6` smallint(9) unsigned NOT NULL default '0',
  `dropID7` smallint(9) unsigned NOT NULL default '0', 
  `dropRate7` smallint(9) unsigned NOT NULL default '0', 
  `dropID8` smallint(9) unsigned NOT NULL default '0', 
  `dropRate8` smallint(9) unsigned NOT NULL default '0', 
  `dropID9` smallint(9) unsigned NOT NULL default '0',
  `dropRate9` smallint(9) unsigned NOT NULL default '0',
  `dropCardID` smallint(9) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`)
)
