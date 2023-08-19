// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title A contract for Stella Token
 * @author Buki
 * @notice The token is not live
 * @dev This contract implements chailink vrf
 */
contract Stella is ERC20, ReentrancyGuard {
    error InsufficientFunds();

    uint256 private immutable _pool;

    event Airdrop(address indexed to, uint256 indexed amount);
    event Lottery(address indexed to, uint256 indexed amount);
    event EthSwapforSTS(address indexed to, uint256 indexed amount);
    event EtsSwapforETH(address indexed to, uint256 indexed amount);
    event ExactTokenSwapped(address indexed t0, uint256 indexed tokenAmount, uint256 indexed ethAmount);

    constructor(uint256 initialSupply) payable ERC20("STELLA", "STS") {
        _pool = (initialSupply * msg.value) * 1e18;
        _mint(address(this), initialSupply);
    }

    /**
     * implements a token swap, we assume ETH is an ERC20 TOKEN
     * x*y = K
     */

    function requestSTSforETH(uint256 amount) public view returns (uint256 sts) {
        uint256 txpool = _pool;
        uint256 ethValue = address(this).balance;
        uint256 tokenBalance = balanceOf(address(this));
        uint256 newSTSValue = txpool / ((ethValue + amount) * 1e18);
        sts = tokenBalance - newSTSValue;
    }

    // BUYING TOKENS
    function swapETHforSTS() external payable {
        uint256 sts = requestSTSforETH(msg.value);
        _transfer(address(this), msg.sender, sts);
        emit EthSwapforSTS(msg.sender, sts);
    }

    //BUYING EXACT TOKENS
    function swapETHforExactToken(uint256 amount) external payable {
        uint256 ethValue = requestETHforSTS(amount);
        require(msg.value == ethValue, "Price has Changed");
        _transfer(address(this), msg.sender, amount);
        emit ExactTokenSwapped(msg.sender, amount, msg.value);
    }

    function requestETHforSTS(uint256 amount) public view returns (uint256 newEthTokenValue) {
        uint256 txpool = _pool;
        uint256 ethValue = address(this).balance;
        uint256 tokenBalance = balanceOf(address(this));
        uint256 newEthValue = txpool / ((tokenBalance + amount) * 1e18);
        newEthTokenValue = ethValue - newEthValue;
    }

    // SELLING STSTOKEN for Ethereum
    function swapSTSforETH(uint256 amount) external {
        if (balanceOf(msg.sender) < amount) {
            revert InsufficientFunds();
        }
        _transfer(msg.sender, address(this), amount);
        uint256 ethAmount = requestETHforSTS(amount);
        (bool sent,) = msg.sender.call{value: ethAmount}("");
        require(sent);
        emit EtsSwapforETH(msg.sender, ethAmount);
    }

    /**
     * we are sending burning any tokens thats mistakenly eneters the contract
     * we can easily send the tokens back to the sender, but we will assume the sender is an attack
     */
    receive() external payable nonReentrant {
        uint256 amount = msg.value;
        address _msgSender = address(0);
        (bool sent,) = _msgSender.call{value: amount}("");
        require(sent);
    }
}
