#!/usr/bin/env node
//sudo npm install mysql
//sudo npm install -g --unsafe-perm=true --allow-root
const express = require('express');
const mysql = require('mysql');
var bodyParser = require('body-parser');
const app = express();
const port = 80;
//Loads the handlebars module
const handlebars = require('express-handlebars');
var urlencodedParser = bodyParser.urlencoded({extended: false}); //Parser fuer POST-Request-Body
//Sets our app to use the handlebars engine
app.set('view engine', 'handlebars');
app.use(express.static('public/'))
//Sets handlebars configurations (we will go through them later on)
app.engine('handlebars', handlebars({
layoutsDir: __dirname + '/views/layouts',
}));
var dbCon = mysql.createConnection({
     host: 'localhost',
     database: 'CocktailMachine',
     user:'cocktailMachine', 
     password: 'iLoveCocktails',
     multipleStatements: true
});
dbCon.connect();

app.get('/', (req, res) => {
//Serves the body of the page aka "main.handlebars" to the container //aka "index.handlebars"
res.redirect('/Home');
});
app.get('/Home', (req, res) => {
//Serves the body of the page aka "main.handlebars" to the container //aka "index.handlebars"
    dbCon.query('SELECT * FROM Stat JOIN Cocktail USING (CocktailID) ORDER BY NumberOFCocktails DESC', function(err, main, fields) {
    if (err) throw err;
        console.log("Index Request answered with: ",main)
        res.render('index', {layout : 'default', data: main});
    });
});
app.get('/Pumpen', (req, res) => {
//Serves the body of the page aka "main.handlebars" to the container //aka "index.handlebars"
    dbCon.query('SELECT * FROM Pumpe JOIN Zutat USING (ZutatID) ORDER BY PumpenID ASC;SELECT * FROM Zutat',[0, 1], function(err, main, fields) {
    if (err) throw err;
        console.log(main[0],main[1]);
        res.render('pumpen', {layout : 'default', data: main[0], zutaten: main[1]});
    });
});
app.get('/Cocktails', (req, res) => {
    dbCon.query("SELECT * FROM Cocktail;SELECT * FROM (Cocktail JOIN xRefCocktailZutat ON Cocktail.CocktailID = xRefCocktailZutat.xRefCocktailID) JOIN Zutat ON xRefZutatID = ZutatID;",[1, 2], function(err, main, fields) {
    if (err) throw err;
        console.log("Index Request answered with: ",main)
        //Serves the body of the page aka "main.handlebars" to the container //aka "index.handlebars"
        res.render('cocktails', {layout : 'default', cocktails: main[0],zutaten: main[1]});
    });
});
app.get('/Zutaten', (req, res) => {
//Serves the body of the page aka "main.handlebars" to the container //aka "index.handlebars"
    dbCon.query("SELECT * FROM Zutat WHERE NOT ZutatName = 'None'", function(err, main, fields) {
    if (err) throw err;
        console.log("Index Request answered with: ",main)
        res.render('zutaten', {layout : 'default', data: main});
    });
});
app.post('/Zutat*', urlencodedParser, function(req, res) {
    console.log(" - POST Request from HyperTCheck-Login_Subpage1.html recieved - ");
    console.log(req.body);
    if('neueZutat' in req.body){
        if(req.body['neueZutat'] == ''){
            console.log("leerer Zutaten Request, Ignoring");
        }
        else{
            var ins = req.body['neueZutat']
            var sql =`INSERT INTO Zutat (ZutatName) VALUES ('${ins}')`;
            console.log(sql);
            dbCon.query(sql, function (err, result) {
            if (err) throw err;
                console.log("1 record inserted");
            });
            res.redirect('/Zutaten');
            }
    }
    else if('delete' in req.body){
            var ins = req.body['delete']
            var sql =`DELETE FROM Zutat WHERE ZutatID =${ins}`;
            console.log(sql);
            dbCon.query(sql, function (err, result) {
            if (err) throw err;
                console.log("1 record deleted");
            });
            res.redirect('/Zutaten');
            }
    else{
        console.log("Unknown post");
        res.redirect('/Zutaten');
    }
    
});
app.listen(port, () => console.log(`App listening to port ${port}`));
