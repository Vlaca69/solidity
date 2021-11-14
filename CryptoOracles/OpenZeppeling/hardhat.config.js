require('@nomiclabs/hardhat-ethers');
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
// hardhat.config.js
const { alchemyApiKey, mnemonic } = require('./secrets.json');

module.exports = {
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${alchemyApiKey}`,
      accounts: { mnemonic: mnemonic },
    },
  },
  solidity: "0.8.4",
};