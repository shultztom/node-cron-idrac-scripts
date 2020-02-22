require("dotenv").config();
const shell = require("shelljs");
const cron = require("node-cron");

shell.env["idracPass"] = process.env.IDRAC_PASS;

// First Run
shell.exec(__dirname + "/r610-set-fans.sh");
shell.exec(__dirname + "/r710-set-fans.sh");

cron.schedule("*/2 * * * *", () => {
  shell.exec(__dirname + "/r610-set-fans.sh");
  shell.exec(__dirname + "/r710-set-fans.sh");
});
