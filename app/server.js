const dotenv = require("dotenv");
dotenv.config({ path: "./.env.example" });

const http = require("http");

const app = require("./app");

const server = http.createServer(app);

// if (process.env.DOCKER === "true") {
const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
// } else {
//   server.listen({ fd: 3 });
// }
