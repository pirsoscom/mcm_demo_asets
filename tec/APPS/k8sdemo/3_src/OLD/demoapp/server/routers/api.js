const express = require('express');

module.exports = function (app) {
  const router = express.Router();

  router.get('/', function (req, res, next) {
    res.setHeader('content-type', 'application/json');
    res.end(JSON.stringify([{
      "id": 2,
      "status": "OK",
      "ip_address": "230.193.186.64"
  }, {
      "id": 3,
      "status": "NOK",
      "ip_address": "10.31.130.79"
  }]));

   
  });

  app.use('/api', router);
}




