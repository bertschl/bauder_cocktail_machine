USE CocktailMachine;
drop table if exists xRefCocktailZutat;
drop table if exists Pumpe;
drop table if exists Zubereitungsschritt;
drop table if exists Stat;
drop table if exists Zutat;
drop table if exists Cocktail;

CREATE TABLE Cocktail(
    CocktailID int NOT NULL,
    CocktailName varchar(50),
    PRIMARY KEY (CocktailID)
    );
CREATE TABLE Zubereitungsschritt(
    ZubereitungsschrittID int NOT NULL AUTO_INCREMENT,
    SchrittNummer int NOT NULL,
    Beschreibung varchar(100) NOT NULL,
    schrittCocktailID int NOT NULL,
    PRIMARY KEY (ZubereitungsschrittID),
    CONSTRAINT schrittCocktailID
    FOREIGN KEY (schrittCocktailID) REFERENCES Cocktail (CocktailID)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
    );
CREATE TABLE Zutat(
    ZutatID int NOT NULL,
    ZutatName varchar(100) NOT NULL,
    isAlcohol boolean not NULL,
    pumpingSpeed int not null,
    PRIMARY KEY(ZutatID)
);
CREATE TABLE xRefCocktailZutat(
    xRefCocktailZutatID int NOT NULL AUTO_INCREMENT,
    xRefCocktailID int NOT NULL,
    xRefZutatID int NOT NULL,
    NumberOfParts int NOT NULL,
    PRIMARY KEY(xRefCocktailZutatID),
    CONSTRAINT xRefCocktailID
    FOREIGN KEY (xRefCocktailID) REFERENCES Cocktail (CocktailID)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
    CONSTRAINT xRefZutatID
    FOREIGN KEY (xRefZutatID) REFERENCES Zutat (ZutatID)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
);
CREATE TABLE Pumpe(
    PumpenID int NOT NULL AUTO_INCREMENT,
    GPIO int NOT NULL,
    ZutatID int NOT NULL,
    PRIMARY KEY (PumpenID),
    CONSTRAINT ZutatID
    FOREIGN KEY (ZutatID) REFERENCES Zutat (ZutatID)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
    );
CREATE TABLE Stat(
    StatID int NOT NULL AUTO_INCREMENT,
    CocktailID int NOT NULL,
    NumberOFCocktails int NOT NULL,
    PRIMARY KEY (StatID),
    CONSTRAINT CocktailID
    FOREIGN KEY (CocktailID) REFERENCES Cocktail (CocktailID)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
    );