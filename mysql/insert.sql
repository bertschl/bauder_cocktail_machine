USE CocktailMachine;
INSERT INTO Cocktail (CocktailName) VALUES('Vodka Mojito');
INSERT INTO Cocktail (CocktailName) VALUES('Caiprinoska');
INSERT INTO Cocktail (CocktailName) VALUES('Vodka Soda');
INSERT INTO Cocktail (CocktailName) VALUES('Rum Daiquiri');
INSERT INTO Cocktail (CocktailName) VALUES('Rum Mojito');
INSERT INTO Cocktail (CocktailName) VALUES('Rum Cuatro Mismo');
INSERT INTO Cocktail (CocktailName) VALUES('Rum Maracuja');
INSERT INTO Cocktail (CocktailName) VALUES('Vodka Maracuja');
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('None', 0, 0);--1
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Vodka', 1, 1.5);--2
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Rum', 1, 1.5);--3
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Limettensaft', 0, 1.5);--4
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Zuckersirup', 0, 0.9);--5
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Wasser', 0, 3);--6
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Ananassaft', 0, 3);--7
INSERT INTO Zutat (ZutatName, isAlcohol, pumpingSpeed) VALUES ('Maracujasaft', 0, 3);--8

--VodkaMojito
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Eis, Limttenviertel und Minzblaetter in das Glas geben.', 1);
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', 1);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(1, 2, 1.5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(1, 6, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(1, 5, 0.6);
--Caiprinoska
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Limettenviertel und Crushed Ice in das Glas geben.', 2);
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(2, 2, 1.5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(2, 5, 0.6);
--Vodka Soda
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', 3);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(3, 2, 1.3);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(3, 6, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(3, 4, 0.5);
--Vodka Rum Daiquiri
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', 4);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(4, 3, 6);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(4, 5, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(4, 4, 2);
--Vodka Rum Mojito
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'Limettenviertel, Minzublaetter und Eis in das Glas geben und leicht andruecken.', 5);
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(5, 3, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(5, 5, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(5, 4, 2.5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(5, 6, 6);
--Vodka Rum Cuatro Mismo
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Limettenspalten in ein Glas geben.', 6);
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', 6);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(6, 3, 1);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(6, 6, 3);
--Sunny Maracuja
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', 7);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(7, 7, 6);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(7, 8, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(7, 3, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(7, 4, 1);
--Vodka Maracuja
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', 8);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(8, 7, 6);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(8, 8, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(8, 2, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(8, 4, 1);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(23, 4);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(24, 7);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(25, 2);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(8, 8);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(7, 3);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(12, 6);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(16, 5);
INSERT INTO Stat(CocktailID, NumberOfCocktails) VALUES(1, 0);