exports.renderTasksHtml = (tasks) => {
  let rows = ``;
  for (const task of tasks)
    rows += `      <tr>
        <td>${task.id}</td>
        <td>${task.title}</td>
        <td>${task.status}</td>
        <td>${task.created_at}</td>
      </tr>`;
  const table = `
    <!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>All tasks</title>
  </head>
  <body>
    <table>
      <tr>
        <td>Id</td>
        <td>Title</td>
        <td>Status</td>
        <td>Created at</td>
      </tr>
      ${rows}
    </table>
  </body>
</html>

    `;
  return table;
};

exports.createdTask = () => `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>All tasks</title>
  </head>
  <body>
    <h1>Succefully created your task!</h1>
  </body>
</html>
`;

exports.taskWithChangedStatus = (task) => `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>All tasks</title>
  </head>
  <body>
    <h1>Successfully updated your task status!</h1>
    <table>
      <tr>
        <td>Id</td>
        <td>Title</td>
        <td>Status</td>
        <td>Created at</td>
      </tr>
      <tr>
        <td>${task.id}</td>
        <td>${task.title}</td>
        <td>${task.status}</td>
        <td>${task.created_at}</td>
      </tr>
    </table>
  </body>
</html>
`;
