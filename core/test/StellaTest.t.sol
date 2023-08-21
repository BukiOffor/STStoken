// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Stella} from "../src/Stella.sol";
import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { DeployStella } from "../script/DeployStella.s.sol";

contract StellaTest is Test{
    constructor() {}

    Stella stella;
    function setUp() public {
        DeployStella deployer = new DeployStella();
        stella = deployer.run();
    }

    function testConstructor() external {
        uint balance = address(stella).balance;
        assertEq(balance,7000 ether);
    }

}