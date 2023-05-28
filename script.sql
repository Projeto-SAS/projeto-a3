-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema projetoSAS
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema projetoSAS
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `projetoSAS` DEFAULT CHARACTER SET utf8 ;
USE `projetoSAS` ;

-- -----------------------------------------------------
-- Table `projetoSAS`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Endereco` (
  `id_endereco` INT NOT NULL AUTO_INCREMENT,
  `cidade` VARCHAR(20) NOT NULL,
  `estado` VARCHAR(20) NOT NULL,
  `bairro` VARCHAR(20) NOT NULL,
  `logradouro` VARCHAR(20) NOT NULL,
  `numero` INT NOT NULL,
  `referencia` VARCHAR(20) NULL,
  PRIMARY KEY (`id_endereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Funcionario` (
  `id_funcionario` INT NOT NULL AUTO_INCREMENT,
  `id_endereco` INT NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `idade` INT(2) GENERATED ALWAYS AS (timediff(current_date(), data_nascimento)) VIRTUAL NULL,
  `nome` VARCHAR(50) NOT NULL,
  `cpf` VARCHAR(14) NOT NULL,
  `rg` VARCHAR(12) NOT NULL,
  `titulo_eleitor` VARCHAR(12) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefone_1` VARCHAR(20) NOT NULL,
  `telefone_2` VARCHAR(20) NULL,
  PRIMARY KEY (`id_funcionario`, `id_endereco`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC) VISIBLE,
  UNIQUE INDEX `titulo_eleitor_UNIQUE` (`titulo_eleitor` ASC) VISIBLE,
  UNIQUE INDEX `rg_UNIQUE` (`rg` ASC) VISIBLE,
  INDEX `FOREIGN_idx` (`id_endereco` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `projetoSAS`.`Endereco` (`id_endereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Pagamento` (
  `id_pagamento` INT NOT NULL AUTO_INCREMENT,
  `dinheiro` TINYINT NULL,
  `pix` TINYINT NULL,
  `cartao` TINYINT NULL,
  PRIMARY KEY (`id_pagamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Venda` (
  `id_venda` INT NOT NULL AUTO_INCREMENT,
  `id_pagamento` INT NOT NULL,
  `numero` INT NOT NULL,
  `produto` VARCHAR(45) NOT NULL,
  `data_horario` DATETIME NOT NULL,
  `valor` FLOAT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`id_venda`),
  INDEX `FOREIGN_idx` (`id_pagamento` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_pagamento`)
    REFERENCES `projetoSAS`.`Pagamento` (`id_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Nota_Fiscal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Nota_Fiscal` (
  `id_nota_fiscal` INT NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL,
  `valor` FLOAT NOT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_nota_fiscal`),
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Deposito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Deposito` (
  `id_deposito` INT NOT NULL AUTO_INCREMENT,
  `id_endereco` INT NOT NULL,
  `numero` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `observacao` VARCHAR(45) NULL,
  PRIMARY KEY (`id_deposito`, `id_endereco`),
  INDEX `FOREIGN_idx` (`id_endereco` ASC) VISIBLE,
  UNIQUE INDEX `numero_UNIQUE` (`numero` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `projetoSAS`.`Endereco` (`id_endereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Historico_Venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Historico_Venda` (
  `id_funcionario` INT NOT NULL,
  `id_venda` INT NOT NULL,
  `id_nota_fiscal` INT NOT NULL,
  `id_deposito` INT NOT NULL,
  `numero_venda` INT NOT NULL,
  `valor` FLOAT NOT NULL,
  INDEX `FOREIGN_idx` (`id_funcionario` ASC) VISIBLE,
  PRIMARY KEY (`id_funcionario`, `id_venda`, `id_nota_fiscal`, `id_deposito`),
  INDEX `FOREIGN_idx1` (`id_venda` ASC) VISIBLE,
  INDEX `FOREIGN_idx2` (`id_nota_fiscal` ASC) VISIBLE,
  INDEX `FOREIGN_idx3` (`id_deposito` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `projetoSAS`.`Funcionario` (`id_funcionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_venda`)
    REFERENCES `projetoSAS`.`Venda` (`id_venda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_nota_fiscal`)
    REFERENCES `projetoSAS`.`Nota_Fiscal` (`id_nota_fiscal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_deposito`)
    REFERENCES `projetoSAS`.`Deposito` (`id_deposito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Tipo_Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Tipo_Produto` (
  `id_tipo` CHAR NOT NULL,
  `tipo_produto` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Fornecedor` (
  `id_fornecedor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(30) NOT NULL,
  `email` VARCHAR(30) NOT NULL,
  `site` VARCHAR(30) NOT NULL,
  `razao_social` VARCHAR(30) NULL,
  `cnpj` VARCHAR(18) NOT NULL,
  `id_endereco` INT NOT NULL,
  PRIMARY KEY (`id_fornecedor`, `id_endereco`),
  INDEX `FOREIGN_idx` (`id_endereco` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `projetoSAS`.`Endereco` (`id_endereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Produto` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `id_tipo` CHAR NOT NULL,
  `id_fornecedor` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `codigo_barras` VARCHAR(12) NOT NULL,
  `peso` FLOAT NOT NULL,
  `valor_compra` FLOAT NOT NULL,
  `codigo` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE INDEX `codigo_barras_UNIQUE` (`codigo_barras` ASC) VISIBLE,
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC) VISIBLE,
  INDEX `FOREIGN_idx` (`id_tipo` ASC) VISIBLE,
  INDEX `FOREIGN_idx1` (`id_fornecedor` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_tipo`)
    REFERENCES `projetoSAS`.`Tipo_Produto` (`id_tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_fornecedor`)
    REFERENCES `projetoSAS`.`Fornecedor` (`id_fornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Promotor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Promotor` (
  `id_promotor` INT NOT NULL AUTO_INCREMENT,
  `id_fornecedor` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `codigo_promotor` VARCHAR(30) NOT NULL,
  `telefone` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`id_promotor`, `id_fornecedor`),
  INDEX `FOREIGN_idx` (`id_fornecedor` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_fornecedor`)
    REFERENCES `projetoSAS`.`Fornecedor` (`id_fornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `id_nota_fiscal` INT NOT NULL,
  `id_deposito` INT NOT NULL,
  `id_produto` INT NOT NULL,
  `id_promotor` INT NOT NULL,
  `data_emissao` DATETIME NOT NULL,
  `numero` INT NOT NULL,
  `valor_pedido` FLOAT NOT NULL,
  `quantidade` INT NOT NULL,
  `peso_total` FLOAT GENERATED ALWAYS AS () STORED,
  PRIMARY KEY (`id_pedido`, `id_nota_fiscal`, `id_deposito`, `id_promotor`, `id_produto`),
  UNIQUE INDEX `numero_UNIQUE` (`numero` ASC) VISIBLE,
  INDEX `FOREIGN_idx` (`id_nota_fiscal` ASC) VISIBLE,
  INDEX `FOREIGN_idx1` (`id_deposito` ASC) VISIBLE,
  INDEX `FOREIGN_idx2` (`id_produto` ASC) VISIBLE,
  INDEX `FOREIGN_idx3` (`id_promotor` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_nota_fiscal`)
    REFERENCES `projetoSAS`.`Nota_Fiscal` (`id_nota_fiscal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_deposito`)
    REFERENCES `projetoSAS`.`Deposito` (`id_deposito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_produto`)
    REFERENCES `projetoSAS`.`Produto` (`id_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_promotor`)
    REFERENCES `projetoSAS`.`Promotor` (`id_promotor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Tipo_Cargo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Tipo_Cargo` (
  `id_tipo` CHAR NOT NULL,
  `tipo_cargo` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id_tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Cargo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Cargo` (
  `id_cargo` INT NOT NULL AUTO_INCREMENT,
  `id_tipo` CHAR NOT NULL,
  `nome` VARCHAR(30) NOT NULL,
  `salario` FLOAT NOT NULL,
  PRIMARY KEY (`id_cargo`),
  INDEX `FOREIGN_idx` (`id_tipo` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_tipo`)
    REFERENCES `projetoSAS`.`Tipo_Cargo` (`id_tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Historico_Cargo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Historico_Cargo` (
  `id_funcionario` INT NOT NULL,
  `id_cargo` INT NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NULL,
  `bonificacao` FLOAT NULL,
  `tempo` TIME GENERATED ALWAYS AS () STORED,
  INDEX `FOREIGN_idx` (`id_cargo` ASC) VISIBLE,
  INDEX `FOREIGN_idx1` (`id_funcionario` ASC) VISIBLE,
  PRIMARY KEY (`data_inicio`, `id_funcionario`, `id_cargo`),
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `projetoSAS`.`Cargo` (`id_cargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `projetoSAS`.`Funcionario` (`id_funcionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projetoSAS`.`Historico_Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projetoSAS`.`Historico_Pedido` (
  `data_horario_entrega` DATETIME NOT NULL,
  `tipo` VARCHAR(10) NOT NULL,
  `id_pedido` INT NOT NULL,
  `id_deposito` INT NOT NULL,
  PRIMARY KEY (`data_horario_entrega`, `id_deposito`, `id_pedido`),
  INDEX `FOREIGN_idx` (`id_deposito` ASC) VISIBLE,
  INDEX `FOREIGN_idx1` (`id_pedido` ASC) VISIBLE,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_deposito`)
    REFERENCES `projetoSAS`.`Deposito` (`id_deposito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FOREIGN`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `projetoSAS`.`Pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
