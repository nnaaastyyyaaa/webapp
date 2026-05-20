const prisma = require("../prisma/prismaClient");

exports.getAlive = (req, res) => res.status(200).send("OK");

exports.getReady = async (req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.status(200).send("OK");
  } catch (err) {
    res.status(500).send(`Database not ready: ${err.message}`);
  }
};
