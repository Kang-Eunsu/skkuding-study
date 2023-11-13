const http = require('http');
const fs = require('fs');
const os = require('os');
const express = require('express');
const nunjucks = require('nunjucks');

app = express();
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
nunjucks.configure("./views", {
    express: app
})

http.createServer(app).listen(3000, function () {
    console.log('server running at http://127.0.0.1:3000')
})

app.get('/', (req, res) => {
    res.render("index.html", {
        type: os.type(),
        hostname: os.hostname(),
        cpu_num: os.cpus().length,
        total_mem: `${Math.round(os.totalmem()/1000000)}MB`,
    })
})



//http 모듈 안 쓰고 하는 법: express + nunjucks 
/*
const express = require('express');
const os = require('os');
const nunjucks = require('nunjucks');



const app = express();

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
nunjucks.configure("./views", {
    express: app
})

app.get('/', (req, res) => {
    res.render("lab1.html", {
        type: os.type(),
        hostname: os.hostname(),
        cpu_num: os.cpus().length,
        total_mem: `${Math.round(os.totalmem()/1000000)}MB`,
    })
})


app.listen(3000, ()=>{
    console.log("App is Running");
})
*/


