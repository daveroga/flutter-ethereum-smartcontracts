const ConvertLib = artifacts.require("ConvertLib");
const PetAdoption = artifacts.require("PetAdoption");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, PetAdoption);
  deployer.deploy(PetAdoption);
};
