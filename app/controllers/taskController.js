const {
  renderTasksHtml,
  createdTask,
  taskWithChangedStatus,
} = require("../views/templates/tasks");

const prisma = require("../prisma/prismaClient");

exports.getTasks = async (req, res) => {
  try {
    const listTasks = await prisma.task.findMany();
    if (req.headers.accept?.includes("text/html")) {
      return res.send(renderTasksHtml(listTasks));
    }
    res.json(listTasks);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createTask = async (req, res) => {
  try {
    const { title } = req.body;
    if (!title) return res.status(400).send("Enter title please");
    const task = await prisma.task.create({
      data: {
        title,
      },
    });
    if (req.headers.accept?.includes("text/html")) {
      return res.send(createdTask());
    }
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.setTaskDone = async (req, res) => {
  try {
    const id = req.params.id;
    const task = await prisma.task.update({
      where: {
        id: Number(id),
      },
      data: {
        status: "done",
      },
    });
    if (!task) return res.status(400).send("Note not found");
    if (req.headers.accept?.includes("text/html")) {
      return res.send(taskWithChangedStatus(task));
    }
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
