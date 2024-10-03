require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.20",

  paths: {
    artifacts: "./artifacts",
    sources: "./contracts",
    cache: "./cache",
    tests: "./tests",
  },
  defaultNetwork: "polygonAmoy",
  networks: {
    polygonAmoy: {
      url: "https://rpc-amoy.polygon.technology", //"https://polygon-amoy.blockpi.network/v1/rpc/public", //process.env.POLYGON_AMOY_RPC,
      accounts: [
        "105ec09d904b3efc9f4565279779ab91b81d113ea7bc9e6b605aa65813509c13",
      ], //[process.env.PRIVATE_KEY],
      timeout: 200000,
    },
  },
};
