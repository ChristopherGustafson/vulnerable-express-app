const express = require("express");

const app = express();

const port = 3000;

const template = (content) => `<html><body>${content}</body></html>`;

app.get("/", (req, res) => {
    const content = req?.query["content"] ?? "";
    res.send(template(content));
});

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});
