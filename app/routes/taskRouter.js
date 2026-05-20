const express = require("express");
const router = express.Router();
const controller = require("../controllers/taskController");

router.get("/tasks", controller.getTasks);
router.post("/tasks", controller.createTask);
router.post("/tasks/:id/done", controller.setTaskDone);

module.exports = router;
