const {Sequelize} = require('sequelize');
var {initItem, Item} = require('./item')


async function createTestData() {
    await Item.create({name:"Horror game",
                       status: "ready", minPrice: 20, activationCode: "AA:BB"})
    await Item.create({name: "RPG game",
                       status: "beta", minPrice: 30, activationCode: "AA:BB"})
}


async function initialize() {
    const sequelize = new Sequelize({
        dialect: 'sqlite',
        storage: 'db.sqlite'
    });

    try {
        sequelize.authenticate();
        console.log('Connection has been established successfully.');
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
    
    const Item = initItem(sequelize)
    await Item.sync({force: true})
    createTestData()
 
    return sequelize   
}

module.exports = initialize