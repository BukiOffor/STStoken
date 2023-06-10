// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Stella is ERC20{
    constructor(uint256 initialSupply) ERC20("STELLA","STS"){
        _mint(address(this),initialSupply);
    }
    
    event Airdrop(address to, uint amount);

    function airdrop(address to) public virtual {
        address owner = address(this);
        uint amount = 10000000000;
        require(balanceOf(owner) > amount, "Reserve is dry");
        require(balanceOf(to) <= 0, "Received ICO before");
        require(amount < 10e10, "Amount too much");
        _transfer(owner,to,amount);
        emit Airdrop(to,amount);    
    }
}