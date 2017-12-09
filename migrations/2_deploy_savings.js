var SavingsContract = artifacts.require("SavingsContract.sol");

module.exports = function(deployer) {
    deployer.deploy(SavingsContract);
};