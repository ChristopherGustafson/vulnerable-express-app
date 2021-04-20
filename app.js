const express = require("express");

const app = express();

const template = (content) => `<html><body>${content}</body></html>`;

app.get("/", (req, res) => {
    const content = request?.query["content"] ?? "";
    res.send(template(content));
});
