const {Item} = require('./item');
const {Order} = require('./order');
const {Op} = require('sequelize');

const getAllItems = async (req, res) => {
    await Item.findAll({raw: true,
                        attributes: {exclude: ["activationCode"]}}).then(
        result => res.status(200).json(result),
        error => res.status(500).json({"error": error})
    )
}

const addOrder = async (req, res) => {
    const itemsToOrder = req.body.order
    if (!itemsToOrder || itemsToOrder.length === 0) {
        res.status(503)
        res.json({"status": "error no order items"});
        return
    }

    const items = itemsToOrder.map((it) => it.id)
    await Order.create({"items": items})
    res.json({"status": "ok"});

}

module.exports = {
    getAllItems,
    addOrder
}