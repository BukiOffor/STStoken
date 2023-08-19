// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

/**
 * @title A contract for Stella Token
 * @author Buki
 * @notice The token is not live
 * @dev This contract implements chailink vrf
 */
 contract Stella is ERC20{

    error InsufficientFunds();
    
    uint256 private immutable pool; 


    struct Status{
        bool exists;
        bool fulfiled;
        uint[] words;
    }
 
    mapping(uint=>Status) public randomness;

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
        pool = initialSupply * msg.value;
        _mint(address(this),initialSupply);
     }
    
    
    /**
    implements a token swap, we assume ETH is an ERC20 TOKEN
    x*y = K 
    */
   
    function requestSTSforETH(uint amount) public view returns(uint STS){
        uint Txpool = pool;
        uint ethValue = address(this).balance;
        uint tokenBalance = balanceOf(address(this));
        uint newSTSValue = Txpool / ethValue + amount;
        STS = tokenBalance - newSTSValue;
    }
    // BUYING TOKENS
    function swapETHforSTS() external payable {
        uint STS = requestSTSforETH(msg.value);
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
        uint newEthValue = Txpool / tokenBalance+amount;
        newEthTokenValue = ethValue - newEthValue;
    }

    // SELLING STSTOKEN
    function swapSTSforETH(uint amount)external {
        if(balanceOf(msg.sender) < amount){
            revert InsufficientFunds();
        }
        uint ethAmount = requestETHforSTS(amount);
        (bool sent,) = msg.sender.call{value:ethAmount}("");
        require(sent);
        emit stsSwapforETH(msg.sender, ethAmount);     
    }

    receive() external payable {
        
        }
   

}