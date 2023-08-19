// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title A contract for Stella Token
 * @author Buki
 * @notice The token is not live
 * @dev This contract implements chailink vrf
 */
 contract Stella is ERC20, ReentrancyGuard {

    error InsufficientFunds();
    
    uint256 private immutable pool; 


    event Airdrop(address indexed to, uint indexed amount);
    event Lottery(address indexed to, uint indexed amount);
    event ethSwapforSTS(address indexed to, uint indexed amount);
    event stsSwapforETH(address indexed to, uint indexed amount);
    event exactTokenSwapped(address indexed t0, uint indexed tokenAmount, uint indexed EthAmount);

    constructor(
        uint256 initialSupply
        ) 
    ERC20("STELLA","STS")
     payable {
        pool = (initialSupply * msg.value) * 1e18;
        _mint(address(this),initialSupply);
     }
        
    /**
    implements a token swap, we assume ETH is an ERC20 TOKEN
    x*y = K 
    */
   
    function _requestSTSforETH(uint amount) internal view returns(uint STS){
        uint Txpool = pool;
        uint ethValue = address(this).balance;
        uint tokenBalance = balanceOf(address(this));
        uint newSTSValue = Txpool / ((ethValue + amount)* 1e18);
        STS = tokenBalance - newSTSValue;
    }
    
    // BUYING TOKENS
    function swapETHforSTS() external payable {
        uint STS = _requestSTSforETH(msg.value);
        _transfer(address(this),msg.sender,STS);
        emit ethSwapforSTS(msg.sender,STS);
    }
    
    //BUYING EXACT TOKENS
    function swapETHforExactToken(uint amount ) external payable{
        uint ethValue = requestETHforSTS(amount);
        require(msg.value == ethValue, "Price has Changed");
        _transfer(address(this),msg.sender,amount);
        emit exactTokenSwapped(msg.sender,amount,msg.value);
    }

        
    function requestETHforSTS(uint amount) public view returns(uint newEthTokenValue) {
        uint Txpool = pool;
        uint ethValue = address(this).balance;
        uint tokenBalance = balanceOf(address(this));
        uint newEthValue = Txpool / ((tokenBalance+amount)* 1e18);
        newEthTokenValue = ethValue - newEthValue;
    }

    // SELLING STSTOKEN for Ethereum
    function swapSTSforETH(uint amount)external {
        if(balanceOf(msg.sender) < amount){
            revert InsufficientFunds();
        }
        uint ethAmount = requestETHforSTS(amount);
        (bool sent,) = msg.sender.call{value:ethAmount}("");
        require(sent);
        emit stsSwapforETH(msg.sender, ethAmount);     
    }


/**
    we are sending burning any tokens thats mistakenly eneters the contract
    we can easily send the tokens back to the sender, but we will assume the sender is an attack
 */
    receive() external payable nonReentrant {
        uint amount = msg.value;
        address _msgSender = address(0);
        (bool sent,) = _msgSender.call{value:amount}("");
        require(sent);
        }
   

}