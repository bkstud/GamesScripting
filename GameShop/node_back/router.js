const express = require('express')
const handler = require('./handler')

router = express.Router()
router.get('/items', handler.getAllItems)
router.get('/items/buy/:id', handler.getItemCode)

module.exports = router