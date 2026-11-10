-- MySQL Workbench Forward Engineering

USE dressme;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birthdate` DATE NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(50) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`category_id`),
  INDEX `fk_category_user_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_category_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clothing_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clothing_items` (
  `item_id` INT NOT NULL AUTO_INCREMENT,
  `item_name` VARCHAR(100) NOT NULL,
  `season` VARCHAR(45) NOT NULL,
  `color` VARCHAR(45) NULL,
  `item_description` MEDIUMTEXT NULL,
  `image_path` VARCHAR(255) NOT NULL,
  `user_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `fk_clothing_item_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_clothing_item_category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_clothing_item_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_clothing_item_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `categories` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `outfits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `outfits` (
  `outfit_id` INT NOT NULL AUTO_INCREMENT,
  `outfit_description` VARCHAR(255) NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`outfit_id`),
  INDEX `fk_outfit_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_outfit_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `outfit_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `outfit_items` (
  `outfit_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  PRIMARY KEY (`outfit_id`, `item_id`),
  INDEX `fk_outfit_clothing_item1_idx` (`item_id` ASC) VISIBLE,
  CONSTRAINT `fk_outfit_items_outfit`
    FOREIGN KEY (`outfit_id`)
    REFERENCES `outfits` (`outfit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_outfit_clothing_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `clothing_items` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;