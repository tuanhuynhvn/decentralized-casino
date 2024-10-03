// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interface for the deployed contract
interface IVRF {
    // Define the signature of the function you want to call
    function getResult(uint256 roundId) external view returns (uint256);
}