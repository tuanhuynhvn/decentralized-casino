import { ethers } from "ethers";
import CasinoAbi from "../contracts/contractsData/Casino.json";
import CasinoAddress from "../contracts/contractsData/Casino-address.json";

let casino = null;

const loadContracts = async (signer) => {
  casino = new ethers.Contract(CasinoAddress.address, CasinoAbi.abi, signer);
};

const tokenBalance = async (acc) => {
  try {
    const balance = await casino.tokenBalance(acc);

    const result = parseInt(balance._hex);
    console.log("token", result);
    return result;
  } catch (e) {
    console.log(e);
    return 0;
  }
};

const buyTokens = async (tokenNum, value) => {
  console.log(
    "buy",
    ethers.utils.parseEther(value.toString()).toString(),
    tokenNum
  );
  const estimatedGas = await casino.estimateGas.compraTokens(tokenNum, {
    value: ethers.utils.parseEther(value.toString()),
  });

  // Increase gas limit by a buffer (e.g., 20%)
  const gasLimit = estimatedGas.mul(1000).div(100);
  console.log("estimate gas", estimatedGas, gasLimit);

  await (
    await casino.compraTokens(tokenNum, {
      value: ethers.utils.parseEther(value.toString()),
      gasLimit: gasLimit,
    })
  ).wait();
};

const withdrawTokens = async (tokenNum) => {
  await (await casino.devolverTokens(tokenNum)).wait();
};

const playRoulette = async (start, end, tokensBet) => {
  console.log(
    "playRoulette",
    start.toString(),
    end.toString(),
    tokensBet.toString()
  );
  const estimatedGas = await casino.estimateGas.jugarRuleta(
    start.toString(),
    end.toString(),
    tokensBet.toString()
  );

  // Increase gas limit by a buffer (e.g., 20%)
  const gasLimit = estimatedGas.mul(450).div(100);
  console.log("estimate gas", estimatedGas, gasLimit);

  const game = await (
    await casino.jugarRuleta(
      start.toString(),
      end.toString(),
      tokensBet.toString(),
      {
        gasLimit: gasLimit,
      }
    )
  ).wait();
  let result;
  try {
    result = {
      numberWon: parseInt(game.events[1].args[0]._hex),
      result: game.events[1].args[1],
      tokensEarned: parseInt(game.events[1].args[2]._hex),
    };
  } catch (error) {
    result = {
      numberWon: parseInt(game.events[2].args[0]._hex),
      result: game.events[2].args[1],
      tokensEarned: parseInt(game.events[2].args[2]._hex),
    };
  }
  return result;
};

const tokenPrice = async () => {
  const price = await casino.precioTokens(1);
  return ethers.utils.formatEther(price._hex);
};

const historial = async (account) => {
  const historial = await casino.tuHistorial(account);
  let historialParsed = [];
  historial.map((game) =>
    historialParsed.push([game[2], parseInt(game[0]), parseInt(game[1])])
  );
  return historialParsed;
};

export default {
  loadContracts,
  tokenBalance,
  buyTokens,
  tokenPrice,
  historial,
  playRoulette,
  withdrawTokens,
};
