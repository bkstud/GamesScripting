const {DataTypes, Model, Sequelize} = require('sequelize');
const database = require('./database')


class Order extends Model {}

const orderSchema = {
    items: {
        type: DataTypes.JSON,
        allowNull: false
    },

}

const initOrder = (sequelize) => {
    Order.init(orderSchema, {modelName: 'Order', sequelize})
    return Order
}


module.exports = {Order, initOrder}