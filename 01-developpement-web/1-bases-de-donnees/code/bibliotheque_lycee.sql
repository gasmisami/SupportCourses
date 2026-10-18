-- =====================================================================
-- Base fil rouge : bibliotheque_lycee
-- Compatible MySQL 8.0.16+ et MariaDB 10.2+ (XAMPP / phpMyAdmin)
-- Import : phpMyAdmin > Importer, ou en ligne de commande :
--   mysql -u root -p < bibliotheque_lycee.sql
-- Le script supprime puis recrée la base : il peut être relancé à volonté.
-- =====================================================================

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS bibliotheque_lycee;
CREATE DATABASE bibliotheque_lycee
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bibliotheque_lycee;

-- ---------------------------------------------------------------------
-- Structure (LDD) : tables mères d'abord, tables filles ensuite
-- ---------------------------------------------------------------------

CREATE TABLE Auteur (
  id_auteur   INT PRIMARY KEY,
  nom         VARCHAR(50) NOT NULL,
  prenom      VARCHAR(50),
  nationalite VARCHAR(30) DEFAULT 'Inconnue'
) ENGINE=InnoDB;

CREATE TABLE Livre (
  id_livre  INT PRIMARY KEY,
  titre     VARCHAR(100) NOT NULL,
  annee     INT CHECK (annee BETWEEN 1500 AND 2100),
  genre     VARCHAR(20),
  prix      DECIMAL(6,3) CHECK (prix > 0),
  id_auteur INT,
  CONSTRAINT fk_livre_auteur FOREIGN KEY (id_auteur) REFERENCES Auteur(id_auteur)
) ENGINE=InnoDB;

CREATE TABLE Eleve (
  num_eleve  INT PRIMARY KEY,
  nom        VARCHAR(50) NOT NULL,
  prenom     VARCHAR(50) NOT NULL,
  classe     VARCHAR(10) NOT NULL,
  date_naiss DATE
) ENGINE=InnoDB;

CREATE TABLE Emprunt (
  id_emprunt   INT PRIMARY KEY,
  id_livre     INT NOT NULL,
  num_eleve    INT NOT NULL,
  date_emprunt DATE NOT NULL,
  date_retour  DATE,
  CONSTRAINT fk_emprunt_livre FOREIGN KEY (id_livre) REFERENCES Livre(id_livre),
  CONSTRAINT fk_emprunt_eleve FOREIGN KEY (num_eleve) REFERENCES Eleve(num_eleve)
    ON DELETE CASCADE,
  CONSTRAINT chk_dates CHECK (date_retour >= date_emprunt)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Données (LMD)
-- ---------------------------------------------------------------------

INSERT INTO Auteur VALUES
  (1, 'Hugo',    'Victor',        'France'),
  (2, 'Camus',   'Albert',        'France'),
  (3, 'Chebbi',  'Abou el Kacem', 'Tunisie'),
  (4, 'Messadi', 'Mahmoud',       'Tunisie'),
  (5, 'Gibran',  'Khalil',        'Liban'),
  (6, 'Hussein', 'Taha',          'Egypte');

INSERT INTO Livre VALUES
  (1, 'Les Misérables',       1862, 'Roman',   25.500, 1),
  (2, 'Les Contemplations',   1856, 'Poésie',  12.000, 1),
  (3, 'L''Etranger',          1942, 'Roman',    9.800, 2),
  (4, 'La Peste',             1947, 'Roman',   11.200, 2),
  (5, 'Les Chants de la vie', 1955, 'Poésie',   8.500, 3),
  (6, 'Le Barrage',           1955, 'Théâtre', 10.000, 4),
  (7, 'Le Prophète',          1923, 'Poésie',   7.900, 5),
  (8, 'Le Livre des jours',   1929, 'Roman',   13.500, 6);

INSERT INTO Eleve VALUES
  (101, 'Ben Salah', 'Leila',   '4SI1', '2008-03-14'),
  (102, 'Trabelsi',  'Karim',   '4SI1', '2008-11-02'),
  (103, 'Gharbi',    'Amel',    '4SI2', '2007-07-21'),
  (104, 'Mansour',   'Yasmine', '3SI1', '2009-01-17'),
  (105, 'Jaziri',    'Omar',    '4SI2', '2008-05-09'),
  (106, 'Haddad',    'Sami',    '3SI1', '2009-06-30');

INSERT INTO Emprunt VALUES
  (1, 2, 101, '2026-09-15', '2026-09-29'),
  (2, 3, 101, '2026-10-01', NULL),
  (3, 5, 102, '2026-09-20', '2026-09-27'),
  (4, 7, 103, '2026-09-22', '2026-10-08'),
  (5, 4, 104, '2026-09-10', '2026-09-24'),
  (6, 6, 105, '2026-10-05', NULL),
  (7, 1, 103, '2026-10-06', NULL),
  (8, 8, 102, '2026-10-02', '2026-10-09');

-- ---------------------------------------------------------------------
-- Contrôle rapide après import (résultats attendus : 6 / 8 / 6 / 8)
-- ---------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM Auteur)  AS nb_auteurs,
  (SELECT COUNT(*) FROM Livre)   AS nb_livres,
  (SELECT COUNT(*) FROM Eleve)   AS nb_eleves,
  (SELECT COUNT(*) FROM Emprunt) AS nb_emprunts;
