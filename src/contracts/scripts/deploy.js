async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const CASINO = await ethers.getContractFactory("Casino");
  const ownerAddress = "0xeb5406A2d82DBb73eb0c4BdbeC5DEF57c9342beD";
  const vrfContractAddress = "0x09990dbf33ddd5d5285847def61bf980fbb8c3ca";

  const estimatedGas = await CASINO.signer.estimateGas(
    CASINO.getDeployTransaction(ownerAddress, vrfContractAddress)
  );
  console.log("estimatedGas", estimatedGas);

  // Get current gas price in wei
  const gasPrice = await ethers.provider.getGasPrice();
  console.log("Gas Price (in wei):", gasPrice.toString());

  // Calculate total gas cost in wei
  const totalGasCostInWei = estimatedGas.mul(gasPrice);
  console.log("Total Gas Cost (in wei):", totalGasCostInWei.toString());

  // Convert total gas cost to ether
  const totalGasCostInEther = ethers.utils.formatEther(totalGasCostInWei);
  console.log("Total Gas Cost (in ether):", totalGasCostInEther);

  // Get account balance
  const accountBalanceInWei = await deployer.getBalance();
  const accountBalanceInEther = ethers.utils.formatEther(accountBalanceInWei);
  console.log("Account Balance (in ether):", accountBalanceInEther);

  // Check if balance is sufficient
  if (parseFloat(accountBalanceInEther) >= parseFloat(totalGasCostInEther)) {
    console.log("Account balance is sufficient.");
  } else {
    console.log("Account balance is insufficient.");
  }

  const casino = await CASINO.deploy(ownerAddress, vrfContractAddress);
  // Save copies of each contracts abi and address to the frontend.
  saveFrontendFiles(casino, "Casino");
  console.log("Token address:", await casino.getAdress());
}

function saveFrontendFiles(contract, name) {
  const fs = require("fs");
  const contractsDir = __dirname + "/../../contracts/contractsData";
  console.log("contractsDir", contractsDir);

  if (!fs.existsSync(contractsDir)) {
    console.log("create dir");
    fs.mkdirSync(contractsDir);
  }

  console.log("check folder done");

  fs.writeFileSync(
    contractsDir + `/${name}-address.json`,
    JSON.stringify({ address: contract.address }, undefined, 2)
  );

  console.log("write address done");

  const contractArtifact = artifacts.readArtifactSync(name);

  fs.writeFileSync(
    contractsDir + `/${name}.json`,
    JSON.stringify(contractArtifact, null, 2)
  );

  console.log("write contract done");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
