exports.getRootView = () => `
    <html>
      <head><title>mywebapp API</title></head>
      <body>
        <h1>mywebapp endpoints</h1>
        <ul>
          <li>GET /health/alive</li>
          <li>GET /health/ready</li>
          <li>GET /tasks </li>
          <li>POST /tasks</li>
          <li>POST /tasks/:id/done</li>
        </ul>
      </body>
    </html>
  `;
