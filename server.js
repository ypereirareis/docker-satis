var http = require('http');
var sys = require('sys')
var exec = require('child_process').exec;
var express = require('express')
var app = express()


// Add headers
app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
    res.setHeader('Access-Control-Allow-Credentials', true);
    next();
});

app.get('/', function (req, res) {
 res.sendFile('/satis/web/index.html');
});

app.get('/build', function (req, res) {
  exec("cd /satis && php bin/satis -n build config.json web/", function (error, stdout, stderr) {
    if (stdout) res.end(stdout);
  });
});


var server = app.listen(3000, function () {
  var host = server.address().address
  var port = server.address().port
  console.log('Satis server listening at http://%s:%s', host, port)
});
