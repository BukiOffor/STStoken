// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import { Stella } from "../src/Stella.sol";
import { Script, console2 } from "forge-std/Script.sol";

contract DeployStella is Script {
    constructor(){}

    function run() external returns (Stella sts, uint256 initialSupply, uint256 amount) {
        initialSupply = 5000e18;
        amount = 7000 ether;
        
        if (block.chainid == 31337){            
            vm.startBroadcast();
            sts = new Stella{value:amount}(initialSupply);
            vm.stopBroadcast();
        }
    }
}