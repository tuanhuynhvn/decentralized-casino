// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Token.sol";
import "hardhat/console.sol";
import "./IVRF.sol"; // Import the interface

contract Casino is Ownable{

    event RouletteGame (
        uint NumberWin,
        bool result,
        uint tokensEarned
    );

    ERC20 private token;
    address public tokenAddress;
    IVRF public vrfContract;

    // precio: price
    function precioTokens(uint256 _numTokens) public pure returns (uint256){
        return _numTokens * (0.001 ether);
    }

    function tokenBalance(address _of) public view returns (uint256){
        return token.balanceOf(_of);
    }

    constructor(address initialOwner, address vrfContractAddress)  Ownable(initialOwner){
        token =  new ERC20("Casino", "CAS");
        tokenAddress = address(token);
        token.mint(1000000);
        vrfContract = IVRF(vrfContractAddress);
    }

    // Visualization of the ether balance of the Smart Contract
    function balanceEthersSC() public view returns (uint256){
        return address(this).balance / 10**18;
    }

    function getAdress() public view returns (address){
        return address(token);

    }

    // buy token
     function compraTokens(uint256 _numTokens) public payable{        
        // User registration
        // Establishment of the cost of the tokens to be purchased
        // Evaluation of the money that the client pays for the tokens
        console.log("fee ", precioTokens(_numTokens), "account balance", msg.value);
        require(msg.value >= precioTokens(_numTokens), "Buy fewer tokens or pay with more ethers");

        // Creation of new tokens in case there is not enough supply
        if  (token.balanceOf(address(this)) < _numTokens){
            token.mint(_numTokens*100000);
        }

        // Refund of excess money
        // Smart Contract returns the remaining amount
        payable(msg.sender).transfer(msg.value - precioTokens(_numTokens));

        // Sending the tokens to the client/user
        token.transfer(address(this), msg.sender, _numTokens);
    }

    // Returning tokens to the Smart Contract
    function devolverTokens(uint _numTokens) public payable {
        // The number of tokens must be greater than 0
        require(_numTokens > 0, "You need to return a number of tokens greater than 0");

        // The user must prove they have the tokens they want to return
        require(_numTokens <= token.balanceOf(msg.sender), "You do not have the tokens you want to return");

        // The user transfers the tokens to the Smart Contract
        token.transfer(msg.sender, address(this), _numTokens);

        // The Smart Contract sends the ethers to the user
        payable(msg.sender).transfer(precioTokens(_numTokens)); 
    }

    struct Bet {
        uint tokensBet;
        uint tokensEarned;
        string game;
    }

    struct RouleteResult {
        uint NumberWin;
        bool result;
        uint tokensEarned;
    }

    // historical betting
    mapping(address => Bet []) historialApuestas;

    // to remove Eth
    function retirarEth(uint _numEther) public payable onlyOwner {
        // The number of tokens must be greater than 0
        require(_numEther > 0, "You need to return a number of tokens greater than 0");

        // The user must prove they have the tokens they want to return
        require(_numEther <= balanceEthersSC(), "You do not have the tokens you want to return");

        // Transfer the requested ethers to the owner of the smart contract
        payable(owner()).transfer(_numEther);
    }

    // tu: you, ropietario: owner
    function tuHistorial(address _propietario) public view returns(Bet [] memory){
        return historialApuestas[_propietario];
    }

    // playRoulette
    function jugarRuleta(uint _start, uint _end, uint _tokensBet) public{
        require(_tokensBet <= token.balanceOf(msg.sender), " Insufficient token");
        require(_tokensBet > 0);
        
        //uint random = uint(uint(keccak256(abi.encodePacked(block.timestamp))) % 14); // todo: get random from Oracle
        uint random = vrfContract.getResult(1);
        uint tokensEarned = 0;
        bool win = false;
        token.transfer(msg.sender, address(this), _tokensBet);
        
        console.log(
            "start end random", _start, _end,
            random
        );
        console.log("current balance", token.balanceOf(msg.sender));
        if ((random <= _end) && (random >= _start)) {
            win = true;
            if (random == 0) {
                tokensEarned = _tokensBet*14;
            } else {
                tokensEarned = _tokensBet * 2;
            }

            if  (token.balanceOf(address(this)) < tokensEarned){
                token.mint(tokensEarned*100000);
            }

            token.transfer( address(this), msg.sender, tokensEarned);
            console.log("win balance", token.balanceOf(msg.sender));
        }
            
        addHistorial("Roulete", _tokensBet, tokensEarned, msg.sender);
        emit RouletteGame(random, win, tokensEarned);
    }

    function addHistorial(string memory _game, uint _tokensBet,  uint _tokenEarned, address caller) internal{
        Bet memory apuesta = Bet(_tokensBet, _tokenEarned, _game);
        historialApuestas[caller].push(apuesta);
    }
}




