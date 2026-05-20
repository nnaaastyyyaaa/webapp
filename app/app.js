const express = require("express");
const tasksRouter = require("./routes/taskRouter");
const healthRoutes = require("./routes/healthRoutes");
const { getRootView } = require("./views/templates/root");

const app = express();
app.use(express.json());

app.use("/", tasksRouter);
app.use("/health", healthRoutes);
app.get("/", (req, res) => {
  const accept = req.headers.accept || "";

  if (!accept.includes("text/html")) {
    return res.status(406).send("Only text/html is supported");
  }

  res.setHeader("Content-Type", "text/html");

  res.send(getRootView());
});
module.exports = app;
