const express = require("express");
const router = express.Router();
const controller = require("../controllers/healthController");

router.get("/alive", controller.getAlive);
router.get("/ready", controller.getReady);

module.exports = router;
