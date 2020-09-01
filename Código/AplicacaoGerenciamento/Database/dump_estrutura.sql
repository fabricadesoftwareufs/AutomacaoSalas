-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           8.0.21 - MySQL Community Server - GPL
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.0.0.6080
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para str_db
CREATE DATABASE IF NOT EXISTS `str_db` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `str_db`;


-- Copiando estrutura para tabela str_db.bloco
CREATE TABLE IF NOT EXISTS `bloco` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Organizacao` int unsigned NOT NULL,
  `Titulo` varchar(100) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_Bloco_Organizacao1_idx` (`Organizacao`),
  CONSTRAINT `fk_Bloco_Organizacao1` FOREIGN KEY (`Organizacao`) REFERENCES `organizacao` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;


-- Copiando estrutura para tabela str_db.sala
CREATE TABLE IF NOT EXISTS `sala` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(100) NOT NULL,
  `Bloco` int unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_Sala_Bloco1_idx` (`Bloco`),
  CONSTRAINT `fk_Sala_Bloco1` FOREIGN KEY (`Bloco`) REFERENCES `bloco` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `monitoramento` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `Luzes` TINYINT(4) NOT NULL,
  `ArCondicionado` TINYINT(4) NOT NULL,
  `Sala` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Sala_Id` FOREIGN KEY (`Sala`)  REFERENCES `sala` (`Id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8;


-- Copiando estrutura para tabela str_db.tipohardware
CREATE TABLE IF NOT EXISTS `tipohardware` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Descricao` varchar(45) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


-- Copiando estrutura para tabela str_db.hardwaredebloco
CREATE TABLE IF NOT EXISTS `hardwaredebloco` (
  `id` int NOT NULL AUTO_INCREMENT,
  `MAC` varchar(45) NOT NULL,
  `Bloco` int unsigned NOT NULL,
  `TipoHardware` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idHardwareDeBloco_UNIQUE` (`id`),
  KEY `fk_HardwareDeBloco_Bloco1_idx` (`Bloco`),
  KEY `fk_HardwareDeBloco_TipoHardware1_idx` (`TipoHardware`),
  CONSTRAINT `fk_HardwareDeBloco_Bloco1` FOREIGN KEY (`Bloco`) REFERENCES `bloco` (`Id`),
  CONSTRAINT `fk_HardwareDeBloco_TipoHardware1` FOREIGN KEY (`TipoHardware`) REFERENCES `tipohardware` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela str_db.hardwaredesala
CREATE TABLE IF NOT EXISTS `hardwaredesala` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `MAC` varchar(45) NOT NULL,
  `Sala` int unsigned NOT NULL,
  `TipoHardware` int unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_Hardware_Sala1_idx` (`Sala`),
  KEY `fk_HardwareDeSala_TipoHardware1_idx` (`TipoHardware`),
  CONSTRAINT `fk_Hardware_Sala1` FOREIGN KEY (`Sala`) REFERENCES `sala` (`Id`),
  CONSTRAINT `fk_HardwareDeSala_TipoHardware1` FOREIGN KEY (`TipoHardware`) REFERENCES `tipohardware` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.


-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela str_db.tipousuario
CREATE TABLE IF NOT EXISTS `tipousuario` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Descricao` varchar(45) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela str_db.usuario
CREATE TABLE IF NOT EXISTS `usuario` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Cpf` varchar(11) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `DataNascimento` date DEFAULT NULL,
  `Senha` varchar(100) NOT NULL,
  `TipoUsuario` int unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Cpf_UNIQUE` (`Cpf`),
  KEY `fk_Usuario_TipoUsuario1_idx` (`TipoUsuario`),
  CONSTRAINT `fk_Usuario_TipoUsuario1` FOREIGN KEY (`TipoUsuario`) REFERENCES `tipousuario` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela str_db.usuarioorganizacao
CREATE TABLE IF NOT EXISTS `usuarioorganizacao` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Organizacao` int unsigned NOT NULL,
  `Usuario` int unsigned NOT NULL,
  PRIMARY KEY (`Id`,`Organizacao`,`Usuario`),
  KEY `fk_Organizacao_has_Usuario_Usuario1_idx` (`Usuario`),
  KEY `fk_Organizacao_has_Usuario_Organizacao1_idx` (`Organizacao`),
  CONSTRAINT `fk_Organizacao_has_Usuario_Organizacao1` FOREIGN KEY (`Organizacao`) REFERENCES `organizacao` (`Id`),
  CONSTRAINT `fk_Organizacao_has_Usuario_Usuario1` FOREIGN KEY (`Usuario`) REFERENCES `usuario` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela str_db.horariosala
CREATE TABLE IF NOT EXISTS `horariosala` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Data` datetime NOT NULL,
  `HorarioInicio` time NOT NULL,
  `HorarioFim` time NOT NULL,
  `Situacao` ENUM('PENDENTE', 'APROVADA','REPROVADA', 'CANCELADA') NOT NULL DEFAULT 'APROVADA',
  `Objetivo` varchar(500) NOT NULL,
  `Usuario` int unsigned NOT NULL,
  `Sala` int unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_HorarioSala_Usuario1_idx` (`Usuario`),
  KEY `fk_HorarioSala_Sala1_idx` (`Sala`),
  CONSTRAINT `fk_HorarioSala_Sala1` FOREIGN KEY (`Sala`) REFERENCES `sala` (`Id`),
  CONSTRAINT `fk_HorarioSala_Usuario1` FOREIGN KEY (`Usuario`) REFERENCES `usuario` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Copiando estrutura para tabela str_db.planejamento
CREATE TABLE IF NOT EXISTS `planejamento` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `DataInicio` date NOT NULL,
  `DataFim` date NOT NULL,
  `HorarioInicio` time NOT NULL,
  `HorarioFim` time NOT NULL,
  `DiaSemana` enum('SEG','TER','QUA','QUI','SEX','SAB','DOM') NOT NULL,
  `Objetivo` varchar(500) NOT NULL,
  `Usuario` int unsigned NOT NULL,
  `Sala` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Planejamento_Usuario1_idx` (`Usuario`),
  KEY `fk_Planejamento_Sala1_idx` (`Sala`),
  CONSTRAINT `fk_Planejamento_Sala1` FOREIGN KEY (`Sala`) REFERENCES `sala` (`Id`),
  CONSTRAINT `fk_Planejamento_Usuario1` FOREIGN KEY (`Usuario`) REFERENCES `usuario` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportação de dados foi desmarcado.


-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela str_db.salaparticular
CREATE TABLE IF NOT EXISTS `salaparticular` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `Usuario` int unsigned NOT NULL,
  `Sala` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_MinhaSala_Usuario1_idx` (`Usuario`),
  KEY `fk_MinhaSala_Sala1_idx` (`Sala`),
  CONSTRAINT `fk_MinhaSala_Sala1` FOREIGN KEY (`Sala`) REFERENCES `sala` (`Id`),
  CONSTRAINT `fk_MinhaSala_Usuario1` FOREIGN KEY (`Usuario`) REFERENCES `usuario` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
