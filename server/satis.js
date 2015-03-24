var http = require('http');
var sys = require('sys');
var exec = require('child_process').exec;
var express = require('express');
var app = express();
var serveStatic = require('serve-static');


// Add headers
app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
    res.setHeader('Access-Control-Allow-Credentials', true);
    next();
});

app.use(serveStatic('/satis/web', {'index': ['index.html']}))

var buildHook = function (req, res) {
  exec("scripts/build.sh", function (error, stdout, stderr) {
    if (stdout) res.end(stdout);
  });
};

app.get('/build', buildHook);
app.post('/build', buildHook);

module.exports = app;
