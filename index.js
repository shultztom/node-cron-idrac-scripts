require("dotenv").config();
const shell = require("shelljs");
const cron = require("node-cron");

shell.env["idracPass"] = process.env.IDRAC_PASS;

// First Run
shell.exec("./r610-set-fans.sh");
shell.exec("./r710-set-fans.sh");

cron.schedule("*/2 * * * *", () => {
  shell.exec("./r610-set-fans.sh");
  shell.exec("./r710-set-fans.sh");
});
