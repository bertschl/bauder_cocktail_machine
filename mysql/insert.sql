USE CocktailMachine;
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(1, 'Vodka Mojito');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(2, 'Caiprinoska');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(3, 'Vodka Soda');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(4, 'Rum Daiquiri');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(5, 'Rum Mojito');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(6, 'Rum Cuatro Mismo');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(7, 'Rum Maracuja');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(8, 'Vodka Maracuja');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(9, 'Whisky Sour');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(10, 'Whisky Cola');
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (1, 'None', 0, 0);--1
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (2, 'Vodka', 1, 1.5);--2
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (3, 'Rum', 1, 1.5);--3
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (4, 'Limettensaft', 0, 1.5);--4
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (5, 'Zuckersirup', 0, 0.9);--5
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (6, 'Wasser', 0, 3);--6
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (7, 'Ananassaft', 0, 3);--7
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (8, 'Maracujasaft', 0, 3);--8

--VodkaMojito
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Eis, Limettenviertel und Minzblaetter in das Glas geben.', 1);
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', 1);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(1, 2, 1.5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(1, 6, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(1, 5, 0.6);
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
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'Limettenviertel, Minzblaetter und Eis in das Glas geben und leicht andruecken.', 5);
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
--Whisky Sour
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Bitte Vodkaschlauch in Whisky stecken.', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Sour'))
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', 9);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(9, 2, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(9, 4, 3);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES(9, 5, 1.6);
--Whisky Cola/Ginger
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Bitte Vodkaschlauch in Whisky stecken.', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Cola'))
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Cola'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Cola'), (SELECT ZutatID FROM Zutat WHERE ZutatName = 'Vodka'), 1);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Cola'), (SELECT ZutatID FROM Zutat WHERE ZutatName = 'Wasser'), 3);

INSERT INTO Pumpe (GPIO, ZutatID) VALUES(23, 4);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(24, 7);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(25, 2);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(8, 8);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(7, 3);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(12, 6);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(16, 5);
INSERT INTO Stat(CocktailID, NumberOfCocktails) VALUES(1, 0);