const FileHistoryLib = artifacts.require("FileHistoryLib");
const FileHistory = artifacts.require("FileHistory");

module.exports = function(deployer) {
  deployer.deploy(FileHistoryLib);
  deployer.link(FileHistoryLib, FileHistory);
  deployer.deploy(FileHistory);
};
