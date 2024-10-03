require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const privateKey = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.4",
  paths: {
    artifacts: "./src/contracts/artifacts",
    sources: "./src/contracts/contracts",
    cache: "./src/contracts/cache",
    tests: "./src/contracts/tests",
  },
  defaultNetwork: "polygonAmoy",
  networks: {
    polygonAmoy: {
      url: process.env.POLYGON_AMOY_RPC,
      accounts: [privateKey],
    },
    ganache: {
      url: "http://127.0.0.1:7545",
    },
    polygon: {
      url: "https://rpc-mumbai.maticvigil.com/v1/99a99d15ac2ad3b526aa97401fdbe30ee724ba38",
      accounts: [privateKey],
    },
    testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [privateKey],
    },
    bsc: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [privateKey],
    },
    hardhat: {},
  },
};
