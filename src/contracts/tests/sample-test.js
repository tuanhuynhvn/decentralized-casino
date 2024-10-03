const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Casino", function () {
  it("works", async function () {
    const Casino = await ethers.getContractFactory("Casino");
    const casino = await Casino.deploy();
    await casino.deployed();

    const addresss = await casino.getAdress();
    console.log("address", addresss);

    const [owner] = await ethers.getSigners();
    console.log("owner address", owner.address);
    const balance = await ethers.provider.getBalance(owner.address);
    console.log("owner balance", balance);

    //await network.provider.send("hardhat_setBalance", [owner.address, "0x100"]);

    const buyTx = await casino.compraTokens(100, {
      value: "100000000000000000",
    });
    await buyTx.wait();

    const playTx = await casino.jugarRuleta(1, 7, 10);
    const result = await playTx.wait();
    const event = result.events?.filter((x) => {
      return x.event == "RouletteGame";
    });
    console.log("event", event);

    const history = await casino.tuHistorial(owner.address);
    console.log("history ", history);
  });
});
