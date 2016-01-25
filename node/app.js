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

    if (req.body.to) {
        argArray.push("-t");
        argArray.push(req.body.to);
    }

    if (req.body.subj) {
        argArray.push("-s");
        argArray.push(req.body.subj);
    }

    if (req.body.msg) {
        argArray.push("-m");
        argArray.push(req.body.msg);
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
    console.log('Example app listening on port 4000!');
});
