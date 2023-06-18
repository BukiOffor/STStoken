// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "hardhat/console.sol";

/**
 * @title A contract for Stella Token
 * @author Buki
 * @notice The token is not live
 * @dev This contract implements chailink vrf
 */
 contract Stella is ERC20, VRFConsumerBaseV2{

    error InsufficientFunds();
    
    bytes32 private immutable i_gasLane;
    uint64  private immutable subscriptionID;
    uint32 private immutable i_callbackGasLimit;
    uint8 private constant request_confirmations = 3;
    uint8 private constant num_words = 1;
    uint256 private immutable pool; 

    VRFCoordinatorV2Interface private immutable i_coordinator;

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
        uint256 initialSupply, 
        uint64 _subscriptionID, 
        address vrfcoordinator,
        bytes32 gasLane,
        uint32 callbackGasLimit
        ) 
    ERC20("STELLA","STS")
    VRFConsumerBaseV2(vrfcoordinator) payable {
        subscriptionID = _subscriptionID;
        i_coordinator = VRFCoordinatorV2Interface(vrfcoordinator);
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
        pool = initialSupply * msg.value;
        _mint(address(this),initialSupply);
     }
    
    function airdrop(address to) public virtual {
        address owner = address(this);
        uint amount = 10000000000;
        require(balanceOf(owner) > amount, "Reserve is dry");
        require(balanceOf(to) <= 0, "Received ICO before");
        _transfer(owner,to,amount);
        emit Airdrop(to,amount);    
    }

    function lottery()public virtual {
        require(balanceOf(msg.sender) <= 0, "Received ICO before");
        uint256 requestID = requestRandomWords();
        address owner = address(this);
        require(randomness[requestID].exists, 'Please try again Later');
        uint amount = 1000000000 * randomness[requestID].words[0];
        _transfer(owner,msg.sender,amount);
        emit Lottery(msg.sender, amount);
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal virtual override{
        randomness[_requestId] = Status(true,false,_randomWords);   
    }

    function requestRandomWords()internal returns(uint requestId){
        requestId = i_coordinator.requestRandomWords(
            i_gasLane,
            subscriptionID,
            request_confirmations,
            i_callbackGasLimit,
            num_words
        );
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