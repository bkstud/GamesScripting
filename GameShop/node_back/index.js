const express = require('express')
const database = require('./database')
const router = require('./router')


const app = express()
const PORT = 3001


//enable CORS
app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});
app.use(express.json())

database().then(
    console.log("Initialized database.")
)

app.use("/", router)

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`)
})