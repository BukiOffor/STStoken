// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Stella} from "../../src/Stella.sol";
import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { DeployStella } from "../../script/DeployStella.s.sol";

contract StellaTest is Test{
    constructor() {}

    uint supply;
    uint amount;
    Stella stella;

    function setUp() public {
        DeployStella deployer = new DeployStella();
        (stella,supply,amount ) = deployer.run();
    }

    function testConstructor() external {
        uint Ethbalance = address(stella).balance;
        uint initialSupply = stella.balanceOf(address(stella));
        assertEq(Ethbalance,amount);
        assertEq(initialSupply,supply);
    }



}