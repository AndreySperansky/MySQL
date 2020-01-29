USE vk_;
/* создаем таблицу для отображения постов пользователей на которых мы подписаны */

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `get_follow_user` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
 PRIMARY KEY (`get_follow_user`),
  CONSTRAINT `news_user_fk`
    FOREIGN KEY (`get_follow_user`) REFERENCES `vk_`.`users` (`id`),
  CONSTRAINT `news_media_fk`
	FOREIGN KEY (`media_id`)  REFERENCES `vk_`.`media` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);
    
    
 ALTER TABLE `vk_`.`news` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`get_follow_user`, `media_id`);
;

DROP TABLE IF EXISTS `bookmarks_type`;
CREATE TABLE `vk_`.`bookmarks_type` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `bm_type` VARCHAR(255) NOT NULL COMMENT 'Люди, Сообщества, Записи, Статьи, Ссылки, Подкасты, Видео, Сюжеты, Товары ',
  PRIMARY KEY (`id`),
  INDEX `bm_name` (`bm_type` ASC) INVISIBLE)
COMMENT = 'типы закладок доступные пользователю - закрытый список';


DROP TABLE IF EXISTS `media_files_type`;
CREATE TABLE `vk_`.`media_files_type` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_type` VARCHAR(45) NOT NULL COMMENT 'Закрытый список: аудио, видео, статья, картинка',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC, `file_type` ASC) VISIBLE)
COMMENT = 'Типы файлов, доступные пользователям';

DROP TABLE IF EXISTS `bookmarks`;
CREATE TABLE `bookmarks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bm_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bm_user_fk_idx` (`user_id`),
  KEY `bookmarks_fk` (`bm_id`),
  CONSTRAINT `bm_userid_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bookmarks_fk` FOREIGN KEY (`bm_id`) REFERENCES `bookmarks_type` (`id`)
) 
COMMENT='Закладки ползователей';


DROP TABLE IF EXISTS `tags`;
CREATE TABLE `vk_`.`tags` (
  `idtags` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag_name` VARCHAR(45) NULL,
  `bookmarks_id` BIGINT NULL,
  PRIMARY KEY (`idtags`),
  UNIQUE INDEX `idtags_UNIQUE` (`idtags` ASC) VISIBLE,
  UNIQUE INDEX `tag_name_UNIQUE` (`tag_name` ASC) VISIBLE)
COMMENT = 'Заметки';














