import express from 'express';
import fs from 'fs';
import path from 'path';
import os from 'os';


const app = express();

// 방법 1 - ejs 이용
// const engine = ejs;
// app.engine('html', engine.renderFile );
// app.set('view engine', 'html');
// app.set('views', './views');
// app.get('/', (req, res) => {
//     res.render("index.html")
// });

// 방법 2 - ejs 이용 안 하기
const __dirname = path.resolve();
app.get('/', (req, res) => {
    res.sendFile(__dirname + "/views/lab.html")
});

app.use(express.json());

// USER 정보 저장
app.post('/signup', (req, res) =>{
    const fileExists = fs.existsSync('user.json');
    const reqId = req.body.username;
    let saveData;

    if(fileExists){
        let userData = JSON.parse(fs.readFileSync('user.json'));
        const duplicated = userData.filter((e)=>{ // 중복 확인
            return e.username === reqId
        }).length;
        if (duplicated == 0){ //user명이 없는 경우
            userData.push(req.body);
            saveData = userData;
        }
        else{ //User명이 존재하는 경우
            return res.status(201).send('Username already exists'); 
        }  
    } else{
        saveData = [req.body]
    }
    fs.writeFileSync('user.json', JSON.stringify(saveData));
    res.status(201).send('Json read&write Success!');
})

app.post('/login', (req, res) =>{
    const fileExists = fs.existsSync('user.json');
    if (!fileExists){ // User Json 파일 없는 경우 
        return res.status(401).send("No User Json File");
    }
    const reqId = req.body.username;
    const reqPw = req.body.password;
    const jsonFile = fs.readFileSync('user.json', 'utf-8');
    const jsonUser = JSON.parse(jsonFile);
    const check = jsonUser.filter( (e) =>{ // 해당 id와 pw가 데이터베이스에 있는지 확인
        return e.username === reqId && e.password === reqPw;
    }).length;
    if (check){
        res.status(200).send('Login Success!');
    }
    else{
        res.status(401).send('Login Failed!');
    }
    
})

// app.get('/users', (res, req) => {
//     fs.readFileSync('user.json');
// })

app.get('/os', (req, res) =>{
    const osInfo = {
        "type": os.type(),
        "hostname": os.hostname(),
        "cpu_num": os.cpus().length,
        "total_mem": `${Math.round(os.totalmem()/1000000)}MB`,
    }
    res.json(osInfo);

})

app.listen(3000, ()=>{
    console.log("App is Running");
})


