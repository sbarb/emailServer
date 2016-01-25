var app = require('express')();
var bodyParser = require('body-parser');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data

app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

function run_cmd(cmd, args, callBack ) {
    var spawn = require('child_process').spawn;
    var child = spawn(cmd, args);
    var resp = "";

    child.stdout.on('data', function (buffer) { resp += buffer.toString() });
    child.stdout.on('end', function() { callBack (resp) });
}

app.post('/', function (req, res) {
    var argArray = [];

    if (req.body.conf) {
        argArray.push("-C");
        argArray.push(req.body.conf);
    }

    if (req.body.to) {
        for (var arg in req.body.args){
            argArray.push("-t");
            argArray.push(req.body.to);
        }
    }

    if (req.body.subj) {
        argArray.push("-s");
        argArray.push(req.body.subj);
    }

    if (req.body.msg) {
        argArray.push("-m");
        argArray.push(req.body.msg);
    }

    if (req.body.attach) {
        for (var arg in req.body.args){
            argArray.push("-a");
            argArray.push(req.body.attach);
        }
    }

    if (req.body.html_file) {
        argArray.push("-H");
        argArray.push(req.body.html_file);
    }

    if (req.body.args) {
        for (var arg in req.body.args){
            argArray.push(req.body.args[arg]);
        }
    }

    var response = "\n\n";
    run_cmd( "email", argArray, function(text) {
        console.log (text)
        response += text;
        response += "\n\n";
        res.send(response);
    });
});

app.listen(4000, function () {
    var os = require( 'os' );
    var networkInterfaces = os.networkInterfaces( );

    for (var con in networkInterfaces) {
        console.log('Email app running on', networkInterfaces[con][0]["address"]+':4000');
    }

    console.log('Now you have an endpoint to to send an email to');

    console.log("Default config file is located at ~/.email/config");

    console.log("Press Ctrl+C to exit");
});
