const express = require('express');
const app = express();
const port = 8080;
const os = require('os');

app.get('/', (req, res) => {
  res.send(`Hello World! Running on host: ${os.hostname()}`);
});

app.get('/health', (req, res) => {
  res.status(200).send('ok');
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
