-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema financial_inclusion_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema financial_inclusion_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `financial_inclusion_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `financial_inclusion_db` ;

-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`Countries` (
    `CountryID` INT NOT NULL AUTO_INCREMENT,
    `CountryName` VARCHAR(100) NOT NULL,
    `Region` VARCHAR(50) NOT NULL,
    `Population` INT DEFAULT NULL,
    `GDP` DECIMAL(15,2) DEFAULT NULL,
    `HDI` DECIMAL(4,3) DEFAULT NULL,
    `FinancialInclusionIndex` DECIMAL(4,3) DEFAULT NULL,
    PRIMARY KEY (`CountryID`)
);



-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`FinancialInclusionMetrics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`FinancialInclusionMetrics` (
    `MetricID` INT NOT NULL AUTO_INCREMENT,  -- Ensure NOT NULL for primary key
    `CountryID` INT NOT NULL,                -- Ensure NOT NULL for foreign key
    `MetricName` VARCHAR(100) NOT NULL,
    `Year` INT NOT NULL,
    `Value` DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (`MetricID`),
    INDEX (`CountryID` ASC),
    CONSTRAINT `fk_CountryID`
        FOREIGN KEY (`CountryID`)
        REFERENCES `financial_inclusion_db`.`Countries` (`CountryID`)
);



-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`EconomicDevelopmentIndicators`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`EconomicDevelopmentIndicators` (
    `IndicatorID` INT NOT NULL AUTO_INCREMENT,  -- Ensure `NOT NULL` for primary key
    `CountryID` INT NOT NULL,                   -- Ensure `NOT NULL` for foreign key
    `IndicatorName` VARCHAR(100) NOT NULL,
    `Year` INT NOT NULL,
    `Value` DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (`IndicatorID`),
    INDEX (`CountryID` ASC),
    CONSTRAINT `fk_CountryID_EconomicIndicators`  -- Unique foreign key constraint name
        FOREIGN KEY (`CountryID`)
        REFERENCES `financial_inclusion_db`.`Countries` (`CountryID`)
);




-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`HealthcareDevelopmentIndicators`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`HealthcareDevelopmentIndicators` (
    `IndicatorID` INT NOT NULL AUTO_INCREMENT,  -- Ensure `NOT NULL` for primary key
    `CountryID` INT NOT NULL,                   -- Ensure `NOT NULL` for foreign key
    `IndicatorName` VARCHAR(100) NOT NULL,
    `Year` INT NOT NULL,
    `Value` DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (`IndicatorID`),
    INDEX (`CountryID` ASC),
    CONSTRAINT `fk_CountryID_HealthcareIndicators`  -- Unique foreign key constraint name
        FOREIGN KEY (`CountryID`)
        REFERENCES `financial_inclusion_db`.`Countries` (`CountryID`)
);


-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`DevelopmentProjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`DevelopmentProjects` (
    `ProjectID` INT NOT NULL AUTO_INCREMENT,  -- Ensure `NOT NULL` for primary key
    `ProjectName` VARCHAR(150) NOT NULL,
    `CountryID` INT NOT NULL,                 -- Ensure `NOT NULL` for foreign key
    `Sector` VARCHAR(100) NOT NULL,
    `StartDate` DATE NOT NULL,
    `EndDate` DATE DEFAULT NULL,
    `FundingAmount` DECIMAL(15,2) DEFAULT NULL,
    `Status` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`ProjectID`),
    INDEX (`CountryID` ASC),
    CONSTRAINT `fk_CountryID_DevelopmentProjects`  -- Unique foreign key constraint name
        FOREIGN KEY (`CountryID`)
        REFERENCES `financial_inclusion_db`.`Countries` (`CountryID`)
);



-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`ProjectImpacts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`ProjectImpacts` (
    `ImpactID` INT NOT NULL AUTO_INCREMENT,  -- Ensure `NOT NULL` for primary key
    `ProjectID` INT NOT NULL,                -- Ensure `NOT NULL` for foreign key
    `IndicatorID` INT NOT NULL,              -- Ensure `NOT NULL` for foreign key
    `ImpactType` VARCHAR(50) NOT NULL,
    `ImpactValue` DECIMAL(10,2) DEFAULT NULL,
    `AssessmentDate` DATE NOT NULL,
    PRIMARY KEY (`ImpactID`),
    INDEX (`ProjectID` ASC),
    INDEX (`IndicatorID` ASC),
    CONSTRAINT `fk_ProjectID_ProjectImpacts`  -- Named foreign key constraint
        FOREIGN KEY (`ProjectID`)
        REFERENCES `financial_inclusion_db`.`DevelopmentProjects` (`ProjectID`),
    CONSTRAINT `fk_IndicatorID_ProjectImpacts`  -- Named foreign key constraint
        FOREIGN KEY (`IndicatorID`)
        REFERENCES `financial_inclusion_db`.`EconomicDevelopmentIndicators` (`IndicatorID`)
);



-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`Donors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`Donors` (
    `DonorID` INT NOT NULL AUTO_INCREMENT,  -- Ensure `NOT NULL` for primary key
    `DonorName` VARCHAR(150) NOT NULL,
    `Type` VARCHAR(50) DEFAULT NULL,
    `Country` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (`DonorID`)
);



-- -----------------------------------------------------
-- Table `financial_inclusion_db`.`Donations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financial_inclusion_db`.`Donations` (
    `DonationID` INT NOT NULL AUTO_INCREMENT,  -- Ensure `NOT NULL` for primary key
    `DonorID` INT NOT NULL,                    -- Ensure `NOT NULL` for foreign key
    `ProjectID` INT NOT NULL,                  -- Ensure `NOT NULL` for foreign key
    `Amount` DECIMAL(15,2) DEFAULT NULL,
    `Date` DATE NOT NULL,
    PRIMARY KEY (`DonationID`),
    INDEX (`DonorID` ASC),
    INDEX (`ProjectID` ASC),
    CONSTRAINT `fk_DonorID_Donations`          -- Named foreign key constraint
        FOREIGN KEY (`DonorID`)
        REFERENCES `financial_inclusion_db`.`Donors` (`DonorID`),
    CONSTRAINT `fk_ProjectID_Donations`       -- Named foreign key constraint
        FOREIGN KEY (`ProjectID`)
        REFERENCES `financial_inclusion_db`.`DevelopmentProjects` (`ProjectID`)
);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
