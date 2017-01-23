#! /bin/sh

pm2 start index.js --name test

#pm2 start socket/app.json --no-daemon

supervisor socket/app.js