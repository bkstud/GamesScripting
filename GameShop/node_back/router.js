const express = require('express')
const handler = require('./handler')

router = express.Router()
router.get('/items', handler.getAllItems)
router.post('/order', handler.addOrder)

module.exports = router