require("dotenv").config();
const shell = require("shelljs");
const cron = require("node-cron");

shell.env["idracPass"] = process.env.IDRAC_PASS;
const setFans = () => {
  shell.exec(__dirname + "/r310-set-fans.sh");
  shell.exec(__dirname + "/r610-set-fans.sh");
  shell.exec(__dirname + "/r710-set-fans.sh");
};

const healthCheck = () => {
  shell.exec(
    `curl -fsS --retry 3 https://hc-ping.com/${process.env.HEALTH_CHECK_KEY} > /dev/null`
  );
};

// First Run
setFans();
healthCheck();

cron.schedule("*/2 * * * *", () => {
  setFans();
});

cron.schedule("0 */8 * * *", () => {
  healthCheck();
});
