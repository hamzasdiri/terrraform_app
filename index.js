import express from "express"
import dotenv from "dotenv"

const app = express();

dotenv.config();

const PORT = process.env.PORT || 3000;

app.get('/',(req,res)=>{
    res.status(200).send("WELCOME");
    
})

app.listen(PORT,async()=>{
    console.log(`Server listening on port : ${PORT}`)
})