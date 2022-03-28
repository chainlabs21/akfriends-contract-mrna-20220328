var MyKIP17 = artifacts.require('MyKIP17');

module.exports = function(deployer) {
  deployer.deploy(MyKIP17, 
    "Animal Kingdom Friends", "AKF", 
    "ipfs://bafybeidvaxawdoye3gi4bi6nfb6iicjzc6cmvndad3skr67c5wdasebcau/",
    {gas: 5000000})
};
