const {Item} = require('./item');
const {Op} = require('sequelize');

const getAllItems = async (req, res) => {
    await Item.findAll({raw: true,
                        attributes: {exclude: ["activationCode"]}}).then(
        result => res.status(200).json(result),
        error => res.status(500).json({"error": error})
    )
}

const getItemCode = async (req, res) => {
    const id = req.params.id;
    await Item.findByPk(id,
        {
            raw: true,
        }).then(
            result => res.status(200).json(result.activationCode),
            error => res.status(500).json({"error": error})
        )

}

module.exports = {
    getAllItems,
    getItemCode
}