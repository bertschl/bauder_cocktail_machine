USE CocktailMachine;
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(1, 'Whisky Sour');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(2, 'Gin Grapefruit');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(3, 'Vodka Maracuja');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(4, 'Vodka Mojito');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(5, 'Rum Sour');
INSERT INTO Cocktail (CocktailID, CocktailName) VALUES(6, 'Rum Mojito');

INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (1, 'None', 0, 0);--1
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (2, 'Vodka', 1, 1.5);--2
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (3, 'Rum', 1, 1.5);--3
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (4, 'Limettensaft', 0, 1.5);--4
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (5, 'Zuckersirup', 0, 0.9);--5
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (6, 'Wasser', 0, 3);--6
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (7, 'Grapefruit', 0, 3);--7
INSERT INTO Zutat (ZutatID, ZutatName, isAlcohol, pumpingSpeed) VALUES (8, 'Maracujasaft', 0, 3);--8

--Vodka Mojito
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'Eis, Limettenviertel und Minzblaetter in das Glas geben.', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Mojito'));
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Mojito'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Mojito'), 2, 1.5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Mojito'), 6, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Mojito'), 5, 0.6);

--Rum Sour
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Sour'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Sour'), 3, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Sour'), 5, 1.8);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Sour'), 4, 3);

--Vodka Rum Mojito
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'Limettenviertel, Minzblaetter und Eis in das Glas geben und leicht andruecken.', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Mojito'));
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(2, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Mojito'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Mojito'), 3, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Mojito'), 5, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Mojito'), 4, 2.5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Rum Mojito'), 6, 6);

--Vodka Maracuja
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Maracuja'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Maracuja'), 7, 6);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Maracuja'), 8, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Maracuja'), 2, 2);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Vodka Maracuja'), 4, 1);
--Whisky Sour
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Sour'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Sour'), 2, 5);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Sour'), 4, 3);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Whisky Sour'), 5, 1.6);
--Gin Grapefruit
INSERT INTO Zubereitungsschritt (SchrittNummer, Beschreibung, schrittCocktailID) VALUES(1, 'go', (SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Gin Grapefruit'));
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Gin Grapefruit'), (SELECT ZutatID FROM Zutat WHERE ZutatName = 'Vodka'), 1);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Gin Grapefruit'), (SELECT ZutatID FROM Zutat WHERE ZutatName = 'Grapefruit'), 3);
INSERT INTO xRefCocktailZutat (xRefCocktailID, xRefZutatID, NumberOfParts) VALUES((SELECT CocktailID FROM Cocktail WHERE CocktailName = 'Gin Grapefruit'), (SELECT ZutatID FROM Zutat WHERE ZutatName = 'Zuckersirup'), 0.3);

INSERT INTO Pumpe (GPIO, ZutatID) VALUES(23, 4);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(24, 7);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(25, 2);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(8, 8);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(7, 3);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(12, 6);
INSERT INTO Pumpe (GPIO, ZutatID) VALUES(16, 5);
INSERT INTO Stat(CocktailID, NumberOfCocktails) VALUES(1, 0);