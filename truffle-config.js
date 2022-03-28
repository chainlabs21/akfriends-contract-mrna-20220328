// Load modules
const fs = require('fs');
const path = require("path");
const Caver = require('caver-js')
const HDWalletProvider = require("truffle-hdwallet-provider-klaytn");

// Load configuration from .env
require('dotenv').config()

// Configuration
const accessKeyId = process.env.ACCESS_KEY;
const secretAccessKey = process.env.SECRET_ACCESS_KEY;
const privateKey = process.env.MINTER_PRV_KEY;
const cypressPrivateKey = process.env.MINTER_PRV_KEY;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      gas: 80000000
    },
    klaytn: {
      provider: () => {
        const pks = JSON.parse(fs.readFileSync(path.resolve(__dirname)+'/privateKeys.js'))

        return new HDWalletProvider(pks, "http://localhost:8551", 0, pks.length)
      },
      network_id: '203', //Klaytn baobab testnet's network id
      gas: '8500000',
      gasPrice: null
    },
    kasBaobab: {
      provider: () => {
        const option = {
          headers: [
            { name: 'Authorization', value: 'Basic ' + Buffer.from(accessKeyId + ':' + secretAccessKey).toString('base64') },
            { name: 'x-chain-id', value: '1001' }
          ],
          keepAlive: false,
        }
        return new HDWalletProvider(privateKey, new Caver.providers.HttpProvider("https://node-api.klaytnapi.com/v1/klaytn", option))
      },
      network_id: '1001', //Klaytn baobab testnet's network id
      gas: '8500000',
      gasPrice:'25000000000'
    },
    kasCypress: {
      provider: () => {
        const option = {
          headers: [
            { name: 'Authorization', value: 'Basic ' + Buffer.from(accessKeyId + ':' + secretAccessKey).toString('base64') },
            { name: 'x-chain-id', value: '8217' }
          ],
          keepAlive: false,
        }
        return new HDWalletProvider(cypressPrivateKey, new Caver.providers.HttpProvider("https://node-api.klaytnapi.com/v1/klaytn", option))
      },
      network_id: '8217', //Klaytn baobab testnet's network id
      gas: '8500000',
      gasPrice:'25000000000'
    },
    baobab: {
      provider: () => { return new HDWalletProvider(privateKey, "http://your.baobab.en:8551") },
      network_id: '1001', //Klaytn baobab testnet's network id
      gas: '8500000',
      gasPrice: null
    },
    cypress: {
      provider: () => { return new HDWalletProvider(privateKey, "http://your.cypress.en:8551") },
      network_id: '8217', //Klaytn mainnet's network id
      gas: '8500000',
      gasPrice: null
    }
  },
  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.6",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "constantinople"
      }
    }
  }
}
