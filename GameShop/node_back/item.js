const {DataTypes, Model, Sequelize} = require('sequelize');
const database = require('./database')


class Item extends Model {}

const itemSchema = {
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    status: {
        type: DataTypes.STRING,
        allowNull: false
    },
    minPrice: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    activationCode: {
        type: DataTypes.STRING,
        allowNull: false
    },

}

const initItem = (sequelize) => {
    Item.init(itemSchema, {modelName: 'Item', sequelize})
    return Item
}


module.exports = {Item, initItem}